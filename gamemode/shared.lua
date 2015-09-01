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
slot_size = 32

if (SERVER) then
	util.AddNetworkString("deadremains.updatessize")

	net.Receive("deadremains.updatessize", function(bits, ply)
		ply.slot_size = net.ReadUInt(32)
	end)
end

if (CLIENT) then
	STORE_SCALE_X = math.Clamp(ScrW() / 1100, 0, 1)
	STORE_SCALE_Y = math.Clamp(ScrH() / 600, 0, 1)
	slot_size = slot_size * STORE_SCALE_Y

	-- hacky fix
	timer.Simple(2, function()
		print(ScrW() .. " : " .. ScrH())
		print(STORE_SCALE_X .. " : " .. STORE_SCALE_Y)
		print(slot_size)
		net.Start("deadremains.updatessize")
			net.WriteUInt(slot_size, 32)
		net.SendToServer()
	end)

end


inventory_equip_feet = 1
inventory_equip_legs = 2
inventory_equip_head = 3
inventory_equip_back = 4
inventory_equip_chest = 5
inventory_equip_primary = 6
inventory_equip_secondary = 7

inventory_equip_maximum = 7