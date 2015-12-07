skills = {}
characteristics = {}
buffs = {}
debuffs = {}

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

concommand.Add("newcharp", function()
	LocalPlayer():newCharacter("models/player/group01/male_03.mdl", "m")
end)
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

function player_meta:hasBuff(name)
	return buffs[name] == 1
end

function player_meta:hasDebuff(name)
	return debuffs[name] == 1
end

function player_meta:hasBuffOrDebuff(name)
	return buffs[name] or debuffs[name]
end
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.getskills", function(bits)
	local len = net.ReadUInt(8)

	print("Recieved skills!", len)

	-- Clear all the skills.
	if (len > 1) then
		skills = {}
	end

	for i = 1, len do
		local skill = net.ReadString()
		skills[skill] = true
	end
end)

net.Receive("deadremains.getchars", function(bits)
	local len = net.ReadUInt(8)

	print("Recieved characteristics!", len)

	if (len > 1) then
		characteristics = {}
	end

	for i = 1, len do
		local name = net.ReadString()
		local value = net.ReadUInt(32)
		characteristics[name] = value
	end
end)

net.Receive("deadremains.getbuffs", function(bits)
	local len = net.ReadUInt(8)
	print("Recieved buffs!", len)

	if (len > 1) then
		buffs = {}
	end

	for i = 1, len do
		local name = net.ReadString()
		local value = net.ReadUInt(4)
		buffs[name] = value
	end
end)

net.Receive("deadremains.getdebuffs", function(bits)
	local len = net.ReadUInt(8)

	print("Recieved debuffs!", len)

	if (len > 1) then
		debuffs = {}
	end

	for i = 1, len do
		local name = net.ReadString()
		local value = net.ReadUInt(4)
		debuffs[name] = value
	end
end)