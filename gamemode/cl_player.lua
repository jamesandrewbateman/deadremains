deadremains.netrequest.create("deadremains.syncdata", function() end)

concommand.Add("deadremains.syncdata", function()
	deadremains.netrequest.trigger("deadremains.syncdata")
end)