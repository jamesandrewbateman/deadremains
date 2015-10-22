local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.sizeX = 2
	self.sizeY = 2

	self.icon = matCircle

	self.parent = self:GetParent()

end

function ELEMENT:setGridSize(x, y)

	self.sizeX = x
	self.sizeY = y

	self:SetSize(x * 60, y * 60)

	--print(self.sizeX, self.sizeY)
	--print(self:GetSize())
	self.modelPanel = vgui.Create("DModelPanel", self)
	self.modelPanel:SetSize(self.sizeX * 60, self.sizeY * 60)

	local i_data = deadremains.item.get(self.id)
	local sX, sY = self:GetPos()

	self.modelPanel:SetPos(sX, sY)

	self.modelPanel:SetModel(i_data.model)
	self.modelPanel:SetCamPos(i_data.cam_pos)
	self.modelPanel:SetLookAt(i_data.look_at)
	self.modelPanel:SetFOV(i_data.fov)
	self.modelPanel:SetMouseInputEnabled(true)

	self.modelPanel.item_icon = self

	function self.modelPanel:OnMousePressed(m)
		self.item_icon:OnMousePressed(m)
	end

	function self.modelPanel:OnMouseReleased(m)
		self.item_icon:OnMouseReleased(m)
	end

	function self.modelPanel:OnMouseWheeled(dt)
		self.item_icon:OnMouseWheeled(dt)
	end
end

function ELEMENT:Paint(w, h)
	if self.clicked then

		local x, y = gui.MousePos()
		if (math.abs(self.mPosX - x) > 5 or math.abs(self.mPosY - y) > 5) and !self.dragging then

			self:SetParent()
			self.dragging = true

			deadremains.ui.isDragging = true

			self:SetPos(x - w / 2, y - h / 2)

		elseif self.dragging then

			self:SetPos(x - w / 2, y - h / 2)

		end

		--surface.SetDrawColor(255, 255, 255, 255)
		--surface.SetMaterial(self.icon)
		--surface.DrawTexturedRect(0, 0, w, h)

	else

		surface.SetDrawColor(deadremains.ui.colors.clr2)
		surface.DrawRect(0, 0, w, h)

		--surface.SetDrawColor(255, 255, 255, 255)
		--surface.SetMaterial(self.icon)
		--surface.DrawTexturedRect(0, 0, w, h)

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

function ELEMENT:OnMouseWheeled(dt)

	self:GetParent():OnMouseWheeled(dt)

end

function ELEMENT:OnMouseReleased(m)

	if m == MOUSE_LEFT then

		self.clicked = false
		self.dragging = false

		self:onDropped()

	elseif m == MOUSE_RIGHT then
		-- find item information about this entry.
		local items = LocalPlayer().Inventories
		local foundItem = false
		local sX, sY = self:GetPos()

		for k,v in pairs(items) do
			if (v.SlotPosition.X == sX) then
				if (v.SlotPosition.Y == sY) then
					foundItem = v
				end
			end
		end

		-- does it exist?
		if not foundItem then return end

		if self.active then return end

		local activeMenu = deadremains.ui.getActiveActionMenu()
		if activeMenu then

			activeMenu:Remove()

		end

		self.active = true

		local w, _ = self:GetSize()
		self.circle_rad_to = w / 2

		local x, y = gui.MousePos()
		local actionMenu = vgui.Create("deadremains.inventory_action_menu")
		actionMenu:SetSize(190, 5)
		actionMenu:setOrigin(x + 15, y)
		actionMenu:setDisableFunc(function() self.active = false end)

		-- item meta to send to server
		actionMenu.inventoryName = foundItem.InventoryName
		actionMenu.itemUnique = foundItem.ItemUnique

		local actions = deadremains.item.get(self.id).context_menu
		for _, v in pairs(actions) do

			actionMenu:addAction(v.name, function()
				local slot = {}
				slot.action_name = v.name
				slot.inventory_name = actionMenu.inventoryName
				slot.item_unique = actionMenu.itemUnique
				slot.slot_position = Vector(sX, sY, 0)

				v.callback(slot)
				deadremains.ui.getActiveActionMenu():Remove()

				deadremains.ui.destroyMenu()
				deadremains.ui.createMenu()
			end, Material("deadremains/characteristics/sprintspeed.png", "noclamp smooth"))

		end

		deadremains.ui.activeActionMenu = actionMenu

	end

end

function ELEMENT:onDropped()

	self:SetParent(self.parent)
	self:SetPos(self.xPos, self.yPos)

	deadremains.ui.isDragging = false

end

function ELEMENT:setSlot(x, y, selected)

	self.slotX = x
	self.slotY = y

	if selected then

		self:SetPos((x - 1) * 60, (y - 1) * 60)

	else

		self:SetPos((x - 1) * 60, (y - 1) * 60 + 83)

	end

end

function ELEMENT:getSlot()

	return Vector(self.slotX, self.slotY, 0)

end

function ELEMENT:setID(id)

	self.id = id

end

function ELEMENT:getID()

	return self.id

end
vgui.Register("deadremains.item_icon", ELEMENT, "Panel")