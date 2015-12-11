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
	entry_count = 1
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
deadremains.crafting.weapons["tfa_dr_bow"] = { name = "Primitive Bow", quantity = 1 }
deadremains.crafting.weapons["tfm_sharp_trpaxe"] = { name = "Primitive Axe", quantity = 1 }
deadremains.crafting.weapons["tfm_sharp_screwdriver"] = { name = "Screwdriver", quantity = 1 }
deadremains.crafting.weapons["tfm_blunt_shovel"] = { name = "Shovel", quantity = 1 }
deadremains.crafting.weapons["tfm_sword_knight_longsword"] = { name = "Longsword", quantity = 1 }
deadremains.crafting.weapons["tfm_sword_snowflake_katana"] = { name = "Katana", quantity = 1 }
deadremains.crafting.weapons["tfbow_arrow"] = { name = "Arrow", quantity = 5 }

function deadremains.crafting.GetItemInfo(item_name)

	local return_tbl = {}

	if deadremains.crafting.weapons[item_name] ~= nil then

		return_tbl.type = "weapon"
		return_tbl.item_name = item_name
		return_tbl.print_name = deadremains.crafting.weapons[item_name].name
		return_tbl.quantity = deadremains.crafting.weapons[item_name].quantity

	elseif deadremains.crafting.craftingitems[item_name] ~= nil then

		return_tbl.type = "craftingitem"
		return_tbl.item_name = item_name
		return_tbl.print_name = deadremains.crafting.craftingitems[item_name].name
		return_tbl.quantity = deadremains.crafting.craftingitems[item_name].quantity

	elseif deadremains.crafting.consumables[item_name] ~= nil then

		return_tbl.type = "consumable"
		return_tbl.item_name = item_name
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

	local craftable_items = {}

	for craftable_name, required_items in pairs(deadremains.crafting.recipes) do
		craftable_items[craftable_name] = 100

		for item_name, required_item_count in pairs(required_items) do
			if type(required_item_count) == "table" then
				
				local recipe_item_found = false

				-- ANY of the items in this table.
				for recipe_item_name, recipe_item_quantity in pairs(required_item_count) do

					if not recipe_item_found then
						
						local item_count = deadremains.crafting.GetItemCount( ply, recipe_item_name )
						--print(recipe_item_name, item_count)
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

				local item_count = deadremains.crafting.GetItemCount( ply, item_name )
				--print(item_name, item_count)
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

	--print(table.Count(craftable_items), "HI")

	return craftable_items
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