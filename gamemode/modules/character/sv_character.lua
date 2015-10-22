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
concommand.Add("newchar", function(ply)
	ply:newCharacter("models/player/group01/male_03.mdl", "m")
end)

function player_meta:newCharacter(model, gender)
	self:SetModel(model)
	self.dr_character.gender = gender

	-- use this as temp storage for players health.
	-- we do this because we run the buffs.etc every second, and
	-- they want actions to happen say (-1 Hp every 60 seconds).
	-- ply:SetHealth() doesn't like ply:Health()+(1/60);

	self.dr_character.float_hp = self:Health()

	-- flags, on or off?
	self.dr_character.debuffs = {}
	self.dr_character.debuffs["COLD"] = 0
	self.dr_character.debuffs["SICKNESS"] = 0
	self.dr_character.debuffs["HEART_ATTACK"] = 0
	self.dr_character.debuffs["UNCONCIOUS"] = 0
	self.dr_character.debuffs["TIREDNESS"] = 0
	self.dr_character.debuffs["BANDIT"] = 0
	self.dr_character.debuffs["DEPRESSION"] = 0
	self.dr_character.debuffs["PSYCHOSIS"] = 0
	self.dr_character.debuffs["ZINFECTED_HIT"] = 0
	self.dr_character.debuffs["ZINFECTED_BLOOD"] = 0
	self.dr_character.debuffs["DEHYDRATED"] = 0
	self.dr_character.debuffs["STARVATION"] = 0
	self.dr_character.debuffs["BLEEDING"] = 0
	self.dr_character.debuffs["RESTRAINED"] = 0

	self.dr_character.buffs = {}
	self.dr_character.buffs["HYDRATED"] = 1
	self.dr_character.buffs["FULL"] = 1
	self.dr_character.buffs["ZINVISIBLE"] = 0
	self.dr_character.buffs["BOOST"] = 0
	self.dr_character.buffs["PAUSE"] = 0
	self.dr_character.buffs["HEALTHY"] = 0
	self.dr_character.buffs["ATHLETIC"] = 0
	self.dr_character.buffs["IRON_MAN"] = 0
	self.dr_character.buffs["RIPPED"] = 0
	self.dr_character.buffs["WARM"] = 0
	self.dr_character.buffs["HERO"] = 0

	self.dr_character.created = true
	print("Created a new character")
end

deadremains.character = {}

-- list of functions with strings as keys and value as 1 or 0
deadremains.character.flagCheckFuncs = {}
-- these are ran if the condition of the buff/debuff is met.
deadremains.character.processFlagFuncs = {}

-- looper to apply these to all players online.
timer.Create("deadremains.buffschecker", 1, 0, function()
	for k,ply in pairs(player.GetAll()) do
		if (ply.dr_character) then
			if (IsValid(ply) and (ply.dr_character.created == true)) then
				-- process each flag one by one
				for unique, flag in pairs(ply.dr_character.buffs) do
					if (flag == 1) then
						-- does this buff actually have any code to run/check?
						if (deadremains.character.flagCheckFuncs[unique] ~= nil) then
							flag = deadremains.character.flagCheckFuncs[unique](ply)
						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if (flag == 1) then
							deadremains.character.processFlagFuncs[unique](ply)
						end
					end
				end

				for unique, flag in pairs(ply.dr_character.debuffs) do
					if (flag == 1) then
						-- does this buff actually have any code to run/check?
						if (deadremains.character.flagCheckFuncs[unique] ~= nil) then
							flag = deadremains.character.flagCheckFuncs[unique](ply)
						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if (flag == 1) then
							deadremains.character.processFlagFuncs[unique](ply)
						end
					end
				end
			end
		end
	end
end)

-- ran every second if enabled.
deadremains.character.flagCheckFuncs["HYDRATED"] = function(ply)
	if (ply:getThirst() > 80) then return 1 else return 0 end
end
deadremains.character.processFlagFuncs["HYDRATED"] = function(ply)
	local addVal = 1/60	-- 1 hp every 60 seconds.
	local newHp = ply.dr_character.float_hp + addVal

	if (newHp > 100) then
		newHp = 100
	elseif (newHp < 0) then
		newHp = 0
	end

	-- track float value.
	ply.dr_character.float_hp = newHp

	-- floor the tracked float value
	ply:SetHealth(math.floor(ply.dr_character.float_hp))
end


deadremains.character.flagCheckFuncs["FULL"] = function(ply)
	if (ply:getHunger() > 80) then return 1 else return 0 end
end
deadremains.character.processFlagFuncs["FULL"] = function(ply)
	local addVal = 1/60	-- 1 hp every 60 seconds.
	local newHp = ply.dr_character.float_hp + addVal

	if (newHp > 100) then
		newHp = 100
	elseif (newHp < 0) then
		newHp = 0
	end

	-- track float value.
	ply.dr_character.float_hp = newHp

	ply:SetHealth(math.floor(ply.dr_character.float_hp))
end

deadremains.character.processFlagFuncs["BLEEDING"] = function(ply)
	--print("bleeding out")
end