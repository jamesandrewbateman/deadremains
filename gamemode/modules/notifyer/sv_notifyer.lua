util.AddNetworkString("deadremains.notifyer.add")

-- mode is optional string
function deadremains.notifyer.Add(ply, message, mode)
	net.Start("deadremains.notifyer.add")
		net.WriteString(message)
	net.Send(ply)
end

concommand.Add("dr_addnotification", function(ply, cmd, args)

	deadremains.notifyer.Add(ply, "hello world")

end)