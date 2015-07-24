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

-- What equipment slot this item can be placed in.
--item.equip_slot = inventory_equip_back

-- What type of inventory this item creates.
--item.inventory_type = "hunting_backpack"

-- What functions exists on the context menu.
item.context_menu = {item_function_drop, item_function_destroy}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

--function item:use(player)
--end