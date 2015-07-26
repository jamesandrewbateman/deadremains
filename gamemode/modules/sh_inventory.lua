deadremains.inventory = {}

local stored = {}

local meta_table = {}
meta_table.__index = meta_table

meta_table.unique = "base"

-- How many horizontal slots this inventory has.
meta_table.slots_horizontal = 2

-- How many vertical slots this inventory has.
meta_table.slots_vertical = 2

-- What type of equipment slot this is.
meta_table.equip_slot = nil

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.inventory.register(data)
--	data.__index = data
	
	setmetatable(data, meta_table)

	stored[data.unique] = data
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.inventory.get(unique)
	return stored[unique]
end

----------------------------------------------------------------------
-- Purpose:
--		Called when you try to equip an item in this inventory.
----------------------------------------------------------------------

function meta_table:isEquipInventory()
	return self.equip_slot != nil
end

----------------------------------------------------------------------
-- Purpose:
--		Called when you try to equip an item in this inventory.
----------------------------------------------------------------------

function meta_table:canEquip(player, item)
	print("canEquip:",self.unique,item.equip_slot,self.equip_slot)

	if (bit.band(bit.lshift(1, self.equip_slot), item.equip_slot) == 0) then
		return false, "You can't equip that item in this slot."
	end

	return true
end

----------------------------------------------------------------------
-- Purpose:
--		Called when you equip an item in this inventory.
----------------------------------------------------------------------

function meta_table:equip(player, item)
	local item_data = deadremains.item.get(item.unique)

	print("equipped item:", item.unique, "in the inventory", self.unique)

	-- Create the inventory if the item has one.
	if (item_data.inventory_type) then

		-- Let's check if this item has an inventory already.
		if (item.inventory_index) then
			player:networkInventory(item.inventory_index)

		-- Create a new inventory.
		else
			local inventory_data = deadremains.inventory.get(item_data.inventory_type)

			item.inventory_index = player:createInventory(item_data.inventory_type, inventory_data.slots_horizontal, inventory_data.slots_vertical)
		end
	end

	if (item_data.equip) then
		item_data:equip(player)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		Called when you unequip an item in this inventory.
----------------------------------------------------------------------

function meta_table:unEquip(player, item, dropped_item)
	local item_data = deadremains.item.get(item.unique)

	print("unequipped item:", item.unique, "in the inventory", self.unique, "dropped_item:",dropped_item)

	-- Remove the inventory if the item has one.
	if (item_data.inventory_type and item.inventory_index) then
		player:removeInventory(item.inventory_index, dropped_item)
	end

	if (item_data.unEquip) then
		item_data:unEquip(player)
	end
end









local inventory = {}

inventory.unique = "feet"

-- A nice name for this inventory.
inventory.name = "Feet"

-- What type of equipment slot this is.
inventory.equip_slot = inventory_equip_feet

deadremains.inventory.register(inventory)




local inventory = {}

inventory.unique = "legs"

-- A nice name for this inventory.
inventory.name = "Legs"

-- What type of equipment slot this is.
inventory.equip_slot = inventory_equip_legs

deadremains.inventory.register(inventory)





local inventory = {}

inventory.unique = "head"

-- A nice name for this inventory.
inventory.name = "Head"

-- What type of equipment slot this is.
inventory.equip_slot = inventory_equip_head

deadremains.inventory.register(inventory)




local inventory = {}

inventory.unique = "back"

-- A nice name for this inventory.
inventory.name = "Back"

-- How many vertical slots this inventory has.
inventory.slots_vertical = 4

-- What type of equipment slot this is.
inventory.equip_slot = inventory_equip_back

deadremains.inventory.register(inventory)




local inventory = {}

inventory.unique = "chest"

-- A nice name for this inventory.
inventory.name = "Chest"

-- What type of equipment slot this is.
inventory.equip_slot = inventory_equip_chest

deadremains.inventory.register(inventory)





local inventory = {}

inventory.unique = "primary"

-- A nice name for this inventory.
inventory.name = "Primary"

-- How many horizontal slots this inventory has.
inventory.slots_horizontal = 5

-- What type of equipment slot this is.
inventory.equip_slot = inventory_equip_primary

deadremains.inventory.register(inventory)




local inventory = {}

inventory.unique = "secondary"

-- A nice name for this inventory.
inventory.name = "Secondary"

-- How many horizontal slots this inventory has.
inventory.slots_horizontal = 3

-- What type of equipment slot this is.
inventory.equip_slot = inventory_equip_secondary

deadremains.inventory.register(inventory)






local inventory = {}

inventory.unique = "hunting_backpack"

-- A nice name for this inventory.
inventory.name = "Hunting Backpack"

-- How many horizontal slots this inventory has.
inventory.slots_horizontal = 9

-- How many vertical slots this inventory has.
inventory.slots_vertical = 3

-- Is this inventory external?
inventory.external = true

deadremains.inventory.register(inventory)



local inventory = {}

inventory.unique = "bike_armor"

-- A nice name for this inventory.
inventory.name = "Bike Armor"

-- How many horizontal slots this inventory has.
inventory.slots_horizontal = 9

-- How many vertical slots this inventory has.
inventory.slots_vertical = 1

-- Is this inventory external?
inventory.external = true

deadremains.inventory.register(inventory)
