AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

function ENT:Think()
--	if (self.itemData and self.itemData.Think) then
--		self.itemData:Think(self)
	--end
end

function ENT:Use(player)
	--if (self.itemData and self.itemData.WorldUse) then
	--	self.itemData:WorldUse(player, self)
	--end
end

function ENT:StartTouch(entity)
	--if (self.itemData and self.itemData.StartTouch) then
	--	self.itemData:StartTouch(self, entity)
	--end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end