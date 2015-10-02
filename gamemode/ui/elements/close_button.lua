local matCross = Material("deadremains/menu/cross.png", "noclamp smooth")

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

	if self.hovered then

		surface.SetDrawColor(deadremains.ui.colors.clr16)

	else

		surface.SetDrawColor(deadremains.ui.colors.clr13)

	end
	surface.SetMaterial(matCross)
	surface.DrawTexturedRect(0, 0, w, h)

end
vgui.Register("deadremains.close_button", ELEMENT, "Panel")