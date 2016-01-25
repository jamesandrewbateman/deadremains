item.unique = "apple"
item.label = "Apple"

-- The model that this item should have.
item.model = "models/Gibs/HGIBS.mdl"

item.colour = Color(0, 155, 0)

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
item.weight = 30

item.meta["type"] = item_type_consumable

-- What functions exists on the context menu.
item.context_menu = {item_function_consume, item_function_drop}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function item:use(ply)
	if (SERVER) then
		ply:setNeed("hunger", ply:getNeed("hunger") + 300)

		ply:setNeed("thirst", ply:getNeed("thirst") + 300)

		ply:SetHealth(math.Clamp(ply:Health() + 10, 0, ply:getChar("health")))
	end
end