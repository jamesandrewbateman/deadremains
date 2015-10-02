deadremains.notifyer = {}
deadremains.notifyer.active = {}

util.AddNetworkString("deadremains.notifyer.popup")
util.AddNetworkString("deadremains.notifyer.receive")

function deadremains.notifyer.popup(ply, message, mode, callback)
	net.Start("deadremains.notifyer.popup")
		net.WriteString(message)
		net.WriteUInt(mode, 8)
	net.Send(ply)

	deadremains.notifyer.active[ply:SteamID()] = callback
end

net.Receive("deadremains.notifyer.receive", function(bits, ply)
	local response = net.ReadUInt(8)
	-- response is a uint representing which button was pressed.
	-- 1 = yes
	-- 2 = no
	-- 3 = ok
	
	local callback = deadremains.notifyer.active[ply:SteamID]
	callback(response)
end)