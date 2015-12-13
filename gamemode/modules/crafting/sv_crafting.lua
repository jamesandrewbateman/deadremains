function deadremains.crafting.canCraft(pItemName)
	local craftable_items = deadremains.crafting.getCraftables()

	if (craftable_items ~= nil) then
		return true, craftable_items[pItemName]
	end

	return false, 0
end

-- remove the recipe items from the crafting table.
function deadremains.crafting.craft(pItemName)
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

--! @brief global network function to send all the required data to the client at runtime.
deadremains.netrequest.create("deadremains.craftitem", function (ply, data)
	local item_name = data.name

	print("crafing", item_name)

	local items = deadremains.crafting.GetCraftableItems(ply)

	PrintTable(items)

	if table.Count(items) > 0 then

		if items[item_name] ~= nil then

			local required_items = deadremains.crafting.recipes[item_name] or {}
			local crafted_item_info = deadremains.crafting.GetItemInfo(item_name)

			for k,v in pairs(required_items) do

				if type(v) == "table" then

					local found_item_name = ""
					local found_item_quant = ""

					for i,j in pairs(v) do

						local this_item_count = deadremains.crafting.GetItemCount( ply, i )

						if this_item_count >= j and found_item_name == "" then

							found_item_name = i
							found_item_quant = j

						end

					end

					print(found_item_name, found_item_quant)

					for n=1, found_item_quant do

						ply:RemoveItemCrafting(k)

					end

				elseif tostring(k) ~= "entry_count" and not deadremains.crafting.IsPersisted(k) then

					for i=1, v do

						ply:RemoveItemCrafting(k)

					end

				end

			end


			for i=1, crafted_item_info.quantity do

				ply:AddItemToInventory("feet", item_name)

			end

			-- pingback
			if (data) then

				return data

			end

		else

			return { canCraft = false }

		end

	else

		return { canCraft = false }

	end
end)