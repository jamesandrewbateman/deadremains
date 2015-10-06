local ELEMENT = {}
function ELEMENT:Init()

	self.sizeX = 2
	self.sizeY = 2

end

function ELEMENT:setGridSize(x, y)

	self.sizeX = x
	self.sizeY = y

	self:SetSize(x * 60, y * 60)

end

function ELEMENT:Think()

	local mx, my = gui.MousePos()
	local s_mx, s_my = self:ScreenToLocal(mx, my)

	if s_mx > 0 and s_my > 0 and s_mx < self:GetWide() and s_my < self:GetTall() and !self.minimized then

		self:setHovered(true)

	else

		self:setHovered(false)

	end

end

function ELEMENT:OnMouseWheeled(dt)

	self:GetParent():OnMouseWheeled(dt)

end

function ELEMENT:Paint(w, h)

	if self.hovered then

		surface.SetDrawColor(deadremains.ui.colors.clr18)

	else

		surface.SetDrawColor(deadremains.ui.colors.clr17)

	end
	surface.DrawRect(1, 1, w - 2, h - 2)

	surface.SetDrawColor(deadremains.ui.colors.clr6)
	surface.DrawRect(0, 0, w, 1)
	surface.DrawRect(w - 1, 1, 1, h - 1)
	surface.DrawRect(0, h - 1, w - 1, 1)
	surface.DrawRect(0, 1, 1, h - 2)

	for i = 1, self.sizeX - 1 do

		surface.SetDrawColor(deadremains.ui.colors.clr6)
		surface.DrawRect(i * 60, 1, 1, h - 2)

	end

	for i = 1, self.sizeY - 1 do

		surface.SetDrawColor(deadremains.ui.colors.clr6)
		surface.DrawRect(1, i * 60, w - 2, 1)

	end

end

function ELEMENT:setHovered(b)

	self.hovered = b

end

function ELEMENT:setID(id)

	self.id = id

end

function ELEMENT:getID()

	return self.id

end
vgui.Register("deadremains.inventory_grid", ELEMENT, "Panel")