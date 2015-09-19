local material_health = Material("deadremains/hud/outercircle.png", "noclamp smooth")
local material_health_shadow = Material("vgui/hsv", "noclamp smooth")
local material_health_background = Material("deadremains/hud/innercircle.png", "noclamp smooth")

local health_x, health_y = 100, 256
local health_size = 200
local health_value = 100
local thirst_value = 100
local hunger_value = 100

local color_circle_inner = Color(0, 0, 0, 100)
local color_circle_shadow = Color(0, 0, 0, 80)

function GM:HUDPaint()

	-- Health.
	local health = LocalPlayer():Health()

	if (math.Round(health_value) != health) then
		health_value = math.Approach(health_value, health, 0.7)
	end

	local health_angle = math.NormalizeAngle(360.001 * (1 -health_value / 100))

	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x -5, ScrH() -(health_y + 5), health_size + 10, health_size + 10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x, ScrH() -health_y, health_size, health_size)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(248, 153, 36, 255 * 0.9))
	surface.drawSection(health_x, ScrH() -health_y, health_size, health_size, 90, 90.001 + health_angle, true)

	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big.blur", health_x +health_size *0.5, ScrH() -(health_y -health_size *0.5), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big", health_x +health_size *0.5 +1, ScrH() -(health_y -health_size *0.5 -1), Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big", health_x + health_size * 0.5, ScrH() -(health_y -health_size * 0.5), Color(248, 153, 36, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- Thirst.
	local thirst = LocalPlayer():GetNWInt("dr_thirst", 0)

	if (math.Round(thirst_value) != thirst) then
		thirst_value = math.Approach(thirst_value, thirst, 0.7)
	end

	local thirst_angle = math.NormalizeAngle(360.001 * (1 -thirst_value / 100))

	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x + 256 -5, ScrH() -((health_y -health_size * 0.2) + 5), health_size * 0.8 + 10, health_size * 0.8 + 10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x + 256, ScrH() -(health_y -health_size * 0.2), health_size * 0.8, health_size * 0.8)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(0, 174, 239, 255 * 0.9))
	surface.drawSection(health_x + 256, ScrH() -(health_y -health_size * 0.2), health_size * 0.8, health_size * 0.8, 90, 90.001 + thirst_angle, true)

	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big.blur", health_x +256 +(health_size *0.8) *0.5, ScrH() -(health_y -(health_size *1.2) *0.5), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big",  health_x +256 +(health_size *0.8) *0.5 +1, ScrH() -(health_y -health_size -(health_size *1.2) *0.5 -1), Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(thirst, "deadremains.hud.big", health_x + 256 + (health_size * 0.8) * 0.5, ScrH() -(health_y -(health_size * 1.2) * 0.5), Color(0, 174, 239, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	-- Hunger.
	local hunger = LocalPlayer():GetNWInt("dr_hunger", 0)

	if (math.Round(hunger_value) != hunger) then
		hunger_value = math.Approach(hunger_value, hunger, 0.7)
	end

	local hunger_angle = math.NormalizeAngle(360.001 * (1 -hunger_value / 100))

	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x + 256 + 192 -5, ScrH() -((health_y -health_size * 0.2) + 5), health_size * 0.8 + 10, health_size * 0.8 + 10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x + 256 + 192, ScrH() -(health_y -health_size * 0.2), health_size * 0.8, health_size * 0.8)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(0, 235, 30, 255 *0.9))
	surface.drawSection(health_x + 256 + 192, ScrH() -(health_y -health_size * 0.2), health_size * 0.8, health_size * 0.8, 90, 90.001 + hunger_angle, true)

	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big.blur", health_x +256 +192 +(health_size *0.8) *0.5, ScrH() -(health_y -(health_size *1.2) *0.5), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big",  health_x +256 +192 +(health_size *0.8) *0.5 +1, ScrH() -(health_y -health_size -(health_size *1.2) *0.5 -1), Color(0, 0, 0, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(hunger, "deadremains.hud.big", health_x + 256 + 192 + (health_size * 0.8) * 0.5, ScrH() -(health_y -(health_size * 1.2) * 0.5), Color(0, 235, 30, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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