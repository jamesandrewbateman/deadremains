deadremains.skills = {}

function deadremains.skills.getStartValues()
	-- now we sample the database
	-- to find out which characteristics are the least.

end

util.AddNetworkString("deadremains.character.new")
util.AddNetworkString("deadremains.shownotification_ok")

net.Receive("deadremains.character.new", function(bits, ply)
	if ply:GetNWInt("dr_character_created") == 0 then
		ply:SetNWInt("dr_character_created", 1)

		local model = net.ReadString()
		local gender = net.ReadString()

		ply:SetModel(model)
		ply.dr_character.gender = gender
	else
		ply:sendNotification("Warning", "Could not save character, already have\n one one created.")
	end
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:hasSkill(skill)
	if self.dr_character.skills[skill] ~= nil then return 1 else return 0 end
end

function player_meta:sendNotification(title, message)
	net.Start("deadremains.shownotification_ok")
		net.WriteString(title)
		net.WriteString(message)
	net.Send(self)
end