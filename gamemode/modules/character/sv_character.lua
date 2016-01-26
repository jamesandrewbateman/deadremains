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

		timer.Simple(1, function()
			ply:AddInventory("hunting_backpack", 9, 9)
			ply:AddItemToInventory("hunting_backpack", "bandage")
			ply:AddItemToInventory("hunting_backpack", "fizzy_drink")
			ply:AddItemToInventory("hunting_backpack", "tfm_blunt_shovel")
		end)

	end)

	ply.dr_loaded = true

	ply:newCharacter("models/player/group01/male_03.mdl", "m")

	ply:SetNWInt("zombie_kill_count", 0)

	ply:ConCommand("deadremains.syncdata")

end)

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

	ply.dr_character.elapsed_minutes = 0

	deadremains.character.resetFlags(ply)

	ply:setNeed("Thirst", 100)
	ply:setNeed("Hunger", 100)

	if (timer.Exists("player_check_details" .. ply:UniqueID())) then

		timer.Remove("player_check_details" .. ply:UniqueID())

	end

	timer.Create("player_check_details" .. ply:UniqueID(), 1.5, 0, function()

		if (ply:getNeed("Thirst") < 0) then ply:setNeed("Thirst", 0) end
		if (ply:getNeed("Hunger") < 0) then ply:setNeed("Hunger", 0) end

		if (ply:getNeed("Thirst") > 100) then ply:setNeed("Thirst", 100) end
		if (ply:getNeed("Hunger") > 100) then ply:setNeed("Hunger", 100) end

		if (ply:Health() <= 0) and (ply:Alive()) then ply:Kill() end

		--ply:ConCommand("deadremains.syncdata")

	end)


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

		local previous_value = ply.dr_character.buffs[name]

		ply.dr_character.buffs[name] = val

		if tonumber(val) == 0 then

			local feffect = deadremains.character.GetFEffect(name)

			if (feffect ~= nil) then

				feffect:OnEnd(ply)

			end

		else

			local feffect = deadremains.character.GetFEffect(name)

			if (feffect ~= nil) then

				feffect:OnStart(ply)

			end

		end			

		if not (disableNetwork == 1) then

			if val ~= previous_value then

				deadremains.character.networkFlags(ply)

			end

		end

	end

end

function deadremains.character.setDebuff(ply, name, val, disableNetwork)

	if (ply.dr_character.created) then

		local previous_value = ply.dr_character.buffs[name]

		ply.dr_character.debuffs[name] = val

		if tonumber(val) == 0 then

			local feffect = deadremains.character.GetFEffect(name)

			if (feffect ~= nil) then

				feffect:OnEnd(ply)

			end

		else

			local feffect = deadremains.character.GetFEffect(name)

			if (feffect ~= nil) then

				feffect:OnStart(ply)

			end

		end		

		if not (disableNetwork == 1) then

			if val ~= previous_value then

				deadremains.character.networkFlags(ply)

			end

		end

	end

end

function deadremains.character.networkFlags(ply)

	print("Sending buffs and debuffs")

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


hook.Add("EntityTakeDamage", "BloodDamageCheck", function(ent, dmginfo)
	if ent:IsPlayer() then

		local amount = dmginfo:GetDamage() --jamez
		local BleedRandomize = math.random(0,17)

		--if dmginfo:IsFallDamage() then
		if (amount >= 25 or BleedRandomize <= 4) and ent:Health() < 70 then

			deadremains.character.setDebuff(ent, "BLEEDING", 1)

			ent.DropBlood = CurTime() + 2.5
			ent.BloodyTrail = CurTime() + 1
			ent.LimpEffect = CurTime() + 0.7

			ent:SetNWInt("BRedFade", 0.7)
			ent:SetNWInt("BColorFade", 0.3)

		end

	end
end)