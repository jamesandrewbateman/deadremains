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

util.AddNetworkString("deadremains.getbuffs")
util.AddNetworkString("deadremains.getdebuffs")

function player_meta:newCharacter(model, gender)
	self:SetModel(model)
	self.dr_character.gender = gender

	-- use this as temp storage for players health.
	-- we do this because we run the buffs.etc every second, and
	-- they want actions to happen say (-1 Hp every 60 seconds).
	-- ply:SetHealth() doesn't like ply:Health()+(1/60);

	self.dr_character.float_hp = self:Health()

	-- do not sure set/buff/debuff because that would trigger end/start funcs.
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

	deadremains.character.networkFlags(self)

	print("Created a new character")
end

hook.Add("PlayerInitialSpawn", "deadremains_init_spawn_char", function(ply)
	ply:resetData()

	timer.Simple(1, function()
		ply:loadDataFromMysql()
	end)

	ply.dr_loaded = true

	ply:newCharacter("models/player/group01/male_03.mdl", "m")
	ply.zombie_kill_count = 0
end)

hook.Add("PlayerSpawn", "deadremains_player_spawn_char")

function player_meta:hasBuff(name)
	if (self.dr_character.created) then
		return self.dr_character.buffs[name]
	end
end

function player_meta:hasDebuff(name)
	if (self.dr_character.created) then
		return self.dr_character.debuffs[name]
	end
end




deadremains.character = {}

deadremains.character.startFlagFuncs = {}
-- list of functions with strings as keys and value as 1 or 0
deadremains.character.flagCheckFuncs = {}
-- these are ran if the condition of the buff/debuff is met.
deadremains.character.processFlagFuncs = {}
-- end points.
deadremains.character.finishFlagFuncs = {}

function deadremains.character.resetFlags(ply)
	-- trigger on/off functions too.
	deadremains.character.setDebuff(ply, "COLD", 0, 1)
	deadremains.character.setDebuff(ply, "SICKNESS", 0, 1)
	deadremains.character.setDebuff(ply, "HEART_ATTACK", 0, 1)
	deadremains.character.setDebuff(ply, "UNCONCIOUS", 0, 1)
	deadremains.character.setDebuff(ply, "TIREDNESS", 0, 1)
	deadremains.character.setDebuff(ply, "BANDIT", 0, 1)
	deadremains.character.setDebuff(ply, "DEPRESSION", 0, 1)
	deadremains.character.setDebuff(ply, "PSYCHOSIS", 0, 1)
	deadremains.character.setDebuff(ply, "ZINFECTED_HIT", 0, 1)
	deadremains.character.setDebuff(ply, "ZINFECTED_BLOOD", 0, 1)
	deadremains.character.setDebuff(ply, "DEHYDRATED", 0, 1)
	deadremains.character.setDebuff(ply, "STARVATION", 0, 1)
	deadremains.character.setDebuff(ply, "BLEEDING", 0, 1)
	deadremains.character.setDebuff(ply, "RESTRAINED", 0, 1)

	deadremains.character.setBuff(ply, "HYDRATED", 1, 1)
	deadremains.character.setBuff(ply, "FULL", 1, 1)
	deadremains.character.setBuff(ply, "ZINVISIBLE", 0, 1)
	deadremains.character.setBuff(ply, "BOOST", 0, 1)
	deadremains.character.setBuff(ply, "PAUSE", 0, 1)
	deadremains.character.setBuff(ply, "HEALTHY", 1, 1)
	deadremains.character.setBuff(ply, "ATHLETIC", 0, 1)
	deadremains.character.setBuff(ply, "IRON_MAN", 0, 1)
	deadremains.character.setBuff(ply, "RIPPED", 0, 1)
	deadremains.character.setBuff(ply, "WARM", 0, 1)
	deadremains.character.setBuff(ply, "HERO", 0, 1)

	deadremains.character.networkFlags(ply)
end


util.AddNetworkString("deadremains_refreshinv")
hook.Add("PlayerSpawn", "deadremains_player_spawn_char", function(ply)
	deadremains.character.resetFlags(ply)

	net.Start("deadremains_refreshinv")
	net.Send(ply)
end)


concommand.Add("dr_setflag", function(ply, cmd, args)
	local flagname = args[1]
	local flagval = args[2]

	if (ply.dr_character.buffs[flagname] ~= nil) then
		deadremains.character.setBuff(ply, flagname, flagval)
	elseif (ply.dr_character.debuffs[flagname] ~= nil) then
		deadremains.character.setDebuff(ply, flagname, flagval)
	else
		ply:ChatPrint("Could not set buff/debuff.")
	end

	deadremains.character.networkFlags(ply)
end)

