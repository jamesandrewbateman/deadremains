----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------
-- always listen
deadremains.netrequest.create("load_deadmin_items", function()
	local data = {}

	local temp_data = {}
	for k,v in pairs(ents.GetAll()) do
		if IsValid(v) then
			if v.item then
				local i = deadremains.item.get(v.item)

				if temp_data[v.item] then
					-- specify data to send back.
					temp_data[v.item] = {
						count = 1 + temp_data[v.item].count,
						type = i.meta["type"]
					}
				else
					temp_data[v.item] = {
						count = 1,
						type = i.meta["type"]
					}
				end
			end
		end
	end

	for k,v in pairs(temp_data) do
		table.insert(data, {unique=k, count=v.count, type=v.type})
	end

	return data
end)

function deadremains.item.mapSpawn(unique, position, model)
	local item = deadremains.item.get(unique)

	if (item) then
		local entity = ents.Create("deadremains_item")
		entity:SetPos(position)
		entity:SetModel(model)
		entity:Spawn()

		entity.item = item.unique
	end
end

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
	end
end

function deadremains.item.spawn_meta(player, unique, meta_data)
	local item = deadremains.item.get(unique)

	if (item) then
		local trace = player:eyeTrace(192)

		local entity = ents.Create("deadremains_item")
		entity:SetPos(trace.HitPos)
		entity:SetModel(item.model)
		entity:Spawn()

		entity.item = item.unique
		entity.meta = table.Copy(meta_data)
	end
end

----------------------------------------------------------------------
-- Purpose:
--	Find out whether the item provides inventory expansion.	
----------------------------------------------------------------------

deadremains.item.types = {}
deadremains.item.types.normal = 1
deadremains.item.types.inventory_provider = 2

function deadremains.item.type(unique)
	local item = deadremains.item.get(unique)

	-- items which provide the space name.
	local inventory_uniques = {
		"hunting_backpack",
		"bike_armor"
	}

	for _, u in pairs(inventory_uniques) do
		if (u == item.unique) then
			return deadremains.item.types.inventory_provider
		end
	end

	return deadremains.item.types.normal
end