//Main Tables
dr.Chars = {}
dr.Chars.Functions = {}
dr.Chars.Data = {}

function dr.Chars.Functions.CreateNewChar( ply, name, model )
	if ply.Characters == nil then ply.Characters = {} end
	
	//For now just write it into slot 1
	local index = 1
	ply.Characters[index] = {
		Name = name, 
		Model = model, 
		InventoryData = {}, 
		LocationData = dr.Spawner.Functions.GetValidPlayerSpawn(), 
		VitalsData = {Hunger = {Value = 1000, Max = 1000, TickRate = 1}, Thirst = {Value = 1000, Max = 1000, TickRate = 2}}
	}
	dr.Chars.Functions.LoadChar( ply, index )
end

function dr.Chars.Functions.LoadChar( ply, index )
	if ply.Characters == nil then return end
	
	ply.ActiveChar = index
	
	local data = ply.Characters[index]
	//Set names
	//ply.Name = data.Name
	ply:SetModel(data.Model)
	//SetInventoryData
	//Put them in their last location
	ply:SetPos(data.LocationData)
	dr.Vitals.Functions.SetData( ply, data.VitalsData )
end

util.AddNetworkString( "dr.Characters" )
function dr.Chars.Functions.SyncClient( ply )
	net.Start( "dr.Characters" )
		net.WriteTable( ply.Characters )
	net.Send( ply )
	print("Syncing: " .. ply:Nick() .. "'s " .. "Characters")
end