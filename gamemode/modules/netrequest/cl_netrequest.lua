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
		local data = nil
		if (bits > 0) then
			data = net.ReadTable()
		end

		for k,v in pairs(request_table.Callbacks) do
			v(data)
		end
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


--! @brief clientside can have multiple callbacks.
function deadremains.netrequest.create(name, callback, unique)
	if not unique then
		-- do we already have a request set for this event?
		-- if so add it to that events callback table.
		for k,v in pairs(deadremains.netrequest.requests) do
			if (v.Name == name) then
				table.insert(v.Callbacks, callback)
				return
			end
		end
	end

	-- otherwise make a new request.
	local request = {
		Name = name,
		Callbacks = {
			callback
		},
		Meta = meta
	}
	table.insert(deadremains.netrequest.requests, request)
end