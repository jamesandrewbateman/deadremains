item.unique = "fire_3"
item.label = "Fire No.3"

-- The model that this item should have.
item.model = "models/props_foliage/campfire02.mdl"

-- How many horizontal slots this item should take.
item.slots_horizontal = 1

-- How many vertical slots this item should take.
item.slots_vertical = 1

-- Used the modify the position of the camera on DModelPanel.
item.cam_pos = Vector(50, 30, -2)

-- Used to change the angle at which the camera views the model.
item.look_at = Vector(0, 0, 0)

-- The FOV of the DModelPanel.
item.fov = 20

-- How much the entity in the DModelPanel should be rotated (yaw).
item.rotate = 45

-- How much this item weighs.
item.weight = 4

item.meta["type"] = item_type_consumable

-- What functions exists on the context menu.
item.context_menu = {item_function_drop}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function item:use(player)
end