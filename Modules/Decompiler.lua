--[[
	GokuDex Module: Decompiler
	Author: gokuthug1
	Part of GokuDex Ultimate (100% Native)

	100% Native, In-Process Decompiler and Bytecode Inspector Suite.
	Zero external HTTP requests. No third-party APIs. Pure client-side Luau.
--]]

local Decompiler = {}

local function getGlobal(name)
	local ok, val = pcall(function()
		if getgenv and getgenv()[name] ~= nil then return getgenv()[name] end
		local genv = (getfenv and getfenv())
		if genv and genv[name] ~= nil then return genv[name] end
		if rawget and getfenv and rawget(getfenv(), name) ~= nil then return rawget(getfenv(), name) end
		if _G and _G[name] ~= nil then return _G[name] end
		return nil
	end)
	return ok and val or nil
end

local nativeDecompile = getGlobal("decompile") or (syn and syn.decompile) or (fluxus and fluxus.decompile)
local getscriptbytecode = getGlobal("getscriptbytecode")

-- Pure native Luau bytecode inspector (extracts strings, constants, and structure locally)
local function InspectLuauBytecode(bytecode, scriptObj)
	local output = {}
	table.insert(output, "-- [GokuDex Native Luau Bytecode Inspector]")
	table.insert(output, "-- Script: " .. (scriptObj and scriptObj:GetFullName() or "Unknown"))
	table.insert(output, "-- Bytecode Size: " .. tostring(#bytecode) .. " bytes")
	table.insert(output, "")

	if #bytecode < 4 then
		table.insert(output, "-- [Error: Bytecode too short or empty]")
		return table.concat(output, "\n")
	end

	local version = string.byte(bytecode, 1)
	table.insert(output, "-- Luau Bytecode Version: " .. tostring(version))

	-- Extract printable string constants from bytecode
	local strings = {}
	local minStrLen = 3
	local current = {}
	for i = 1, #bytecode do
		local b = string.byte(bytecode, i)
		if (b >= 32 and b <= 126) or b == 9 or b == 10 then
			table.insert(current, string.char(b))
		else
			if #current >= minStrLen then
				local s = table.concat(current)
				if not strings[s] and #s < 200 then
					strings[s] = true
				end
			end
			current = {}
		end
	end
	if #current >= minStrLen then
		local s = table.concat(current)
		if not strings[s] and #s < 200 then
			strings[s] = true
		end
	end

	table.insert(output, "-- Embedded String Literals & Identifiers:")
	local sortedStrings = {}
	for s in pairs(strings) do
		table.insert(sortedStrings, s)
	end
	table.sort(sortedStrings)

	for idx, s in ipairs(sortedStrings) do
		table.insert(output, string.format("  [%03d] %q", idx, s))
	end

	table.insert(output, "")
	table.insert(output, "-- Note: For full high-level AST reconstruction, ensure your executor")
	table.insert(output, "-- provides native 'decompile()'. Bytecode strings inspected natively above.")

	return table.concat(output, "\n")
end

function Decompiler.Decompile(scriptInstance, ...)
	if not scriptInstance or typeof(scriptInstance) ~= "Instance" then
		return "-- [GokuDex Native Decompiler]\n-- Invalid instance provided."
	end

	-- 1. Check if server-side script
	if scriptInstance.ClassName == "Script" and (scriptInstance.RunContext == Enum.RunContext.Legacy or scriptInstance.RunContext == Enum.RunContext.Server) then
		return "-- [GokuDex Native Decompiler]\n-- Cannot decompile: Server scripts are executed entirely on the server and their bytecode is not replicated to clients.\n-- Path: " .. scriptInstance:GetFullName()
	end

	-- 2. Try native executor decompiler first
	local dec = nativeDecompile or (getgenv and getgenv().decompile) or (syn and syn.decompile) or decompile
	if typeof(dec) == "function" then
		local ok, res = pcall(dec, scriptInstance, ...)
		if ok and type(res) == "string" and #res > 0 and not res:find("Failed to decode Luau bytecode") then
			return res
		end
	end

	-- 3. Try reading .Source property directly (Studio, unstripped, or local scripts)
	local okSrc, src = pcall(function() return scriptInstance.Source end)
	if okSrc and type(src) == "string" and #src > 0 then
		return src
	end

	-- 4. Try native Luau bytecode inspector if bytecode is available
	if typeof(getscriptbytecode) == "function" then
		local okByte, bytecode = pcall(getscriptbytecode, scriptInstance)
		if okByte and type(bytecode) == "string" and #bytecode > 0 then
			local okInsp, resInsp = pcall(InspectLuauBytecode, bytecode, scriptInstance)
			if okInsp and resInsp then
				return resInsp
			end
		end
	end

	return "-- [GokuDex Native Decompiler]\n-- Decompilation is not supported by your current executor for this script.\n-- Script: " .. scriptInstance:GetFullName()
end

return Decompiler
