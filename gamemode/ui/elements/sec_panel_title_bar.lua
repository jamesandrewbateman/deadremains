local ELEMENT = {}
function ELEMENT:Init()

	self.item = "XXXX"

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr9)
	surface.DrawRect(0, 0, w, h)

	draw.SimpleText("Selected Item - " .. self.item, "deadremains.menu.title", w / 2, h / 2, deadremains.ui.colors.clr3, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function ELEMENT:setTitle(item)

	self.item = item

end
vgui.Register("deadremains.sec_panel_title_bar", ELEMENT, "Panel")