item.unique = "test"

-- The model that this item should have.
item.model = "models/captainbigbutt/skeyler/hats/cowboyhat.mdl"

-- How many horizontal slots this item should take.
item.slots_horizontal = 2

-- How many vertical slots this item should take.
item.slots_vertical = 4

-- Used the modify the position of the camera on DModelPanel.
item.cam_pos = Vector(50, 30, -2)

-- Used to change the angle at which the camera views the model.
item.look_at = Vector(0, 0, 0)

-- The FOV of the DModelPanel.
item.fov = 20

-- How much the entity in the DModelPanel should be rotated (yaw).
item.rotate = 45

-- What type of inventory this item fits in.
item.type = inventory_type_head

-- How many of this item we can fit into one slot.
item.stack = 16

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function item:use()
end
