local skills = {}
local characteristics = {}

----------------------------------------------------------------------
-- Purpose:
-- 		Sends the data (selected from the character_creation) panels
--      to the server, also validates this information.
----------------------------------------------------------------------
function player_meta:newCharacter(model, gender)
	net.Start("deadremains.character.new")
		net.WriteString(model)
		net.WriteString(gender)
	net.SendToServer()
end

----------------------------------------------------------------------
-- Purpose:
--	
----------------------------------------------------------------------

function player_meta:hasSkill(skill)
	return skills[skill]
end


function player_meta:getChar(name)
	return characteristics[name]
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

net.Receieve("deadremains.getchars", function(bits)
	local len = net.ReadUint(8)

	if (len > 1) then
		characteristics = {}
	end

	for i = 1, len do
		local name = net.ReadString()
		local value = net.ReadUInt(32)
		characteristics[name] = value
	end
end)