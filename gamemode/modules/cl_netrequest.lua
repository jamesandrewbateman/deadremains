deadremains.netrequest = {}
deadremains.netrequest.requests = {}

function deadremains.netrequest.trigger(name, meta)
	-- friend the request which matches this name.
	local request_table;
	for k,v in pairs(deadremains.netrequest.requests) do
		if (v) then
			if (v.Name == name) then
				request_table = v
			end
		end
	end

	-- setup listen to fire callback when received.
	net.Receive("STC".. request_table.Name, function(bits, ply)
		local data = net.ReadTable()
		request_table.Callback(data)
	end)

	-- response to client after 0.1 seconds.
	timer.Simple(0.1, function()
		net.Start("CTS".. request_table.Name)
			if (meta) then
				net.WriteTable(meta)
			end
		net.SendToServer()
	end)
end


function deadremains.netrequest.create(name, callback)
	local request = {
		Name = name,
		Callback = callback,
		Meta = meta
	}
	
	table.insert(deadremains.netrequest.requests, request)
end