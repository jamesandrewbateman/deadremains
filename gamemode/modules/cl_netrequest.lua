deadremains.netrequest = {}
deadremains.netrequest.requests = {}

function deadremains.netrequest.trigger(name)
	local request_table;
	for k,v in pairs(deadremains.netrequest.requests) do
		if (v) then
			if (v.Name == name) then
				request_table = v
			end
		end
	end

	net.Receive("STC".. request_table.Name, function(bits, ply)
		local data = net.ReadTable()
		request_table.Callback(data)
	end)

	timer.Simple(0.1, function()
		net.Start("CTS".. request_table.Name)
		net.SendToServer()
	end)
end


function deadremains.netrequest.create(name, callback)
	table.insert(deadremains.netrequest.requests, {Name=name, Callback=callback})
end