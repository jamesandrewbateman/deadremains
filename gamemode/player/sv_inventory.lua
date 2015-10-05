--[[
	STRUCTURE OF INVENTORY SYSTEM!

	player.inventories = { }

	player.inventories[inventory index] =
		{
			name = "Backpack"
			size = Vector(10, 10, 0)
			items =
				{
					{
						unique = "tin_beans"
						slot_position = Vector(0, 0, 0)
						contains = { item1, item2, item3 }
					}
				}
		}

]]

-- BASE INVENTORY STRUCTURE
function player_meta:InitInventories()
	print("INIT INVENTORIES")
	local invs = deadremains.settings.get("default_inventories")

	self.Inventories = {}

	for k,v in pairs(invs) do
		self.Inventories[v.inventory_index] = 
		{
			Name = v.unique,
			Size = v.size,
			Items = {}
		}
	end
end
hook.Add("PlayerInitialSpawn", "invPSpawn", function(ply)
	ply:InitInventories()
end)

function player_meta:AddInventory(unique, horiz, vert, inv_index)
	if (inv_index == nil) then inv_index = #self.Inventories + 1 end

	self.Inventories[inv_index] =
	{
		Name = unique,
		Size = Vector(horiz, vert, 0),
		Items = {}
	}
end

concommand.Add("give_backpack", function(ply)
	ply:AddInventory("hunting_backpack", 9, 3)
end)

function player_meta:GetInventoryId(name)
	local invID = 0
	for k,v in pairs(self.Inventories) do if v.Name == name then invID = k end end

	return invID
end

function player_meta:RemoveInventory(name)
	local invID = self:GetInventoryId(name)
	
end

function player_meta:GetInventory(name)
	local invID = self:GetInventoryId(name)
	return self.Inventories[invID]
end

function player_meta:GetInventoryName(id)
	return self.Inventories[id].Name
end


-- ITEM ACTIONS --
-- used internally, does not check for placement collisions.
-- inv_type is whether it provides a inventory space or not (is the unique).
function player_meta:InsertItem(inv_name, unique, inv_type, slot_position, contains)
	local invId = self:GetInventoryId(inv_name)
	local inv = self:GetInventory(inv_name)
	local items = inv.Items

	local itemData = deadremains.item.get(unique)

	if (itemData.equip_slot) then
		if (bit.band(bit.lshift(1, invId), itemData.equip_slot) != 0) then
			print("can fit it in this inventory space!")
			table.insert(items, {
					Unique = unique,
					SlotPosition = slot_position,
					InvType = inv_type,
					Contains = contains
				})
		end
	else
		-- after index 7 of inventories, ANYTHING can be placed.
		if (#self.Inventories > inventory_equip_maximum) then		-- do we have more inventory space?
			for indx = inventory_equip_maximum + 1, #self.Inventories do
				print("found extra inventories, checking to fit it in.")
				local invName = self:GetInventoryName(indx)

				-- loop through all extra inventories, try to fit it in.
				local s, x, y = self:CanFitItem(invName, unique)
				if s then
					print("Fit item in ", indx)
					table.insert(self:GetInventory(invName).Items, {
							Unique = unique,
							SlotPosition = Vector(x, y, 0),
							InvType = inv_type,
							Contains = contains
						})
					return
				end
			end
		else
			print("Max inventory number reached")
		end
	end
end
concommand.Add("Instinbeans", function(ply)
	ply:AddItemToInventory("feet", "tin_beans")
end)

function player_meta:AddItemToInventorySlot(inv_name, item_unique, slot_position, contains)
	local inv = self:GetInventory(inv_name)
	local selectedItemCore = deadremains.item.get(item_unique)
	local s, x, y = self:CanFitItem(inv_name, item_unique, contains)

	if s then
		self:InsertItem(inv_name, item_unique, selectedItemCore.inventory_type, slot_position, contains)
	end
end

-- external version of the function above.
function player_meta:AddItemToInventory(inv_name, item_unique, contains)
	local s, x, y = self:CanFitItem(inv_name, item_unique, contains)
	local selectedItemCore = deadremains.item.get(item_unique)

	if s then
		self:InsertItem(inv_name, item_unique, selectedItemCore.inventory_type, Vector(x, y, 0), contains)
	end
end

function player_meta:CanFitItem(inv_name, item_unique, contains)
	local inv = self:GetInventory(inv_name)
	local selectedItemCore = deadremains.item.get(item_unique)

	local it_slotwidth = inv.Size.X - selectedItemCore.slots_horizontal
	local it_slotheight = inv.Size.Y - selectedItemCore.slots_vertical

	for ox = 0, it_slotwidth do
		for oy = 0, it_slotheight do
			print("Checking origin, ", Vector(ox, oy))
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
					print("free")
					return true, ox, oy
				end
			else
				--print(testOriginItem.Unique)
			end
		end
	end

	return false
end

-- for searching the inventory
function player_meta:GetItemAt(inv_name, position)
	print(inv_name, position)
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

-- bbox in slots
function player_meta:GetItemBBox(slot_position, item_unique)
	local i = deadremains.item.get(item_unique)

	local width = i.slots_horizontal - 1
	local height = i.slots_vertical - 1

	local oX = slot_position.x
	local oY = slot_position.y

	return oX,oY, width,height
end