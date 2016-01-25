deadremains.crafting = {}
deadremains.crafting.recipes = {}
deadremains.crafting.chars = {}

-- consumables
deadremains.crafting.recipes["bandage"] = {
	cloth = 2,
	string = 1,
	entry_count = 2
}
deadremains.crafting.recipes["filled_water_bottle"] = {
	water_bottle = 1,
	water = 1,
	entry_count = 2
}
deadremains.crafting.consumables = {}
deadremains.crafting.consumables["bandage"] = { name = "Bandage", quantity = 1 }
deadremains.crafting.consumables["filled_water_bottle"] = { name = "Filled Water Bottle", quantity = 1 }




-- crafting items
deadremains.crafting.recipes["crafted_feather"] = {
	dead_bird = 1,
	entry_count = 1
}
deadremains.crafting.craftingitems = {}
deadremains.crafting.craftingitems["crafted_feather"] = { name = "Crafted Feather", quantity = 1 }





-- weapons
deadremains.crafting.recipes["tfa_dr_bow"] = {
	stick = 1,
	{ string = 1, crafted_string = 1 },
	entry_count = 2
}
deadremains.crafting.recipes["tfm_sharp_trpaxe"] = {
	stick = 1,
	scrap_metal = 1,
	{ string = 1, crafted_string = 1},
	entry_count = 3
}
deadremains.crafting.recipes["tfm_sharp_screwdriver"] = {
	stick = 1,
	scrap_metal = 1,
	entry_count = 2
}
deadremains.crafting.recipes["tfm_blunt_shovel"] = {
	stick = 1,
	scrap_metal = 2,
	entry_count = 2
}
deadremains.crafting.recipes["tfm_sword_knight_longsword"] = {
	scrap_metal = 4,
	plank = 2,
	cloth = 2,
	metal_pipe = 2,
	rusty_bolt = 2,
	entry_count = 5
}
deadremains.crafting.recipes["tfm_sword_snowflake_katana"] = {
	scrap_metal = 4,
	plank = 2,
	cloth = 2,
	metal_pipe = 2,
	rusty_bolt = 2,
	entry_count = 5	
}

-- ammo
deadremains.crafting.recipes["tfbow_arrow"] = {
	{string = 1, crafted_string = 1 },
	stick = 1,
	{ feather = 1, created_feather = 1},
	entry_count = 3
}

deadremains.crafting.weapons = {}
deadremains.crafting.weapons["tfa_dr_bow"] = { name = "Bow", quantity = 1 }
deadremains.crafting.weapons["tfm_sharp_trpaxe"] = { name = "Wood Axe", quantity = 1 }
deadremains.crafting.weapons["tfm_sharp_screwdriver"] = { name = "Screwdriver", quantity = 1 }
deadremains.crafting.weapons["tfm_blunt_shovel"] = { name = "Shovel", quantity = 1 }
deadremains.crafting.weapons["tfm_sword_knight_longsword"] = { name = "Longsword", quantity = 1 }
deadremains.crafting.weapons["tfm_sword_snowflake_katana"] = { name = "Katana", quantity = 1 }
deadremains.crafting.weapons["tfbow_arrow"] = { name = "Arrow", quantity = 5 }





function deadremains.crafting.GetRecipeCategory(cat_name)

	local return_tbl = {}

	for k,v in pairs(deadremains.crafting.recipes) do

		local iteminfo = deadremains.crafting.GetItemInfo(k)

		if (iteminfo.category == cat_name) then

			table.insert(return_tbl, iteminfo)

		end

	end

	return return_tbl

end

