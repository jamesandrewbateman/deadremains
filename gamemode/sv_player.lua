----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local function default(self)
	local needs = deadremains.settings.get("needs")
	
	for unique, data in pairs (needs) do
		self.dr_character.needs[unique] = data.default
	end

	local characteristics = deadremains.settings.get("characteristics")
	
	for unique, data in pairs (characteristics) do
		self.dr_character.characteristics[unique] = data.default
	end

	local inventories = deadremains.settings.get("default_inventories")

	for unique, data in pairs(inventories) do
		self:createInventory(unique, data.horizontal, data.vertical)
	end
end

function player_meta:reset()
	default(self)
end
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:initializeCharacter()
	local steam_id = deadremains.sql.escape(database_main, self:SteamID())

	self.dr_character = {}

	self.dr_character.needs = {}
	self.dr_character.skills = {}
	self.dr_character.inventory = {}
	self.dr_character.characteristics = {}

	default(self)

	local needs = deadremains.settings.get("needs")
	local characteristics = deadremains.settings.get("characteristics")

	deadremains.sql.query(database_main, "SELECT * FROM `users` WHERE `steam_id` = " .. steam_id, function(data, affected, last_id)
		if (data and data[1]) then
			data = data[1]

			for unique, _ in pairs (needs) do
				local info = data["need_" .. unique]

				if (info) then
					self.dr_character.needs[unique] = info
				end
			end

			for unique, _ in pairs (characteristics) do
				local info = data["characteristic_" .. unique]

				if (info) then
					self.dr_character.characteristics[unique] = info
				end
			end

		-- No data, let's create a new profile.
		else
			local query = "INSERT INTO users(steam_id, "

			for unique, value in pairs(self.dr_character.needs) do
				query = query .. "need_" .. unique .. ", "
			end

			for unique, value in pairs(self.dr_character.characteristics) do
				query = query .. "characteristic_" .. unique .. ", "
			end

			query = string.sub(query, 0, #query -2) .. ") VALUES(".. steam_id .. ", "
			
			for unique, value in pairs(self.dr_character.needs) do
				query = query .. value .. ", "
			end

			for unique, value in pairs(self.dr_character.characteristics) do
				query = query .. value .. ", "
			end

			query = string.sub(query, 0, #query -2) .. ")"

			deadremains.sql.query(database_main, query)
		end
	end)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

util.AddNetworkString("deadremains.player.initalize")

net.Receive("deadremains.player.initalize", function(bits, player)
	if (!player.dr_loaded) then
		player:initializeCharacter()

		player.dr_loaded = true
	end
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:createInventory(unique, slots_horizontal, slots_vertical)
	self.dr_character.inventory[unique] = {slots_horizontal = slots_horizontal, slots_vertical = slots_vertical, slots = {}}
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:getItemsAtArea(inventory, start_x, start_y, end_x, end_y, return_one)
	local result = {}

	for i = 1, #inventory.slots do
		local slot = inventory.slots[i]

		if (slot) then
			local item = deadremains.item.get(slot.unique)
			local slot_x, slot_y = slot.x, slot.y
			local width, height = item.slots_horizontal *slot_size, item.slots_vertical *slot_size
			
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
	end

	return result
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

util.AddNetworkString("deadremains.getitem")

function player_meta:addItem(inventory_id, unique, amount, x, y)
	local inventory = self.dr_character.inventory[inventory_id]

	if (inventory) then
		local item = deadremains.item.get(unique)

		if (item) then
			if (inventory.type and item.type and inventory.type != item.type) then
				return false, "You can't equip that item there."
			end

			if (x and y) then
				if (x +item.slots_horizontal *slot_size -2 <= inventory.slots_horizontal *slot_size and y +item.slots_vertical *slot_size -2 <= inventory.slots_vertical *slot_size) then
					local items = self:getItemsAtArea(inventory, x +1, y +1, x +item.slots_horizontal *slot_size -2, y +item.slots_vertical *slot_size -2)
					
					if (#items <= 0) then
	
						-- Clamp it to the closest slot.
						for y2 = 1, inventory.slots_vertical do
							for x2 = 1, inventory.slots_horizontal do
								local slot_x, slot_y = x2 *slot_size -slot_size, y2 *slot_size -slot_size
				
								if (x +1 > slot_x +slot_size) then continue end
								if (y +1 > slot_y +slot_size) then continue end
								if (slot_x > x +1) then continue end
								if (slot_y > y +1) then continue end
								
								table.insert(inventory.slots, {unique = unique, amount = amount, x = slot_x, y = slot_y})
	
								net.Start("deadremains.getitem")
									net.WriteString(inventory_id)
									net.WriteString(unique)
									net.WriteUInt(amount, 32)
									net.WriteUInt(slot_x, 32)
									net.WriteUInt(slot_y, 32)
								net.Send(self)

								return true
							end
						end
					else
						return false, "Can't put that there."
					end
				end
			else
				local found = false

				for y = 1, inventory.slots_vertical do
					for x = 1, inventory.slots_horizontal do
						local start_x, start_y = x *slot_size -slot_size +1, y *slot_size -slot_size +1
						local end_x, end_y = start_x +item.slots_horizontal *slot_size -2, start_y +item.slots_vertical *slot_size -2
						
						-- Don't search outside the inventory bounds.
						if (end_x <= inventory.slots_horizontal *slot_size and end_y <= inventory.slots_vertical *slot_size and amount > 0) then
							local slots = self:getItemsAtArea(inventory, start_x, start_y, end_x, end_y)
							
							if (#slots <= 0) then

								-- We search 1 pixel inside the slot, reset that.
								start_x, start_y = start_x -1, start_y -1

								table.insert(inventory.slots, {unique = unique, amount = amount, x = start_x, y = start_y})

								net.Start("deadremains.getitem")
									net.WriteString(inventory_id)
									net.WriteString(unique)
									net.WriteUInt(amount, 32)
									net.WriteUInt(start_x, 32)
									net.WriteUInt(start_y, 32)
								net.Send(self)

								found = true

								return true
							else
								for i = 1, #slots do
									local slot = slots[i]
		
									if (slot.unique == item.unique) then
										if (slot.amount < item.stack) then
											local left_over = math.max(slot.amount +(amount -item.stack), 0)

											slot.amount = slot.amount +(amount -left_over)

											net.Start("deadremains.itemamount")
												net.WriteString(inventory_id)
												net.WriteString(slot.unique)
												net.WriteUInt(slot.x, 32)
												net.WriteUInt(slot.y, 32)
												net.WriteUInt(slot.amount, 32)
											net.Send(self)

											if (left_over > 0) then
												amount = left_over
											else
												return
											end
										end
									end
								end
							end
						end
					end
				end

				if (!found) then
					return false, "Can't fit that item into any inventory."
				end
			end
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

util.AddNetworkString("deadremains.removeitem")

function player_meta:removeItem(inventory_id, unique, amount, x, y)
	local inventory = self.dr_character.inventory[inventory_id]

	if (inventory) then
		local item = deadremains.item.get(unique)

		if (item) then
			for i = 1, #inventory.slots do
				local slot = inventory.slots[i]

				if (slot.unique == item.unique and slot.x == x and slot.y == y) then
					local difference = slot.amount -amount

					if (difference <= 0) then
						net.Start("deadremains.removeitem")
							net.WriteString(inventory_id)
							net.WriteString(unique)
							net.WriteUInt(slot.amount, 32)
							net.WriteUInt(x, 32)
							net.WriteUInt(y, 32)
						net.Send(self)

						table.remove(inventory.slots, i)
					else
						slot.amount = difference

						net.Start("deadremains.removeitem")
							net.WriteString(inventory_id)
							net.WriteString(unique)
							net.WriteUInt(amount, 32)
							net.WriteUInt(x, 32)
							net.WriteUInt(y, 32)
						net.Send(self)
					end

					break
				end
			end
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

util.AddNetworkString("deadremains.itemamount")

function player_meta:moveItem(new_inventory_id, inventory_id, unique, x, y, move_x, move_y)
	local inventory = self.dr_character.inventory[inventory_id]
	local new_inventory = self.dr_character.inventory[new_inventory_id]

	if (inventory and new_inventory) then
		local item = deadremains.item.get(unique)

		if (item) then

			-- The slot where we want to move our moving slot.
			local slot = self:getItemsAtArea(new_inventory, move_x +1, move_y +1, move_x +item.slots_horizontal *slot_size -2, move_y +item.slots_vertical *slot_size -2, true)
			
			-- The slot that we are moving.
			local move_slot = self:getItemsAtArea(inventory, x +1, y +1, x +item.slots_horizontal *slot_size -2, y +item.slots_vertical *slot_size -2, true)
			
			if (slot and slot != move_slot) then
				local slot_item = deadremains.item.get(slot.unique)

				if (slot_item) then

					-- The item in the slot we want to move to is the same.
					-- Let's fill it up.
					if (slot_item.unique == item.unique) then
						local left_over = math.max(slot.amount +(move_slot.amount -slot_item.stack), 0)

						-- We have merged! Let's remove the item we moved.
						if (left_over <= 0) then
							self:removeItem(inventory_id, unique, move_slot.amount, x, y)

							-- Fill up the slot that we're moving to.
							slot.amount = slot.amount +(move_slot.amount -left_over)
							
							net.Start("deadremains.itemamount")
								net.WriteString(new_inventory_id)
								net.WriteString(slot_item.unique)
								net.WriteUInt(move_x, 32)
								net.WriteUInt(move_y, 32)
								net.WriteUInt(slot.amount, 32)
							net.Send(self)

						-- Swap or fill up.
						else

							-- Let's fill it up
							if (slot.amount < slot_item.stack) then

								-- Set the amount on the slot that we are moving.
								move_slot.amount = left_over

								net.Start("deadremains.itemamount")
									net.WriteString(inventory_id)
									net.WriteString(unique)
									net.WriteUInt(x, 32)
									net.WriteUInt(y, 32)
									net.WriteUInt(move_slot.amount, 32)
								net.Send(self)

								-- Fill up the slot we're moving to.
								slot.amount = slot_item.stack

								net.Start("deadremains.itemamount")
									net.WriteString(new_inventory_id)
									net.WriteString(slot_item.unique)
									net.WriteUInt(move_x, 32)
									net.WriteUInt(move_y, 32)
									net.WriteUInt(slot.amount, 32)
								net.Send(self)

							-- Swap positions.
							else
								-- Remove the item that we are moving from.
								self:removeItem(inventory_id, unique, move_slot.amount, x, y)
								
								-- Add the item that we are moving to, to the moving slots position.
								self:addItem(inventory_id, slot.unique, slot.amount, x, y)
								
								-- Remove the item that we are moving to.
								self:removeItem(new_inventory_id, slot.unique, slot.amount, move_x, move_y)
	
								-- Add the item that we are moving to that slot.
								self:addItem(new_inventory_id, unique, move_slot.amount, move_x, move_y)
							end
						end
						
					-- Let's see if we can swap the positions of the slots.
					else
						if (item.slots_horizontal == slot_item.slots_horizontal and item.slots_vertical == slot_item.slots_vertical) then

							-- Remove the item that we are moving from.
							self:removeItem(inventory_id, unique, move_slot.amount, x, y)

							-- Add the item that we are moving to, to the moving slots position.
							self:addItem(inventory_id, slot.unique, slot.amount, x, y)

							-- Remove the item that we are moving to.
							self:removeItem(new_inventory_id, slot.unique, slot.amount, move_x, move_y)

							-- Add the item that we are moving to that slot.
							self:addItem(new_inventory_id, unique, move_slot.amount, move_x, move_y)
						else
							return false, "Can't swap these items."
						end
					end
				end

			-- We are moving to an empty area.
			else

				self:removeItem(inventory_id, unique, move_slot.amount, x, y)
				self:addItem(new_inventory_id, unique, move_slot.amount, move_x, move_y)
			end
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.getitem", function(bits, player)
	local inventory_id = net.ReadString()
	local unique = net.ReadString()
	local x = net.ReadUInt(32)
	local y = net.ReadUInt(32)

	player:addItem(inventory_id, unique, amount, x, y)
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

util.AddNetworkString("deadremains.moveitem")

net.Receive("deadremains.moveitem", function(bits, player)
	local new_inventory_id = net.ReadString() -- In what inventory we want to put this item.
	local inventory_id = net.ReadString() -- In what inventory we are currently.
	local unique = net.ReadString()
	local x = net.ReadUInt(32) -- Where the item comes from.
	local y = net.ReadUInt(32) -- Where the item comes from.
	local move_x = net.ReadUInt(32) -- Where we want to move the item.
	local move_y = net.ReadUInt(32) -- Where we want to move the item.

	player:moveItem(new_inventory_id, inventory_id, unique, x, y, move_x, move_y)
end)