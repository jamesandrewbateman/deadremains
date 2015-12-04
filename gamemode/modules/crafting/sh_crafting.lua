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

-- crafting items
deadremains.crafting.recipes["crafted_feather"] = {
	dead_bird = 1,
	entry_count = 1
}

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


-- are not consumed upon crafting
deadremains.crafting.items = {
	water_bottle,
	wire_wool
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