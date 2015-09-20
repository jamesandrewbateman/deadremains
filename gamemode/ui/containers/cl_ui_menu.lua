
deadremains.ui.key = KEY_F9

deadremains.ui.enableBlur = true

local UI_MAIN

local keyDown = false
local menuOpen = false

hook.Add("Think", "deadremains.ui.detectKey", function()

	if !keyDown then

		if input.IsKeyDown(deadremains.ui.key) then

			keyDown = true

			deadremains.ui.createMenu()

			timer.Simple(0.5, function() keyDown = false end)

		elseif input.IsKeyDown(KEY_F10) then

			keyDown = true

			deadremains.ui.hideMenu()

			timer.Simple(0.5, function() keyDown = false end)

		end

	end

end)

function deadremains.ui.getMenu()

	return UI_MAIN

end

function deadremains.ui.isMenuOpen()

	return menuOpen

end

function deadremains.ui.createMenu()

	-- Do not re-create the whole menu so players can stay on the same tab when re-opening
	if UI_MAIN then

		UI_MAIN:Show()
		gui.EnableScreenClicker(true)
		menuOpen = true

		deadremains.ui.getHUD():minimize()

	else

		gui.EnableScreenClicker(true)
		menuOpen = true

		if !deadremains.ui.getHUD() then deadremains.ui.createHUD() end
		deadremains.ui.getHUD():minimize()

		UI_MAIN = vgui.Create("deadremains.screen")
		UI_MAIN:SetSize(deadremains.ui.screenSizeX, deadremains.ui.screenSizeY)
		UI_MAIN:SetPos(0, 0)

		local main_panel = vgui.Create("deadremains.main_panel", UI_MAIN)
		main_panel:SetSize(640, 771)
		main_panel:SetPos(deadremains.ui.screenSizeX / 2 - 35 / 2 - 640, deadremains.ui.screenSizeY / 2 - 771 / 2)

	end

end

function deadremains.ui.hideMenu()

	if UI_MAIN then

		UI_MAIN:Hide()

		gui.EnableScreenClicker(false)
		menuOpen = false

		if deadremains.ui.getHUD() then

			deadremains.ui.getHUD():maximize()

		end

	end

end

function deadremains.ui.destroyMenu()

	if UI_MAIN then

		UI_MAIN:Remove()
		UI_MAIN = nil

		gui.EnableScreenClicker(false)
		menuOpen = false

		deadremains.ui.getHUD():maximize()

	end

end
