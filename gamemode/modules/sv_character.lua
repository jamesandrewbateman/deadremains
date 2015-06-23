----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:hasSkill(skill)
	return self.dr_character.skills[skill]
end