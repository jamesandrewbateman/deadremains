deadremains.loader = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.loader.initialize()
	local GAMEMODE = GM
	local map = string.lower(game.GetMap())
	local directory = GAMEMODE.FolderName .. "/gamemode/settings/" .. map
	
	-- Load sh_settings first.
	if (SERVER) then
		AddCSLuaFile(directory .. "/sh_settings.lua")
	end
	
	include(directory .. "/sh_settings.lua")
	
	deadremains.log.write(deadremains.log.loader, "Initialized settings.")
	
	-- Load the folders.
	local _, folders = file.Find(directory .. "/*", "LUA")
	
	for _, folder in pairs(folders) do
		if (folder == "items") then
			item = {}

			if (SERVER) then
				AddCSLuaFile(directory .. "/" .. folder .. "/base_item.lua")
			end
			
			include(directory .. "/" .. folder .. "/base_item.lua")

			deadremains.item.register(item)

			local base_item = item

			item = nil

			local files = file.Find(directory .. "/" .. folder .. "/*", "LUA")
			
			for _, file in pairs(files) do
				if (file != "base_item.lua") then
					item = table.Copy(base_item)
	
					if (SERVER) then
						AddCSLuaFile(directory .. "/" .. folder .. "/" .. file)
					end
					
					include(directory .. "/" .. folder .. "/" .. file)
					
					print(item)
					deadremains.item.register(item)
	
					item = nil
	
					deadremains.log.write(deadremains.log.loader, "Loaded file settings/" .. map .. "/" .. folder .. "/" .. file .. ".")
				end
			end
		else
		end
	end
end