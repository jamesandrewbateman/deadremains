----------------------------------------------------------------------
-- Purpose:
-- Get craftable items.
----------------------------------------------------------------------

function deadremains.crafting.getCraftables(pCraftingTableEnt)
	local craftable_items = {}

	for craftable_name, required_items in pairs(deadremains.crafting.recipes) do
		craftable_items[craftable_name] = 100

		for item_name, required_item_count in pairs(required_items) do
			if type(required_item_count) == "table" then
				
				local recipe_item_found = false

				-- ANY of the items in this table.
				for recipe_item_name, recipe_item_quantity in pairs(required_item_count) do

					if not recipe_item_found then
						
						local item_count = pCraftingTableEnt:GetItemCount( recipe_item_name )
						local craft_count = math.floor(item_count / recipe_item_quantity) or 0

						if item_count >= recipe_item_quantity then

							if craft_count < craftable_items[craftable_name] then
								craftable_items[craftable_name] = craft_count

								recipe_item_found = true
							end

						else

							craftable_items[craftable_name] = 0

						end

					end
				end

			elseif tostring(item_name) ~= "entry_count" then

				local item_count = pCraftingTableEnt:GetItemCount(item_name)
				local craft_count = math.floor(item_count / required_item_count) or 0

				if item_count >= required_item_count then

					if craft_count < craftable_items[craftable_name] then
						craftable_items[craftable_name] = craft_count
					end

				else

					craftable_items[craftable_name] = 0

				end

			end
		end
	end

	for k,v in pairs(craftable_items) do
		if v == 0 then
			craftable_items[k] = nil
		end
	end

	return craftable_items
end

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