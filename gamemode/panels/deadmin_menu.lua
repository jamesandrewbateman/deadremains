deadremains.deadmin = {}
deadremains.deadmin.itemcount = {}

net.Receive("deadremains.sendItemCount", function(bits, ply)
	local unique = net.ReadString()
	local count = net.ReadUInt(32)
	deadremains.deadmin.itemcount[unique] = count
end)

concommand.Add("spawn_menu_deadmin", function()
	deadremains.deadmin.spawn_menu = vgui.create("DFrame")
	deadremains.deadmin.spawn_menu:SetSize(ScrW() * 0.3, ScrH() * 0.3)
	deadremains.deadmin.spawn_menu:SetPos(ScrW() * -0.002, ScrH() * 0.002)
	deadremains.deadmin.spawn_menu:SetTitle('Deadmin Spawn Item')
	deadremains.deadmin.spawn_menu:SetSizable(true)
	deadremains.deadmin.spawn_menu:SetDeleteOnClose(false)
	deadremains.deadmin.spawn_menu:MakePopup()
end)

concommand.Add("open_deadmin", function()
	-- load data required
	net.Start("deadremains.getItemCounts")
	net.SendToServer()

	timer.Simple(0.01, function()
		local items = deadremains.item.getAll()

		deadremains.deadmin.main = vgui.Create('DFrame')
		deadremains.deadmin.main:SetSize(ScrW() * 0.61, ScrH() * 0.609)
		deadremains.deadmin.main:SetPos(ScrW() * -0.002, ScrH() * 0.002)
		deadremains.deadmin.main:SetTitle('Deadmin v1.0.0')
		deadremains.deadmin.main:SetSizable(true)
		deadremains.deadmin.main:SetDeleteOnClose(false)
		deadremains.deadmin.main:MakePopup()

		local sheet = vgui.Create("DPropertySheet", deadremains.deadmin.main)
		sheet:Dock(FILL)

		-- Spawning panel
		local spawning_panel = vgui.Create("DPanel", sheet)
		local cat_height = deadremains.deadmin.main:GetTall() / 4
		
		-- Consumables
		local consumable_cat = vgui.Create("DCollapsibleCategory", spawning_panel)
		consumable_cat:Dock(FILL)
		consumable_cat:SizeToChildren(false, true)
		consumable_cat:SetLabel("Consumables")

		local item_list = vgui.Create("DListView", spawning_panel)
		item_list:SetMultiSelect(false)
		item_list:AddColumn("Name")
		item_list:AddColumn("Type")
		item_list:AddColumn("Map Count")
		consumable_cat:SetContents(item_list)

		-- populate the list.
		for k,v in pairs(items) do
			if v.meta["type"] == item_type_consumable then
				item_list:AddLine(v.unique, type_to_string(v.meta["type"]), deadremains.deadmin.itemcount[v.unique] or 0)
			end
		end

		sheet:AddSheet("Spawning", spawning_panel, "icon16/wand.png")
	end)
end)