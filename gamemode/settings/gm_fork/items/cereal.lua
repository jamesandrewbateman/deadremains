item.unique = "cereal"
item.label = "Cereal"

-- The model that this item should have.
item.model = "models/nordfood/cereal.mdl"

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
item.weight = 200

item.meta["type"] = item_type_craftable

-- What functions exists on the context menu.
item.context_menu = {item_function_consume, item_function_drop}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function item:use(ply)
	if (SERVER) then
		ply:setNeed("hunger", ply:getNeed("hunger") + 600)

		ply:setNeed("thirst", ply:getNeed("thirst") + 60)

		ply:SetHealth(math.Clamp(ply:Health() + 5, 0, ply:getChar("health")))
	end
end