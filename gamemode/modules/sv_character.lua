util.AddNetworkString("deadremains.character.new")
util.AddNetworkString("deadremains.shownotification_ok")

net.Receive("deadremains.character.new", function(bits, ply)
	if ply:GetNWInt("dr_character_created") == 0 then
		ply:SetNWInt("dr_character_created", 1)

		local model = net.ReadString()
		local gender = net.ReadString()

		ply:newCharacter(model, gender)
	else
		ply:sendNotification("Warning", "Could not save character, already have\n one one created.")
	end
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:newCharacter(model, gender)
	self:SetModel(model)
	self.dr_character.gender = gender

	-- flags
	self.dr_character.debuffs = {
		COLD = 0,
		SICKNESS = 0,
		HEART_ATTACK = 0,
		UNCONCIOUS = 0,
		TIREDNESS = 0,
		BANDIT = 0,
		DEPRESSION = 0,
		PSYCHOSIS = 0,
		ZINFECTED_HIT = 0,
		ZINFECTED_BLOOD = 0,
		DEHYDRATED = 0,
		STARVATION = 0,
		BLEEDING = 0,
		RESTRAINED = 0
	}

	self.dr_character.buffs = {
		HYDRATED = 1,
		FULL = 1,
		ZINVISIBLE = 0,
		BOOST = 0,
		PAUSE = 0,
		HEALTHY = 0,
		ATHLETIC = 0,
		IRON_MAN = 0,
		RIPPED = 0,
		WARM = 0,
		HERO = 0
	}

	self.dr_character.created = true
end

deadremains.character = {}

-- looper to apply these to all players online.
timer.Create("deadremains.buffschecker", 1, 0, function()
	for k,ply in pairs(player.GetAll()) do
		if (IsValid(ply) and ply.dr_character.created) then

			-- process each flag one by one
			for unique, flag in pairs(ply.dr_character.buffs) do
				if (flag == 1) then
					if (deadremains.character.flagCheckFuncs[unique] ~= nil) then
						flag = deadremains.character.flagCheckFuncs[unique]

						if (flag == 1) then
							print("Processing flag", unique)
							deadremains.character.processFlagFuncs[unique](ply)
						end
					end
				end
			end

		end
	end
end)

-- list of functions with strings as keys
-- these are ran if the condition of the buff/debuff is met.
deadremains.character.flagCheckFuncs = {}
deadremains.character.processFlagFuncs = {}

-- ran every second if enabled.

deadremains.character.flagCheckFuncs["HYDRATED"] = function(ply)
	if (ply:getThirst() > 80) then return 1 else return 0 end
end
deadremains.character.processFlagFuncs["HYRDRATED"] = function(ply)
	local v = math.Clamp(ply:Heath() + (1/60), 0, 100)
	ply:SetHealth(v)
end

deadremains.character.flagCheckFuncs["FULL"] = function(ply)
	if (ply:getHunger() > 80) then return 1 else return 0 end
end
deadremains.character.processFlagFuncs["FULL"] = function(ply)
	local v = math.Clamp(ply:Health() + (1/60), 0, 100)
	ply:SetHealth(v)
end