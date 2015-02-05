//Main Tables
dr.Inventory = {}
dr.Inventory.Functions = {}
dr.Inventory.Data = {}

net.Receive( "dr.Inventory", function( len )
	local ply = net.ReadEntity()
	local data = net.ReadTable()
	if data != nil and IsValid(ply) then
		print("Receiving Data: " .. ply:Nick() .. "'s " .. "Inventory", len)
		ply.Inventories = data
		PrintTable(data)
	end
end )

//Client-Side version
function dr.Inventory.Functions.HasSpace( ply, inv, size, force, max )
	//Check we have that inventory
	if ply.Inventories[inv] != nil then
		//local max = dr.Inventory.Data[inv].Size
		local br = false
		local test = {}
		local toplefts = {}
		//If the force var is not set then
		if force == nil then
			//Get every free slot
			for i=1, max[1] do 
				for i2=1, max[2] do
					if ply.Inventories[inv][i][i2] == false then
						table.insert(test, {i,i2})
					end
				end
			end
		else
			test[1] = force
		end
		//using the free table, determine if there is enough space for the slaves
		for k,v in pairs(test) do
			//First check it doesn't go out of bounds
			if ((v[1] + size[1] - 1) > max[1]) or ((v[2] + size[2] - 1) > max[2]) then
				//Out of bounds
				test[k] = nil
				//print("Removing: Top Left: " .. v[1] .. ", " .. v[2])
			else
				//print("Top Left: " .. v[1] .. ", " .. v[2])
				//Ensure every tile around here is fine
				for i=v[1], v[1] + size[1] - 1 do 
					for i2=v[2], v[2] + size[2] - 1 do
						//print("Testing: ".. i .. ", " .. i2)
						if ply.Inventories[inv][i][i2] != false then
							//Collision
							test[k] = nil
							print("Collision: Top Left: " .. v[1] .. ", " .. v[2])
						end
					end
				end
			end
		end
		
		//PrintTable(test)
		return table.GetFirstValue(test) or false
		
	end
end

//Client Request to move the item

function dr.Inventory.Functions.SendRequest( str, req )
	net.Start( "dr.Inventory" )
		net.WriteString( str )
		net.WriteTable( req )
	net.SendToServer()
end