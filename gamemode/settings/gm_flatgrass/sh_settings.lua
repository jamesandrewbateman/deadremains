
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
	sight = {name = "Sight", default = 0},
	thirst = {name = "Thirst", default = 0},
	health = {name = "Health", default = 0},
	hunger = {name = "Hunger", default = 0},
	strength = {name = "Strength", default = 0}
}

deadremains.settings.new("characteristics", characteristics)

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

local inventories = {
	feet = {name = "Feet", horizontal = 2, vertical = 2, type = inventory_type_gear},
	legs = {name = "Legs", horizontal = 2, vertical = 2, type = inventory_type_gear},
	head = {name = "Head", horizontal = 2, vertical = 2, type = inventory_type_gear},
	back = {name = "Back", horizontal = 2, vertical = 4, type = inventory_type_gear},
	chest = {name = "Chest", horizontal = 2, vertical = 2, type = inventory_type_gear},
	primary = {name = "Primary", horizontal = 5, vertical = 2, type = inventory_type_primary},
	secondary = {name = "Secondary", horizontal = 3, vertical = 2, type = inventory_type_secondary},

	hunting_backpack = {name = "Hunting Backpack", horizontal = 9, vertical = 9}
}

deadremains.settings.new("default_inventories", inventories)