require("middleclass")

-- baseclass --
local FEffect = middleclass('FEffect')

function FEffect:initialize( ) end

function FEffect:OnStart( ply ) end

function FEffect:CheckEnable( ply ) end

function FEffect:OnTick( ply ) end

function FEffect:OnEnd( ply ) end

-- Bandit / Hero system --
local FEffect_Bandit = middleclass('FEffect_Bandit', FEffect)

function FEffect_Bandit:initialize( )

	FEffect.initialize( self )

end

function FEffect_Bandit:OnStart( ply )

	ply:SetModel("models/player/gasmask.mdl")

end

hook.Add("PlayerDeath", "drPlayerDeath", function(victim, inflictor, attacker)

	if IsValid(attacker) and victim ~= attacker then

		if attacker:IsPlayer() then

			attacker.dr_character.headcount = attacker.dr_character.headcount or {}

			-- another kill to the pool.
			table.insert( attacker.dr_character.headcount, { Victim = victim, Time = CurTime() } )

			-- how many people have we slain in the last 30 mins? (1800 seconds)
			local nowTime = CurTime()
			local halfHourHeadCount = 0

			for k,v in pairs(attacker.dr_character.headcount) do

				local killTime = v.Time
				local killVictim = v.Victim

				if (nowTime - 1800) <= killTime then

					halfHourHeadCount = halfHourHeadCount + 1

				end

			end

			print(halfHourHeadCount)

			if halfHourHeadCount == 1 then

				deadremains.notifyer.Add(attacker, "You feel numb...", "effect")

			elseif halfHourHeadCount == 2 then

				deadremains.notifyer.Add(attacker, "Unknown voices taunt you...", "effect")

			elseif halfHourHeadCount == 3 then

				deadremains.notifyer.Add(attacker, "Death is only the beginning...", "effect")

			elseif halfHourHeadCount >= 4 then

				deadremains.notifyer.Add(attacker, "Death is only the beginning...", "effect")

			end

		end

	end

end)

function FEffect_Bandit:OnEnd( ply )

	ply:SetModel("models/player/group01/male_03.mdl")

end


-- all effects --
local FEffect_Healthy = middleclass('FEffect_Healthy', FEffect)

function FEffect_Healthy:initialize( )

	FEffect.initialize( self )

end

function FEffect_Healthy:CheckEnable( ply )

	if (ply:Health() > 80) then return 1 else return 0 end

end

function FEffect_Healthy:OnTick( ply )

	if ply:hasDebuff("COLD") == 1 then

		deadremains.character.setDebuff(ply, "COLD", 0)

	end

end


local FEffect_Full = middleclass('FEffect_Full', FEffect)

function FEffect_Full:initialize( )

	FEffect.initialize( self )

end

function FEffect_Full:CheckEnable( ply )

	if (ply:getHunger() > 80) then

		return 1

	else

		return 0 

	end

end

function FEffect_Full:OnTick( ply )

	ply:SetHealth( ply:Health() + ply.dr_character.elapsed_minutes )

end



local FEffect_Hydrated = middleclass('FEffect_Hydrated', FEffect)

function FEffect_Hydrated:initialize( )

	FEffect.initialize( self )

end

function FEffect_Hydrated:CheckEnable( ply )

	if (ply:getThirst() > 80) then

		return 1

	else

		return 0 

	end

end

function FEffect_Hydrated:OnTick( ply )

	ply:SetHealth( ply:Health() + ply.dr_character.elapsed_minutes )

end



local FEffect_Dehydrated = middleclass('FEffect_Dehydrated', FEffect)

function FEffect_Dehydrated:initialize( )

	FEffect.initialize( self )

end

function FEffect_Dehydrated:OnStart( ply )

	ply:SetWalkSpeed(180)

	ply:SetRunSpeed(200)

end


function FEffect_Dehydrated:CheckEnable( ply )

	if (ply:getThirst() <= 25) then

		return 1

	else

		return 0 

	end

end

function FEffect_Dehydrated:OnTick( ply )

	ply:SetHealth( ply:Health() - ply.dr_character.elapsed_minutes )

end

function FEffect_Dehydrated:OnEnd( ply )

	ply:SetWalkSpeed(180)

	ply:SetRunSpeed(200)

end



local FEffect_Starvation = middleclass('FEffect_Starvation', FEffect)

function FEffect_Starvation:initialize( )

	FEffect.initialize( self )

end

function FEffect_Starvation:OnStart( ply )

	ply:SetWalkSpeed(180)

	ply:SetRunSpeed(200)

end

function FEffect_Starvation:CheckEnable( ply )

	if (ply:getHunger() < 25) then

		return 1

	else

		return 0 

	end

