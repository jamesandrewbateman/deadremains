ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = "Bambo"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "NetworkName")
end