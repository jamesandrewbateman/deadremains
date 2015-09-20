require("navigation")

deadremains.navigator = {}
deadremains.navigator.Nav = nav.Create(64)
deadremains.navigator.startPos = 0
deadremains.navigator.endPos = 0

function deadremains.navigator.generateGround(ply)
	-- Find a position on the ground where we can generate the mesh from.
	local Pos = (IsValid(ply) and (ply:GetPos() + Vector(0,0,5))) or Vector(0, 0, 1)
	local trace = {}
	trace.start = Pos + Vector(0, 0, 1)
	trace.endpos = trace.start - Vector(0, 0, 9000)
	trace.ignore = ply
	trace.mask = MASK_PLAYERSOLID
	local tr = util.TraceLine(trace)

	local Nav = deadremains.navigator.Nav
	if (tr.HitWorld) then
		Nav:ClearGroundSeeds()

		-- add a single node to generate from.
		Nav:AddGroundSeed(Pos, tr.Normal)
		Nav:Generate(function(nav)
			print("Generated " .. nav:GetNodeTotal() .. " nodes.")
		end, function(Nav, GeneratedNodes)
		end)
	end
end
concommand.Add("gen_nav_ground", function(ply)
	deadremains.navigator.generateGround(ply)
end)

function deadremains.navigator.setStart(pos)
	local Nav = deadremains.navigator.Nav
	Nav:SetStart(Nav:GetClosestNode(pos))
	deadremains.navigator.startPos = Nav:GetStart()
end

function deadremains.navigator.setEnd(pos)
	local Nav = deadremains.navigator.Nav
	Nav:SetEnd(Nav:GetClosestNode(pos))
	deadremains.navigator.endPos = Nav:GetEnd()
end

-- this needs to be networked.
function deadremains.navigator.computeHullPath(startPos, endPos, ent)
	local Nav = deadremains.navigator.Nav

	deadremains.navigator.setStart(startPos)
	deadremains.navigator.setEnd(endPos)

	-- compute hull path.
	local maxVector = ent:OBBMaxs()
	local minVector = ent:OBBMins()
	Nav:FindPathHull(maxVector, minVector, function(Nav, FoundPath, Path)
		if FoundPath then
			PrintTable(Path)
			return Path
		end
	end)
end