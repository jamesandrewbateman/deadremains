deadremains.map_config = {}
deadremains.stored = {}

----------------------------------------------------------------------
-- Purpose:
-- Load the specific items at the positions given in the mysql db.
----------------------------------------------------------------------
function deadremains.map_config.initialize(database_name, map_name)
	deadremains.map_config.map_name = map_name
	deadremains.map_config.database_name = database_name

	-- load new map from file? json?
	deadremains.map_config.setupTables()

	-- query the db.
	deadremains.sql.query(database_main, "SELECT * FROM `map_config` WHERE map_name = " .. deadremains.sql.escape(database_name, map_name), function(data, affected, last_id)
		if (data and data[1]) then
			deadremains.log.write(deadremains.log.mysql, "Map config for " .. map_name .. " found...")

			for row_number,item in pairs(data) do
				-- spawn the item
				local i = deadremains.item.get(item["name"])

				local ent = ents.Create("deadremains_item")
				ent:SetPos(Vector(item["x"], item["y"], item["z"]))
				ent:SetModel(i.model)
				ent:Spawn()

				ent.item = i.unique
			end

		else
			deadremains.log.write(deadremains.log.mysql, "No data found for map config with name " .. map_name .. " in database " .. database_name)
		end
	end)
end

function deadremains.map_config.setupTables()
	deadremains.sql.query(database_main,
	[[
	CREATE TABLE `map_config` (
	  `map_name` varchar(255) DEFAULT NULL,
	  `entry_type` varchar(45) DEFAULT NULL,
	  `name` varchar(45) DEFAULT NULL,
	  `x` varchar(45) DEFAULT NULL,
	  `y` int(2) DEFAULT NULL,
	  `z` int(2) DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8]])
end

function deadremains.map_config.addItem(item, position)
	deadremains.log.write(deadremains.log.mysql, "Adding item " .. item.unique)

	local query = "INSERT INTO map_config (map_name, entry_type, name, x, y, z) VALUES ("
	query = query .. deadremains.sql.escape(deadremains.map_config.database_name, deadremains.map_config.map_name) .. ", "
	query = query .. "'item'" .. ", "
	query = query .. "'" .. item.unique .. "', "
	query = query .. position.x .. ", "
	query = query .. position.y .. ", "
	query = query .. position.z .. ");"
	
	deadremains.sql.query(database_main, query)
end


function deadremains.map_config.persistSpawn(player, cmd, args)
	if (args ~= nil) then
		local item = deadremains.item.get(args[1])
		local pos = player:GetPos() --player:eyeTrace(192)
		deadremains.map_config.addItem(item, pos)
	end

	deadremains.item.spawn(player, cmd, args)
end
concommand.Add("dr_map_config_spawnitem", deadremains.map_config.persistSpawn)