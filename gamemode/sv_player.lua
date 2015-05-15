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
			default(self)

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
	end,

	-- Failed to connect to the database.
	function()
		default(self)
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

util.AddNetworkString("deadremains.getitem")

function player_meta:addItem(inventory_id, unique, amount, x, y)
	local inventory = self.dr_character.inventory[inventory_id]

	if (inventory) then
		local item = deadremains.item.get(unique)

		if (item) then
			if (x and y) then
				if (x +item.slots_horizontal *slot_size -2 <= inventory.slots_horizontal *slot_size and y +item.slots_vertical *slot_size -2 <= inventory.slots_vertical *slot_size) then
					local items = self:getItemsAtArea(inventory, x, y, x +item.slots_horizontal *slot_size, y +item.slots_vertical *slot_size)

					if (#items <= 0) then
	
						-- Clamp it to the closest slot.
						for y2 = 1, inventory.slots_vertical do
							for x2 = 1, inventory.slots_horizontal do
								local slot_x, slot_y = x2 *slot_size -slot_size, y2 *slot_size -slot_size
								local width, height = slot_size, slot_size
		
								if (x > slot_x +width) then continue end
								if (y > slot_y +height) then continue end
								if (slot_x > x) then continue end
								if (slot_y > y) then continue end
								
								table.insert(inventory.slots, {unique = unique, amount = amount, x = slot_x, y = slot_y})
	
								net.Start("deadremains.getitem")
									net.WriteString(inventory_id)
									net.WriteString(unique)
									net.WriteUInt(slot_x, 8)
									net.WriteUInt(slot_y, 8)
								net.Send(self)

								return true
							end
						end
					else
						return false
					end
				end
			else
				for y = 1, inventory.slots_vertical do
					for x = 1, inventory.slots_horizontal do
						local start_x, start_y = x *slot_size -slot_size +1, y *slot_size -slot_size +1
						local end_x, end_y = start_x +item.slots_horizontal *slot_size -2, start_y +item.slots_vertical *slot_size -2
						
						-- Don't search outside the inventory bounds.
						if (end_x <= inventory.slots_horizontal *slot_size and end_y <= inventory.slots_vertical *slot_size) then
							local slots = self:getItemsAtArea(inventory, start_x, start_y, end_x, end_y)
				
							if (#slots <= 0) then

								-- We search 1 pixel inside the slot, reset that.
								start_x, start_y = start_x -1, start_y -1

								table.insert(inventory.slots, {unique = unique, amount = amount, x = start_x, y = start_y})

								net.Start("deadremains.getitem")
									net.WriteString(inventory_id)
									net.WriteString(unique)
									net.WriteUInt(start_x, 8)
									net.WriteUInt(start_y, 8)
								net.Send(self)

								return true
							else
								return false
							end
						end
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

function player_meta:getItemsAtArea(inventory, start_x, start_y, end_x, end_y)
	local result = {}

	for i = 1, #inventory.slots do
		local slot = inventory.slots[i]
		local item = deadremains.item.get(slot.unique)
		local slot_x, slot_y = slot.x, slot.y
		local width, height = item.slots_horizontal *slot_size, item.slots_vertical *slot_size
		
		width, height = width -1, height -1

		if (start_x > slot_x +width) then continue end
		if (start_y > slot_y +height) then continue end
		if (slot_x > end_x) then continue end
		if (slot_y > end_y) then continue end

		table.insert(result, slot)
	end

	return result
end
