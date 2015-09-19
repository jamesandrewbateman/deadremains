deadremains.ui.screenSizeX = ScrW()
deadremains.ui.screenSizeY = ScrH()

deadremains.ui.key = KEY_F9

deadremains.ui.colors = {}
deadremains.ui.colors.clr1 = Color(30, 30, 30, 150)
deadremains.ui.colors.clr2 = Color(75, 80, 100, 150)
deadremains.ui.colors.clr3 = Color(255, 156, 28, 255)
deadremains.ui.colors.clr4 = Color(245, 245, 245, 255)
deadremains.ui.colors.clr5 = Color(245, 245, 245, 75)
deadremains.ui.colors.clr6 = Color(245, 245, 245, 40)
deadremains.ui.colors.clr7 = Color(60, 60, 60, 255)
deadremains.ui.colors.clr8 = Color(75, 80, 100, 255)
deadremains.ui.colors.clr9 = Color(75, 80, 100, 200)

local UI_MAIN

local keyDown = false

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

		elseif input.IsKeyDown(KEY_F11) then

			keyDown = true

			deadremains.ui.destroyMenu()

			timer.Simple(0.5, function() keyDown = false end)

		end

	end

end)

function deadremains.ui.getMenu()

	return UI_MAIN

end

function deadremains.ui.createMenu()

	-- Do not re-create the whole menu so players can stay on the same tab when re-opening
	if UI_MAIN then

		UI_MAIN:Show()
		gui.EnableScreenClicker(true)

	else

		gui.EnableScreenClicker(true)

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

	end

end

function deadremains.ui.destroyMenu()

	if UI_MAIN then

		UI_MAIN:Remove()
		UI_MAIN = nil
		gui.EnableScreenClicker(false)

	end

end
