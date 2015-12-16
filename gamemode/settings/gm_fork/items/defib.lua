item.unique = "defib"
item.label = "Defibrillator"

-- The model that this item should have.
item.model = "models/props_urban/tire001.mdl"

-- How many horizontal slots this item should take.
item.slots_horizontal = 2

-- How many vertical slots this item should take.
item.slots_vertical = 2

-- Used the modify the position of the camera on DModelPanel.
item.cam_pos = Vector(50, 30, -2)

-- Used to change the angle at which the camera views the model.
item.look_at = Vector(0, 0, 0)

-- The FOV of the DModelPanel.
item.fov = 20

-- How much the entity in the DModelPanel should be rotated (yaw).
item.rotate = 45

-- How much this item weighs.
item.weight = 1000

item.meta["type"] = item_type_weapon

-- What functions exists on the context menu.
item.context_menu = {item_function_consume, item_function_drop}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function item:use(ply)
	if (SERVER) then
		ply:SetHealth(math.Clamp(ply:Health() - 90, 0, ply:getChar("health")))

		-- do defib code
	end
end