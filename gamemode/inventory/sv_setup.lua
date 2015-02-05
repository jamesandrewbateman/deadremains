//Main Tables
dr.Inventory = {}
dr.Inventory.Functions = {}
dr.Inventory.Data = {}
//														VVV = {2,3} / 2 rows, 3 columns / First number down left, second number across top 
function dr.Inventory.Functions.CreateNewInv(id, name, size )
	//Check its not overwriting anything
	if dr.Inventory.Data[id] == nil then
		dr.Inventory.Data[id] = {Name = name, Size = size}
		
		PrintTable(dr.Inventory)
	else
		//Warning
		
	end
end

function dr.Inventory.Functions.GiveInv( ply, id )
	
	//Check its not overwriting anything
	if dr.Inventory.Data[id] != nil then
		local data = dr.Inventory.Data[id]
		
		//Make sure they have their setup
		if ply.Inventories == nil then ply.Inventories = {} end
		if true then //ply.Inventories[id] == nil then 
			
			ply.Inventories[id] = {}
			
			
			for i=1, data.Size[1] do 
				ply.Inventories[id][i] = {}
				for i2=1, data.Size[2] do
					 ply.Inventories[id][i][i2] = false
				 end
			end
			
			PrintTable(ply.Inventories[id])
			
			//Update Clients
			dr.Inventory.Functions.SyncClient( )
			
		else
			//Attempting to give an new inventory with same ID
		end
		
		
	else
		//Warning
		
	end
end

function dr.Inventory.Functions.HasSpace( ply, inv, size, force )
	//Check we have that inventory
	if ply.Inventories[inv] != nil then
		local max = dr.Inventory.Data[inv].Size
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

function dr.Inventory.Functions.InsertItem( ply, inv, itemid, force )
	//Check we have that inventory
	if ply.Inventories[inv] != nil then
		local size = dr.Items.Data.MItems[itemid].Size
		
		//Make function to check if the space is free
		local free = dr.Inventory.Functions.HasSpace( ply, inv, size, force )
		
		if free != false then
		
			local index = true
			
			for i=free[1], free[1] + size[1] - 1 do 
				for i2=free[2], free[2] + size[2] - 1 do
					if index == true then
						index = {i, i2}
						ply.Inventories[inv][i][i2] = {Status = "M", ItemID = itemid, Slaves = {}}
						print("Inserting Master into free space: " .. i .. ", " .. i2 )
					else
						ply.Inventories[inv][i][i2] = {Status = "S", Ref = index}
						table.insert( ply.Inventories[inv][index[1]][index[2]].Slaves, {i,i2})
						print("Inserting Slave into free space: " .. i .. ", " .. i2 )
					end
				end
			end
			PrintTable(ply.Inventories[inv])
			
			//Update clients
			dr.Inventory.Functions.SyncClient( )
		else
			print("NO SPACE")
		end
	else
		//Warning
		
	end
end
//															VVV table stucture {ply, "id of inv", {pos}}
function dr.Inventory.Functions.MoveItem( ply, inv, slot, moveto )
	//Check we have that inventory
	if ply.Inventories[inv] != nil then
		local master = ply.Inventories[inv][slot[1]][slot[2]]
		
		if master == false then
			print("Empty Space")
			return
		elseif master.Status == "S" then
			
			master = ply.Inventories[inv][master.Ref[1]][master.Ref[2]]
			print("Gave slave node, capturing master")
		end
		
		local itemid = master.ItemID
		local size = dr.Items.Data.MItems[itemid].Size
		print("Printing master")
		PrintTable(master)
		//Check if we can force it into the slot
		if dr.Inventory.Functions.HasSpace( moveto.Ent, moveto.Inv, size, moveto.Pos ) then
			print("Yay!")
			dr.Inventory.Functions.InsertItem( moveto.Ent, moveto.Inv, itemid, moveto.Pos )
			//Now remove the old items
			dr.Inventory.Functions.RemoveItem(ply, inv, slot)
		else
			//Dissallow the move request
			
		end
	else
		//Warning
		
	end
end

function dr.Inventory.Functions.RemoveItem(ply, inv, slot)
	//Check we have that inventory
	if ply.Inventories[inv] != nil then
		local master = ply.Inventories[inv][slot[1]][slot[2]]
		
		if master == false then
			print("Empty Space")
			return
		elseif master.Status == "S" then
			slot = {master.Ref[1], master.Ref[2]}
			master = ply.Inventories[inv][master.Ref[1]][master.Ref[2]]
			print("Gave slave node, capturing master")
		end
		
		//Remove the slaves
		for k,v in pairs(master.Slaves) do
			ply.Inventories[inv][v[1]][v[2]] = false
		end
		//Remove the master
		ply.Inventories[inv][slot[1]][slot[2]] = false
		
		PrintTable(ply.Inventories[inv])
			
		//Update clients
		dr.Inventory.Functions.SyncClient( )
	else
		//Warning
		
	end
end

concommand.Add( "dick", function() 
	dr.Inventory.Functions.MoveItem( player.GetByID(1), "BASIC", {1,2}, {
		["Ent"] = player.GetByID(1),
		["Inv"] = "BASIC",
		["Pos"] = {5,5},
	} )
end )

concommand.Add( "dick2", function() 
	dr.Inventory.Functions.RemoveItem( player.GetByID(1), "BASIC", {1,2} )
end )

util.AddNetworkString( "dr.Inventory" )
function dr.Inventory.Functions.SyncClient( )

	for k,v in pairs(player.GetAll()) do
		net.Start( "dr.Inventory" )
			net.WriteEntity( v )
			net.WriteTable( v.Inventories or {} )
		net.Send( v )
		print("Syncing: " .. v:Nick() .. "'s " .. "Inventory")
	end
	
end
//Request handler
net.Receive( "dr.Inventory", function( len, ply )
	local request = net.ReadString()
	if request == "MoveItem" then
		local data = net.ReadTable()
		dr.Inventory.Functions.MoveItem( data.ply, data.inv, data.slot, data.moveto )
	end
end )

//Tests
hook.Add( "PlayerInitialSpawn", "dr.InitSpawn.Inventory", function(ply) 
	timer.Simple(1, function() dr.Inventory.Functions.SyncClient() end) 
	timer.Simple(1, function() Q.GiveInv(ply, "BASIC") end) 
end )


//Quick Functions
Q.CreateNewInv = dr.Inventory.Functions.CreateNewInv
Q.GiveInv = dr.Inventory.Functions.GiveInv
Q.InsertItem = dr.Inventory.Functions.InsertItem
Q.MoveItem = dr.Inventory.Functions.MoveItem
Q.CreateNewInv("HEAD", "Head", {2,3})
Q.CreateNewInv("BASIC", "Basic Inventory", {6,6})