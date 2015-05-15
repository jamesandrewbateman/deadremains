deadremains = {}

include("shared.lua")
include("sh_utilities.lua")
include("modules/sh_log.lua")
include("modules/sh_settings.lua")
include("modules/sh_item.lua")
include("sh_loader.lua")

include("panels/button.lua")
include("panels/combo_box.lua")
include("panels/slot.lua")
include("panels/inventory.lua")
include("panels/character_creation.lua")
include("panels/main_menu.lua")
include("modules/sh_character.lua")
include("modules/cl_character.lua")

deadremains.loader.initialize()

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:InitPostEntity()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:OnEntityCreated(entity)
	if (IsValid(entity)) then
		if (entity == LocalPlayer()) then
			net.Start("deadremains.player.initalize")
			net.SendToServer()
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

surface.CreateFont("deadremains.hud.big", {font = "AvenirNext LT Pro Regular", size = 60, weight = 400})
--surface.CreateFont("deadremains.hud.big.blur", {font = "AvenirNext LT Pro Regular", size = 60, weight = 400, blursize = 6, antialias = false})

local material_health = Material("deadremains/hud/outercircle.png", "noclamp smooth")
local material_health_shadow = Material("vgui/hsv", "noclamp smooth")
local material_health_background = Material("deadremains/hud/innercircle.png", "noclamp smooth")

local health_x, health_y = 100, 256
local health_size = 200
local health_value = 100

local color_circle_inner = Color(0, 0, 0, 100)
local color_circle_shadow = Color(0, 0, 0, 80)

function GM:HUDPaint()

	-- Health.
	local health = LocalPlayer():Health()

	if (math.Round(health_value) != health) then
		health_value = math.Approach(health_value, health, 0.7)
	end
	
	local health_angle = math.NormalizeAngle(360.001 *(1 -health_value /100))

	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x -5, ScrH() -(health_y +5), health_size +10, health_size +10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x, ScrH() -health_y, health_size, health_size)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(248, 153, 36, 255 *0.9))
	surface.drawSection(health_x, ScrH() -health_y, health_size, health_size, 90, 90.001 +health_angle, true)

	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big.blur", health_x +health_size *0.5, ScrH() -(health_y -health_size *0.5), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big", health_x +health_size *0.5 +1, ScrH() -(health_y -health_size *0.5 -1), Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big", health_x +health_size *0.5, ScrH() -(health_y -health_size *0.5), Color(248, 153, 36, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- Thirst.
	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x +256 -5, ScrH() -((health_y -health_size *0.2) +5), health_size *0.8 +10, health_size *0.8 +10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x +256, ScrH() -(health_y -health_size *0.2), health_size *0.8, health_size *0.8)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(0, 174, 239, 255 *0.9))
	surface.drawSection(health_x +256, ScrH() -(health_y -health_size *0.2), health_size *0.8, health_size *0.8, 90, 180.1, true)

	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big.blur", health_x +256 +(health_size *0.8) *0.5, ScrH() -(health_y -(health_size *1.2) *0.5), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big",  health_x +256 +(health_size *0.8) *0.5 +1, ScrH() -(health_y -health_size -(health_size *1.2) *0.5 -1), Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big", health_x +256 +(health_size *0.8) *0.5, ScrH() -(health_y -(health_size *1.2) *0.5), Color(0, 174, 239, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- Hunger.
	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x +256 +192 -5, ScrH() -((health_y -health_size *0.2) +5), health_size *0.8 +10, health_size *0.8 +10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x +256 +192, ScrH() -(health_y -health_size *0.2), health_size *0.8, health_size *0.8)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(0, 235, 30, 255 *0.9))
	surface.drawSection(health_x +256 +192, ScrH() -(health_y -health_size *0.2), health_size *0.8, health_size *0.8, 90, 350.1, true)

	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big.blur", health_x +256 +192 +(health_size *0.8) *0.5, ScrH() -(health_y -(health_size *1.2) *0.5), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big",  health_x +256 +192 +(health_size *0.8) *0.5 +1, ScrH() -(health_y -health_size -(health_size *1.2) *0.5 -1), Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big", health_x +256 +192 +(health_size *0.8) *0.5, ScrH() -(health_y -(health_size *1.2) *0.5), Color(0, 235, 30, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	--[[
	surface.SetTexture(material_blur)
		
	render.SetStencilEnable(true)
		render.SetStencilReferenceValue(1)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)

		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCIL_REPLACE)

		render.ClearStencil()

		render.SetStencilCompareFunction(STENCIL_EQUAL)

		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawTexturedRect(216-30 *scale*0.5, ScrH() -132-30 *scale*0.5, 30 *scale, 30 *scale)

		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)

		surface.SetDrawColor(Color(248, 153, 36, 255))
		surface.drawSection(216-56 *scale*0.5, ScrH() -132-56 *scale*0.5, 56 *scale, 56 *scale, 90, 90.1, true)

		--surface.SetDrawColor(Color(51, 51, 51, 120))
		--surface.DrawPoly(a)
	
		--surface.SetDrawColor(Color(248, 153, 36, 255))
		--surface.DrawPoly(b)
		
		render.ClearStencil()
	render.SetStencilEnable(false)

	]]
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