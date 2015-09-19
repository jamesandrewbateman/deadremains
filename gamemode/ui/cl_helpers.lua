deadremains.ui.screenSizeX = ScrW()
deadremains.ui.screenSizeY = ScrH()

function deadremains.ui.lerp(frac, from, to)

	// if math.ceil(from * 10) == to * 10 or math.floor(from * 10) == to * 10 then return to end

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