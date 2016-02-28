AddCSLuaFile()

ENT.Base = "base_nextbot"

function ENT:Initialize()

	local models = {

		"models/nmr_zombie/badass_infected.mdl",
		"models/nmr_zombie/bateman_infected.mdl",
		"models/nmr_zombie/berny.mdl",
		"models/nmr_zombie/butcher_infected.mdl",
		"models/nmr_zombie/casual_02.mdl",
		"models/nmr_zombie/herby.mdl",
		"models/nmr_zombie/hunter_infected.mdl",
		"models/nmr_zombie/jive_infected.mdl",
		"models/nmr_zombie/jogger.mdl",
		"models/nmr_zombie/julie.mdl",
		--"models/nmr_zombie/lisa.mdl",
		"models/nmr_zombie/maxx.mdl",
		"models/nmr_zombie/molotov_infected.mdl",
		"models/nmr_zombie/national_guard.mdl",
		"models/nmr_zombie/officezom.mdl",
		"models/nmr_zombie/roje_infected.mdl",
		"models/nmr_zombie/wally_infected.mdl",
		--"models/nmr_zombie/zombiekid_boy.mdl",
		--"models/nmr_zombie/zombiekid_girl.mdl"
	}

	if SERVER then self:SetModel( models[math.random( 1, #models ) ] ) end

	self:SetHealth( 100 )
	self:SetCollisionBounds( Vector( - 16, - 16, 0 ), Vector( 16, 16, 70 ) )

	self.ChaseSpeed = math.random( 150, 200 )
	self.WanderSpeed = math.random( 20, 50 )

	self.LoseTargetDist	= 2000
	self.SearchRadius 	= 650

	self.InAttack = false
	self.LastPush = CurTime()

end

function ENT:RunBehaviour()

	while ( true ) do

		if self:HaveEnemy() then

			if self:EnemyInRange( 50 ) && self:HaveEnemy() then
				if math.random( 1, 10 ) < 9 then
					self:Attack()
				else
					self:Choke()
				end
			end

			local chase = self:ChaseEnemy()

			if chase == "ok" || chase == "failed" then
				self:FindEnemy()
			end

		else

			if math.random( 1, 100 ) >= 60 then

				local speed = self.WanderSpeed

				self.loco:SetDesiredSpeed( speed )
				local navs = navmesh.Find( self:GetPos(), 1000, 120, 120 )
				local nav = navs[ math.random( 1, #navs ) ]
				local pos = nav:GetRandomPoint()

				if math.random( 1, 2 ) <= 1 then self.loco:SetDesiredSpeed( speed / 2 ) self.InCrawl = true self.loco:SetMaxYawRate( 125 ) end

				self:Wander( pos, { tolerance = 30, lookahead = 10, repath = 5, maxage = 30 } )

				if self.InCrawl then self.InCrawl = false self.loco:SetMaxYawRate( 250 ) end

			else

				self:Idle( math.random( 5, 30) )

			end

		end

	end


end

function ENT:Idle( duration )

	self:StartActivity( ACT_IDLE )

	for i = 0, duration do
		coroutine.wait( 1 )
		if self:HaveEnemy() then break end
	end

end

function ENT:Wander( pos, options )

	options = options || {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead || 10 )
	path:SetGoalTolerance( options.tolerance || 20 )
	path:Compute( self, pos )

	local check = 1

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )

		if ( GetConVar( "drt_debug" ):GetBool() ) then

			path:Draw()

		end

		if ( path:GetAge() > 0.75 * check ) then
			if self:HaveEnemy() then
				return "ok"
			end
			check = check + 1
		end


		if ( self.loco:IsStuck() ) then

			self:HandleStuck();

			return "stuck"

		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then
				path:Compute( self, pos )
				check = 1
			end
		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:ChaseEnemy( options )

	if !self:HaveEnemy() then return "failed" end

	options = options || {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead || 300 )
	path:SetGoalTolerance( options.tolerance || 10 )
	path:Compute( self, self:GetEnemy():GetPos() )

	if ( !path:IsValid() ) then return "failed" end

	self.loco:SetDesiredSpeed( self.ChaseSpeed )
	self.loco:SetMaxYawRate( 250 )

	self.InAttack = false

	while ( path:IsValid() && self:HaveEnemy() && !self:EnemyInRange( 45 ) && path:GetLength() < self.LoseTargetDist * 2 ) do

		if ( path:GetAge() > 0.1 ) then
			path:Compute( self, self:GetEnemy():GetPos() )
		end
		path:Update( self )

		if ( GetConVar( "drt_debug" ):GetBool() ) then path:Draw() end

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		if self.loco:GetVelocity():Length() < 10 then
			self:ApplyRandomPush()
		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:Attack()

	self.loco:SetMaxYawRate( 1000 )

	for i = 1, 100 do self.loco:FaceTowards( self:GetEnemy():GetPos() ) end

	self.InAttack = true

	local rng = math.random( 1, 3 )
	local attack

	if rng == 1 then
		attack = "attackA"
	elseif rng == 2 then
		attack = "attackB"
	elseif rng == 3 then
		attack = "attackC"
	end

	local _, dur = self:LookupSequence( attack )

	timer.Simple( dur / 3, function()
		if self:EnemyInRange( 60 ) then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage( 10 )
			dmginfo:SetAttacker( self )
			dmginfo:SetDamageType( DMG_SLASH )

			self:GetEnemy():TakeDamageInfo( dmginfo )

			local blood = ents.Create("env_blood")
			blood:SetKeyValue("targetname", "carlbloodfx")
			blood:SetKeyValue("parentname", "prop_ragdoll")
			blood:SetKeyValue("spawnflags", 8)
			blood:SetKeyValue("spraydir", math.random(500) .. " " .. math.random(500) .. " " .. math.random(500))
			blood:SetKeyValue("amount", 250.0)
			blood:SetCollisionGroup( COLLISION_GROUP_WORLD )
			blood:SetPos( self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() + Vector( 0, 0, 10 ) )
			blood:Spawn()
			blood:Fire("EmitBlood")
		end
	end )

	local enemy = self:GetEnemy()

	local plyWSpd = enemy:GetWalkSpeed()
	local plyRSpd = enemy:GetRunSpeed()

	enemy:SetWalkSpeed( plyWSpd / 3 )
	enemy:SetRunSpeed( plyRSpd / 3 )

	--failsafe
	timer.Simple( 1.1,function()
		enemy:SetWalkSpeed( plyWSpd )
		enemy:SetRunSpeed( plyRSpd )
	end)

	self:PlayAttackAndWait( attack, 1.1 )

	enemy:SetWalkSpeed( plyWSpd )
	enemy:SetRunSpeed( plyRSpd )

	self.loco:SetMaxYawRate( 250 )
	self.InAttack = false

end

function ENT:PlayAttackAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed || 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed  );

	local endtime = CurTime() + len / speed

	while ( true ) do

		if ( endtime < CurTime() || ( self:HaveEnemy() && !self:EnemyInRange(60) && ( ( endtime - CurTime() ) > len / 3 ) ) ) then
			self:StartActivity( ACT_RUN )
			return
		end
		if self:HaveEnemy() && self:EnemyInRange(60) then
			self.loco:SetDesiredSpeed( 30 )
			self.loco:Approach( self:GetEnemy():GetPos(), 10 )
		end

		coroutine.yield()

	end

end

function ENT:Choke()

	local _, dur1 = self:LookupSequence( "Enter_Choke" )
	local _, dur2 = self:LookupSequence( "Choke_Eat" )

	local dur = dur1 + dur2

	self.loco:SetMaxYawRate( 1000 )

	for i = 1, 200 do self.loco:FaceTowards( self:GetEnemy():GetPos() ) end

	self:PlaySequenceAndWait( "Enter_Choke" )

	local tr = util.TraceLine( { start = self:GetShootPos(), endpos = self:GetShootPos() + self:GetAimVector() * 50, filter = self } )

	if tr.Hit && tr.Entity:IsPlayer() then

		self:GetEnemy():AddFlags( FL_ATCONTROLS )

		timer.Create( self:EntIndex() .. ".choke", dur / 4, 4, function()

			if !self:HasEnemy() then timer.Remove( self:EntIndex() .. ".choke" ) return end

			local dmginfo = DamageInfo()
			dmginfo:SetDamage( 5 )
			dmginfo:SetAttacker( self )
			dmginfo:SetDamageType( DMG_SLASH )

			self:GetEnemy():TakeDamageInfo( dmginfo )

			local blood = ents.Create("env_blood")
			blood:SetKeyValue("targetname", "carlbloodfx")
			blood:SetKeyValue("parentname", "prop_ragdoll")
			blood:SetKeyValue("spawnflags", 8)
			blood:SetKeyValue("spraydir", math.random(500) .. " " .. math.random(500) .. " " .. math.random(500))
			blood:SetKeyValue("amount", 250.0)
			blood:SetCollisionGroup( COLLISION_GROUP_WORLD )
			blood:SetPos( self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() + Vector( 0, 0, 10 ) )
			blood:Spawn()
			blood:Fire("EmitBlood")

		end )

		self:PlaySequenceAndWait( "Choke_Eat" )

	else

		self:PlaySequenceAndWait( "Choke_Miss" )

	end

	self.loco:SetMaxYawRate( 250 )

	if self:GetEnemy():IsFlagSet( FL_ATCONTROLS ) then self:GetEnemy():RemoveFlags( FL_ATCONTROLS ) end

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if self.InAttack then self:FrameAdvance() return end

	if ( len2d > 50 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 10 ) then self.CalcIdeal = ACT_WALK end

	if self.InCrawl then self.CalcIdeal = self:GetSequenceActivity( self:LookupSequence( "crawl" ) ) end

	if self:GetActivity() != self.CalcIdeal then self:StartActivity( self.CalcIdeal ) end

	if ( self.CalcIdeal == ACT_RUN || self.CalcIdeal == ACT_WALK ) then

		self:BodyMoveXY()

	end

	self:FrameAdvance()

end

function ENT:SetEnemy( ent )

	self.Enemy = ent

end

function ENT:GetEnemy()

	return self.Enemy

end

function ENT:HasEnemy()

	return IsValid( self.Enemy )

end

function ENT:IsEnemy( ent )

	if ent == self:GetEnemy() then
		return true
	else
		return false
	end

end

function ENT:HaveEnemy()

	if ( self:GetEnemy() && IsValid( self:GetEnemy() ) ) then
		if ( self:GetEnemy():IsPlayer() && !self:GetEnemy():Alive() ) then
			return self:FindEnemy()
		elseif ( self:GetRangeTo( self:GetEnemy():GetPos() ) > self.LoseTargetDist ) then
			return self:FindEnemy()
		end
		return true
	else
		return self:FindEnemy()
	end

end

function ENT:EnemyInRange( dist )
	if !self:GetEnemy() then return false end
	return self:GetEnemy():GetPos():Distance(self:GetPos()) <= dist
end

function ENT:FindEnemy()

	if ( GetConVar( "drt_debug" ):GetBool() ) then

		local x1 = self:GetAimVector().x
		local y1 = self:GetAimVector().y

		local x = math.cos( 70 ) * x1 - y1 * math.sin( 70 )
		local y = math.sin( 70 ) * x1 + y1 * math.cos( 70 )

		local v1 = Vector( x, y, 0 )

		debugoverlay.Line( self:GetShootPos(), self:GetShootPos() + self:GetAimVector() * self.SearchRadius , 0.05, Color( 255, 0, 0 ) )

		debugoverlay.Line( self:GetShootPos(), self:GetShootPos() + v1 * self.SearchRadius , 0.3, Color( 255, 0, 0 ) )

		x = math.cos( - 70 ) * x1 - y1 * math.sin( - 70 )
		y = math.sin( - 70 ) * x1 + y1 * math.cos( - 70 )

		v1 = Vector( x, y, 0 )

		debugoverlay.Line( self:GetShootPos(), self:GetShootPos() + v1 * self.SearchRadius , 0.3, Color( 255, 0, 0 ) )

		debugoverlay.Sphere( self:GetShootPos(), 200, 0.05, Color( 255, 0, 0, 150 ) )

		debugoverlay.Axis( self:GetShootPos(), self:GetAimVector():Angle(), 5, 0.3, true )

	end

	local players = player.GetAll()

	for k, ply in pairs( players ) do
		local plyPos = ply:GetPos()

		local selfPos = self:GetPos()

		if ( math.abs( selfPos.z - plyPos.z ) ) < self.SearchRadius / 2 then

			plyPos.z = 0
			selfPos.z = 0

			if ( plyPos:Distance( selfPos ) <= 200 ) then
				self:SetEnemy( ply )
				return true
			end

			local x1 = self:GetAimVector().x
			local y1 = self:GetAimVector().y

			local x = math.cos( 70 ) * x1 - y1 * math.sin( 70 )
			local y = math.sin( 70 ) * x1 + y1 * math.cos( 70 )

			local c = selfPos + Vector( x, y, 0 ) * self.SearchRadius

			x = math.cos( - 70 ) * x1 - y1 * math.sin( - 70 )
			y = math.sin( - 70 ) * x1 + y1 * math.cos( - 70 )

			local b = selfPos + Vector( x, y, 0 ) * self.SearchRadius

			local v0 = c - selfPos
			local v1 = b - selfPos
			local v2 = plyPos - selfPos

			-- Compute dot products
			local dot00 = v0:Dot(v0)
			local dot01 = v0:Dot(v1)
			local dot02 = v0:Dot(v2)
			local dot11 = v1:Dot(v1)
			local dot12 = v1:Dot(v2)

			-- Compute barycentric coordinates
			local invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
			local u = (dot11 * dot02 - dot01 * dot12) * invDenom
			local v = (dot00 * dot12 - dot01 * dot02) * invDenom

			-- Check if point is in triangle
			if (u >= 0) && (v >= 0) && (u + v < 1) then
				self:SetEnemy( ply )
				return true
			end
		end

	end

	/*local _ents = ents.FindInCone( self:GetShootPos(), self:GetAimVector(), self.SearchRadius, 140 )

	for k, v in pairs( _ents ) do
		if ( v:IsPlayer() ) then
			self:SetEnemy( v )
			return true
		end
	end

	_ents = ents.FindInSphere( self:GetPos(), 200 )

	for k, v in pairs( _ents ) do
		if ( v:IsPlayer() ) then
			self:SetEnemy( v )
			return true
		end
	end*/

	self:SetEnemy( nil )
	return false
end

function ENT:GetAimVector()

	return  vec || self:GetForward()

end

function ENT:GetShootPos()

	return self:EyePos()

end

function ENT:OnKilled( dmginfo )

	if timer.Exists( self:EntIndex() .. ".choke" ) then timer.Remove( self:EntIndex() .. ".choke" ) end

	if self:GetEnemy():IsFlagSet( FL_ATCONTROLS ) then self:GetEnemy():RemoveFlags( FL_ATCONTROLS ) end

	self:SetCollisionBounds( Vector( - 16, - 16, 0 ), Vector( 16, 16, 70 ) )

	hook.Run( "OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	self:BecomeRagdoll( dmginfo )

end

function ENT:OnInjured( dmginfo )

	self:SetEnemy( dmginfo:GetAttacker() )

end

function ENT:OnContact( ent )

	if ent:GetClass() == self:GetClass() && !self.InAttack then

		self.loco:Approach( self:GetPos() + Vector( math.Rand( - 1, 1 ), math.Rand( - 1, 1 ), 0 ) * 2000, 1000 )

	end

	if  ( ent:GetClass() == "prop_physics_multiplayer" or ent:GetClass() == "prop_physics" ) then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			local force = -physenv.GetGravity().z * phys:GetMass() / 12 * ent:GetFriction()
			local dir = ent:GetPos() - self:GetPos()
			dir:Normalize()
			phys:ApplyForceCenter( dir * force )
		end
	end
end

function ENT:ApplyRandomPush( power )
	if CurTime() < self.LastPush + 0.2 or !self:IsOnGround() or self.InAttack then return end
	power = power or 100
	local vec =  self.loco:GetVelocity() + VectorRand() * power
	vec.z = math.random( 100 )
	self.loco:SetVelocity( vec )
	self.LastPush = CurTime()
end

list.Set( "NPC", "npc_walkerbase", {
	Name = "Zombie Base",
	Class = "npc_walkerbase",
	Category = "Nextbot"
} )
