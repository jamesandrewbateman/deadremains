
deadremains.ui = {}

deadremains.ui.showDebug = true

local GAMEMODE_PATH = "deadremains/gamemode/"

----------------------------------------------------------------------
-- Purpose: Prints debug messages for all UI related things
--
----------------------------------------------------------------------
function deadremains.ui.print(...)

	if deadremains.ui.showDebug then

		print(...)

	end

end

----------------------------------------------------------------------
-- Purpose: Load all required UI helper functions and variables
--
----------------------------------------------------------------------
function deadremains.ui.loadHelpers()

	if SERVER then

		AddCSLuaFile(GAMEMODE_PATH .. "ui/cl_helpers.lua")

		deadremains.ui.print("deadremains.ui :: Added fonts")

	elseif CLIENT then

		include(GAMEMODE_PATH .. "ui/cl_helpers.lua")

		deadremains.ui.print("deadremains.ui :: Loaded fonts")


	end

end

----------------------------------------------------------------------
-- Purpose: Load all required UI Fonts
--
----------------------------------------------------------------------
function deadremains.ui.loadFonts()

	if SERVER then

		AddCSLuaFile(GAMEMODE_PATH .. "ui/cl_fonts.lua")

		deadremains.ui.print("deadremains.ui :: Added fonts")

	elseif CLIENT then

		include(GAMEMODE_PATH .. "ui/cl_fonts.lua")

		deadremains.ui.print("deadremains.ui :: Loaded fonts")


	end

end

----------------------------------------------------------------------
-- Purpose: Load all required UI Elements
--
----------------------------------------------------------------------
function deadremains.ui.loadElements()

	if SERVER then

		local f, _ = file.Find(GAMEMODE_PATH .. "ui/elements/*", "LUA")
		for _, name in pairs(f) do

			AddCSLuaFile(GAMEMODE_PATH .. "ui/elements/" .. name)

			deadremains.ui.print("deadremains.ui :: Added element", name)

		end

	elseif CLIENT then

		local f, _ = file.Find(GAMEMODE_PATH .. "ui/elements/*", "LUA")
		for _, name in pairs(f) do

			include(GAMEMODE_PATH .. "ui/elements/" .. name)

			deadremains.ui.print("deadremains.ui :: Loaded element", name)

		end

	end

end

----------------------------------------------------------------------
-- Purpose: Loads all containers of the UI
--
----------------------------------------------------------------------
function deadremains.ui.loadContainers()

	if SERVER then

		local f, _ = file.Find(GAMEMODE_PATH .. "ui/containers/*", "LUA")
		for _, name in pairs(f) do

			AddCSLuaFile(GAMEMODE_PATH .. "ui/containers/" .. name)

			deadremains.ui.print("deadremains.ui :: Added container", name)

		end

	elseif CLIENT then

		local f, _ = file.Find(GAMEMODE_PATH .. "ui/containers/*", "LUA")
		for _, name in pairs(f) do

			include(GAMEMODE_PATH .. "ui/containers/" .. name)

			deadremains.ui.print("deadremains.ui :: Loaded container", name)

		end

	end

end

----------------------------------------------------------------------
-- Purpose: Initialize the UI
--
----------------------------------------------------------------------
function deadremains.ui.initialize()

	deadremains.ui.loadHelpers()
	deadremains.ui.loadFonts()
	deadremains.ui.loadElements()
	deadremains.ui.loadContainers()

end

deadremains.ui.initialize()