function deadremains.character.setBuff(ply, name, val, disableNetwork)
	if (ply.dr_character.created) then
		ply.dr_character.buffs[name] = val

		if tonumber(val) == 0 then
			if (deadremains.character.finishFlagFuncs[name] ~= nil) then
				deadremains.character.finishFlagFuncs[name](ply)
			end
		else
			if (deadremains.character.startFlagFuncs[name] ~= nil) then
				deadremains.character.startFlagFuncs[name](ply)
			end
		end			

		if not (disableNetwork == 1) then
			deadremains.character.networkFlags(ply)
		end
	end
end

function deadremains.character.setDebuff(ply, name, val, disableNetwork)
	if (ply.dr_character.created) then
		ply.dr_character.debuffs[name] = val

		if tonumber(val) == 0 then
			if (deadremains.character.finishFlagFuncs[name] ~= nil) then
				deadremains.character.finishFlagFuncs[name](ply)
			end
		else
			if (deadremains.character.startFlagFuncs[name] ~= nil) then
				deadremains.character.startFlagFuncs[name](ply)
			end
		end	

		if not (disableNetwork == 1) then
			deadremains.character.networkFlags(ply)
		end
	end
end

function deadremains.character.networkFlags(ply)
	net.Start("deadremains.getbuffs")

		net.WriteUInt(table.Count(ply.dr_character.buffs), 8)

		for k,v in pairs(ply.dr_character.buffs) do
			net.WriteString(k)
			net.WriteUInt(v, 4)
		end

	net.Send(ply)


	net.Start("deadremains.getdebuffs")
	
		net.WriteUInt(table.Count(ply.dr_character.debuffs), 8)

		for k,v in pairs(ply.dr_character.debuffs) do
			net.WriteString(k)
			net.WriteUInt(v, 4)
		end

	net.Send(ply)
end

function deadremains.character.startFlagsChecker()
	-- looper to apply these to all players online.
	timer.Create("deadremains.buffschecker", 1, 0, function()
		for k,ply in pairs(player.GetAll()) do
			if (ply.dr_character) then
				if (IsValid(ply) and (ply.dr_character.created == true)) then

					-- process each flag one by one
					for unique, flag in pairs(ply.dr_character.buffs) do

						-- does this buff actually have any code to run/check?
						if (deadremains.character.flagCheckFuncs[unique] ~= nil) then
							local newFlag = tonumber(deadremains.character.flagCheckFuncs[unique](ply))

							if newFlag ~= flag then
								deadremains.character.setBuff(ply, unique, newFlag)
							end
						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if tonumber(ply:hasBuff(unique)) == 1 then
							if (deadremains.character.processFlagFuncs[unique] ~= nil) then
								deadremains.character.processFlagFuncs[unique](ply)
							end
						end
					end

					for unique, flag in pairs(ply.dr_character.debuffs) do

						-- does this buff actually have any code to run/check?
						if (deadremains.character.flagCheckFuncs[unique] ~= nil) then
							local newFlag = tonumber(deadremains.character.flagCheckFuncs[unique](ply))

							if newFlag ~= flag then
								deadremains.character.setDebuff(ply, unique, newFlag)
							end
						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if tonumber(ply:hasDebuff(unique)) == 1 then
							if (deadremains.character.processFlagFuncs[unique] ~= nil) then
								deadremains.character.processFlagFuncs[unique](ply)
							end
						end
					end
				end
			end
		end
	end)
end
deadremains.character.startFlagsChecker()


-- Hydrated --
-- ran every second if enabled.
deadremains.character.startFlagFuncs["HYDRATED"] = function(ply)
	ply:ChatPrint("You are hydrated!")
end
deadremains.character.flagCheckFuncs["HYDRATED"] = function(ply)
	if (ply:getThirst() > 80) then
		return 1
	else
		return 0
	end
end
deadremains.character.processFlagFuncs["HYDRATED"] = function(ply)
	local addVal = 1/60	-- 1 hp every 60 seconds.
	local newHp = ply.dr_character.float_hp + addVal

	if (newHp > 100) then
		newHp = 100
	end

	-- track float value.
	ply.dr_character.float_hp = newHp

	-- floor the tracked float value
	ply:SetHealth(math.floor(ply.dr_character.float_hp))
end
deadremains.character.finishFlagFuncs["HYDRATED"] = function(ply)
	ply:ChatPrint("You are not hydrated...")
end

-- Dehydrated --

deadremains.character.startFlagFuncs["DEHYDRATED"] = function (ply)
	ply:ChatPrint("You are dehydrated!")
	ply:SetWalkSpeed(180)
	ply:SetRunSpeed(200)
end
deadremains.character.flagCheckFuncs["DEHYDRATED"] = function(ply)
	if (ply:getThirst() < 25) then
		return 1
	else
		return 0
	end
end
deadremains.character.finishFlagFuncs["DEHYDRATED"] = function(ply)
	ply:ChatPrint("You are not dehydrated anymore...")
	ply:SetWalkSpeed(180)	-- change these
	ply:SetRunSpeed(200)	-- change these
end 



-- Full --
deadremains.character.startFlagFuncs["FULL"] = function(ply)
	ply:ChatPrint("You are full!")
