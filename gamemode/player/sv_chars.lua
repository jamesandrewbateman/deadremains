----------------------------------------------------------------------
-- Purpose:
--	So that the values can be loaded in from an sql result string.
-- into Characteristics
----------------------------------------------------------------------

function player_meta:setChar(char_unique, value)
	self.dr_character.characteristics[char_unique] = value
	self:networkChars()
end

function player_meta:getChar(char_unique)
	if (self.dr_character.characteristics[char_unique] ~= nil) then
		return self.dr_character.characteristics[char_unique]
	else
		error("Could not get " .. self:Nick() .. "'s characteristic " .. char_unique)
	end
end

util.AddNetworkString("deadremains.getchars")
function player_meta:networkChars()
	net.Start("deadremains.getchars")
	net.WriteUInt(table.Count(self.dr_character.characteristics), 8)

	for k,v in pairs(self.dr_character.characteristics) do
		net.WriteString(k)
		net.WriteUInt(v, 32)
	end
	net.Send(self)
end