deadremains.team = {}
deadremains.team.invitations = {}
function deadremains.team.addInvitation(gov_steamid, target_steamid)
	-- [from]
	deadremains.team.invitations[target_steamid] = gov_steamid
end

function deadremains.team.hasInviteFrom(gov_steamid, target_steamid)
	return deadremains.team.invititations[target_steamid] == gov_steamid
end

function deadremains.team.removeInvitation(steamid)
	deadremains.team.invititations[steamid] = nil
end
----------------------------------------------------------------------
-- Purpose:
-- Hooks to the clientside.
----------------------------------------------------------------------
util.AddNetworkString("deadremains.createteam")
util.AddNetworkString("deadremains.asktojointeam")
util.AddNetworkString("deadremains.jointeam")

net.Receive("deadremains.createteam", function(bits, ply)
	-- lets check whether we can make a team, requires multiple players nearby.
	if not ply:inTeam() then
		local nearPlayers = ents.FindInSphere(ply:GetPos(), 600)
		for k,v in pairs(nearPlayers) do
			if v:IsPlayer() then
				deadremains.team.askToJoin(ply, v)
			end
		end
	end
end)

net.Receive("deadremains.jointeam", function(bits, ply)
	local gov_steamid = net.ReadString()

	-- protection from joining random teams.
	if (deadremains.team.hasInviteFrom(gov_steamid, ply:SteamID())) then
		-- create the team, or if it already exists, set the team.
		local gov_player = player.GetBySteamID(gov_steamid)
		local gov_teamid = gov_player:getTeam()
		local steam_id = deadremains.sql.escape(database_main, ply:SteamID())

		if not gov_player:inTeam() then
			-- the person offering the invitation isn't in a team yet, this is confir
			-- mation that we should create the team itself.
			deadremains.team.create(gov_player, function (team_id)
				gov_teamid = team_id

				ply:setTeam(gov_teamid, 0)

				local params = "INSERT INTO user_teams VALUES (team_id, steam_id, is_gov) VALUES ("
				params = params .. gov_teamid .. ", "
				params = params .. steam_id .. ", "
				params = params .. "0)"
				deadremains.sql.query(database_main, params)
			end)
		else
			ply:setTeam(gov_teamid, 0)

			local params = "INSERT INTO user_teams VALUES (team_id, steam_id, is_gov) VALUES ("
			params = params .. gov_teamid .. ", "
			params = params .. steam_id .. ", "
			params = params .. "0)"
			deadremains.sql.query(database_main, params)
		end

		deadremains.team.removeInvitation(ply)
	end
end)

function deadremains.team.askToJoin(gov, ply)
	if (ply:inTeam()) then
		gov:ChatPrint("Could not ask " .. ply:Nick() .. " to join, already in a team.")
	elseif (gov:inTeam() and not gov:isGov()) then
		gov:ChatPrint("Could not ask " .. ply:Nick() .. " to join, since you are not the govener.")
	else
		deadremains.team.addInvitation(gov:SteamID(), ply:SteamID())
		net.Start("deadremains.asktojointeam")
			net.WriteString(gov:SteamID())
		net.Send(ply)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.team.create(ply, callback)
	print("Creating team " .. ply:SteamID())
	local steam_id = deadremains.sql.escape(database_main, ply:SteamID())

	-- the team_id will be automagically assigned by mysql.
	deadremains.sql.query("INSERT INTO user_teams(steam_id, is_gov) VALUES (" .. steam_id .. ", 1);")

	-- now we get the id assigned by mysql and make this player the gov of the team.
	deadremains.sql.query("SELECT * FROM user_teams WHERE steam_id=" .. steam_id, function(data, a, l)
		if (data and data[1]) then
			data = data[1]
			print("New team_id is " .. data.team_id)
			ply:setTeam(data.team_id, 1)
			callback(data.team_id)
		end
	end)
end