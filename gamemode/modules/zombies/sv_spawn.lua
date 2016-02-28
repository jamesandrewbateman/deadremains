local function SpawnThink()
	local limit = GetConVar( "drt_zombie_limit" ):GetInt()
	local limitPerWave = GetConVar( "drt_zombie_maxperwave" ):GetInt()
	local count = 0

	local zedCount = #ents.FindByClass( "npc_walker*" )

	local allNavs = navmesh.GetAllNavAreas()

	if zedCount >= limit then return end

	for i = 1, limitPerWave do

		if zedCount >= limit then break end

		local found = false

		local spwnPoint

		for j = 1, 5 do

			found = true

			local nav = allNavs[ math.random( #allNavs ) ]

			spwnPoint = nav:GetRandomPoint() + Vector( 0, 0, 4 )

			if !nav:IsUnderwater() then

				for _, v in pairs( player.GetAll() ) do
					if v:GetPos():Distance( spwnPoint ) < 1500 then
						found = false
						break
					end
				end

				local tr = {
					start = spwnPoint,
					endpos = spwnPoint,
					mins = Vector( - 16, - 16, 0 ),
					maxs = Vector( 16, 16, 71 )
				}

				if util.TraceHull( tr ).Hit then
					found = false
				end

				if found then break end

			end

		end

		--spawn Zombie
		if found then
			local walker = ents.Create("npc_walkerbase")
			if !IsValid( walker ) then break end
			walker:SetPos( spwnPoint )
			walker:Spawn()
			walker:Activate()

			zedCount = zedCount + 1
			count = count + 1
		end

	end

	print( "Spawned: " .. count .. " Zombies." )
	print( "Total Zombies alive: " .. zedCount )

end

local function SpawnInit()
	print("Initializing zombie spawing")
	timer.Create( "SpawnThink", GetConVar("drt_zombie_thinkdelay"):GetInt(), 0, function() SpawnThink() end )
end

hook.Add( "InitPostEntity", "drZombieSpawnInit", function()
	SpawnInit()
end )