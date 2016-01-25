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
	local internal_item = stored[unique]

	if internal_item == nil then

		local addon_config = deadremains_config[unique]

		if addon_config == nil then return false end
		
		local weapon_config = weapons.Get(unique)

		if weapon_config == nil then

			if unique == "tfbow_arrow" then

				addon_config.label = "Arrow"
				
				addon_config.model = "models/weapons/w_dr_arrow.mdl"

			else

				return false

			end

		else

			-- add attributes to config table
			addon_config.label = weapon_config.PrintName
			addon_config.model = weapon_config.WorldModel

		end

		addon_config.meta = {}
		addon_config.meta["type"] = item_type_weapon

		if CLIENT then

			addon_config.context_menu = {item_function_equip, item_function_drop}

		end

		return addon_config

	else

		return internal_item

	end
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
item_action_equip = 5

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

item_function_equip = {name = "Equip", callback = function(slot)
	LocalPlayer():InventoryItemAction(slot.action_name, slot.inventory_name, slot.item_unique, slot.slot_position)
end}

end