deadremains.deadmin = {}
deadremains.deadmin.itemcount = {}


deadremains.netrequest.create("load_deadmin_items", function(data)
	print("Clientside called")
	if (data) then
		for k,v in pairs(data) do
			deadremains.deadmin.itemcount[v.unique] = {
				count = v.count,
				type = v.type
			}
		end

		ShowDeadmin()
	end
end)

concommand.Add("show_deadmin", function()
	deadremains.netrequest.trigger("load_deadmin_items")
end)

function ShowDeadmin()
	local itemcount = deadremains.deadmin.itemcount

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
	spawning_panel:Dock(FILL)
	spawning_panel:SetBackgroundColor(Color(155, 155, 155))

	local button = vgui.Create("DButton", sheet)
	button:Dock(TOP)
	button:SetTall(25)
	button:SetColor(Color(0, 155, 0))
	button:SetText("Spawn New Item")

	local item_list = vgui.Create("DListView", spawning_panel)
	item_list:Dock(TOP)
	item_list:DockMargin(0, 8, 0, 0)
	--item_list:SetTall(deadremains.deadmin.main:GetTall())
	item_list:SetMultiSelect(false)
	item_list:AddColumn("Name")
	item_list:AddColumn("Type")
	item_list:AddColumn("Map Count")

	local function AddItem(unique, item_data)
		item_list:AddLine(unique, type_to_string(item_data.type), item_data.count)
	end

	-- populate the lists.
	for k,v in pairs(itemcount) do
		AddItem(k, v)
	end

	-- make it the correct size
	item_list:SizeToContents()
	sheet:AddSheet("Spawning", spawning_panel, "icon16/wand.png")
end