//Main Tables
dr.Items = {}
dr.Items.Functions = {}
dr.Items.Data = {}
dr.Items.Data.MItems = {}

function dr.Items.Functions.CreateNewItem(id, name, cats, model, size, usefunc )
	//Check its not overwriting anything
	if dr.Items.Data.MItems[id] == nil then
		dr.Items.Data.MItems[id] = {Name = name, Cats = cats, useFunc = usefunc, Model = model, Size = size}
		
		PrintTable(dr.Items)
	else
		//Warning
		
	end
end

function dr.Items.Functions.SpawnItem(id, position)
	//Check it exists
	
	local data = dr.Items.Data.MItems[id]
	
	if data != nil then
		
		local item = ents.Create( "spawned_item" )
		if ( !IsValid( item ) ) then return end 
		item:SetModel( data.Model )
		item:SetPos( position )
		item:SetItemID( id )
		item:SetData( data )
		item:Spawn()
		
	else
		//Warning
		
	end
end

util.AddNetworkString( "dr.Items" )
function dr.Items.Functions.SyncClient()
	//Prepare the table to send
	local data = table.Copy(dr.Items.Data.MItems)
	//Get rid of un-nessessary Data
	for k,v in pairs(data) do
		data[k].useFunc = nil
		data[k].Model = nil
	end
	
	net.Start( "dr.Items" )
		net.WriteTable( data )
	net.Broadcast()
	
	print("Syncing: Items")
end

hook.Add( "PlayerInitialSpawn", "dr.InitSpawn.Items", function() timer.Simple(1, function() dr.Items.Functions.SyncClient() end) end )


//Quick Functions
Q.CreateNewItem = dr.Items.Functions.CreateNewItem

Q.SpawnItem = dr.Items.Functions.SpawnItem

Q.CreateNewItem("TIN_BEANS","Beans", {"Consumable"}, "models/props_c17/chair02a.mdl", {2,2}, function(ply)
	ply:SetHealth(600)
end)

Q.CreateNewItem("APPLE","Apple", {"Consumable"}, "models/props_c17/chair02a.mdl", {1,2}, function(ply)
	ply:SetHealth(100)
end)
Q.CreateNewItem("1","Apple1slo", {"Consumable"}, "models/props_c17/chair02a.mdl", {1,1}, function(ply)
	ply:SetHealth(100)
end)
Q.CreateNewItem("2","Apple1slo", {"Consumable"}, "models/props_c17/chair02a.mdl", {5,6}, function(ply)
	ply:SetHealth(100)
end)