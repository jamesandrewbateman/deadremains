deadremains.netrequest = {}
deadremains.netrequest.requests = {}

--! @brief we can have multiple listeners on 1 signal.
function deadremains.netrequest.listen(name)
	local request_table;
	for k,v in pairs(deadremains.netrequest.requests) do
		if (v) then
			if (v.Name == name) then
				request_table = v
			end
		end
	end

	util.AddNetworkString("CTS".. request_table.Name)
	util.AddNetworkString("STC".. request_table.Name)

	net.Receive("CTS".. request_table.Name, function(bits, ply)
		local meta_data = nil
		if (bits > 0) then
			meta_data = net.ReadTable()
		end

		local response_data = request_table.Callback(ply, meta_data)

		timer.Simple(0.1, function()
			net.Start("STC".. request_table.Name)
				if (response_data) then
					net.WriteTable(response_data)
				end
			net.Send(ply)
		end)
	end)
end

function deadremains.netrequest.create(name, callback)
	table.insert(deadremains.netrequest.requests, {Name=name, Callback=callback})
	deadremains.netrequest.listen(name)
end