----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:hasSkill(skill)
	if self.dr_character.skills[skill] ~= nil then return 1 else return 0 end
end


----------------------------------------------------------------------
-- Purpose:
--	Used by sv_sql.lua to get the players skills in a specific format
--  to be queried.	
----------------------------------------------------------------------

function player_meta:getMysqlString()
	local format = ""
	local skills = deadremains.settings.get("skills")

	-- find out how many skills there are in the array.
	local count = 0
	for _, skill in pairs(skills) do count = count + 1 end

	local c = 0
	for _, skill in pairs(skills) do
		-- if we are at the last entry in the array.
		if (c == count - 1) then
			format = format .. skill.unique .. " = " .. self:hasSkill(skill.unique)
		else	
			format = format .. skill.unique .. " = " .. self:hasSkill(skill.unique) .. ", "
		end

		c = c + 1
	end

	return format
end