----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

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

function deadremains.item.persistSpawn(player, cmd, args)
	if (args ~= nil) then
		local item = deadremains.item.get(args[1])
		local pos = player:GetPos() --player:eyeTrace(192)
		deadremains.map_config.addItem(item, pos)
	end

	deadremains.item.spawn(player, cmd, args)
end
concommand.Add("dr_map_config_spawnitem", deadremains.item.persistSpawn)