--[[
	GokuDex Module: Bypasses
	Author: gokuthug1
	Part of GokuDex Ultimate (100% Native)

	Native client-side anti-detection and safety layer.
	Zero external dependencies. Pure native Luau environment hardening.
--]]

local Bypasses = {}

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

local hookfunction = getGlobal("hookfunction")
local hookmetamethod = getGlobal("hookmetamethod")
local checkcaller = getGlobal("checkcaller") or function() return false end
local newcclosure = getGlobal("newcclosure") or function(f) return f end
local getgc = getGlobal("getgc") or getGlobal("get_gc_objects")

local isApplied = false

function Bypasses.Init()
	if isApplied then return true end
	isApplied = true

	local success = pcall(function()
		-- 1. GCInfo / CollectGarbage Memory Spoofer
		-- Games often poll gcinfo() or collectgarbage("count") to detect spikes from UI explorers.
		if hookfunction and type(gcinfo) == "function" then
			local oldGcInfo
			local baseGc = gcinfo()
			oldGcInfo = hookfunction(gcinfo, newcclosure(function(...)
				if checkcaller and checkcaller() then
					return oldGcInfo(...)
				end
				-- Return a stabilized, normal memory metric with small natural jitter
				return baseGc + math.random(50, 150)
			end))
		end

		if hookfunction and type(collectgarbage) == "function" then
			local oldCollectGarbage
			local baseGcKb = (type(gcinfo) == "function" and gcinfo()) or 10240
			oldCollectGarbage = hookfunction(collectgarbage, newcclosure(function(opt, ...)
				if checkcaller and checkcaller() then
					return oldCollectGarbage(opt, ...)
				end
				if type(opt) == "string" and opt:lower() == "count" then
					return baseGcKb + math.random(50, 150)
				end
				return oldCollectGarbage(opt, ...)
			end))
		end

		-- 2. UserInputService.GetFocusedTextBox Protection
		-- Games check if focused textbox belongs to an injected CoreGui or unauthorized container.
		local uis = game:GetService("UserInputService")
		if hookfunction and uis and uis.GetFocusedTextBox then
			local oldGetFocused
			oldGetFocused = hookfunction(uis.GetFocusedTextBox, newcclosure(function(self, ...)
				local res = oldGetFocused(self, ...)
				if res and not checkcaller() then
					-- If the focused textbox is part of GokuDex, hide it from game scripts
					local parent = res
					while parent do
						if parent.Name and parent.Name:sub(1, 9) == "_GOKUDEX_" then
							return nil
						end
						parent = parent.Parent
					end
				end
				return res
			end))
		end

		-- 3. ContentProvider.PreloadAsync Protection
		-- Prevents games from scanning or detecting loaded GokuDex asset ids.
		local cp = game:GetService("ContentProvider")
		if hookfunction and cp and cp.PreloadAsync then
			local oldPreload
			oldPreload = hookfunction(cp.PreloadAsync, newcclosure(function(self, contentList, callback, ...)
				if not checkcaller() and type(contentList) == "table" then
					local sanitized = {}
					for _, item in ipairs(contentList) do
						local itemStr = tostring(item)
						if not itemStr:find("GokuDex") and not itemStr:find("_GOKUDEX_") then
							table.insert(sanitized, item)
						end
					end
					return oldPreload(self, sanitized, callback, ...)
				end
				return oldPreload(self, contentList, callback, ...)
			end))
		end
	end)

	return success
end

return Bypasses
