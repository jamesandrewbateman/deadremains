deadremains.sql = {}
deadremains.sql.stored = {}
deadremains.sql.tmysql = nil
-- time in seconds between mysql database updates.
deadremains.sql.save_timer = 60
local queue = {}
local modules_loaded = false

local extras_base_path = GM.FolderName .. "/gamemode/modules/"
include(extras_base_path .. "sv_sql_player.lua")

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
	-- every X seconds save ALL the players active.
	timer.Simple(deadremains.sql.save_timer, function()
		for _, v in pairs(player.GetAll()) do
			deadremains.log.write(deadremains.log.mysql, "Saving current players info")
			deadremains.sql.savePlayer(v)
		end
	end)
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
	-- users table
	deadremains.sql.query(database_main,
	[[
	CREATE TABLE `users` (
	  `steam_id` varchar(255) NOT NULL,
	  `need_health` decimal(65,0) DEFAULT NULL,
	  `need_thirst` decimal(65,0) DEFAULT NULL,
	  `need_hunger` decimal(65,0) DEFAULT NULL,
	  `characteristic_strength` decimal(65,0) DEFAULT NULL,
	  `characteristic_thirst` decimal(65,0) DEFAULT NULL,
	  `characteristic_hunger` decimal(65,0) DEFAULT NULL,
	  `characteristic_health` decimal(65,0) DEFAULT NULL,
	  `characteristic_sight` decimal(65,0) DEFAULT NULL,
	  `gender` int(2) DEFAULT NULL,
	  PRIMARY KEY (`steam_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8]])

	deadremains.sql.query(database_main,
	[[
	CREATE TABLE `user_skills` (
	  `steam_id` varchar(255) DEFAULT NULL,
	  `fortification` varchar(45) DEFAULT NULL,
	  `mechanics` varchar(45) DEFAULT NULL,
	  `first_aid` int(2) DEFAULT NULL,
	  `medic` int(2) DEFAULT NULL,
	  `surgeon` int(2) DEFAULT NULL,
	  `chemistry` int(2) DEFAULT NULL,
	  `electronics` int(2) DEFAULT NULL,
	  `campcraft` int(2) DEFAULT NULL,
	  `woodwork` int(2) DEFAULT NULL,
	  `fire` int(2) DEFAULT NULL,
	  `hunting` int(2) DEFAULT NULL,
	  `wep1` int(2) DEFAULT NULL,
	  `wep2` int(2) DEFAULT NULL,
	  `wep3` int(2) DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8]])
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