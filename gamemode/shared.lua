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
slot_size = 52
ui_width = 1132
ui_height = 756

inventory_equip_feet = 1
inventory_equip_legs = 2
inventory_equip_head = 3
inventory_equip_back = 4
inventory_equip_chest = 5
inventory_equip_primary = 6
inventory_equip_secondary = 7

inventory_equip_maximum = 7