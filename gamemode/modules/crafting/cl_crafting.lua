function deadremains.crafting.getCraftables(pItemName)
	PrintTable(LocalPlayer().Inventories)
end

concommand.Add("cl_getCraftables", function(ply)
	deadremains.crafting.getCraftables("bandage")
end)