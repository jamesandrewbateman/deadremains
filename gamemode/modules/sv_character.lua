----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:hasSkill(skill)
	if self.dr_character.skills[skill] ~= nil then return 1 else return 0 end
end