function deadremains.crafting.GetItemInfo(item_name)

	local return_tbl = {}

	if deadremains.crafting.weapons[item_name] ~= nil then

		return_tbl.category = "weapons"
		return_tbl.item_name = item_name
		return_tbl.required_mats = deadremains.crafting.recipes[item_name]
		return_tbl.print_name = deadremains.crafting.weapons[item_name].name
		return_tbl.quantity = deadremains.crafting.weapons[item_name].quantity

	elseif deadremains.crafting.craftingitems[item_name] ~= nil then

		return_tbl.category = "craftingitems"
		return_tbl.item_name = item_name
		return_tbl.required_mats = deadremains.crafting.recipes[item_name]
		return_tbl.print_name = deadremains.crafting.craftingitems[item_name].name
		return_tbl.quantity = deadremains.crafting.craftingitems[item_name].quantity

	elseif deadremains.crafting.consumables[item_name] ~= nil then

		return_tbl.category = "consumables"
		return_tbl.item_name = item_name
		return_tbl.required_mats = deadremains.crafting.recipes[item_name]
		return_tbl.print_name = deadremains.crafting.consumables[item_name].name
		return_tbl.quantity = deadremains.crafting.consumables[item_name].quantity

	end

	if table.Count(return_tbl) > 0 then return return_tbl end

end

function deadremains.crafting.GetItemCount(ply, item_name)
	if CLIENT then

		local c = 0
		--PrintTable(ply.Inventories)
		for k,v in pairs(ply.Inventories) do
			--PrintTable(v)
			if v.ItemUnique == item_name then
				c = c + 1
			end

		end

		return c

	end

	if SERVER then

		local c = ply:InventoryGetItemCount(item_name)

		return c

	end
end

function deadremains.crafting.GetCraftableItems(ply)

	local crafted_items_store = {}

	for target_item_name, target_required_mats in pairs(deadremains.crafting.recipes) do

		crafted_items_store[target_item_name] = {
			TotalCheckMatCount = 0,
			CurrentMatCount = 0,
			Mats = {

			}
		}

		for mat_name, mat_count in pairs(target_required_mats) do

			if mat_name == "entry_count" then

				-- how many required materials we need to have the correct amount of mats for.
				crafted_items_store[target_item_name].TotalCheckMatCount = mat_count

			elseif type(mat_count) == "table" then

				local selected_mat_name = ""

				-- any of the items exceed the amount needed to craft it.
				-- select that mat.
				for k,v in pairs(mat_count) do

					local ply_mat_count = deadremains.crafting.GetItemCount(ply, k)

					if ply_mat_count >= v then

						selected_mat_name = tostring(k)

						break

					end

				end

				if selected_mat_name ~= "" then

					-- we can craft this item with this material.
					crafted_items_store[target_item_name].CurrentMatCount = crafted_items_store[target_item_name].CurrentMatCount + 1

					table.insert(crafted_items_store[target_item_name].Mats, selected_mat_name)

				end

			elseif type(mat_count) == "number" then

				local ply_mat_count = deadremains.crafting.GetItemCount(ply, mat_name)

				if ply_mat_count >= mat_count then

					crafted_items_store[target_item_name].CurrentMatCount = crafted_items_store[target_item_name].CurrentMatCount + 1

					table.insert(crafted_items_store[target_item_name].Mats, mat_name)

				end

			end

		end

	end
	--PrintTable(craftable_items)
	--PrintTable(crafted_items_store)
	for k,v in pairs(crafted_items_store) do

		if v.CurrentMatCount ~= v.TotalCheckMatCount then

			crafted_items_store[k] = nil

		end

	end

	--print(table.Count(craftable_items), "HI")
	--PrintTable(craftable_items)

	return crafted_items_store
end


-- are not consumed upon crafting
deadremains.crafting.items = {
	water_bottle,
	wire_wool,
	tfm_sharp_screwdriver
}
function deadremains.crafting.IsPersisted(item_name)
	for k,v in pairs(deadremains.crafting.items) do
		if tostring(k) == tostring(item_name) then
			return true
		end
	end

	return false
end

-- required characteristics
-- 1 = required
-- 0 = optional
deadremains.crafting.chars["tfa_dr_bow"] = {
	woodwork = 1,
	wep1 = 1
}
deadremains.crafting.chars["tfm_sharp_trpaxe"] = {
	woodwork = 1,
	wep1 = 1
}
deadremains.crafting.chars["tfm_sharp_screwdriver"] = {
	woodwork = 1
}
deadremains.crafting.chars["tfm_sword_knight_longsword"] = {
	woodwork = 1,
	wep2 = 1
}
deadremains.crafting.chars["tfm_sword_snowflake_katana"] = {
	woodwork = 1,
	wep3 = 1
}