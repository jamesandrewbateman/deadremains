ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Tree"
ENT.Category		= "Dead Remains"
ENT.Author			= "Bambo"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 350, "DRValue")
end