
----------------------------------------------------------------------
-- Purpose:
-- Save entire player information to the DB.
----------------------------------------------------------------------
function deadremains.sql.savePlayer(player)
	deadremains.log.write(deadremains.log.mysql, "Saving player: " .. player:Nick())
	if (!database_main) then
		error("Could not find database in store.")
		return
	end
	local steam_id = deadremains.sql.escape(database_main, player:SteamID())
	print(steam_id)

	-- create the section for all the needs.
	local needs = deadremains.settings.get("needs")
	local params = "UPDATE users SET "

	for unique, data in pairs(needs) do
		params = params .. "need_" .. unique .. " = " .. player:getNeed(unique) .. ", "
	end

	-- characteristics
	local chars = deadremains.settings.get("characteristics")
	for unique, data in pairs(chars) do
		params = params .. "characteristic_" .. unique .. " = " .. player:getChar(unique) .. ", "
	end

	params = params .. "gender = 1 "
	params = params .. "WHERE steam_id = " .. steam_id .. ";"
	deadremains.sql.query(database_main, params);

	-- skills
	params = ""
	params = params .. "UPDATE user_skills SET "
	params = params .. player:getSkillsMysqlString()
	params = params .. " WHERE steam_id = " .. steam_id .. ";"
	deadremains.sql.query(database_main, params)

	-- meta
	params = ""
	params = params .. "UPDATE user_meta SET "
	params = params .. "x = " .. player:GetPos().x .. ", "
	params = params .. "y = " .. player:GetPos().y .. ", "
	params = params .. "z = " .. player:GetPos().z .. ", "
	params = params .. "name = " .. deadremains.sql.escape(database_main, player:Nick()) .. ", "
	params = params .. "time_alive = " .. player.alive_timer .. ", "
	params = params .. "zombie_kill_count = " .. player.zombie_kill_count
	params = params .. " WHERE steam_id = " .. steam_id .. ";"
	deadremains.sql.query(database_main, params)

	local inventories = player.dr_character.inventory

	-- before we do anything, we must clear the db of all saved values for this player.
	params = ""
	params = params .. "DELETE FROM user_items WHERE steam_id = " .. steam_id
	deadremains.sql.query(database_main, params, function()
		-- when we have cleared the database rows
		-- insert new ones from the db.
		-- TODO not sure on the performance of this section?
		for key, data in pairs(inventories) do
			if (data) then
				if (#data.slots > 0) then
					for k,v in pairs(data.slots) do
						params = ""
						params = params .. "INSERT INTO user_items (steam_id, inventory_unique, item_unique, slot_x, slot_y) VALUES ("
						params = params .. steam_id .. ", "
						params = params .. "'" .. data.unique .. "', "
						params = params .. "'" .. v.unique .. "', "
						params = params .. v.x .. ", "
						params = params .. v.y .. ");"
						deadremains.sql.query(database_main, params)
					end
				end
			end
		end
	end)
end
concommand.Add("dr_saveply", deadremains.sql.savePlayer)

----------------------------------------------------------------------
-- Purpose:
-- Create a new row in the db for all the properties for this player.
-- Also resets the player to SELECT * the new values.
----------------------------------------------------------------------
function deadremains.sql.newPlayer(player)
	local steam_id = deadremains.sql.escape(database_main, player:SteamID())
	local needs = deadremains.settings.get("needs")
	local characteristics = deadremains.settings.get("characteristics")

	deadremains.log.write(deadremains.log.mysql, "No data in database for player, inserting new values.")

	-- `users` table.
	local query = "INSERT INTO users(steam_id, "

	for unique, value in pairs(needs) do
		query = query .. "need_" .. unique .. ", "
	end

	for unique, value in pairs(characteristics) do
		query = query .. "characteristic_" .. unique .. ", "
	end

	query = string.sub(query, 0, #query -2) .. ", gender) VALUES(".. steam_id .. ", "
	
	for unique, value in pairs(needs) do
		query = query .. player:getNeed(unique) .. ", "
	end

	for unique, value in pairs(characteristics) do
		query = query .. player:getChar(unique) .. ", "
	end

	query = string.sub(query, 0, #query -2) .. ", 1)"

	deadremains.sql.query(database_main, query)


	-- generate random skill type
	local skill_types = deadremains.settings.get("skill_types")
	local randomized = {}

	for _, type in pairs(skill_types) do
		local sorted = deadremains.getSkillByType(type)
		table.insert(randomized, sorted[math.random(1, #sorted)])
	end


	-- `user_skills` table.
	query = "INSERT INTO user_skills ("

	for k,v in pairs(deadremains.settings.get("skills")) do
		query = query .. v.unique .. ", "
	end

	query = string.sub(query, 0, #query -2); -- removes the last ", "
	query = query .. ", steam_id) VALUES ("

	for k,v in pairs(deadremains.settings.get("skills")) do
		local out_var = 0

		-- if we find it in our randomized table, enable it.
		for i = 1, #randomized do
			local data = randomized[i]
			if (data.unique == v.unique) then out_var = 1 end
		end

		query = query .. out_var .. ", "
	end

	query = string.sub(query, 0, #query -2)
	query = query .. ", " .. steam_id .. ")"

	deadremains.sql.query(database_main, query)


	-- `user_meta` table
	query = "INSERT INTO user_meta ("
	query = query .. "steam_id, "
	query = query .. "x, "
	query = query .. "y, "
	query = query .. "z, "
	query = query .. "name, "
	query = query .. "time_alive, "
	query = query .. "zombie_kill_count)"

	query = query .. " VALUES ("
	query = query .. steam_id .. ", "
	query = query .. player:GetPos().x .. ", "
	query = query .. player:GetPos().y .. ", "
	query = query .. player:GetPos().z .. ", "
	query = query .. deadremains.sql.escape(database_main, player:Nick()) .. ", "
	query = query .. 0 .. ", "
	query = query .. 0 .. ")"
 	deadremains.sql.query(database_main, query)


 	-- `user_items` table
 	-- items are inserted into the table if they cannot be updated in Save Player method.

	player:reset()
end


----------------------------------------------------------------------
-- Purpose:
--	Used by sv_sql.lua to get the players skills in a specific format
--  to be queried.	
----------------------------------------------------------------------

function player_meta:getSkillsMysqlString()
	local format = ""
	local skills = deadremains.settings.get("skills")

	-- find out how many skills there are in the array.
	local count = 0
	for _, skill in pairs(skills) do count = count + 1 end

	local c = 0
	for _, skill in pairs(skills) do
		-- if we are at the last entry in the array.
		if (c == count - 1) then
			format = format .. skill.unique .. " = " .. self:getSkill(skill.unique)
		else	
			format = format .. skill.unique .. " = " .. self:getSkill(skill.unique) .. ", "
		end

		c = c + 1
	end

	return format
end