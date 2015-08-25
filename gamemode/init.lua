deadremains = {}

AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_utilities.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("modules/sh_log.lua")
AddCSLuaFile("modules/sh_settings.lua")
AddCSLuaFile("modules/sh_item.lua")
AddCSLuaFile("sh_loader.lua")
AddCSLuaFile("modules/sh_inventory.lua")
AddCSLuaFile("modules/cl_inventory.lua")
AddCSLuaFile("modules/cl_gear.lua")

AddCSLuaFile("panels/button.lua")
AddCSLuaFile("panels/combo_box.lua")
AddCSLuaFile("panels/slot.lua")
AddCSLuaFile("panels/slot_context_menu.lua")
AddCSLuaFile("panels/inventory.lua")
AddCSLuaFile("panels/character_creation.lua")
AddCSLuaFile("panels/main_menu.lua")
AddCSLuaFile("modules/sh_character.lua")
AddCSLuaFile("modules/cl_character.lua")

include("shared.lua")
include("sh_utilities.lua")
include("modules/sh_log.lua")
include("modules/sh_settings.lua")
include("modules/sh_inventory.lua")
include("modules/sh_item.lua")
include("modules/sv_item.lua")
include("sh_loader.lua")
include("modules/sv_sql.lua")
include("modules/sv_map_config.lua")
include("modules/sh_character.lua")
include("modules/sv_character.lua")
include("sv_player.lua")

deadremains.loader.initialize()

database_main = "deadremains"

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:Initialize()
	deadremains.sql.setupModules()

	-- stored[name], hostname, username, password, database, port, (Optional) unixsocketpath, (Optional) clientflags
	deadremains.sql.intialize(database_main, "localhost", "root", "_debug", "deadremains", 3306)
	deadremains.map_config.initialize(database_main, "gm_flatgrass")
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:PlayerInitialSpawn(player)
	player.zombie_kill_count = 0
	self.BaseClass:PlayerInitialSpawn(player)
end 

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:ShowHelp(ply)
	ply:ConCommand("inventory")
end

function GM:PlayerSpawn(ply)
	ply.alive_timer = 0

	timer.Create("dr_alive_timer" .. ply:UniqueID(), 1, 0, function()
		if (IsValid(ply)) then
			ply.alive_timer = ply.alive_timer + 1
		end
	end)
end


function GM:PlayerConnect(ply)

end

function GM:PlayerDisconnect(ply)
	timer.Remove("dr_alive_timer" .. ply:UniqueID())

	deadremains.sql.savePlayer(ply)
	self.BaseClass:PlayerDisconnect(ply)
end

function GM:PostPlayerDeath(ply)
	player.alive_timer = 0
end