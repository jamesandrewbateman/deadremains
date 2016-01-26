----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------
-- for mapconfig
function deadremains.item.mapSpawn(unique, position, model)
	local item = deadremains.item.get(unique)

	if (item) then
		local entity = ents.Create("deadremains_item")
		entity:SetPos(position)
		entity:SetModel(model)
		entity:Spawn()

		entity.item = item.unique
		entity:SetDRName(item.label)
	end
end

-- for concommand spawning
function deadremains.item.spawn(player, cmd, args)
	local item
	if (args ~= nil) then
		item = deadremains.item.get(args[1])
	else
		item = deadremains.item.get(cmd)
	end

	if (item) then
		local trace = player:eyeTrace(192)

		local entity = ents.Create("deadremains_item")
		entity:SetPos(trace.HitPos)
		entity:SetModel(item.model)
		entity:Spawn()

		entity.item = item.unique
		entity:SetDRName(item.label)
		entity.Use = function(self, activator, caller)
			deadremains.item.worldUse(activator, self.Entity)
		end
	end
end
concommand.Add("dr_item_spawn", deadremains.item.spawn)

-- for spawning code
function deadremains.item.spawn_meta(player, unique, meta_data)
	local item = deadremains.item.get(unique)

	if (item) then
		local trace = player:eyeTrace(192)

		local entity = ents.Create("deadremains_item")
		entity:SetPos(trace.HitPos)
		entity:SetModel(item.model)
		entity:Spawn()

		entity.item = item.unique
		entity:SetDRName(item.label)
		entity.meta = table.Copy(meta_data)
	end
end

function deadremains.item.spawn_contains(player, unique, contains)
	local item = deadremains.item.get(unique)

	if (item) then
		local trace = player:eyeTrace(192)

		local entity = ents.Create("deadremains_item")
		entity:SetPos(trace.HitPos)
		entity:SetModel(item.model)
		entity:Spawn()

		entity.item = item.unique
		entity:SetDRName(item.label)
		entity.meta = {}
		entity.meta["contains"] = contains
	end
end

function deadremains.item.zombie_drop(zname, zposition)
	local items = deadremains.item.getAll()

	local container_index = deadremains.containers.create("zombie_package", 4, 4, zposition)

	for i=1,math.random(1,15) do
		if (math.random(0,100) > 20) then

			local item = 0
			local target_i = math.random(1, table.Count(items))
			--print(target_i)
			local c = 0
			local reached = false
			for k,v in pairs(items) do
				if not reached then
					if c == target_i then
						item = v
						reached = true
					end

					c = c + 1
				end
			end

			--print(item)
			if item ~= 0 then
				deadremains.containers.addItem(container_index, item.unique)
			else
				print("could not find item with index", target_i)
			end

		end
	end
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
			print(itemName, success)

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
--	Find out whether the item provides inventory expansion.	
----------------------------------------------------------------------

function deadremains.item.isInventory(unique)
	local item = deadremains.item.get(unique)

	-- items which provide the space name.
	local inventory_uniques = {
		"hunting_backpack",
		"bike_armor"
	}

	for _, u in pairs(inventory_uniques) do
		if (u == item.unique) then
			return true
		end
	end

	return false
end