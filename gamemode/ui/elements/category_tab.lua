local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.icon = matCircle

	self.active = false

	self.hovered = false

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	if !self.active then

		surface.SetDrawColor(deadremains.ui.colors.clr5)
		surface.DrawRect(0, 0, w, h)

	end

	if self.active or self.hovered then

		surface.SetDrawColor(deadremains.ui.colors.clr3)

	else

		surface.SetDrawColor(deadremains.ui.colors.clr7)

	end

	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect( 0, 0, w, h )

end

function ELEMENT:setPanel(p)

	self.panel = p

end

function ELEMENT:setIcon(icon)

	self.icon = icon

end

function ELEMENT:setActive(b)

	self.active = b

	if b then

		self.panel:Show()

	else

		self.panel:Hide()

	end

end

function ELEMENT:OnCursorEntered()

	self.hovered = true

end

function ELEMENT:OnMousePressed(m)

	self.hovered = false

	self.active = true

	self.DoClick(self)

end

function ELEMENT:OnCursorExited()

	self.hovered = false

end
vgui.Register("deadremains.category_tab", ELEMENT, "Panel")