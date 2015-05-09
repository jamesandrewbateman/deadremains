local ok, status = pcall(require, "tmysql4")

if (!ok) then
	deadremains.log.write(deadremains.log.mysql, "Could not load tmysql4: " .. tostring(status))
	
	error("Could not load tmysql4: " .. tostring(status) .. "\n")
end

deadremains.sql = {}
deadremains.sql.stored = {}

local queue = {}

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