deadremains.ui.screenSizeX = ScrW()
deadremains.ui.screenSizeY = ScrH()

deadremains.ui.colors = {}
deadremains.ui.colors.clr1 = Color(24, 24, 24, 235)
deadremains.ui.colors.clr2 = Color(75, 80, 100, 150)
deadremains.ui.colors.clr3 = Color(255, 156, 28, 255)
deadremains.ui.colors.clr4 = Color(245, 245, 245, 255)
deadremains.ui.colors.clr5 = Color(245, 245, 245, 75)
deadremains.ui.colors.clr6 = Color(245, 245, 245, 40)
deadremains.ui.colors.clr7 = Color(40, 40, 40, 230)
deadremains.ui.colors.clr8 = Color(75, 80, 100, 255)
deadremains.ui.colors.clr9 = Color(75, 80, 100, 200)
deadremains.ui.colors.clr10 = Color(245, 245, 245, 20)

function deadremains.ui.lerp(frac, from, to)

	local dif = math.abs(from - to)

	if dif < from / 100 then return to end

	return Lerp(frac, from, to)

end

hook.Add("Think", "deadremains.ui.detectDebugKillKey", function()

	if !keyDown then

		if input.IsKeyDown(KEY_F11) then

			keyDown = true

			deadremains.ui.destroyMenu()
			deadremains.ui.destroyHUD()

			timer.Simple(0.5, function() keyDown = false end)

		end

	end

end)