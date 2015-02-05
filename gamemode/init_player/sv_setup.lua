
//Here's what to do when we first spawn
function GM:PlayerInitialSpawn(ply)
	//Set them under the map or kill them
	
	//Force open the menu
	
	//For now just load the first character here
	timer.Simple(1, function() dr.Chars.Functions.SyncClient( ply ) dr.Chars.Functions.LoadChar( ply, 1 ) end)
end