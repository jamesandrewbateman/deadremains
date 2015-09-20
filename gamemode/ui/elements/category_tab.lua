local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.icon = matCircle

	self.active = false

	self.hovered = false

	self.pos_y = -1
	self.pos_y_to = -1

	self.a = 0
	self.a_to = 1

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	self.pos_y = deadremains.ui.lerp(0.25, self.pos_y, self.pos_y_to)

	local pos_x, pos_y = self:GetPos()
	if pos_y != self.pos_y_to and self.pos_y != -1 then

		self:SetPos(pos_x, self.pos_y)

	elseif self.a != self.a_to then

		self.a = deadremains.ui.lerp(0.15, self.a, self.a_to)

	end

	if !self.active then

		surface.SetDrawColor(deadremains.ui.colors.clr10.r, deadremains.ui.colors.clr10.g, deadremains.ui.colors.clr10.b, deadremains.ui.colors.clr10.a * self.a)
		surface.DrawRect(0, 0, w, h)

	end

	if self.active or self.hovered and self.a > 0.7 then

		surface.SetDrawColor(deadremains.ui.colors.clr3.r, deadremains.ui.colors.clr3.g, deadremains.ui.colors.clr3.b, deadremains.ui.colors.clr3.a * self.a)

	else

		surface.SetDrawColor(deadremains.ui.colors.clr7.r, deadremains.ui.colors.clr7.g, deadremains.ui.colors.clr7.b, deadremains.ui.colors.clr7.a)

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

function ELEMENT:moveTo(to_x, to_y)

	local x, y = self:GetPos()

	self.a = 0

	self.pos_y = y

	self.pos_y_to = to_y

end

function ELEMENT:setActive(b)

	self.active = b

	if b then

		self.panel:Show()

	else

		self.panel:Hide()

	end

end

function ELEMENT:getActive()

	return self.active

end

function ELEMENT:OnCursorEntered()

	self.hovered = true

end

function ELEMENT:OnMousePressed(m)

	self.hovered = false

	self.active = true

	self.DoClick(self)

	local activeActionMenu = deadremains.ui.getActiveActionMenu()
	if activeActionMenu then activeActionMenu:Remove() end

end

function ELEMENT:OnCursorExited()

	self.hovered = false

end
vgui.Register("deadremains.category_tab", ELEMENT, "Panel")