end
deadremains.character.flagCheckFuncs["FULL"] = function(ply)
	if (ply:getHunger() > 80) then return 1 else return 0 end
end
deadremains.character.processFlagFuncs["FULL"] = function(ply)
	local addVal = 1/60	-- 1 hp every 60 seconds.
	local newHp = ply.dr_character.float_hp + addVal

	if (newHp > 100) then
		newHp = 100
	end

	-- track float value.
	ply.dr_character.float_hp = newHp

	ply:SetHealth(math.floor(ply.dr_character.float_hp))
end
deadremains.character.finishFlagFuncs["FULL"] = function(ply)
	ply:ChatPrint("You are not full...")
end

-- STARVATION
deadremains.character.startFlagFuncs["STARVATION"] = function(ply)
	ply:ChatPrint("You are starving!")
	ply:SetWalkSpeed(180)
	ply:SetRunSpeed(200)
end
deadremains.character.flagCheckFuncs["STARVATION"] = function(ply)
	if (ply:getHunger() < 25) then return 1 else return 0 end
end
deadremains.character.finishFlagFuncs["STARVATION"] = function(ply)
	ply:ChatPrint("You are not starving...")
	ply:SetWalkSpeed(180)
	ply:SetRunSpeed(200)
end




-- Healthy --
deadremains.character.startFlagFuncs["HEALTHY"] = function(ply)
	ply:ChatPrint("You are healthy!")
end
deadremains.character.flagCheckFuncs["HEALTHY"] = function(ply)
	if (ply:Health() > 80) then return 1 else return 0 end
end
deadremains.character.processFlagFuncs["HEALTHY"] = function(ply)
	if (ply:hasDebuff("COLD")) then
		deadremains.character.setDebuff(ply, "COLD", 0)
	end
end
deadremains.character.finishFlagFuncs["HEALTHY"] = function(ply)
	ply:ChatPrint("You are not healthy...")
end

-- Sickness --
deadremains.character.startFlagFuncs["SICKNESS"] = function(ply)
	ply:ChatPrint("You are sick brah!")
	ply:SetWalkSpeed(180)
	ply:SetRunSpeed(200)
end
deadremains.character.flagCheckFuncs["SICKNESS"] = function(ply)
	if (ply:Health() < 30 and ply.dr_character.bleed_time > 120) then return 1 else return 0 end
end
deadremains.character.finishFlagFuncs["SICKNESS"] = function(ply)
	ply:ChatPrint("You are not sick... brah.")
	ply:SetWalkSpeed(180)
	ply:SetRunSpeed(200)
end


-- Bleeding --

deadremains.character.startFlagFuncs["BLEEDING"] = function (ply)
	ply:ChatPrint("You are bleeding out!")
	ply:SetWalkSpeed(180)
	ply:SetRunSpeed(200)
	ply.dr_character.bleed_time = 0
end
deadremains.character.processFlagFuncs["BLEEDING"] = function(ply)
	ply.dr_character.bleed_time = ply.dr_character.bleed_time + 1

	local addVal = 1	-- 1 hp every 60 seconds.
	local newHp = ply.dr_character.float_hp - addVal

	-- track float value.
	ply.dr_character.float_hp = newHp

	ply:SetHealth(math.floor(ply.dr_character.float_hp))

	-- jamez + bambo
	-- spawn a decal every multiple of 4 of HP.
	if ply:Health() % 2 == 0 then
		local traceb = {}
		traceb.start = ply:GetPos() + ply:GetUp()*20 - ply:GetForward()*20
		traceb.endpos = traceb.start + (Vector(0,0,-1) * 9999)
		traceb.filter = ply
		traceb.mask = MASK_NPCWORLDSTATIC
		local trb = util.TraceLine(traceb)
		local tb1 = trb.HitPos + trb.HitNormal
		local tb2 = trb.HitPos - trb.HitNormal
		util.Decal("Blood", tb1, tb2)
	end
end
deadremains.character.finishFlagFuncs["BLEEDING"] = function(ply)
	ply:ChatPrint("You have stopped bleeding...")
	ply:SetWalkSpeed(230)
	ply:SetRunSpeed(330)
	ply:SetJumpPower( 200 )
	ply.dr_character.bleed_time = 0
end
hook.Add("EntityTakeDamage", "BloodDamageCheck", function(ent, dmgInfo)
	local amount = dmginfo:GetDamage() --jamez
	local BleedRandomize = 4--math.random(0,17)

	if ent:IsPlayer() then
		--if dmginfo:IsFallDamage() then
		if amount >= 25 or BleedRandomize == 4 then
			deadremains.character.setBuff(ent, "BLEEDING", 1)

			ent.DropBlood = CurTime() + 2.5
			ent.BloodyTrail = CurTime() + 1
			ent.LimpEffect = CurTime() + 0.7

			ent:SetNWInt("BRedFade", 0.7)
			ent:SetNWInt("BColorFade", 0.3)
		end
	end
end)