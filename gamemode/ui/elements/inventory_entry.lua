local ELEMENT = {}
function ELEMENT:Init()

	self.UI_SEC = deadremains.ui.getMenu().sec

	self.grid = vgui.Create("deadremains.inventory_grid", self)
	self.grid:SetPos(0, 0)

	self.infoL = vgui.Create("deadremains.inventory_info_bar", self)
	self.infoL:SetPos(0, 120)
	self.infoL:SetSize(269, 78)

	self.infoR = vgui.Create("deadremains.inventory_info_bar", self)
	self.infoR:SetPos(271, 120)
	self.infoR:SetSize(269, 78)

end

function ELEMENT:setID(id)

	self.id = id

	self.grid:setID(id)

end

function ELEMENT:setGridSize(x, y)

	self.sizeX = x
	self.sizeY = y

	self:SetSize(540, y * 60 + 78)

	self.grid:setGridSize(x, y)

	self.infoL:SetPos(0, y * 60)
	self.infoR:SetPos(271, y * 60)

end

function ELEMENT:setSelected(b)

	self.selected = b

	if b then

		if self.title then self.title:Remove() end

		local bar = self:GetParent().titleBar
		bar:setTitle(self.name)

		self.grid:SetPos(0, 0)
		self.infoL:SetPos(0, self.sizeY * 60)
		self.infoR:SetPos(271, self.sizeY * 60)

	else

		self.title = vgui.Create("deadremains.inventory_title", self)
		self.title:SetPos(0, 0)
		self.title:SetSize(540, 83)
		self.title:setTitle(self.name)

		self.grid:SetPos(0, 83)
		self.infoL:SetPos(0, self.sizeY * 60 + 83)
		self.infoR:SetPos(271, self.sizeY * 60 + 83)

	end

end

function ELEMENT:setName(name)

	self.name = name

end

function ELEMENT:setCapacity(kg)

	self.capacity = kg

	self.infoL:setMax(kg)
	self.infoL:setTitle("KG")

end

function ELEMENT:getID()

	return self.id

end

function ELEMENT:minimize()

	self:SetSize(540, 115)

	self.UI_SEC:minimize(self.id)

end

function ELEMENT:maximize()

	if self.selected then

		self:SetSize(540, self.sizeY * 60 + 78)

	else

		self:SetSize(540, self.sizeY * 60 + 78 + 83)

	end

	self.UI_SEC:maximize(self.id)

end

function ELEMENT:addItem(id, slotX, slotY)

	local item = vgui.Create("deadremains.item_icon", self)
	item:setID(id)
	item:setSlot(slotX, slotY)

end
vgui.Register("deadremains.inventory_entry", ELEMENT, "Panel")