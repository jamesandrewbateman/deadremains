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


local UI_HUD

function deadremains.ui.createHUD()

	if UI_HUD then

		UI_HUD:Show()

	else

		UI_HUD = vgui.Create("deadremains.hud_handler")
		UI_HUD:SetSize(deadremains.ui.screenSizeX, deadremains.ui.screenSizeY)
		UI_HUD:SetPos(0, 0)

		UI_HUD.STATS = vgui.Create("deadremains.hud_stats", UI_HUD)

		function UI_HUD:maximize() UI_HUD.STATS:maximize() end
		function UI_HUD:minimize() UI_HUD.STATS:minimize() end

	end

end

function deadremains.ui.getHUD()

	return UI_HUD

end

function deadremains.ui.hideHUD()

	if UI_HUD then

		UI_HUD:Hide()

	end

end

function deadremains.ui.destroyHUD()

	if UI_HUD then

		UI_HUD:Remove()
		UI_HUD = nil

	end

end