deadremains = {}

include("shared.lua")
include("sh_utilities.lua")
include("modules/cl_netrequest.lua")
include("modules/sh_log.lua")
include("modules/sh_settings.lua")
include("modules/sh_item.lua")
include("sh_loader.lua")
include("modules/sh_inventory.lua")
include("modules/cl_inventory.lua")
include("modules/cl_team.lua")
include("modules/cl_gear.lua")
include("modules/cl_character.lua")

include("panels/button.lua")
include("panels/combo_box.lua")
include("panels/slot.lua")
include("panels/slot_context_menu.lua")
include("panels/inventory.lua")
include("panels/character_creation.lua")
include("panels/main_menu.lua")
include("panels/notification_popup.lua")
include("panels/deadmin_menu.lua")

include("modules/sh_character.lua")
include("modules/cl_character.lua")

include("cl_player.lua")

include("modules/sh_uiloader.lua")

deadremains.loader.initialize()

----------------------------------------------------------------------
-- Purpose:
--
----------------------------------------------------------------------

function GM:InitPostEntity()
	net.Start("deadremains.player.initalize")
	net.SendToServer()
end

----------------------------------------------------------------------
-- Purpose:
--
----------------------------------------------------------------------

function GM:OnEntityCreated(entity)
end