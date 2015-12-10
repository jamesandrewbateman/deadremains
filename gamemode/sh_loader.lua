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

					deadremains.item.register(item)
	
					item = nil
	
					deadremains.log.write(deadremains.log.loader, "Loaded file settings/" .. map .. "/" .. folder .. "/" .. file .. ".")
				end
			end
		else
		end
	end
end

function LoadInfoFile(data)
	print("Loading Module...", data.Name)
	local path_to_module = GM.FolderName .. "/gamemode/modules/" .. data.Name

	for k,v in ipairs(data.Dependencies) do
		-- Recursive module loading, failsafe?
		LoadModule(v.Name)
	end

	for k,file in ipairs(data.Order) do
		file = path_to_module .. "/" .. file

		if (string.find(file, "sv_")) then
			if (SERVER) then
				include(file)
			end
		elseif (string.find(file, "sh_")) then
			if (SERVER) then
				AddCSLuaFile(file)
			end
			include(file)
		elseif (string.find(file, "cl_")) then
			if (SERVER) then
				AddCSLuaFile(file)
			else
				include(file)
			end
		end
	end
end

function LoadModule(name)
	local path_to_folder = GM.FolderName .. "/gamemode/modules/" .. name
	if (SERVER) then AddCSLuaFile(path_to_folder .. "/sh_info.lua") end
	include (path_to_folder .. "/sh_info.lua")
	-- should call LoadInfoFile()
end