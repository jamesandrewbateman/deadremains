//Main Tables
dr.Spawning = {}
dr.Spawning.Functions = {}
dr.Spawning.Data = {}

function dr.Spawning.Functions.ZedSpawn(position)
	local ent1 = ents.Create("zed_spawn") 
	local pos = position
	pos.z = pos.z - ent1:OBBMaxs().z
	ent1:SetPos( pos )
	ent1:Spawn()
end

function dr.Spawning.Functions.PlayerSpawn(position)
	local ent1 = ents.Create("player_spawn") 
	local pos = position
	pos.z = pos.z - ent1:OBBMaxs().z
	ent1:SetPos( pos )
	ent1:Spawn()
end

function dr.Spawning.Functions.ItemSpawn(position)
	local ent1 = ents.Create("item_spawn") 
	local pos = position
	pos.z = pos.z - ent1:OBBMaxs().z
	ent1:SetPos( pos )
	ent1:Spawn()
end


Q.PlayerSpawn = dr.Spawning.Functions.PlayerSpawn
Q.ZedSpawn = dr.Spawning.Functions.ZedSpawn
Q.ItemSpawn = dr.Spawning.Functions.ItemSpawn