include("main_menu_cats/base_menu.lua")
include("main_menu_cats/equipment.lua")
include("main_menu_cats/skills.lua")
include("main_menu_cats/team.lua")
include("main_menu_cats/characteristics.lua")

deadremains.store = {}

function ShowMenu()
	-- toggle functionality
	if (IsValid(main_menu)) then
		main_menu:Remove()
		return
	end

	-- Network the variables.
	LocalPlayer():ConCommand("syncdata")

	-- Wait for the networking
	timer.Simple(0.001, function()
		main_menu = vgui.Create("deadremains.main_menu")
		main_menu:Center()
		main_menu.x = 10
		main_menu.y = 10

		main_menu:SetSize(ScrW() * STORE_SCALE_X, ScrH() * STORE_SCALE_Y)

		main_menu:SetPos(x, y)

		main_menu:MakePopup()
		main_menu:InvalidateLayout(true)

		local character_icon = Material("icon16/user.png")

		main_menu:addCategory("a", character_icon, function(base)
			local character_panel = main_menu:getPanel("character_panel")
			local inventory_panel = main_menu:getPanel("inventory_panel")

			if (!IsValid(character_panel)) then
				character_panel = main_menu:addPanel(base, "character_panel", "deadremains.equipment")
				character_panel:Dock(FILL)
				
				inventory_panel = main_menu:Add("deadremains.inventory.external")
				inventory_panel:Dock(LEFT)
				inventory_panel:DockMargin(2, 0, 0, 0)

				main_menu:addPanel(nil, "inventory_panel", inventory_panel)

				nextFrame(function()
					main_menu:InvalidateLayout(true)
					main_menu:SizeToChildren(true, false)
				end)
			end
			
			inventory_panel:SetVisible(true)

			main_menu:setTitle("EQUIPMENT")
		end)

		local skills_icon = Material("icon16/user_add.png")

		-- keep in mind skills panel holds characteristics too
		main_menu:addCategory("b", skills_icon, function(base)
			local skills_panel = main_menu:getPanel("skills_panel")
			local characteristics_panel = main_menu:getPanel("characteristics_panel")

			if (IsValid(characteristics_panel)) then characteristics_panel:Remove() end
			
			if (!IsValid(skills_panel)) then
				skills_panel = main_menu:addPanel(base, "skills_panel", "deadremains.skills")
				skills_panel:Dock(FILL)

				skills_panel:addCategory("Combat", "weapon")
				skills_panel:addCategory("Crafting", "crafting")
				skills_panel:addCategory("Survival", "survival")
				skills_panel:addCategory("Medical", "medical")
				skills_panel:addCategory("Spec", "special")

				nextFrame(function()
					main_menu:InvalidateLayout(true)
					main_menu:SizeToChildren(true, false)
				end)
			end

			characteristics_panel = main_menu:Add("deadremains.characteristics")
			characteristics_panel:Dock(LEFT)
			characteristics_panel:DockMargin(2, 0, 0, 0)
			characteristics_panel:initCategories()
			characteristics_panel:SetVisible(true)

			main_menu:addPanel(nil, "characteristics_panel", characteristics_panel)

			nextFrame(function()
				main_menu:InvalidateLayout(true)
				main_menu:SizeToChildren(true, false)
			end)

			main_menu:setTitle("SKILLS")
		end)

		local teams_icon = Material("icon16/user_add.png")

		main_menu:addCategory("c", teams_icon, function(base)
			local team_panel = main_menu:getPanel("team_panel")

			if (!IsValid(team_panel)) then
				team_panel = main_menu:addPanel(base, "team_panel", "deadremains.team")
				team_panel:Dock(FILL)

				nextFrame(function()
					main_menu:InvalidateLayout(true)
					main_menu:SizeToChildren(true, false)
				end)
			end

			main_menu:setTitle("TEAM")
		end)

		main_menu:openCategory("b")

		deadremains.store.main_menu = main_menu
	end)
end
concommand.Add("inventory", ShowMenu)

--[[
main_menu:addCategory("c", skills_icon, function(base)
	local map_panel = main_menu:getPanel("map_panel")
	
	if (!IsValid(skills_panel)) then
		map_panel = main_menu:addPanel(base, "map_panel", "Panel")
		map_panel:Dock(FILL)

		local cam_vector = LocalPlayer():EyePos()--Vector(0, 0, 0)
		local last_x, last_y
		local camHeight = 100--30500

		function map_panel:OnMouseWheeled(delta)
			camHeight = camHeight -600 *delta
		end
		
		local drawing_map = false
		hook.Add("PreDrawSkyBox","asd",function()
			if (drawing_map) then
				return drawing_map
			end
		end)

		function map_panel:Paint(w, h)
			if (draw) then
				local x, y = self:LocalToScreen()

				drawing_map = true

				render.RenderView({
				    x = x,
				    y = y,
				    w = w,
				    h = h,
				    dopostprocess = false,
				    drawhud = false,
				    drawmonitors = false,
				    drawviewmodel = false,
				    ortho = true,
				    ortholeft = -camHeight/2,
				    orthobottom = camHeight/2,
				    orthoright = camHeight/2,
				    orthotop = -camHeight/2,
				    origin = cam_vector,
				    angles = Angle(90, 0, 0),
				    aspectratio = 1,
				   -- znear = -camHeight,
				   -- zfar = camHeight
				})

			 	drawing_map = false

				if (self.Hovered and input.IsMouseDown(MOUSE_LEFT)) then
					local mouseX, mouseY = gui.MousePos()
					local x, y = self:ScreenToLocal(mouseX, mouseY)

					last_x = last_x or x

					local delta = x -last_x
					
					if (math.abs(delta) > 0) then
						cam_vector.y = cam_vector.y +delta *100
					end
					
					last_x = x

					last_y = last_y or y

					local delta = y -last_y
					
					if (math.abs(delta) > 0) then
						cam_vector.x = cam_vector.x +delta *100
					end
					
					last_y = y
				else
					last_x, last_y = nil, nil
				end
			end
		end
	end

	main_menu:setTitle("MAP")
end)]]