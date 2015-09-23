deadremains = {}

include("shared.lua")
include("sh_utilities.lua")
include("sh_loader.lua")

LoadModule("netrequest")
LoadModule("log")
LoadModule("sql")
LoadModule("item")
LoadModule("settings")
LoadModule("inventory")
LoadModule("character")
LoadModule("team")
LoadModule("map_config")
LoadModule("gear")
LoadModule("container")
LoadModule("deadmin")

include("sh_uiloader.lua")
include("cl_player.lua")

deadremains.loader.initialize()

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:InitPostEntity()
	net.Start("deadremains.player.initalize")
	net.SendToServer()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:OnEntityCreated(entity)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:Think()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local defaultHUD = {
	["CHudHealth"] 			= true,
	["CHudBattery"] 		= true,
	--["CHudChat"] 			= true,
	["CHudAmmo"] 			= true,
	["CHudCrosshair"]		= true,
	["CHudSecondaryAmmo"] 	= true,
	["CHudWeaponSelection"] = true
}

function GM:HUDShouldDraw(id)
	return !defaultHUD[id]
end