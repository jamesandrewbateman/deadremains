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
	print(self.unique,item.equip_slot,self.equip_slot)
	if (item.equip_slot != self.equip_slot) then
		return false, "You can't equip that item in this slot."
	end

	return 1
end

----------------------------------------------------------------------
-- Purpose:
--		Called when you equip an item in this inventory.
----------------------------------------------------------------------

function meta_table:equip(player, item)
	print("equipped item:", item.unique, "in the inventory", self.unique)

	
end

----------------------------------------------------------------------
-- Purpose:
--		Called when you unequip an item in this inventory.
----------------------------------------------------------------------

function meta_table:unEquip(player, item)
	print("unequipped item:", item.unique, "in the inventory", self.unique)
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

deadremains.inventory.register(inventory)
