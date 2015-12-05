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
	local i = stored[unique]
	if i == nil then
		local w = DR_GetWeaponInfo(unique)

		w.label = w.label
		w.meta = {}
		w.meta["type"] = item_type_weapon

		if CLIENT then

			w.context_menu = {item_function_equip, item_function_drop}

		end

		return w
	else
		return i
	end
end

function deadremains.item.getAll()
	return stored
end

function deadremains.item.worldUse(player, entity)
	local success = false
	local itemName = entity.item

	if itemName then
		if deadremains.item.isInventory(itemName) then
			local dr_item_info = deadremains.settings.get("default_inventories")
			
			local slot_size = 0

			for k,v in pairs(dr_item_info) do
				if v.unique == itemName then
					slot_size = v.size
				end
			end
			
			--print("item name", itemName)
			--PrintTable(entity.meta["contains"])
			if entity.meta then
				if (entity.meta["contains"] ~= nil) then
					success = player:AddInventoryContains(itemName, slot_size.X, slot_size.Y, entity.meta["contains"])
				end
			else
				success = player:AddInventory(itemName, slot_size.X, slot_size.Y)
			end
		else
			success = player:AddItemToInventory("feet", itemName)
		end
	end

	if (!success) then
		player:ChatPrint("Could not pick up item")
	else
		entity:Remove()
	end
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