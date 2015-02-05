//Main Tables
dr.Spawner = {}
dr.Spawner.Functions = {}
dr.Spawner.Data = {}

local function CheckIfSuitable(pos)
	local Ents = ents.FindInBox( pos + Vector( -16, -16, 0 ), pos + Vector( 16, 16, 64 ) )
	local Blockers = 0
			
	if Ents == nil then return true end
	for k, v in pairs( Ents ) do
		if ( IsValid( v ) and (v:GetClass() == "player" or v:GetClass() == "nut_zombie_basic") ) then
			Blockers = Blockers + 1
		end
	end
	if Blockers == 0 then
		return true
	end
		return false
end

function dr.Spawner.Functions.ZombieSpawner()
	//Check zombies have a player around them
	
	local foo = false
	for k,v in pairs(ents.FindByClass("nut_zombie_*")) do
		for k2,v2 in pairs(ents.FindInSphere(v:GetPos(), 5000)) do
			if v2:IsPlayer() then
				foo = true
			end
		end
		if foo == false then
			//Remove this zombie
			v:Remove()
		end
		foo = false
	end	
	
	if #ents.FindByClass("nut_zombie_*") > 100 then
		//Do nothing
	else
					
		local valids = {}
		//make a table of valid spawns
		for k,v in pairs(ents.FindByClass("zed_spawn")) do
			for k2,v2 in pairs(ents.FindInSphere(v:GetPos(), 1000)) do
				if v2:IsPlayer() then
					table.insert(valids, v:GetPos())
					break
				end
			end
		end		
		
		if valids[1] == nil then
			return
			--Since we couldn't find a valid spawn, just back out for now.
		end
		
		local position = table.Random(valids)
		if CheckIfSuitable(position) then
			local typ = "nut_zombie_basic"
				
			local zombie = ents.Create(typ)
			zombie:SetPos(position)
			zombie:Spawn()
			zombie:Activate()
		end
	end
end

function dr.Spawner.Functions.GetValidPlayerSpawn()
	local valids = {}
	//make a table of valid spawns
	local foo = false
	for k,v in pairs(ents.FindByClass("player_spawn")) do
		for k2,v2 in pairs(ents.FindInSphere(v:GetPos(), 500)) do
			if v2:IsPlayer() then
				foo = true
			end
		end
		if foo == false then
			//Remove this spawn
			table.insert(valids, v:GetPos())
		end
		foo = false
	end	
	
	if valids[1] == nil then
		return ents.FindByClass("info_player_start")[1]:GetPos()
		--Since we couldn't find a valid spawn, just back out for now.
	end
		
	local position = table.Random(valids)
	if CheckIfSuitable(position) then
		print(position)
		return position
	end
end

timer.Create("dr.Spawner.ZombieSpawner", 1, 0, dr.Spawner.Functions.ZombieSpawner)