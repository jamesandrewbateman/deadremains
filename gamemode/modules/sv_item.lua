----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------
deadremains.item.spawn_count = {}
function deadremains.item.spawnedItem(unique)
	local item_count = deadremains.item.spawn_count[unique]

	if item_count == nil then
		deadremains.item.spawn_count[unique] = 1
	else
		deadremains.item.spawn_count[unique] = deadremains.item.spawn_count[unique] + 1
	end
end

util.AddNetworkString("deadremains.getItemCounts")
util.AddNetworkString("deadremains.sendItemCount")

net.Receive("deadremains.getItemCounts", function(bits, ply)
	for k,v in pairs(deadremains.item.spawn_count) do
		net.Start("deadremains.sendItemCount")
			net.WriteString(k)
			net.WriteUInt(v, 32)
		net.Send(ply)
	end
end)

function deadremains.item.mapSpawn(unique, position, model)
	local item = deadremains.item.get(unique)

	if (item) then
		local entity = ents.Create("deadremains_item")
		entity:SetPos(position)
		entity:SetModel(model)
		entity:Spawn()

		entity.item = item.unique

		deadremains.item.spawnedItem(item.unique)
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

		deadremains.item.spawnedItem(item.unique)
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

		deadremains.item.spawnedItem(item.unique)
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