//Meta
local entityMeta = FindMetaTable("Entity")

function entityMeta:IsItem()
	if self.GetItemID != nil then return true end
	
	return false
end