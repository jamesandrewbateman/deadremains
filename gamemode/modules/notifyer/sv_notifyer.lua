util.AddNetworkString("deadremains.notifyer.add")

function deadremains.notifyer.Add(ply, message)
	net.Start("deadremains.notifyer.add")
		net.WriteString(message)
	net.Send(ply)
end

concommand.Add("dr_addnotification", function(ply, cmd, args)

	deadremains.notifyer.Add(ply, "hello world")

end)