deadremains.item = {}

local stored = {}

local meta_table = {}
meta_table.__index = meta_table

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.item.register(data)
	data.__index = data
	
	setmetatable(data, meta_table)

	deadremains.log.write(deadremains.log.general, "Registered item: " .. data.unique)
	stored[data.unique] = data
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.item.get(unique)
	return stored[unique]
end

function deadremains.item.getAll()
	return stored
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:use()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

item_action_use = 1
item_action_drop = 2
item_action_destroy = 3
item_action_consume = 4

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

if (CLIENT) then

item_function_use = {name = "Use", callback = function(slot)
	LocalPlayer():InventoryItemAction(slot.action_name, slot.inventory_name, slot.item_unique, slot.slot_position)
end}

item_function_drop = {name = "Drop", callback = function(slot)
	LocalPlayer():InventoryItemAction(slot.action_name, slot.inventory_name, slot.item_unique, slot.slot_position)
end}

item_function_destroy = {name = "Destroy", callback = function(slot)
	LocalPlayer():InventoryItemAction(slot.action_name, slot.inventory_name, slot.item_unique, slot.slot_position)
end}

item_function_consume = {name = "Consume", callback = function(slot)
	LocalPlayer():InventoryItemAction(slot.action_name, slot.inventory_name, slot.item_unique, slot.slot_position)
end}

end