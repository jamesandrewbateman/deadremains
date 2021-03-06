--[[
	STRUCTURE OF INVENTORY SYSTEM!

	player.inventories = { }

	player.inventories[inventory index] =
		{
			name = "Backpack"
			size = Vector(10, 10, 0)							-- not networked
			items =
				{
					{
						unique = "tin_beans"
						slot_position = Vector(0, 0, 0)
						contains = { item1, item2, item3 }		-- not networked
					}
				}
		}

]]

concommand.Add("give_backpack", function(ply)
	ply:AddInventory("hunting_backpack", 9, 9)
end)

concommand.Add("dr_drop_inv", function(ply, cmd, args)
	ply:DropInventory(args[1])
end)

concommand.Add("Networkinv", function(ply)
	ply:NetworkInventory()
end)

-- BASE INVENTORY STRUCTURE
function player_meta:InitInventories()
	local invs = deadremains.settings.get("default_inventories")

	self.Inventories = {}

	for k,v in pairs(invs) do
		if (v.inventory_index ~= -1) then 
			self.Inventories[v.inventory_index] = 
			{
				Name = v.unique,
				Size = v.size,
				MaxWeight = v.max_weight,
				CurrentWeight = 0,
				Items = {}
			}
		end
	end

	self:NetworkInventory()
end

function player_meta:AddInventory(unique, horiz, vert, inv_index, max_weight)
	local found = false

	if (inv_index == nil) then
		for k,v in pairs(self.Inventories) do
			if v.Name == unique and not found then
				inv_index = k
				found = true
			end
		end

		if not found then
			inv_index = #self.Inventories + 1
		end
	end

	if (max_weight == nil) then max_weight = 20000 end

	if found then
		return false
	else
		self.Inventories[inv_index] =
		{
			Name = unique,
			Size = Vector(horiz, vert, 0),
			MaxWeight = max_weight,
			CurrentWeight = 0,
			Items = {}
		}
	end

	self:NetworkInventory()

	deadremains.notifyer.Add(self, "Equipped " .. unique)

	return true
end

function player_meta:AddInventoryContains(unique, horiz, vert, contains)
	if self:AddInventory(unique, horiz, vert) then
		for k,v in pairs(contains) do
			local item_unique = v.Unique
			self:AddItemToInventory(unique, item_unique)
		end
		return true
	else
		for k,v in pairs(contains) do
			local item_unique = v.Unique
			self:AddItemToInventory(unique, item_unique)
		end
		return true
	end
	return false
end

function player_meta:GetInventoryId(name)
	local invID = 0
	for k,v in pairs(self.Inventories) do if v.Name == name then invID = k end end

	return invID
end

function player_meta:RemoveInventory(name)
	local invID = self:GetInventoryId(name)
	self.Inventories[invID] = nil
end

function player_meta:GetInventory(name)
	local invID = self:GetInventoryId(name)
	return self.Inventories[invID]
end

function player_meta:GetInventoryName(id)
	return self.Inventories[id].Name
end

function player_meta:DropInventory(unique)
	deadremains.item.spawn_contains(self, unique, self:GetInventory(unique).Items)

	self:RemoveInventory(unique)

	self:NetworkInventory()

	net.Start("deadremains.refreshinv")
	net.Send(self)
end
util.AddNetworkString("deadremains.refreshinv")

