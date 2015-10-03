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
	player_meta.Inventories = {}

	-- body inventories
	self:AddInventory("Feet", Vector(2, 2, 0))
	self:AddInventory("Legs", Vector(2, 2, 0))
	self:AddInventory("Head", Vector(2, 2, 0))
	self:AddInventory("Back", Vector(2, 4, 0))
	self:AddInventory("Chest", Vector(2, 2, 0))
	self:AddInventory("Primary", Vector(5, 2, 0))
	self:AddInventory("Secondary", Vector(3, 2, 0))

	self:InsertItem("Head", "tin_beans", Vector(0, 0, 0))
end

function player_meta:AddInventory(name, size)
	table.insert(player_meta.Inventories, {
			Name = name,
			Size = size,
			Items = {}
		})
end

function player_meta:RemoveInventory(name)
	local invID = self:GetInventoryId()
	table.insert(player_meta.Inventories, invID)
end

function player_meta:GetInventoryId(name)
	local invID = 0
	for k,v in pairs(player_meta.Inventories) do if v.Name == name then invID = k end

	return invID
end

function player_meta:GetInventory(name)
	local invID = self:GetInventoryId()
	return player_meta.Inventories[invID]
end


-- ITEM ACTIONS --

-- used internally, does not check for placement collisions.
function player_meta:InsertItem(inv_name, unique, slot_position, contains)
	local items = self:GetInventory(inv_name).Items

	table.insert(items, {
			Unique = unique,
			SlotPosition = slot_position,
			Contains = contains
		})
end

-- external version of the function above.
function player_meta:AddItemToInventory(inv_name, item_unique, contains)
	local inv = self:GetInventory(inv_name)
	local selectedItemCore = deadremains.item.get(item_unique)

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
					if contains == nil then contains = {} end
					self:InsertItem(inv_name, item_unique, selectedItemCore.inventory_type, Vector(ox, oy, 0), contains)
					return
				end
			else
				--print(testOriginItem.Unique)
			end
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

-- bbox in slots
function player_meta:GetItemBBox(slot_position, item_unique)
	local i = deadremains.item.get(item_unique)

	local width = i.slots_horizontal - 1
	local height = i.slots_vertical - 1

	local oX = slot_position.x
	local oY = slot_position.y

	return oX,oY, width,height
end