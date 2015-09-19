local keyDown = false

hook.Add("Think", "deadremains.ui.detectDebugKey", function()

	if !keyDown then

		if input.IsKeyDown(KEY_F8) then

			deadremains.ui.createDebugPanel()

			keyDown = true

			timer.Simple(0.5, function() keyDown = false end)

		end

	end

end)

local function get_t_key(t, val)

	for k, v in pairs(t) do

		if val == v then

			return k

		end

	end

end

function deadremains.ui.createDebugPanel()

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 500, 300 )
	frame:Center()
	frame:MakePopup()

	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:Dock( FILL )


	local clrSheet = vgui.Create("DPropertySheet")
	clrSheet:Dock( FILL )
	sheet:AddSheet("Colors", clrSheet)

	local clrs = table.sort(deadremains.ui.colors, function(a, b) return get_t_key(deadremains.ui.colors, a) > get_t_key(deadremains.ui.colors, b) end )
	for k, v in pairs(clrs) do

		local clrPanel = vgui.Create("DPanel")
		clrPanel:SetSize( 200, 200 )
		clrPanel:Center()
		clrSheet:AddSheet(k, clrPanel)

		-- Color label
		local color_label = Label( "Color( 255, 255, 255 )", clrPanel )
		color_label:SetPos( 40, 160 )
		color_label:SetSize( 150, 20 )
		color_label:SetHighlight( true )
		color_label:SetColor( Color( 0, 0, 0 ) )

		-- Color picker
		local color_picker = vgui.Create( "DRGBPicker", clrPanel )
		color_picker:SetPos( 5, 5 )
		color_picker:SetSize( 30, 190 )

		-- Color cube
		local color_cube = vgui.Create( "DColorCube", clrPanel )
		color_cube:SetPos( 40, 5 )
		color_cube:SetSize( 155, 155 )

		-- When the picked color is changed...
		function color_picker:OnChange( col )

			-- Get the hue of the RGB picker and the saturation and vibrance of the color cube
			local h = ColorToHSV( col )
			local _, s, v = ColorToHSV( color_cube:GetRGB() )

			-- Mix them together and update the color cube
			col = HSVToColor( h, s, v )
			color_cube:SetColor( col )

			-- Lastly, update the background color and label
			UpdateColors( col )

		end

		function color_cube:OnUserChanged( col )

			-- Update background color and label
			UpdateColors( col )

		end

		-- Updates display colors, label, and clipboard text
		function UpdateColors( col )

			clrPanel:SetBackgroundColor( col )
			color_label:SetText( "Color( "..col.r..", "..col.g..", "..col.b.." )" )
			color_label:SetColor( Color( ( 255-col.r ), ( 255-col.g ), ( 255-col.b ) ) )
			SetClipboardText( color_label:GetText() )

		end

	end

end

