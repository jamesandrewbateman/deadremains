local ELEMENT = {}
function ELEMENT:Init()

	self.title = "XXXX"

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 0, w, h)

	draw.SimpleText(self.title, "deadremains.menu.title", w / 2 + 50, h / 2, deadremains.ui.colors.clr3, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function ELEMENT:setTitle(title)

	self.title = title

end
vgui.Register("deadremains.panel_title_bar", ELEMENT, "Panel")