end

function FEffect_Starvation:OnTick( ply )

	ply:SetHealth( ply:Health() - ply.dr_character.elapsed_minutes )

end

function FEffect_Starvation:OnEnd( ply )

	ply:SetWalkSpeed(180)

	ply:SetRunSpeed(200)

end



local FEffect_Sickness = middleclass('FEffect_Sickness', FEffect)

function FEffect_Sickness:initialize( )

	FEffect.initialize( self )

end

function FEffect_Sickness:OnStart( ply )

	ply:SetWalkSpeed(180)

	ply:SetRunSpeed(200)

end

function FEffect_Sickness:CheckEnable( ply )

	if (ply:Health() < 3) and (ply.dr_character.bleed_time > 120) then

		return 1

	else

		return 0 

	end

end

function FEffect_Sickness:OnTick( ply )

	ply:SetHealth( ply:Health() + ply.dr_character.elapsed_minutes )

end

function FEffect_Sickness:OnEnd( ply )

	ply:SetWalkSpeed(180)

	ply:SetRunSpeed(200)

end



local FEffect_Bleeding = middleclass('FEffect_Bleeding', FEffect)

function FEffect_Bleeding:initialize( )

	FEffect.initialize( self )

end

function FEffect_Bleeding:OnStart( ply )

	ply:SetWalkSpeed(180)

	ply:SetRunSpeed(200)

	ply.dr_character.bleed_time = 0

end

function FEffect_Bleeding:OnTick( ply )

	ply.dr_character.bleed_time = ply.dr_character.bleed_time + 1

	ply:SetHealth(ply:Health() - 1)

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

function FEffect_Bleeding:OnEnd( ply )

	ply:SetWalkSpeed(230)

	ply:SetRunSpeed(330)

	ply:SetJumpPower(200)

	ply.dr_character.bleed_time = 0

end

local FEffectsList = {}
FEffectsList["HEALTHY"] = FEffect_Healthy:new()
FEffectsList["BLEEDING"] = FEffect_Bleeding:new()
FEffectsList["FULL"] = FEffect_Full:new()
FEffectsList["HYDRATED"] = FEffect_Hydrated:new()
FEffectsList["STARVATION"] = FEffect_Starvation:new()
FEffectsList["SICKNESS"] = FEffect_Sickness:new()
FEffectsList["DEHYDRATION"] = FEffect_Dehydrated:new()

function deadremains.character.FEffectExists(pFlagName)

	if FEffectsList[pFlagName] == nil then

		return false

	else

		return true

	end

end

function deadremains.character.GetFEffect(pFlagName)

	if deadremains.character.FEffectExists(pFlagName) then

		return FEffectsList[pFlagName]

	end

end


function deadremains.character.GetEnableFlag(pPlayer, pFlagName)

	if FEffectsList[pFlagName] ~= nil then

		return tonumber( FEffectsList[pFlagName]:CheckEnable(pPlayer) )

	end

end

function deadremains.character.startFlagsChecker()

	-- looper to apply these to all players online.
	timer.Create("deadremains.buffschecker", 1, 0, function()

		for k,ply in pairs(player.GetAll()) do

			if (ply.dr_character) then

				if (IsValid(ply) and (ply.dr_character.created == true)) then

					ply.dr_character.elapsed_minutes = ply.dr_character.elapsed_minutes + (1/60)

					-- process each flag one by one
					for unique, flag in pairs(ply.dr_character.buffs) do

						local feffect = deadremains.character.GetFEffect(unique)

						-- does this buff actually have any code to run/check?
						if feffect ~= nil then

							local newFlag = feffect:CheckEnable(ply)

							if newFlag ~= flag then

								deadremains.character.setBuff(ply, unique, newFlag)

							end

						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if tonumber(ply:hasBuff(unique)) == 1 then

							if feffect ~= nil then

								feffect:OnTick(ply)

							end

						end

					end

					for unique, flag in pairs(ply.dr_character.debuffs) do

						local feffect = deadremains.character.GetFEffect(unique)

						-- does this buff actually have any code to run/check?
						if (feffect ~= nil) then

							local newFlag = feffect:CheckEnable(ply)

							if newFlag ~= flag then

								deadremains.character.setDebuff(ply, unique, newFlag)

							end

						end

						-- check again incase our flagCheckFunc has returned a 0.
						-- otherwise the flag is preserved.
						if tonumber(ply:hasDebuff(unique)) == 1 then

							if (feffect ~= nil) then

								feffect:OnTick(ply)

							end

						end

					end

					if (ply:Health() > 100) then

						ply:SetHealth(100)

					end

				end

			end

		end

	end)

end
deadremains.character.startFlagsChecker()