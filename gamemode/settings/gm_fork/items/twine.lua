item.unique = "twine"
item.label = "Twine... you swine!"

-- The model that this item should have.
item.model = "models/Items/CrossbowRounds.mdl"

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

item.meta["type"] = item_type_craftable

-- What functions exists on the context menu.
item.context_menu = {item_function_drop}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function item:use(player)
end