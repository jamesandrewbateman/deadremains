----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local function default(self)
	local needs = deadremains.settings.get("needs")
	
	for unique, data in pairs (needs) do
		self.dr_character.needs[unique] = data.default
	end

	local characteristics = deadremains.settings.get("characteristics")
	
	for unique, data in pairs (characteristics) do
		self.dr_character.characteristics[unique] = data.default
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:initializeCharacter()
	local steam_id = deadremains.sql.escape(database_main, self:SteamID())

	self.dr_character = {}

	self.dr_character.needs = {}
	self.dr_character.skills = {}
	self.dr_character.inventory = {}
	self.dr_character.characteristics = {}

	local needs = deadremains.settings.get("needs")
	local characteristics = deadremains.settings.get("characteristics")

	deadremains.sql.query(database_main, "SELECT * FROM `users` WHERE `steam_id` = " .. steam_id, function(data, affected, last_id)
		if (data and data[1]) then
			data = data[1]

			for unique, _ in pairs (needs) do
				local info = data["need_" .. unique]

				if (info) then
					self.dr_character.needs[unique] = info
				end
			end

			for unique, _ in pairs (characteristics) do
				local info = data["characteristic_" .. unique]

				if (info) then
					self.dr_character.characteristics[unique] = info
				end
			end

		-- No data, let's create a new profile.
		else
			default(self)

			local query = "INSERT INTO users(steam_id, "

			for unique, value in pairs(self.dr_character.needs) do
				query = query .. "need_" .. unique .. ", "
			end

			for unique, value in pairs(self.dr_character.characteristics) do
				query = query .. "characteristic_" .. unique .. ", "
			end

			query = string.sub(query, 0, #query -2) .. ") VALUES(".. steam_id .. ", "
			
			for unique, value in pairs(self.dr_character.needs) do
				query = query .. value .. ", "
			end

			for unique, value in pairs(self.dr_character.characteristics) do
				query = query .. value .. ", "
			end

			query = string.sub(query, 0, #query -2) .. ")"

			deadremains.sql.query(database_main, query)
		end
	end,

	-- Failed to connect to the database.
	function()
		default(self)
	end)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

util.AddNetworkString("deadremains.player.initalize")

net.Receive("deadremains.player.initalize", function(bits, player)
	if (!player.dr_loaded) then
		player:initializeCharacter()

		player.dr_loaded = true
	end
end)