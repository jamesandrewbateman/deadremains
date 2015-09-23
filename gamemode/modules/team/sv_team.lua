deadremains.team = {}
deadremains.team.invitations = {}
function deadremains.team.addInvitation(gov_steamid, target_steamid)
	-- [to] = from
	deadremains.team.invitations[target_steamid] = gov_steamid
end

function deadremains.team.hasInviteFrom(gov_steamid, target_steamid)
	return deadremains.team.invitations[target_steamid] == gov_steamid
end

function deadremains.team.hasInvitePending(target_steamid)
	return deadremains.team.invitations[target_steamid] == nil
end

function deadremains.team.removeInvitation(steamid)
	deadremains.team.invitations[steamid] = nil
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
			if v:IsPlayer() and v ~= ply and deadremains.team.hasInvitePending(v:SteamID()) and not v:inTeam() then
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

				local params = "INSERT INTO user_teams (team_id, steam_id, is_gov) VALUES ("
				params = params .. gov_teamid .. ", "
				params = params .. steam_id .. ", "
				params = params .. "0)"
				deadremains.sql.query(database_main, params)
			end)
		else
			ply:setTeam(gov_teamid, 0)

			local params = "INSERT INTO user_teams (team_id, steam_id, is_gov) VALUES ("
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
			net.WriteEntity(ply)
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

	-- update the number of teams.
	deadremains.sql.query(database_main, "SELECT team_count FROM gm_meta;", function(data, a, l)
		if (data and data[1]) then
			data = data[1]

			local team_count = data.team_count + 1

			deadremains.sql.query(database_main, "UPDATE gm_meta SET team_count=" .. team_count .. " LIMIT 1;")
			deadremains.sql.query(database_main, "INSERT INTO user_teams(team_id, steam_id, is_gov) VALUES (" .. team_count .. "," .. steam_id .. ", 1);")
			
			ply:setTeam(team_count, 1)
			callback(team_count)
		end
	end)
end
concommand.Add("dr_team_create", function(ply)
	deadremains.team.create(ply, function(teamid)
		print("Created a new team!")
	end)
end)

----------------------------------------------------------------------
-- Purpose: Allow members from a team to kick a member.
--		
----------------------------------------------------------------------
deadremains.team.voteKicksTable = {}

function deadremains.team.kickPlayer(ply)
	if (ply:inTeam()) then
		-- remove networked variables
		-- remove row from db
		local steam_id = deadremains.sql.escape(database_main, ply:SteamID())

		deadremains.sql.query(database_main, "DELETE FROM user_teams WHERE steam_id=" .. steam_id);
		ply:setTeam(0, 0)
	end
end
concommand.Add("dr_team_kick", function(ply)
	deadremains.team.kickPlayer(ply)
end)