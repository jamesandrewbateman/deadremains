item.unique = "base"

-- The model that this item should have.
item.model = "models/captainbigbutt/skeyler/hats/bear_hat.mdl"

-- How many horizontal slots this item should take.
item.slots_horizontal = 1

-- How many vertical slots this item should take.
item.slots_vertical = 1

-- Used the modify the position of the camera on DModelPanel.
item.cam_pos = Vector(45, 45, 5)

-- Used to change the angle at which the camera views the model.
item.look_at = Vector(0, 0, 0)

-- The FOV of the DModelPanel.
item.fov = 14

-- How much the entity in the DModelPanel should be rotated (yaw).
item.rotate = 45

-- How much this item weighs.
item.weight = 8

-- Data about data
item.meta = {}
item.meta["type"] = 0
item.meta["enabled"] = 1
item.meta["rarity"] = 1
item.meta["frequency"] = 1
item.meta["contains"] = {}

-- What equipment slot this item can be placed in.
--item.equip_slot = bit.lshift(1, inventory_equip_back)

-- What type of inventory this item creates.
--item.inventory_type = "hunting_backpack"

-- What functions exists on the context menu.
item.context_menu = {item_function_drop, item_function_destroy}

----------------------------------------------------------------------
-- Purpose:
--		Called when a player uses an item from the UI.
--
--		player - the player using it
----------------------------------------------------------------------

--function item:use(player)
--end

----------------------------------------------------------------------
-- Purpose:
--		Called when a player uses E on the entity.
--
--		player - the player using it
--		entity - the item entity
----------------------------------------------------------------------

function item:worldUse(player, entity)
	local success = false
	local itemName = entity.item

	if itemName then
		success = player:AddItemToInventory("feet", itemName)
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
--
--		player - the player 
----------------------------------------------------------------------

--function item:equip(player)
--end

----------------------------------------------------------------------
-- Purpose:
--		
--
--		player - the player 
----------------------------------------------------------------------

--function item:unEquip(player)
--end