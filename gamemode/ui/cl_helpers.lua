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
deadremains.ui.colors.clr11 = Color(250, 150, 28, 255)
deadremains.ui.colors.clr12 = Color(86, 160, 64, 255)
deadremains.ui.colors.clr13 = Color(80, 80, 80, 255)

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

function draw.Circle(x, y, radius, seg)

	local cir = {}

	table.insert(cir, {x = x, y = y, u = 0.5, v = 0.5})
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	end

	local a = math.rad(0) -- This is need for non absolute segment counts
	table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

	surface.DrawPoly(cir)

end
