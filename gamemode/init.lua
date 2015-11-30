deadremains = {}

AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_utilities.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_loader.lua")

AddCSLuaFile("cl_player.lua")
AddCSLuaFile("sh_uiloader.lua")

include("shared.lua")
include("sh_utilities.lua")
include("sh_loader.lua")

LoadModule("netrequest")
LoadModule("log")
LoadModule("sql")
LoadModule("item")
LoadModule("settings")
LoadModule("inventory")
LoadModule("character")
LoadModule("team")
LoadModule("map_config")
--LoadModule("gear")
LoadModule("crafting")
LoadModule("deadmin")
LoadModule("notifyer")

include("sh_uiloader.lua")


deadremains.loader.initialize()

include("sv_player.lua")

database_main = "deadremains"

----------------------------------------------------------------------
-- Purpose:
--
----------------------------------------------------------------------

function GM:Initialize()
	print("Starting")
	deadremains.sql.setupModules()

	-- stored[name], hostname, username, password, database, port, (Optional) unixsocketpath, (Optional) clientflags
	deadremains.sql.connect()

	-- autoreconnect
	timer.Create("deadremains.sqlreconnect", 10, 0, function()
		if not deadremains.sql.isConnected(database_main) then
			print("Could not find connection, reconnecting")
			deadremains.sql.connect()
		end
	end)
end
----------------------------------------------------------------------
-- Purpose:
--
----------------------------------------------------------------------

function GM:PlayerInitialSpawn(player)
	player.zombie_kill_count = 0
	player.dr_character.created = false

	self.BaseClass:PlayerInitialSpawn(player)
end

----------------------------------------------------------------------
-- Purpose:
--
----------------------------------------------------------------------

function GM:ShowHelp(ply)
	ply:ConCommand("inventory")
end

hook.Add("PlayerSpawn", "drPlayerSpawn", function(ply)
	ply.alive_timer = 0
	ply.dr_character.float_hp = 100
	ply:DefaultFlags()

	timer.Create("dr_alive_timer" .. ply:UniqueID(), 1, 0, function()
		if (IsValid(ply)) then
			ply.alive_timer = ply.alive_timer + 1
		end
	end)
end)

function GM:PlayerConnect(ply)

end

function GM:PlayerDisconnect(ply)
	timer.Remove("dr_alive_timer" .. ply:UniqueID())
	timer.Remove("dr.thirst." .. ply:UniqueID())
	timer.Remove("dr.hunger." .. ply:UniqueID())

	deadremains.sql.savePlayer(ply)
	self.BaseClass:PlayerDisconnect(ply)
end

function GM:PostPlayerDeath(ply)
	player.alive_timer = 0
end

hook.Add("PlayerLoadout", "drPlayerLoadout", function(ply)
	ply:Give("keys")
end)

function player_meta:sendNotification(title, message)
	net.Start("deadremains.shownotification_ok")
		net.WriteString(title)
		net.WriteString(message)
	net.Send(self)
end