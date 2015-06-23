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
	deadremains.sql.intialize(database_main, "localhost", "root", "", "deadremains", 3306)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:PlayerInitialSpawn(player)
	self.BaseClass:PlayerInitialSpawn(player)
end 

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:PlayerSpawn(player) 
	self.BaseClass:PlayerSpawn(player)

end 