-- ITEM ACTIONS --
-- used internally, does not check for placement collisions.
-- inv_type is whether it provides a inventory space or not (is the unique).
function player_meta:InsertItem(inv_name, unique, inv_type, slot_position, contains)
	local invId = self:GetInventoryId(inv_name)
	local inv = self:GetInventory(inv_name)
	local items = inv.Items

	local itemData = deadremains.item.get(unique)

	if (itemData.equip_slot) then
		-- can it be placed here?
		if (bit.band(bit.lshift(1, invId), itemData.equip_slot) != 0) then

			local s, x, y = self:CanFitItem(inv_name, unique)
			if s then
				inv.CurrentWeight = inv.CurrentWeight + itemData.weight

				if (inv.CurrentWeight <= inv.MaxWeight) then
					table.insert(items, {
							Unique = unique,
							SlotPosition = slot_position,
							InvType = inv_type,
							Contains = contains
						})
					self:NetworkInventory()

					deadremains.notifyer.Add(self, "+" .. itemData.label)

					return true
				else
					-- pretend we didn't do that.
					inv.CurrentWeight = inv.CurrentWeight - itemData.weight

					deadremains.notifyer.Add(self, "You are over encumbered")
				end
			end
		end
	else
		-- after index 7 of inventories, ANYTHING can be placed.
		if (#self.Inventories > inventory_equip_maximum) then		-- do we have more inventory space?
			for indx = inventory_equip_maximum + 1, #self.Inventories do
				local invName = self:GetInventoryName(indx)
				local inv = self:GetInventory(invName);
					
				-- loop through all extra inventories, try to fit it in.
				local s, x, y = self:CanFitItem(invName, unique)
				if s then

					inv.CurrentWeight = inv.CurrentWeight + itemData.weight

					if (inv.CurrentWeight <= inv.MaxWeight) then
						table.insert(self:GetInventory(invName).Items, {
								Unique = unique,
								SlotPosition = Vector(x, y, 0),
								InvType = inv_type,
								Contains = contains
							})
						
						self:NetworkInventory()

						deadremains.notifyer.Add(self, "+" ..  itemData.label)

						return true
					else
						-- pretend we didn't do that.
						inv.CurrentWeight = inv.CurrentWeight - itemData.weight

						deadremains.notifyer.Add(self, "You are over encumbered")
					end
				end
			end
		else
			deadremains.notifyer.Add(self, "Inventory full")
		end
	end
end

function player_meta:AddItemToInventorySlot(inv_name, item_unique, slot_position, contains)
	local inv = self:GetInventory(inv_name)
	local selectedItemCore = deadremains.item.get(item_unique)
	local s, x, y = self:CanFitItem(inv_name, item_unique, contains)

	if s then
		self:InsertItem(inv_name, item_unique, selectedItemCore.inventory_type, slot_position, contains)
	end
end

--
-- EXTERNAL version of the additem.
--
function player_meta:AddItemToInventory(inv_name, item_unique, contains)
	local s, x, y = self:CanFitItem(inv_name, item_unique, contains)
	local selectedItemCore = deadremains.item.get(item_unique)


	return self:InsertItem(inv_name, item_unique, selectedItemCore.inventory_type, Vector(x, y, 0), contains)

end

function player_meta:SwitchItemToInventory(inv_name, target_inv_name, item_unique, item_position, contains)
	local s, x, y = self:CanFitItem(target_inv_name, item_unique, contains)
	-- will it fit?
	if s then
		-- does the inventory we say we are moving stuff from actually contain that item.
		if self:ContainsItem(inv_name, item_unique, item_position) then
			-- remove item from inv_ and add to target_inv_
			self:RemoveItem(inv_name, item_position)

			self:AddItemToInventory(target_inv_name, item_unique, contains)
		end
	end
end


function player_meta:CanFitItem(inv_name, item_unique, contains)
	local inv = self:GetInventory(inv_name)
	local selectedItemCore = deadremains.item.get(item_unique)

	if selectedItemCore == nil then
		return false, -1, -1
	end

	local it_slotwidth = inv.Size.X - selectedItemCore.slots_horizontal
	local it_slotheight = inv.Size.Y - selectedItemCore.slots_vertical

	for ox = 0, it_slotwidth do
		for oy = 0, it_slotheight do
			local testOriginItem = self:GetItemAt(inv_name, Vector(ox, oy, 0))
			local slotsFreeArea = 0

			-- this one is empty, what about the others?
			if testOriginItem == 0 then

				-- for each slot within the projected new position, is there an item present?
				for dx = 0, selectedItemCore.slots_horizontal - 1 do
					for dy = 0, selectedItemCore.slots_vertical - 1 do
						local testItem = self:GetItemAt(inv_name, Vector(ox, oy, 0) + Vector(dx, dy, 0))
						if testItem == 0 then
							slotsFreeArea = slotsFreeArea + 1
						end
					end
				end

				if slotsFreeArea >= (selectedItemCore.slots_horizontal * selectedItemCore.slots_vertical) then
					
					return true, ox, oy
				end
			else
				--print(testOriginItem.Unique)
			end
		end
	end

	return false, 0, 0
end

function player_meta:RemoveItemCrafting(item_name)

	--PrintTable(self.Inventories)

	for k,v in pairs(self.Inventories) do

		for i,j in pairs(v.Items) do

			--print(j.Unique, item_name)

			if j.Unique == item_name then

				local item_weight = deadremains.item.get(j.Unique).weight

				table.remove(self:GetInventory(v.Name).Items, i)

				self:GetInventory(v.Name).CurrentWeight = self:GetInventory(v.Name).CurrentWeight - item_weight

			end

		end

	end
end

-- for removing from the inventory
function player_meta:RemoveItem(inv_name, slot_position)
	local items = self:GetInventory(inv_name).Items

	for k,v in pairs(items) do

		if (v.SlotPosition == slot_position) then

			local item_weight = deadremains.item.get(v.Unique).weight

			table.remove(items, k)

			self:GetInventory(inv_name).CurrentWeight = self:GetInventory(inv_name).CurrentWeight - item_weight

		end

	end
end

-- for searching the inventory
function player_meta:GetItemAt(inv_name, position)
	local items = self:GetInventory(inv_name).Items

	local selected_item = 0

	-- get the item which this point lands inside of.
	for k,v in pairs(items) do
		local x,y,w,h = self:GetItemBBox(v.SlotPosition, v.Unique)

		if position.X >= x and position.X <= x + w then
			if position.Y >= y and position.Y <= y + h then
				-- found an item to select
				selected_item = v
			end
		end
	end

	return selected_item
end

-- returns a table with all items with that name and their slot positions.
function player_meta:InventoryGetAll(inv_name, item_name)
	local items = self:GetInventory(inv_name).Items

	local selected_items = {}
	for k,v in pairs(items) do
		if (v.Unique == item_name) then
			table.insert(selected_items, v)
		end
	end

	return selected_items
end

function player_meta:InventoryGetItemCount(item_name)
	local item_count = 0

	for k,v in pairs(self.Inventories) do
		local items = v.Items

		for k,v in pairs(items) do
			if (v.Unique == item_name) then
				item_count = item_count + 1
			end
		end
	end

	return item_count
end

function player_meta:ContainsItem(inv_name, item_name, position)
	local items = self:InventoryGetAll(inv_name, item_name)

	for k,v in pairs(items) do
		if (v.SlotPosition == position) then
			return true
		end
	end

	return false
end

-- bbox in slots
function player_meta:GetItemBBox(slot_position, item_unique)
	local i = deadremains.item.get(item_unique)

	local width = i.slots_horizontal - 1
	local height = i.slots_vertical - 1

	local oX = slot_position.x
	local oY = slot_position.y

	return oX,oY, width,height
end

util.AddNetworkString("deadremains.networkinventory")
function player_meta:NetworkInventory()
	-- calculate how many items need to be sent.
	-- perf opti would include ignoring entires which haven't changed.

	local c = 0
	for k,v in pairs(self.Inventories) do
		for i,j in pairs(v.Items) do
			c = c + 1
		end
	end

	net.Start("deadremains.networkinventory")

		net.WriteUInt(c, 16)

		for invIndex, inv in pairs(self.Inventories) do
			local name = inv.Name
			local maxWeight = inv.MaxWeight
			local currentWeight = inv.CurrentWeight
			local items = inv.Items
			local size = inv.Size

			-- send a condensed version of our inventory.
			for itemIndex, item in pairs(items) do
				-- inventory index CL
				net.WriteString(name)
				net.WriteVector(size)
				net.WriteUInt(maxWeight, 16)
				net.WriteUInt(currentWeight, 16)

				-- item data name
				net.WriteString(item.Unique)
				net.WriteVector(item.SlotPosition)
			end
		end

	net.Send(self)
end

-- item handing clientside hooks
util.AddNetworkString("deadremains.itemaction")
net.Receive("deadremains.itemaction", function(bits, ply)
	local action_name = net.ReadString()
	local inventory_name = net.ReadString()
	local item_unique = net.ReadString()
	local item_slot_position = net.ReadVector()

	-- net library likes to optimize out 0,0,0 value of vector.
	if (item_slot_position == nil) then item_slot_position = Vector(0,0,0) end

	local itemData = deadremains.item.get(item_unique)
	local itemInvData = ply:GetItemAt(inventory_name, item_slot_position)

	if (itemInvData ~= 0) then
		if (action_name == "Consume") and (type_to_string(itemData.meta["type"]) == "consumable") then
			ply:RemoveItem(inventory_name, itemInvData.SlotPosition)

			--print("eating ", item_unique, itemInvData.SlotPosition)

			itemData:use(ply)
		elseif (action_name == "Drop") then
			ply:RemoveItem(inventory_name, itemInvData.SlotPosition)

			--print("dropping", item_unique, itemInvData.SlotPosition)
			if (itemData.inventory_type) then
				deadremains.item.spawn_meta(ply, itemInvData.Unique, itemInvData.Contains)
			else
				deadremains.item.spawn(ply, itemInvData.Unique)
			end
		elseif (action_name == "Use") then
			ply:RemoveItem(inventory_name, itemInvData.SlotPosition)

			--print("using", item_unique, itemInvData.SlotPosition)
			itemData:use(ply)
		elseif (action_name == "Equip") then
			ply:RemoveItem(inventory_name, itemInvData.SlotPosition)
			--PrintTable(itemData)
			ply:Give(itemData.unique)
		end
	end

	-- if itemInvData == 0, means we tried to select an item which isn't
	-- here serverside.
	ply:NetworkInventory()

	net.Start("deadremains.refreshinv")
	net.Send(ply)
end)