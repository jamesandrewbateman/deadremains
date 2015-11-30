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

	self:DefaultFlags()

	self.dr_character.created = true
	print("Created a new character")
end

function player_meta:DefaultFlags()
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
end


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

function deadremains.character.setBuff(ply, name, val)
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

		deadremains.character.networkFlags(ply)
	end
end

function deadremains.character.setDebuff(ply, name, val)
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

		deadremains.character.networkFlags(ply)
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
				if (IsValid(ply) and (ply.dr_character.created == true)) and ply:Alive() then

					-- process each flag one by one
					for unique, flag in pairs(ply.dr_character.buffs) do

						-- does this buff actually have any code to run/check?
						if (deadremains.character.flagCheckFuncs[unique] ~= nil) then
							flag = tonumber(deadremains.character.flagCheckFuncs[unique](ply))
						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if tonumber(ply:hasBuff(unique)) == 1 then
							deadremains.character.processFlagFuncs[unique](ply)
						end
					end

					for unique, flag in pairs(ply.dr_character.debuffs) do

						-- does this buff actually have any code to run/check?
						if (deadremains.character.flagCheckFuncs[unique] ~= nil) then
							flag = tonumber(deadremains.character.flagCheckFuncs[unique](ply))
						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if tonumber(ply:hasDebuff(unique)) == 1 then
							deadremains.character.processFlagFuncs[unique](ply)
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
deadremains.character.flagCheckFuncs["HYDRATED"] = function(ply)
	if (ply:getThirst() > 80) then return 1 else return 0 end
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



-- Full --

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



-- Bleeding --

deadremains.character.startFlagFuncs["BLEEDING"] = function (ply)
	ply:SetWalkSpeed(0)
	ply:SetRunSpeed(200)
end

deadremains.character.processFlagFuncs["BLEEDING"] = function(pl)
	local addVal = 2	-- 1 hp every 60 seconds.
	local newHp = pl.dr_character.float_hp - addVal

	if (newHp <= 1) then
		pl:Kill()
	end

	-- track float value.
	pl.dr_character.float_hp = newHp

	pl:SetHealth(math.floor(pl.dr_character.float_hp))

	-- jamez + bambo
	if pl:Health() % 4 == 0 then
		local traceb = {}
		traceb.start = pl:GetPos() + pl:GetUp()*20 - pl:GetForward()*20
		traceb.endpos = traceb.start + (Vector(0,0,-1) * 9999)
		traceb.filter = pl
		traceb.mask = MASK_NPCWORLDSTATIC
		local trb = util.TraceLine(traceb)
		local tb1 = trb.HitPos + trb.HitNormal
		local tb2 = trb.HitPos - trb.HitNormal
		util.Decal("Blood", tb1, tb2)
	end
end

deadremains.character.finishFlagFuncs["BLEEDING"] = function(ply)
	ply:SetWalkSpeed(230)
	ply:SetRunSpeed(330)
	ply:SetJumpPower( 200 )
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