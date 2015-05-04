AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

AddCSLuaFile("panels/button.lua")
AddCSLuaFile("panels/combo_box.lua")
AddCSLuaFile("panels/character_creation.lua")
AddCSLuaFile("modules/sh_character.lua")
AddCSLuaFile("modules/cl_character.lua")

include("shared.lua")
include("modules/sh_character.lua")
include("modules/sv_character.lua")
include("sv_player.lua")

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
