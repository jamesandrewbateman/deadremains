local keyDown = false
local debugKey = KEY_F8

hook.Add("Think", "deadremains.ui.detectDebugKey", function()

	if !keyDown then

		if input.IsKeyDown(debugKey) then

			deadremains.ui.createDebugPanel()

			keyDown = true

			timer.Simple(0.5, function() keyDown = false end)

		end

	end

end)

function deadremains.ui.createDebugPanel()

	local frame = vgui.Create("DFrame")
	frame:SetSize(500, 300)
	frame:Center()
	frame:MakePopup()

	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:Dock(FILL)

	local settings = vgui.Create("DPanel")
	settings:Dock(FILL)
	sheet:AddSheet("Settings", settings)

	local blurBox = vgui.Create("DCheckBox", settings)
	blurBox:SetPos(15, 10)
	blurBox:SetValue(deadremains.ui.enableBlur)
	function blurBox:OnChange(b)

		deadremains.ui.enableBlur = b

	end
	local blurLabel = vgui.Create("DLabel", settings)
	blurLabel:SetPos(35, 8)
	blurLabel:SetText("Enable background blur")
	blurLabel:SetDark(true)
	blurLabel:SetSize(400, 18)

	local clrSheet = vgui.Create("DPropertySheet")
	clrSheet:Dock(FILL)
	sheet:AddSheet("Colors", clrSheet)

	for k, v in SortedPairs(deadremains.ui.colors) do

		local clr = Color(v.r, v.g, v.b, 255)
		local clrPanel = vgui.Create("DPanel")
		clrPanel:SetSize( 200, 200 )
		clrPanel:Center()
		clrSheet:AddSheet(k, clrPanel)

		local reset = vgui.Create("DButton", clrPanel)
		reset:SetPos(230, 160)
		reset:SetText("Reset")
		reset:SetSize(80, 20)
		reset.clr = Color(deadremains.ui.colors[k].r, deadremains.ui.colors[k].g, deadremains.ui.colors[k].b, deadremains.ui.colors[k].a)
		reset.DoClick = function()

			clrPanel.color_cube:SetColor(reset.clr)
			clrPanel.color_picker:SetColor(reset.clr)
			clrPanel.color_a:SetText(reset.clr.a)

			deadremains.ui.colors[k] = reset.clr

		end

		clrPanel.color_r = vgui.Create("DTextEntry", clrPanel)
		clrPanel.color_r:SetPos(40, 160)
		clrPanel.color_r:SetSize(40, 20)
		clrPanel.color_r:SetValue(clr.r)
		function clrPanel.color_r:OnValueChange(val)

			clr = Color(val, clr.g, clr.b, clr.a)
			clrPanel.color_cube:SetColor(clr)
			clrPanel.color_picker:SetColor(clr)

		end

		clrPanel.color_g = vgui.Create("DTextEntry", clrPanel)
		clrPanel.color_g:SetPos(85, 160)
		clrPanel.color_g:SetSize(40, 20)
		clrPanel.color_g:SetValue(clr.g)
		function clrPanel.color_g:OnValueChange(val)

			clr = Color(clr.r, val, clr.b, clr.a)
			clrPanel.color_cube:SetColor(clr)
			clrPanel.color_picker:SetColor(clr)

		end

		clrPanel.color_b = vgui.Create("DTextEntry", clrPanel)
		clrPanel.color_b:SetPos(130, 160)
		clrPanel.color_b:SetSize(40, 20)
		clrPanel.color_b:SetValue(clr.b)
		function clrPanel.color_b:OnValueChange(val)

			clr = Color(clr.r, clr.g, val, clr.a)
			clrPanel.color_cube:SetColor(clr)
			clrPanel.color_picker:SetColor(clr)

		end

		clrPanel.color_a = vgui.Create("DTextEntry", clrPanel)
		clrPanel.color_a:SetPos(175, 160)
		clrPanel.color_a:SetSize(40, 20)
		clrPanel.color_a:SetValue(deadremains.ui.colors[k].a)
		function clrPanel.color_a:OnValueChange(val)

			clr = Color(clr.r, clr.g, clr.b, val)
			clrPanel.color_cube:SetColor(clr)
			clrPanel.color_picker:SetColor(clr)

		end

		clrPanel.color_picker = vgui.Create("DRGBPicker", clrPanel)
		clrPanel.color_picker:SetPos(5, 5)
		clrPanel.color_picker:SetSize(30, 190)
		function clrPanel.color_picker:SetColor(col)

			local h = ColorToHSV(col)
			col = HSVToColor(h, 1, 1)

			self:SetRGB(col)

			local _, height = self:GetSize()
			self.LastY = height * (1 - (h / 360))

			self:OnChange(self:GetRGB())

		end
		clrPanel.color_picker:SetColor(clr)

		clrPanel.color_cube = vgui.Create("DColorCube", clrPanel)
		clrPanel.color_cube:SetPos(40, 5)
		clrPanel.color_cube:SetSize(155, 155)
		clrPanel.color_cube:SetColor(clr)

		function clrPanel.color_picker:OnChange(col)

			local h = ColorToHSV(col)
			local _, s, v = ColorToHSV(clrPanel.color_cube:GetRGB())

			col = HSVToColor(h, s, v)
			clrPanel.color_cube:SetColor(col)

			clrPanel.UpdateColors(col)

		end

		function clrPanel.color_cube:OnUserChanged(col)

			clrPanel.UpdateColors(col)

		end

		function clrPanel.UpdateColors(col)

			clr = col

			clrPanel.color_r:SetText(col.r)
			clrPanel.color_g:SetText(col.g)
			clrPanel.color_b:SetText(col.b)
			clrPanel:SetBackgroundColor( col )

			SetClipboardText( "Color(" .. col.r .. ", " .. col.g .. ", " .. col.b .. ", " .. clrPanel.color_a:GetValue() .. ")" )

			deadremains.ui.colors[k] = Color(col.r, col.g, col.b, clrPanel.color_a:GetValue())

		end

		clrPanel.UpdateColors(clr)

	end

end

