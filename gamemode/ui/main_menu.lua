deadremains.main_menu = {}
deadremains.main_menu.open = false

function OpenMenu()
	local ply = LocalPlayer()

	-- derma scaling must occur from the get-go so...
	local width_scale = 600 / ScrW()
	local height_scale = 400 / ScrH()

	-- Base frame (global so we can close/open it)
	deadremains.main_menu.base_frame = vgui.Create("DFrame")
	local panel_width = width_scale * ScrW()
	local panel_height = height_scale * ScrH()
	deadremains.main_menu.base_frame:SetPos(25, 50)
	deadremains.main_menu.base_frame:SetSize(panel_width, panel_height)
	deadremains.main_menu.base_frame:SetTitle("Main Menu - Deadremains v0.0.0")
	deadremains.main_menu.base_frame:MakePopup()
	-- make sure that when we press I to close the panel, we remove all references.
	deadremains.main_menu.base_frame:SetDeleteOnClose(true)

	-- the holder for the other panels
	local category_sheet = vgui.Create("DPropertySheet")
	category_sheet:SetParent(deadremains.main_menu.base_frame)
	category_sheet:Dock(FILL)

	-- inventory panel
	local settings = {}
	settings.origin = {x=0, y=0}
	settings.padding = {x=10, y=10}
	settings.margin = {x=0, y=0}

	local inventory_panel = vgui.Create("DPanel")
	inventory_panel:Dock(FILL)
	inventory_panel.Paint = function(self, w,h)
		local new_x = settings.origin.x + settings.padding.x
		local new_y = settings.origin.y + settings.padding.y
		local new_width = w - (settings.padding.x * 2)
		local new_height = h - (settings.padding.y * 2)
		draw.RoundedBox( 0, new_x, new_y, new_width, new_height, panel_color_background )
	end
	inventory_panel:SetSize(panel_width, panel_height)

	--inventory_cat:SetSize(panel_width, panel_height)


	category_sheet:AddSheet("Inventory", inventory_panel, "icon16/user.png", false, false, "Character tab.")
end

deadremains.main_menu.thinkwait = false
hook.Add("Think", "dr_think_hook", function(ply)
	local keydown = input.IsKeyDown(KEY_I)

	if (deadremains.main_menu.thinkwait) then return end

	if (keydown and deadremains.main_menu.open) then
		deadremains.main_menu.open = false
		deadremains.main_menu.base_frame:Close()

		deadremains.main_menu.thinkwait = true
		timer.Simple(0.5, function() deadremains.main_menu.thinkwait = false end)
	elseif (keydown and not deadremains.main_menu.open) then
		deadremains.main_menu.open = true
		OpenMenu()

		deadremains.main_menu.thinkwait = true
		timer.Simple(0.5, function() deadremains.main_menu.thinkwait = false end)
	end
end)