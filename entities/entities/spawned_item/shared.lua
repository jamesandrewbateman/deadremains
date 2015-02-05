ENT.Type = "anim"
//ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawned Item"

function ENT:SetupDataTables()
	self:NetworkVar("String", 1, "ItemID")
end