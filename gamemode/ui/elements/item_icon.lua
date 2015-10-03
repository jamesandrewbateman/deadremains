local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.sizeX = 2
	self.sizeY = 2

	self.icon = matCircle

end

function ELEMENT:setGridSize(x, y)

	self.sizeX = x
	self.sizeY = y

	self:SetSize(x * 60, y * 60)

end

function ELEMENT:Paint(w, h)

	if self.clicked then

		local x, y = gui.MousePos()
		if math.abs(self.mPosX - x) > 5 or math.abs(self.mPosY - y) > 5 or self.dragging then

			self.dragging = true
			self:SetPos(x - w / 2, y - h / 2)

		end

	else

		surface.SetDrawColor(deadremains.ui.colors.clr2)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(0, 0, w, h)

	end

end

function ELEMENT:OnMousePressed(m)

	if m == MOUSE_LEFT then

		local x, y = self:GetPos()
		self.xPos = x
		self.yPos = y

		self.clicked = true

		self.mPosX = gui.MouseX()
		self.mPosY = gui.MouseY()

	end

end

function ELEMENT:OnMouseReleased(m)

	if m == MOUSE_LEFT then

		self.clicked = false
		self.dragging = false

		self:onDropped()

	end

end

function ELEMENT:onDropped()

	self:SetPos(self.xPos, self.yPos)

end

function ELEMENT:setSlot(x, y)

	self.slotX = x
	self.slotY = y

	self:SetPos(x * 60, y * 60)

end

function ELEMENT:setID(id)

	self.id = id

end

function ELEMENT:getID()

	return self.id

end
vgui.Register("deadremains.item_icon", ELEMENT, "Panel")