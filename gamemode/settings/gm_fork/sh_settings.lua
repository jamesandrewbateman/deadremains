deadremains.settings.new("cl_defaults",
	{
		spawn_rarity = 0.5
	}
)

----------------------------------------------------------------------
-- Purpose:
--		The default needs.
----------------------------------------------------------------------

local needs = {
	thirst = {name = "Thirst", default = 100},
	health = {name = "Health", default = 100},
	hunger = {name = "Hunger", default = 100}
}

deadremains.settings.new("needs", needs)

----------------------------------------------------------------------
-- Purpose:
--		The default characteristics.
----------------------------------------------------------------------

local characteristics = {
	speed = {name = "Speed", default = 5, icon = "materials/deadremains/characteristics/sight.png"},
	thirst = {name = "Thirst", default = 100, icon = "materials/deadremains/characteristics/thirst.png"},
	health = {name = "Health", default = 100, icon = "materials/deadremains/characteristics/health.png"},
	hunger = {name = "Hunger", default = 100, icon = "materials/deadremains/characteristics/hunger.png"},
	strength = {name = "Strength", default = 5, icon = "materials/deadremains/characteristics/strength.png"}
}

deadremains.settings.new("characteristics", characteristics)

----------------------------------------------------------------------
-- Purpose:
--		The default skills.
----------------------------------------------------------------------

local skills = {
	fortification = {unique = "fortification", name = "Fortification", type = "crafting", icon = "materials/deadremains/skills/CraftingSkill_Fortification.png"},
	mechanics = {unique = "mechanics", name = "Mechanics", type = "crafting", icon = "materials/deadremains/skills/craftingskill_mechanics.png"},
	woodwork = {unique = "woodwork", name = "Woodwork", type = "crafting", icon = "materials/deadremains/skills/craftingskill_woodwork.png"},

	first_aid = {unique = "first_aid", name = "First Aid", type = "medical", icon = "materials/deadremains/skills/medicalskill_heal.png"},
	medic = {unique = "medic", name = "Medic", type = "medical", icon = "materials/deadremains/skills/medicalskill_something.png"},
	surgeon = {unique = "surgeon", name = "Surgeon", type = "medical", icon = "materials/deadremains/skills/medicalskill_surgeon.png"},

	chemistry = {unique = "chemistry", name = "Chemistry", type = "special", icon = "materials/deadremains/skills/specialskill_chemistry.png"},
	electronics = {unique = "electronics", name = "Electronics", type = "special", icon = "materials/deadremains/skills/specialskill_electronics.png"},

	campcraft = {unique = "campcraft", name = "Campcraft", type = "survival", icon = "materials/deadremains/skills/survivalskill_campcraft.png"},
	fire = {unique = "fire", name = "Fire", type = "survival", icon = "materials/deadremains/skills/survivalskill_fire.png"},
	hunting = {unique = "hunting", name = "Hunting", type = "survival", icon = "materials/deadremains/skills/survivalskill_hunting.png"},

	wep1 = {unique = "wep1", name = "Weapon 1", type = "weapon", icon = "materials/deadremains/skills/weaponskill_1.png"},
	wep2 = {unique = "wep2", name = "Weapon 2", type = "weapon", icon = "materials/deadremains/skills/weaponskill_2.png"},
	wep3 = {unique = "wep3", name = "Weapon 3", type = "weapon", icon = "materials/deadremains/skills/weaponskill_3.png"}
}

deadremains.settings.new("skills", skills)

local skill_types = {"crafting", "medical", "special", "survival", "weapon"}

deadremains.settings.new("skill_types", skill_types)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.getSkillByType(type)
	local result = {}

	for unique, data in pairs(skills) do
		if (data.type == type) then
			table.insert(result, data)
		end
	end

	return result
end 

----------------------------------------------------------------------
-- Purpose:
--		The default male character models.
----------------------------------------------------------------------

local models = {
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl"
}

deadremains.settings.new("male_models", models)

----------------------------------------------------------------------
-- Purpose:
--		The default female character models.
----------------------------------------------------------------------

local models = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl"
}

deadremains.settings.new("female_models", models)

----------------------------------------------------------------------
-- Purpose:
--		The default inventories.
----------------------------------------------------------------------

-- These are the default static ones.
inventory_index_feet = 1
inventory_index_legs = 2
inventory_index_head = 3
inventory_index_back = 4
inventory_index_chest = 5
inventory_index_primary = 6
inventory_index_secondary = 7

local inventories = {
	{unique = "feet", inventory_index = inventory_index_feet, size = Vector(2, 2, 0), max_weight = 2000},
	{unique = "legs", inventory_index = inventory_index_legs, size = Vector(2, 2, 0), max_weight = 2000},
	{unique = "head", inventory_index = inventory_index_head, size = Vector(2, 2, 0), max_weight = 2000},
	{unique = "back", inventory_index = inventory_index_back, size = Vector(2, 4, 0), max_weight = 2000},
	{unique = "chest", inventory_index = inventory_index_chest, size = Vector(2, 2, 0), max_weight = 2000},
	{unique = "primary", inventory_index = inventory_index_primary, size = Vector(5, 2, 0), max_weight = 2000},
	{unique = "secondary", inventory_index = inventory_index_secondary, size = Vector(3, 2, 0), max_weight = 2000},
	{unique = "hunting_backpack", inventory_index = -1, size = Vector(11, 6, 0), max_weight = 2000}
}

deadremains.settings.new("default_inventories", inventories)