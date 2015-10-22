function player_meta:setTeam(team_id, is_gov)
	self.dr_character.team.id = team_id
	self.dr_character.team.is_gov = is_gov

	self:SetNWInt("dr_team", self.dr_character.team.id)
	self:SetNWInt("dr_team_gov", self.dr_character.team.is_gov)
end

function player_meta:getTeam()
	return self.dr_character.team.id or 0
end

function player_meta:isGov()
	return (self.dr_character.team.is_gov or 0) == 1
end

function player_meta:inTeam()
	return self:getTeam() > 0
end