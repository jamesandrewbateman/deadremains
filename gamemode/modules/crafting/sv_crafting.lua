function deadremains.crafting.canCraft(pCraftingTableEnt, pItemName)
	local craftable_items = deadremains.crafting.getCraftables(pCraftingTableEnt)

	if (craftable_items ~= nil) then
		return true, craftable_items[pItemName]
	end

	return false, 0
end

-- remove the recipe items from the crafting table.
function deadremains.crafting.craft(pCraftingTableEnt, pItemName)
	-- get the items needed to craft this item.
	local required_items = deadremains.crafting.recipes[pItemName] or {}

	-- by this point the crafting table has been verified to have the items.
	for k,v in pairs(required_items) do
		if tostring(k) ~= "entry_count" and not deadremains.crafting.IsPersisted(pItemName) then
		
			for i=1, v do
				pCraftingTableEnt:RemoveItem(k)
			end

		end
	end

	return pItemName
end