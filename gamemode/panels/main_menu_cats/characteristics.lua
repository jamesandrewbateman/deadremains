local panel = {}
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	--self:DockPadding(25, 25, 25, 25)
	self:SetWide(200 * STORE_SCALE_X)
	self:SetTall(620 * STORE_SCALE_Y)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local char_circle = Material("materials/deadremains/characteristics/segmented_circ.png")

surface.CreateFont("deadremains.characteristics", {font = "Bebas Neue", size = 36, weight = 400})

function panel:initCategories()
	local panel = self:Add("Panel")
	function panel:Paint(w, h)
		surface.DisableClipping(true)
		draw.SimpleText("Characteristics", "deadremains.characteristics", 80 * STORE_SCALE_X, 0, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		--draw.simpleOutlined(0,0,w,h,color_red)
	end

	local characteristics = deadremains.settings.get("characteristics")

	local y = 64 * STORE_SCALE_Y

	for unique, data in pairs(characteristics) do
		local icon = panel:Add("DImage")
		icon:SetImage(data.icon)
		icon:SetSize(64 * STORE_SCALE_X, 64 * STORE_SCALE_Y)
		icon.name = unique
		icon:SetPos(0, y)
		icon:SetMouseInputEnabled(true)

		function icon:Paint(w, h)
			local alpha = self:GetAlpha()
			local char = LocalPlayer():getChar(unique)

			if char then
				if (self.Hovered) then
					draw.material(0, 0, w, h, color_white, char_circle)
					draw.material(4, 4, w -8, h -8, Color(240, 155, 28), char_circle)
				else
					draw.material(0, 0, w, h, Color(85, 161, 63), char_circle)
				end
				
				if (alpha != 255) then
					self:SetAlpha(255)
				end
			else
				draw.material(0, 0, w, h, Color(255, 255, 255, 80), char_circle)

				if (alpha != 80) then
					self:SetAlpha(80)
				end
			end

			DImage.Paint(self, w, h)
			draw.SimpleText(self.name, "deadremains.characteristics", w * 2, 0, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(char, "deadremains.characteristics", w * 2, 50 * STORE_SCALE_Y, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		y = y + (32 * STORE_SCALE_Y) + (48 * STORE_SCALE_Y)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local w, h = self:GetSize()
	local children = self:GetChildren()

	for k, child in pairs(children) do
		local width = math.Round(math.ceil(w /5 -25 *0.5))

		child:SetPos(width *(k -1) +25, 25)
		child:SetSize(width, h -25 *2)
	end
end

function panel:Think()
	local panel = main_menu:getPanel("skills_panel"):GetParent()

	if (!panel:IsVisible()) then
		self:SetVisible(false)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
end

vgui.Register("deadremains.characteristics", panel, "EditablePanel")