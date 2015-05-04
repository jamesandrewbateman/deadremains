local color_label = Color(70, 70, 70, 255)
local color_active = Color(255, 255, 255, 120)
local color_inactive = Color(211, 211, 211, 10)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self.options = {}
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addOption(name, callback)
	table.insert(self.options, {name = name, callback = callback})
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:doClick()
	local w, h = self:GetSize()
	local x, y = self:LocalToScreen()

	x, y = x +16, y +h +2

	local panel = vgui.Create("deadremains.combobox.options")
	panel:SetPos(x, y)
	panel:SetWide(w)
	panel:populate(self.options)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local w, h = self:GetSize()

	self.arrow_polygon = {
		{x = w -50, y = h *0.5 -7}, -- Left corner.
		{x = w -34, y = h *0.5 -7}, -- Right corner.
		{x = w -42, y = h *0.5 +7} -- Bottom left corner.
	}
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(3, 0, 0, w, h, panel_color_background)

	if (!self.disabled) then
		if (self.arrow_polygon) then
			draw.NoTexture()

			surface.SetDrawColor(color_inactive)

			if (last_selected == self or self.Hovered) then
				surface.SetDrawColor(color_active)
			end
			
			surface.DrawPoly(self.arrow_polygon)
		end
		
		draw.SimpleText(self.name, "deadremains.button", 32, h *0.5, panel_color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

vgui.Register("deadremains.combobox", panel, "deadremains.button")

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	RegisterDermaMenuForClose(self)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:GetDeleteSelf()
	return true
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:populate(data)
	for i = 1, #data do
		local info = data[i]

		local panel = self:Add("Panel")
		panel:SetTall(48 +20 *1.5)
		panel:Dock(TOP)
		panel:DockMargin(0, 0, 0, 2)
		panel:SetCursor("hand")

		function panel:OnMousePressed()
			info.callback()
		end
		
		function panel:Paint(w, h)
			draw.RoundedBox(2, 0, 0, w, h, panel_color_background_light)
		end
		
		local label = panel:Add("DLabel")
		label:Dock(LEFT)
		label:DockMargin(32, 0, 0, 0)
		label:SetFont("deadremains.button")
		label:SetColor(color_label)
		label:SetText(info.name)
		label:SizeToContents()

		self:InvalidateLayout(true)
		self:SizeToChildren(false, true)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	
end

vgui.Register("deadremains.combobox.options", panel, "EditablePanel")