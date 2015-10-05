deadremains.team = {}

function player_meta:getTeam()
	return self:GetNWInt("dr_team")
end

function player_meta:isGov()
	return self:GetNWInt("dr_team_gov") == 1
end

function player_meta:inTeam()
	return self:getTeam() > 0
end

-- called when the player clicks create in the VGUI
function deadremains.team.create()
	net.Start("deadremains.createteam")
	net.SendToServer()
end

-- called when the player clicks join in the notification
function deadremains.team.join(ply, gov_steamid)
	if (ply:getTeam() == 0) then
		net.Start("deadremains.jointeam")
			net.WriteString(gov_steamid)
		net.SendToServer()
	end
end

function deadremains.team.join_no(ply, gov_steamid)
	if (ply:getTeam() == 0) then
		net.Start("deadremains.jointeam_no")
			net.WriteString(gov_steamid)
		net.SendToServer()
	end
end

net.Receive("deadremains.asktojointeam", function(bits)
	local ply = net.ReadEntity()
	local gov_steamid = net.ReadString()
	local gov = player.GetBySteamID(gov_steamid)

	if (IsValid(gov)) then
		local gov_name = gov:Nick()

		ShowNotification("Team Invitation", "Would you like to join " .. gov_name .. "'s team?",
		function()
			-- yes
			print(ply:SteamID(), gov_steamid)
			deadremains.team.join(ply, gov_steamid)
		end,
		function()
			-- no
			print("DECLINED INVITATION")
			deadremains.team.join_no(ply, gov_steamid)
		end)
	end
end)