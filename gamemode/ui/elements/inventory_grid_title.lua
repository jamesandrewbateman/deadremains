local ELEMENT = {}
function ELEMENT:Init()

	self.text = "XXXX"
	self:SetSize(60, 30)

end

function ELEMENT:setTitle(txt)

	self.text = txt

	surface.SetFont("deadremains.menu.gridTitle")
	local w, h = surface.GetTextSize(txt)
	self:SetSize(w + 4, h + 4)

end

function ELEMENT:Paint()

	draw.SimpleText(self.text, "deadremains.menu.gridTitle", 0, 0, deadremains.ui.colors.clr3, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

end
vgui.Register("deadremains.inventory_grid_title", ELEMENT, "Panel")