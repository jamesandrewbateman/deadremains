AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()

	phys:Wake()
	
end

function ENT:OnTakeDamage(dmg)
	//self:Remove()
end

function ENT:SetData( data )
	//We're only interested in the use function here here
	//Do stuff with the use function here
	self.useFunc = data.useFunc
end

function ENT:Use(activator,caller)
	//Add to inventory
	//For now make it so we do our use func and remove our self
	self.useFunc(activator)
	self:Remove()
end