//Save/loading

//Main Tables
dr.DataHandler = {}
dr.DataHandler.Functions = {}
dr.DataHandler.Data = {}

file.CreateDir( "dr" ) -- Create the directory
file.CreateDir( "dr/"..game.GetMap().."/chardata" )
function dr.DataHandler.Functions.SavePlayerData( ply )
	if ply.Characters != nil then 
	
		//Update their current character data
		if ply.ActiveChar != nil then
			ply.Characters[ply.ActiveChar].VitalsData = dr.Vitals.Functions.GetData( ply )
			ply.Characters[ply.ActiveChar].LocationData = ply:GetPos()
		end
		print("Saving Data for: " .. ply:Nick() )
		if ply.UniID == nil then ply.UniID = ply:UniqueID( ) end
		local tab = util.TableToJSON( ply.Characters )
		file.Write( "dr/"..game.GetMap().."/chardata/"..ply.UniID..".txt", tab )
	end
	
end

function dr.DataHandler.Functions.LoadPlayerData( ply )
	if ply.UniID == nil then ply.UniID = ply:UniqueID( ) end
	print("Loading Data for: " .. ply:Nick() )
	local tab =  file.Read( "dr/"..game.GetMap().."/chardata/"..ply.UniID..".txt", tab ) 
	if tab != nil then
		tab = util.JSONToTable(tab)
		ply.Characters = tab
	else
		print( ply:Nick() .. " has no valid data." )
	end
end

//Load when player spawns
hook.Add( "PlayerInitialSpawn", "dr.datahandler.Load", function(ply) 
	timer.Simple(0, function()  dr.DataHandler.Functions.LoadPlayerData( ply ) end) 
end )

hook.Add( "PlayerDisconnected", "dr.datahandler.Save", function(ply) 
	dr.DataHandler.Functions.SavePlayerData( ply )
end )
