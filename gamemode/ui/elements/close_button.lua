local ELEMENT = {}
function ELEMENT:Init()

	self.toRemove = self

end

function ELEMENT:OnCursorEntered()

	self.hovered = true

end

function ELEMENT:OnMousePressed()

	self.toRemove:Remove()

end

function ELEMENT:OnCursorExited()

	self.hovered = false

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr14)
	surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.close_button", ELEMENT, "Panel")