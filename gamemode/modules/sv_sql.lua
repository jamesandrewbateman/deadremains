deadremains.sql = {}
deadremains.sql.stored = {}
deadremains.sql.tmysql = nil
local queue = {}
local modules_loaded = false

----------------------------------------------------------------------
-- Purpose:
--	Include the correct c++ modules for tmysql4.
--  Path: garrysmod/lua/bin/gmsv_tmysql4.dll
----------------------------------------------------------------------
function deadremains.sql.setupModules()
	if modules_loaded then return end;

	local tmysql_file = file.Exists("bin/gmsv_tmysql4_*.dll", "LUA");
	if not tmysql_file then
		deadremains.log.write(deadremains.log.mysql, "Could not find gmsv_tmysql4_*.dll")
		error("Could not find suitable tmysql4 module.")
	end

	require("tmysql4")
	deadremains.sql.tmysql = tmsql_file
	modules_loaded = true
end

----------------------------------------------------------------------
-- Purpose:
-- Save entire player information to the DB.
----------------------------------------------------------------------
function deadremains.sql.savePlayer(player)
	deadremains.log.write(deadremains.log.mysql, "Saving player: " .. player:Nick())

	deadremains.sql.query(database_main, [[UPDATE users SET
		need_health = ]] .. player:Health() .. [[,
		need_thirst = ]] .. player:getThirst() .. [[,
		need_hunger = ]] .. player:getHunger() .. [[,
		characteristic_strength = ]] .. player.dr_character.characteristics["strength"] .. [[,
		characteristic_thirst = ]] .. player.dr_character.characteristics["thirst"] .. [[,
		characteristic_hunger = ]] .. player.dr_character.characteristics["hunger"] .. [[,
		characteristic_health = ]] .. player.dr_character.characteristics["health"] .. [[,
		characteristic_sight = ]] .. player.dr_character.characteristics["sight"] .. [[,
		gender = 1 WHERE steam_id = ']] .. player:SteamID() .. [[';]]);
end
concommand.Add("dr_saveply", deadremains.sql.savePlayer)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local function handleCallback(name, query, result, callback_success, callback_failed)
	if (result and result[1]) then
		result = result[1]
		
		if (result.status) then
			if (callback_success) then
				callback_success(result.data, result.affected, result.lastid)
			end
		else
			deadremains.log.write(deadremains.log.mysql, "The mysql query \"" .. tostring(query) .. "\" on database \"" .. tostring(name) .. "\" failed: " .. tostring(result.error))
			
			if (callback_failed) then
				callback_failed()
			end
		end
	else
		deadremains.log.write(deadremains.log.mysql, "The mysql query \"" .. tostring(query) .. "\" on database \"" .. tostring(name) .. "\" failed: Returned no result table?")
		
		if (callback_failed) then
			callback_failed()
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.sql.intialize(name, hostname, username, password, database, port, unixSocketPath, clientFlags)
	local database_object, message = tmysql.initialize(hostname, username, password, database, port, unixSocketPath, clientFlags)
	
	if (database_object) then
		deadremains.sql.stored[name] = database_object
		
		local i = 1
		
		-- Run all the queued queries.
		for k, data in pairs(queue) do
			if (data.name == name) then
				timer.Simple(i *0.1, function()
					local query = data.query
					local callback_success = data.callback_success
					local callback_failed = data.callback_failed
	
					database_object:Query(query, function(result) handleCallback(name, query, result, callback_success, callback_failed) end)
					
					queue[k] = nil
				end)
				
				i = i +1
			end
		end
	else
		deadremains.log.write(deadremains.log.mysql, "Connection to mysql host \"" .. tostring(hostname) .. "\" failed: " .. tostring(message) .. " - Trying again in 20 seconds.")
		
		timer.Simple(20, function() deadremains.sql.intialize(name, hostname, username, password, database, port, unixSocketPath, clientFlags) end)
	end

	deadremains.sql.setupTables()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.sql.query(name, query, callback_success, callback_failed)
	local database = deadremains.sql.stored[name]
	
	if (database) then
		database:Query(query, function(result) handleCallback(name, query, result, callback_success, callback_failed) end)
	else
		deadremains.log.write(deadremains.log.mysql, "The mysql database \"" .. tostring(name) .. "\" does not exist!")
		
		if (callback_failed) then
			callback_failed()
		end
		
		local exist = false
		
		for k, data in pairs(queue) do
			if (data.name == name and tostring(data.query) == tostring(query)) then
				exist = true
				
				break
			end
		end
		
		if (!exist) then
			table.insert(queue, {name = name, query = query, callback_success = callback_success, callback_failed = callback_failed})
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--	Ensures the tables are present in the database.	
----------------------------------------------------------------------
function deadremains.sql.setupTables()
	if (!database_main) then
		error("Could not find database in store.")
		return
	end

	-- users table
	deadremains.sql.query(database_main,
		[[CREATE TABLE users (
		steam_id VARCHAR(255) PRIMARY KEY,
		need_health DECIMAL(65),
		need_thirst DECIMAL(65),
		need_hunger DECIMAL(65),
		characteristic_strength DECIMAL(65),
		characteristic_thirst DECIMAL(65),
		characteristic_hunger DECIMAL(65),
		characteristic_health DECIMAL(65),
		characteristic_sight DECIMAL(65),
		gender INT(2)
		);]])
end


----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.sql.escape(name, text)
	local database = deadremains.sql.stored[name]
	
	if (database) then
		return "\"" .. database:Escape(text) .. "\""
	else
		deadremains.log.write(deadremains.log.mysql, "Could not escape string \"" .. tostring(text) .. "\" - The database \"" .. tostring(name) .. "\" does not exist!")
		
		return sql.SQLStr(text)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.sql.getQueue()
	return queue
end