deadremains.log = {}

deadremains.log.mysql = "mysql"
deadremains.log.loader = "loader"
deadremains.log.general = "general"

if (!file.IsDir("deadremains", "DATA")) then file.CreateDir("deadremains", "DATA") end
if (!file.IsDir("deadremains/logs", "DATA")) then file.CreateDir("deadremains/logs", "DATA") end
if (!file.IsDir("deadremains/logs/mysql", "DATA")) then file.CreateDir("deadremains/logs/mysql", "DATA") end
if (!file.IsDir("deadremains/logs/loader", "DATA")) then file.CreateDir("deadremains/logs/loader", "DATA") end
if (!file.IsDir("deadremains/logs/general", "DATA")) then file.CreateDir("deadremains/logs/general", "DATA") end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.log.write(log_type, text)
	local path = "deadremains/logs/" .. log_type .. "/" .. os.date("%Y-%m-%d") .. ".txt"
	local exists = file.Exists(path, "DATA")
	
	if (!exists) then
		file.Write("", path)
	end
	
	text = tostring(text)
	text = os.date("%H:%M:%S") .. " " .. tostring(text) .. "\r\n"
	
	file.Append(path, text)
	
	if (game.IsDedicated()) then
		ServerLog(text)
	else
		Msg(text)
	end
end