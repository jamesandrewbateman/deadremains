----------------------------------------------------------------------
-- Purpose:
-- Skills like woodcutting/medical skills.etc	
----------------------------------------------------------------------

util.AddNetworkString("deadremains.getskill")

function player_meta:setSkill(skill_unique, value)
	if (value == nil) then value = 0 end

	self.dr_character.skills[skill_unique] = value
end

function player_meta:getSkill(skill_unique)
	local s = self.dr_character.skills[skill_unique]
	if s == nil then return 0 end
	if s == 0 then return 0 end

	return s
end