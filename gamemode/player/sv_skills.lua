--! @module severisde handling of skills data.

util.AddNetworkString("deadremains.getskills")

--! @brief used to send all the skills data to the client.
function player_meta:networkSkills()
	net.Start("deadremains.getskills")
		net.WriteUInt(table.Count(self.dr_character.skills), 8)

		for k,v in pairs(self.dr_character.skills) do
			net.WriteString(k)
			net.WriteUInt(v, 32)
		end
	net.Send(self)
end

--! @brief sets a skill value serverside, does not network.
--! @param @skill_unique string of the skill.
--! @param @value an integer value 0 or 1. 
function player_meta:setSkill(skill_unique, value)
	if (value == nil) then value = 0 end

	self.dr_character.skills[skill_unique] = value
end

--! @brief get a skill stored serverside.
--! @param @skill_unique string of the skill.
--! @returns a value of 0 (false) or 1 (true).
function player_meta:getSkill(skill_unique)
	local s = self.dr_character.skills[skill_unique]
	if s == nil then return 0 end
	if s == 0 then return 0 end

	return s
end

function player_meta:hasSkill(skill)
	if self.dr_character.skills[skill] ~= nil then return 1 else return 0 end
end