local skills = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:hasSkill(skill)
	return skills[skill]
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.getskill", function(bits)
	local len = net.ReadUInt(8)

	-- Clear all the skills.
	if (len > 1) then
		skills = {}
	end

	for i = 1, len do
		local skill = net.ReadString()

		skills[skill] = true
	end
end)