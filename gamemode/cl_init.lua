include("shared.lua")

include("panels/button.lua")
include("panels/combo_box.lua")
include("panels/character_creation.lua")
include("modules/sh_character.lua")
include("modules/cl_character.lua")

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:InitPostEntity()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:OnEntityCreated(entity)
	if (IsValid(entity)) then
		if (entity == LocalPlayer()) then
			net.Start("deadremains.player.initalize")
			net.SendToServer()
		end
	end
end


----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function GM:Think()
end