--! @module serverside player class, loads all dependencies.

-- be careful with order here...
include("player/sv_team.lua")
include("player/sv_needs.lua")
include("player/sv_chars.lua")
include("player/sv_skills.lua")
include("player/sv_init.lua")
include("player/sv_inventory.lua")

--! @brief global network function to send all the required data to the client at runtime.
function player_meta:Network()
	-- characteristics, player/sv_chars.lua
	self:networkChars()
	-- skills, player/sv_skills.lua
	self:networkSkills()
	
	-- teams/needs do not need networking since then are NWInt handled.
end

concommand.Add("syncdata", function(ply)
	ply:Network()
end)