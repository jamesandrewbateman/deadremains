deadremains.notifyer.notifications = {}

net.Receive("deadremains.notifyer.add", function(bits, ply)

	local message = net.ReadString()

	table.insert(deadremains.notifyer.notifications, { Message = message, Countdown = 100 })

end)

function deadremains.notifyer.GetNotifications()

	return deadremains.notifyer.notifications

end

function deadremains.notifyer.RemoveNotification(key)

	table.remove(deadremains.notifyer.notifications, key)

end