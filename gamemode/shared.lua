DeriveGamemode("base")

GM.Name = "Dead Remains"
GM.Author = ""
GM.Website = ""

player_meta = FindMetaTable("Player")
entity_meta = FindMetaTable("Entity")

panel_color_text = Color(248, 154, 34)
panel_color_background = Color(0, 0, 0, 225)
panel_color_background_light = Color(255, 255, 255, 100)

gender_male = 1
gender_female = 2

-- The size of a single rectangle.
slot_size = 60

inventory_type_feet = 1
inventory_type_legs = 2
inventory_type_head = 3
inventory_type_back = 4
inventory_type_chest = 5
inventory_type_primary = 6
inventory_type_secondary = 7