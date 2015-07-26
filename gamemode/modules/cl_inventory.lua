local stored = {}

local meta_table = {}
meta_table.__index = meta_table

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.inventory.create(inventory_index, inventory_id)
	local inventory = stored[inventory_index] or {}
	local data = deadremains.inventory.get(inventory_id)

	setmetatable(inventory, meta_table)

	inventory.inventory_index = inventory_index
	inventory.unique = inventory_id
	inventory.slots = {}
	inventory.rows = data.slots_vertical
	inventory.columns = data.slots_horizontal
	inventory.width = inventory.columns *slot_size
	inventory.height = inventory.rows *slot_size

	stored[inventory_index] = inventory

	-- If an inventory already exists at that inventory_index, we need to clear it.
	local panel = inventory:getPanel()

	if (IsValid(panel)) then
		panel:clear()

	-- Create the inventory panel. (only external inventories)
	else
		if (data.external and IsValid(main_menu) and main_menu:IsVisible()) then
			local inventory_panel = main_menu:getPanel("inventory_panel")

			if (IsValid(inventory_panel)) then
				inventory_panel:setInventory(inventory_index, data)
			end
		end
	end

	return inventory
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.inventory.getStoredC()
	return stored
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.inventory.getc(inventory_index)
	return stored[inventory_index]
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.inventory.remove(inventory_index)
	local inventory = stored[inventory_index]

	if (inventory) then
		inventory:remove()
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:remove()
	if (IsValid(self.panel)) then
		local parent = self.panel:GetParent()

		if (IsValid(parent)) then
			local parent_slots = parent:GetParent():GetParent():GetParent() -- LOL

			parent:Remove()

			nextFrame(function()
				if (IsValid(parent_slots)) then
					parent_slots:resize()
				end
			end)
		end
	end

	stored[self.inventory_index] = nil

	self = nil
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:getInventoryIndex()
	return self.inventory_index
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:getInventoryID()
	return self.unique
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:setPanel(panel)
	self.panel = panel

	for i = 1, #self.slots do
		self.slots[i].parent = panel
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:getPanel()
	return self.panel
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:getSlotsAtArea(start_x, start_y, end_x, end_y, return_one)
	local result = {}

	for y = 1, self.rows do
		for x = 1, self.columns do
			if (isnumber(x) and isnumber(y)) then -- what the fuck?!?!
				local slot_x, slot_y = x *slot_size -slot_size, y *slot_size -slot_size
	
				if (start_x > slot_x +slot_size) then continue end
				if (start_y > slot_y +slot_size) then continue end
				if (slot_x > end_x) then continue end
				if (slot_y > end_y) then continue end
				
				if (return_one) then
					return {x = slot_x, y = slot_y}
				else
					table.insert(result, {x = slot_x, y = slot_y})
				end
			end
		end
	end

	return result
end
 
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:getItemsAtArea(start_x, start_y, end_x, end_y, return_one)
	local result = {}

	for i = 1, #self.slots do
		local slot = self.slots[i]
		local slot_x, slot_y = slot.x, slot.y
		local width, height = slot.width, slot.height
		
		if (start_x > slot_x +width) then continue end
		if (start_y > slot_y +height) then continue end
		if (slot_x > end_x) then continue end
		if (slot_y > end_y) then continue end

		if (return_one) then
			return slot
		else
			table.insert(result, slot)
		end
	end

	return result
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------
 
function meta_table:addItem(item, x, y)
	if (x and y) then
		local slot = {}
		slot.item = item
		slot.x, slot.y = x, y
		slot.width, slot.height = item.slots_horizontal *slot_size, item.slots_vertical *slot_size
		slot.size = item.slots_vertical *item.slots_horizontal
		slot.inventory_index = self.inventory_index

		-- This is basically like Panel.GetParent
		slot.parent = self.panel

		self:addSlot(slot)

		-- Create the icon in the UI.
		if (IsValid(self.panel)) then
			self.panel:addItem(slot)
		end
	else
		for y = 1, self.rows do
			for x = 1, self.columns do
				local start_x, start_y = x *slot_size -slot_size +1, y *slot_size -slot_size +1
				local end_x, end_y = start_x +item.slots_horizontal *slot_size -2, start_y +item.slots_vertical *slot_size -2
				
				if (end_x <= self.width and end_y <= self.height) then
					local slots = self:getItemsAtArea(start_x, start_y, end_x, end_y)
		
					if (#slots <= 0) then
						local slot = {}
						slot.item = item
						slot.x, slot.y = start_x, start_y
						slot.width, slot.height = item.slots_horizontal *slot_size, item.slots_vertical *slot_size
						slot.size = item.slots_vertical *item.slots_horizontal
						slot.inventory_index = self.inventory_index

						-- This is basically like Panel.GetParent
						slot.parent = self.panel

						self:addSlot(slot)
						
						-- Create the icon in the UI.
						if (IsValid(self.panel)) then
							self.panel:addItem(slot)
						end

						return
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:removeItem(item, x, y)
	local slot = self:getItemsAtArea(x +1, y +1, x +item.slots_horizontal *slot_size -2, y +item.slots_vertical *slot_size -2, true)

	if (slot) then
		if (IsValid(slot.slot_panel)) then
			slot.slot_panel:Remove()
		end

		self:removeSlot(slot)
	end
end


----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:addSlot(slot)
	table.insert(self.slots, slot)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:removeSlot(slot)
	for i = 1, #self.slots do
		if (self.slots[i] == slot) then
			table.remove(self.slots, i)

			break
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.getitem", function(bits)
	local inventory_index = net.ReadUInt(8)
	local unique = net.ReadString()
	local x = net.ReadUInt(32)
	local y = net.ReadUInt(32)

	local item = deadremains.item.get(unique)

	if (item) then
		local inventory = stored[inventory_index]

		if (inventory) then
			inventory:addItem(item, x, y)
		end
	end
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.removeitem", function(bits)
	local inventory_index = net.ReadUInt(8)
	local unique = net.ReadString()
	local x = net.ReadUInt(32)
	local y = net.ReadUInt(32)

	local item = deadremains.item.get(unique)

	if (item) then
		local inventory = stored[inventory_index]
	
		if (inventory) then
			inventory:removeItem(item, x, y)
		end
	end
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.createinventory", function(bits)
	local inventory_index = net.ReadUInt(8)
	local inventory_id = net.ReadString()

	deadremains.inventory.create(inventory_index, inventory_id)
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.removeinventory", function(bits)
	local inventory_index = net.ReadUInt(8)

	deadremains.inventory.remove(inventory_index)
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.networkinventory", function(bits)
	local inventory_index = net.ReadUInt(8)
	local inventory_id = net.ReadString()

	local inventory = stored[inventory_index]

	if (!inventory) then
		inventory = deadremains.inventory.create(inventory_index, inventory_id)
	end

	local len = net.ReadUInt(8)

	for i = 1, len do
		local unique = net.ReadString()
		local x = net.ReadUInt(32)
		local y = net.ReadUInt(32)

		local item = deadremains.item.get(unique)

		inventory:addItem(item, x, y)
	end
end)