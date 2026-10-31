--[[
	GokuDex Module: NativeSerializer
	Author: gokuthug1
	Part of GokuDex Ultimate (100% Native)

	100% Native Pure-Luau Place and Model Serializer (.rbxlx / .rbxmx).
	Serializes instances and hierarchies to Roblox XML format natively.
	Zero external dependencies. Works offline.
--]]

local NativeSerializer = {}

local function xmlEscape(str)
	if type(str) ~= "string" then str = tostring(str) end
	return str:gsub("&", "&amp;")
	          :gsub("<", "&lt;")
	          :gsub(">", "&gt;")
	          :gsub("\"", "&quot;")
	          :gsub("'", "&apos;")
end

local function serializeValue(propName, val)
	local vType = typeof(val)
	if vType == "string" then
		return string.format("<string name=\"%s\">%s</string>", xmlEscape(propName), xmlEscape(val))
	elseif vType == "boolean" then
		return string.format("<bool name=\"%s\">%s</bool>", xmlEscape(propName), tostring(val))
	elseif vType == "number" then
		return string.format("<float name=\"%s\">%s</float>", xmlEscape(propName), tostring(val))
	elseif vType == "Vector3" then
		return string.format([[<Vector3 name="%s"><X>%f</X><Y>%f</Y><Z>%f</Z></Vector3>]], xmlEscape(propName), val.X, val.Y, val.Z)
	elseif vType == "Vector2" then
		return string.format([[<Vector2 name="%s"><X>%f</X><Y>%f</Y></Vector2>]], xmlEscape(propName), val.X, val.Y)
	elseif vType == "CFrame" then
		local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = val:GetComponents()
		return string.format([[<CoordinateFrame name="%s">
			<X>%f</X><Y>%f</Y><Z>%f</Z>
			<R00>%f</R00><R01>%f</R01><R02>%f</R02>
			<R10>%f</R10><R11>%f</R11><R12>%f</R12>
			<R20>%f</R20><R21>%f</R21><R22>%f</R22>
		</CoordinateFrame>]], xmlEscape(propName), x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22)
	elseif vType == "Color3" then
		return string.format([[<Color3 name="%s"><R>%f</R><G>%f</G><B>%f</B></Color3>]], xmlEscape(propName), val.R, val.G, val.B)
	elseif vType == "BrickColor" then
		return string.format("<int name=\"%s\">%d</int>", xmlEscape(propName), val.Number)
	elseif vType == "UDim2" then
		return string.format([[<UDim2 name="%s"><XS>%f</XS><XO>%d</XO><YS>%f</YS><YO>%d</YO></UDim2>]], xmlEscape(propName), val.X.Scale, val.X.Offset, val.Y.Scale, val.Y.Offset)
	elseif vType == "EnumItem" then
		return string.format("<token name=\"%s\">%d</token>", xmlEscape(propName), val.Value)
	end
	return nil
end

local CommonProps = {
	"Name", "Archivable",
	-- BasePart
	"Size", "CFrame", "Position", "Color", "Transparency", "Reflectance", "Anchored", "CanCollide", "Massless", "Material",
	-- GUI
	"Visible", "Position", "Size", "BackgroundColor3", "BorderColor3", "BorderSizePixel", "BackgroundTransparency",
	"Text", "TextColor3", "TextSize", "Font", "TextScaled", "TextWrapped",
	-- Lighting / Effects
	"Brightness", "Range", "Shadows", "Enabled"
}

local RiskyServices = {
	AccountService = true, AnalyticsService = true, CoreGui = true, CorePackages = true,
	HttpService = true, RobloxReplicatedStorage = true, ScriptContext = true
}

function NativeSerializer.SerializeInstance(inst, refIdTable, options, decompileFunc)
	if not inst or not inst.Parent and inst ~= game then return "" end
	if RiskyServices[inst.ClassName] then return "" end

	local ref = refIdTable[inst]
	if not ref then
		ref = "RBX" .. tostring(#refIdTable + 1)
		refIdTable[inst] = ref
		table.insert(refIdTable, inst)
	end

	local xml = {}
	table.insert(xml, string.format("<Item class=\"%s\" referent=\"%s\">", xmlEscape(inst.ClassName), ref))
	table.insert(xml, "<Properties>")
	table.insert(xml, string.format("<string name=\"Name\">%s</string>", xmlEscape(inst.Name)))

	-- Handle Scripts Source
	if inst:IsA("LuaSourceContainer") then
		local src = ""
		local okSrc, directSrc = pcall(function() return inst.Source end)
		if okSrc and type(directSrc) == "string" and #directSrc > 0 then
			src = directSrc
		elseif options and options.Decompile and decompileFunc then
			local okDec, decSrc = pcall(decompileFunc, inst)
			if okDec and type(decSrc) == "string" then
				src = decSrc
			end
		end
		-- CDATA wrap
		local sanitizedSrc = src:gsub("]]>", "]]]]><![CDATA[>")
		table.insert(xml, string.format("<ProtectedString name=\"Source\"><![CDATA[%s]]></ProtectedString>", sanitizedSrc))
	end

	-- Serialize common serializable properties safely
	for _, prop in ipairs(CommonProps) do
		if prop ~= "Name" then
			local ok, val = pcall(function() return inst[prop] end)
			if ok and val ~= nil then
				local sVal = serializeValue(prop, val)
				if sVal then
					table.insert(xml, sVal)
				end
			end
		end
	end

	table.insert(xml, "</Properties>")

	-- Children
	local okKids, kids = pcall(inst.GetChildren, inst)
	if okKids and kids then
		for _, child in ipairs(kids) do
			local childXml = NativeSerializer.SerializeInstance(child, refIdTable, options, decompileFunc)
			if childXml and #childXml > 0 then
				table.insert(xml, childXml)
			end
		end
	end

	table.insert(xml, "</Item>")
	return table.concat(xml, "\n")
end

function NativeSerializer.SavePlace(rootObj, filepath, options, decompileFunc)
	rootObj = rootObj or game
	filepath = filepath or ("Place_" .. tostring(game.PlaceId or "Saved") .. ".rbxlx")
	if not filepath:find("%.rbxlx$") and not filepath:find("%.rbxl$") then
		filepath = filepath .. ".rbxlx"
	end

	local refIdTable = {}
	local bodyXml = {}

	if rootObj == game then
		local services = {
			"Workspace", "Lighting", "ReplicatedStorage", "ReplicatedFirst",
			"StarterGui", "StarterPack", "StarterPlayer", "Teams", "SoundService"
		}
		for _, sName in ipairs(services) do
			local sOk, sInst = pcall(game.GetService, game, sName)
			if sOk and sInst then
				local sXml = NativeSerializer.SerializeInstance(sInst, refIdTable, options, decompileFunc)
				if sXml and #sXml > 0 then
					table.insert(bodyXml, sXml)
				end
			end
		end
	else
		local sXml = NativeSerializer.SerializeInstance(rootObj, refIdTable, options, decompileFunc)
		if sXml and #sXml > 0 then
			table.insert(bodyXml, sXml)
		end
	end

	local fullDoc = string.format([[<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
%s
</roblox>]], table.concat(bodyXml, "\n"))

	if writefile then
		writefile(filepath, fullDoc)
		return true, filepath
	end

	return false, "writefile not supported on this executor."
end

return NativeSerializer
