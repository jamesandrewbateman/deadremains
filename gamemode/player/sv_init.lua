local function default(self)
	-- loads all the default data into containers.
	local needs = deadremains.settings.get("needs")
	for unique, data in pairs (needs) do
		self:setNeed(unique, data.default)
	end

	local characteristics = deadremains.settings.get("characteristics")
	for unique, data in pairs (characteristics) do
		self:setChar(unique, data.default)
	end

	--[[
	local inventories = deadremains.settings.get("default_inventories")
	for _, info in pairs(inventories) do
		local data = deadremains.inventory.get(info.unique)

		if (data) then
			print("Added inventory ", data.unique, "at", info.inventory_index);
			self:AddInventory(data.unique, data.horizontal, data.vertical, info.inventory_index)
			-- self:createInventory(data.unique, data.horizontal, data.vertical, info.inventory_index)
		end
	end
	]]

	-- default to 0 (no team for group making)
	self:setTeam(0)

	timer.Create("dr.thirst." .. self:UniqueID(), 15, 100, function()
		if IsValid(self) and self.decreaseThirst then
			self:decreaseThirst(1)
		end
	end)

	timer.Create("dr.hunger." .. self:UniqueID(), 30, 100, function()
		if IsValid(self) and self.decreaseHunger then
			self:decreaseHunger(1)
		end
	end)

	self.dr_character.max_weight = 20
end

--! @brief prepares the player_meta.dr_character table for all incoming data.
function player_meta:reset()
	self.dr_character = {}

	self.dr_character.needs = {}
	self.dr_character.skills = {}
	self.dr_character.characteristics = {}
	self.dr_character.team = {}

	default(self)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:initializeCharacter()
	self:reset()

	timer.Simple(1, function()
		self:loadFromMysql()
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
