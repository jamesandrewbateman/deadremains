deadremains.deadmin = {}
deadremains.deadmin.itemcount = {}

deadremains.netrequest.create("deadremains.spawnitem", function(data) end)
deadremains.netrequest.create("load_deadmin_items", function(data)
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

concommand.Add("show_deadmin_spawnitem", function()
	if (LocalPlayer():IsAdmin()) then
		local si_frame = vgui.Create("DFrame")
		si_frame:SetSize(256, 256)
		si_frame:SetPos(10, 10)
		si_frame:MakePopup()
		si_frame:SetTitle("Spawn new item");

		local si_textbox = vgui.Create("DTextEntry", si_frame)
		si_textbox:SetText("Name of item.")
		si_textbox:SetPos(10, 30)
		si_textbox:SetSize(236, 16)

		local si_rlabel = vgui.Create("DLabel", si_frame)
		si_rlabel:SetText("Rarity (chance of spawning.)")
		si_rlabel:SetPos(50, 50)
		si_rlabel:SizeToContents()

		local si_rslider = vgui.Create("Slider", si_frame)
		si_rslider:SetPos(10, 65)
		si_rslider:SetSize(252, 16)
		si_rslider:SetMin(0)
		si_rslider:SetMax(1)
		si_rslider:SetValue(0.5)

		local si_flabel = vgui.Create("DLabel", si_frame)
		si_flabel:SetText("Frequency (0=never, 0.5=max/2, 1=max)")
		si_flabel:SetPos(30, 80)
		si_flabel:SizeToContents()

		local si_fslider = vgui.Create("Slider", si_frame)
		si_fslider:SetPos(10, 95)
		si_fslider:SetSize(252, 16)
		si_fslider:SetMin(0)
		si_fslider:SetMax(2)
		si_fslider:SetValue(1)

		local si_button = vgui.Create("DButton", si_frame)
		si_button:SetText("Spawn")
		si_button:SetSize(250, 50)
		si_button:SetPos(2, 115)
		si_button.DoClick = function()
			local rarity = si_rslider:GetValue()
			local freq = si_fslider:GetValue()
			local unique = si_textbox:GetValue()

			deadremains.netrequest.trigger("deadremains.spawnitem", {
				unique = unique,
				frequency = freq,
				rariy = rariy
			})
		end
	end
end)

concommand.Add("show_deadmin", function()
	if (LocalPlayer():IsAdmin()) then
		deadremains.netrequest.trigger("load_deadmin_items")
	end
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

	-- Spawning button
	local button = vgui.Create("DButton", sheet)
	button:Dock(TOP)
	button:SetTall(25)
	button:SetColor(Color(0, 155, 0))
	button:SetText("Spawn New Item")
	button.DoClick = function()
		LocalPlayer():ConCommand("show_deadmin_spawnitem")
	end

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