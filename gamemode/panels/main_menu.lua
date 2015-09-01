local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self.dragging = {0, 0}

	self.panels = {}
	self.categories = {}

	self.title = ""

	self:DockPadding(0, 82 * STORE_SCALE_Y, 0, 0)

	self.list = self:Add("Panel")
	self.list:Dock(LEFT)
	self.list:DockMargin(0, 0, 1, 0)
	self.list:SetWide(100 * STORE_SCALE_X)

	self.left = self:Add("Panel")
	self.left:Dock(LEFT)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setTitle(title)
	self.title = title
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getPanel(name)
	return self.panels[string.lower(name)]
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addPanel(base, name, panel)
	if (IsValid(base)) then
		local panel = base:Add(panel)
		
		self.panels[name] = panel
		
		return panel
	else
		self.panels[name] = panel
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:openCategory(name)
	local data = self.categories[string.lower(name)]
	
	if (data) then
		self:switchParent(data.parent, data.callback)
	end
end

function panel:getCategory(name)
	local data = self.categories[string.lower(name)]

	return data
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:switchParent(parent, callback)
	if (IsValid(parent)) then
		local current = self.last_parent
		
		if (IsValid(current)) then
			current:SetVisible(false)
		end
		
		parent:SetVisible(true)
		
		if (callback) then
			callback(parent)
		end
		
		self.last_parent = parent
	else
		if (callback) then
			callback(parent)
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:parent()
	local panel = self.left:Add("EditablePanel")
	panel:Dock(FILL)
	panel:SetVisible(false)
	
	return panel
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addCategory(name, icon, callback, no_parent)
	local parent
	
	if (!no_parent) then
		parent = self:parent()
	end
	
	local panel = self.list:Add("Panel")
	panel:SetTall(100 * STORE_SCALE_Y)
	panel:Dock(TOP)
	panel:DockMargin(0, 0, 0, 2)
	panel:SetCursor("hand")
	
	panel.category_parent = parent
	panel.category_callback = callback

	function panel.OnMousePressed(_self)
		self:switchParent(_self.category_parent, _self.category_callback)
	end
	
	function panel:Paint(w, h)
		draw.RoundedBox(2, 0, 0, w, h, panel_color_background)

		if (icon) then
			draw.material(w *0.5 -16, h *0.5 -16, 32, 32, color_white, icon)
		end
	end
	
	self.list:InvalidateLayout(true)
	self.list:SizeToChildren(false, true)
	
	self.categories[string.lower(name)] = {callback = callback, parent = parent}
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:OnMousePressed()
	if (gui.MouseY() < self.y +20) then
		self.dragging[1] = gui.MouseX() -self.x
		self.dragging[2] = gui.MouseY() -self.y
		
		self:MouseCapture(true)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:OnMouseReleased()
	self.dragging = {0, 0}

	self:MouseCapture(false)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Think()
	if (self.dragging[1] != 0) then
		local x = gui.MouseX() -self.dragging[1]
		local y = gui.MouseY() -self.dragging[2]
		
		x = math.Clamp(x, 0, ScrW() -self:GetWide())
		y = math.Clamp(y, 0, ScrH() -self:GetTall())
		
		self:SetPos(x, y)
	end
	
	if (self.Hovered and gui.MouseY() < self.y +20) then
		self:SetCursor("sizeall")
		
		return
	end
	
	self:SetCursor("arrow")
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local sw, sh = self:GetSize()
	local sx, sy = self:GetPos()

	self.left:SetWide(700 * STORE_SCALE_X)

	self.list:SetWide(100 * STORE_SCALE_X)
	-- does nothing self.list:SetPos(0, 0)
end

----------------------------------------------------------------------
-- Purpose:
--		TextEntry only works when you have the panel do MakePopup (???).
-- 		So we need this to make F1 available.
----------------------------------------------------------------------

function panel:OnKeyCodePressed(code)
	if (code == KEY_F1) then
		--self:SetVisible(false)
		self:Remove()
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	--Derma_DrawBackgroundBlur(self)
	draw.RoundedBox(2, 0, 0, w, 80, panel_color_background)

	draw.SimpleText(self.title, "deadremains.button", w *0.5, 80 *0.5, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("deadremains.main_menu", panel, "EditablePanel")






local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	local data = deadremains.inventory.get("head")

	self.inventory_head = self:Add("deadremains.inventory")
	self.inventory_head:setInventory(inventory_index_head, data)

	data = deadremains.inventory.get("chest")

	self.inventory_chest = self:Add("deadremains.inventory")
	self.inventory_chest:setInventory(inventory_index_chest, data)

	data = deadremains.inventory.get("feet")

	self.inventory_feet = self:Add("deadremains.inventory")
	self.inventory_feet:setInventory(inventory_index_feet, data)

	data = deadremains.inventory.get("primary")

	self.inventory_primary = self:Add("deadremains.inventory")
	self.inventory_primary:setInventory(inventory_index_primary, data)

	data = deadremains.inventory.get("secondary")

	self.inventory_secondary = self:Add("deadremains.inventory")
	self.inventory_secondary:setInventory(inventory_index_secondary, data)

	data = deadremains.inventory.get("back")

	self.inventory_back = self:Add("deadremains.inventory")
	self.inventory_back:setInventory(inventory_index_back, data)

	data = deadremains.inventory.get("legs")

	self.inventory_legs = self:Add("deadremains.inventory")
	self.inventory_legs:setInventory(inventory_index_legs, data)

	self.model = self:Add("DModelPanel")
	self.model:SetModel("models/humans/group01/male_01.mdl")
	self.model:SetSize(264, 500)
	self.model:SetFOV(36)

	function self.model.LayoutEntity(_self, entity)
		local sequence = entity:LookupSequence("idle_subtle")
		
		entity:SetAngles(Angle(0, 45, 0))
		entity:ResetSequence(sequence)
		
		--if (!self.bodyGroups) then
		--	self.skins = entity:SkinCount()
		--	self.bodyGroups = entity:GetNumBodyGroups()
		--end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

deadremains.store = {}
deadremains.store.ScaleW = 1
deadremains.store.ScaleH = 1
deadremains.store.FirstLayout = true
function panel:PerformLayout()
	local w, h = self:GetSize()

	local padding_x = 25 * STORE_SCALE_X
	local padding_y = 25 * STORE_SCALE_Y
	local seperator_x = 16 * STORE_SCALE_X
	local seperator_y = 16 * STORE_SCALE_Y

	-- for each inventory, we must scale it according to the size of the parent panel?
	-- print(w, h)
	-- 700 593
	-- 700 480
	self.inventory_head:SetPos(padding_x, padding_y)

	local height = padding_y + self.inventory_head:GetTall() + seperator_y
	self.inventory_chest:SetPos(padding_x, height)

	height = height + self.inventory_chest:GetTall() + seperator_y
	self.inventory_feet:SetPos(padding_x, height)

	local width = padding_x + self.inventory_back:GetWide()
	self.inventory_back:SetPos(w - width, padding_y)

	width = padding_x + self.inventory_legs:GetWide()
	height = padding_y + self.inventory_secondary:GetTall() + self.inventory_legs:GetTall() + seperator_y

	local back_x, back_y = self.inventory_back:GetPos()
	self.inventory_legs:SetPos(w - width, back_y + self.inventory_back:GetTall() + seperator_y)


	self.model:SetPos(w * 0.5 - self.model:GetWide() * 0.5, -50 * STORE_SCALE_Y)

	local model_x, model_y = self.model:GetPos()
	model_y = model_y + self.model:GetTall()

	height = padding_y + self.inventory_primary:GetTall()
	self.inventory_primary:SetPos(padding_x, model_y - padding_y)

	local legs_x, legs_y = self.inventory_legs:GetPos()
	local primary_x, primary_y = self.inventory_primary:GetPos()

	width = padding_x + self.inventory_secondary:GetWide()
	self.inventory_secondary:SetPos(w - width, primary_y)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	a=self
	draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
end

vgui.Register("deadremains.equipment", panel, "EditablePanel")











local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	--self:DockPadding(25, 25, 25, 25)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local skill_circle = Material("materials/deadremains/skills/circle.png")

surface.CreateFont("deadremains.skill", {font = "Bebas Neue", size = 36, weight = 400})

function panel:addCategory(name, type)
	local panel = self:Add("Panel")

	function panel:Paint(w, h)
		draw.SimpleText(name, "deadremains.skill", w *0.5, 0, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		--draw.simpleOutlined(0,0,w,h,color_red)
	end

	local skills = deadremains.settings.get("skills")

	local y = 64 * STORE_SCALE_Y

	for unique, data in pairs(skills) do
		if (data.type == type) then
			local icon = panel:Add("DImage")
			icon:SetImage(data.icon)
			icon:SetSize(64 * STORE_SCALE_X, 64 * STORE_SCALE_Y)
			icon:SetPos(116 *0.5 -40, y)
			icon:SetMouseInputEnabled(true)

			function icon:Paint(w, h)
				local alpha = self:GetAlpha()
				local has_skill = LocalPlayer():hasSkill(unique)

				if (has_skill) then

					if (self.Hovered) then
						draw.material(0, 0, w, h, color_white, skill_circle)
						draw.material(4, 4, w -8, h -8, Color(240, 155, 28), skill_circle)
					else
						draw.material(0, 0, w, h, Color(85, 161, 63), skill_circle)
					end
					
					if (alpha != 255) then
						self:SetAlpha(255)
					end
				else
					draw.material(0, 0, w, h, Color(255, 255, 255, 80), skill_circle)

					if (alpha != 80) then
						self:SetAlpha(80)
					end
				end

				DImage.Paint(self, w, h)
			end
			
			y = y + (64 * STORE_SCALE_Y) + (48 * STORE_SCALE_Y)
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local w, h = self:GetSize()
	local children = self:GetChildren()

	for k, child in pairs(children) do
		local width = math.Round(math.ceil(w /5 -25 *0.5))

		child:SetPos(width *(k -1) +25, 25)
		child:SetSize(width, h -25 *2)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
end

vgui.Register("deadremains.skills", panel, "EditablePanel")




local panel = {}


----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	if not LocalPlayer():inTeam() then
		self.create_button = self:Add("deadremains.button")
		self.create_button:setName("Create")

		function self.create_button:doClick()
			deadremains.team.create()
		end
	end
end

function panel:PerformLayout()
	if not LocalPlayer():inTeam() then
		local w, h = self:GetSize()

		self.create_button:SetPos(10, 10)
		self.create_button:SetSize(104, 30)
	end
end

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, h, Color(255, 0, 0, 255))
end
vgui.Register("deadremains.team", panel, "EditablePanel")



function ShowMenu()
	-- toggle functionality
	if (IsValid(main_menu)) then
		main_menu:Remove()
		return
	end

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
				main_menu:SizeToChildren(true, true)
			end)
		end
		
		inventory_panel:SetVisible(true)

		main_menu:setTitle("EQUIPMENT")
	end)

	local skills_icon = Material("icon16/user_add.png")

	main_menu:addCategory("b", skills_icon, function(base)
		local skills_panel = main_menu:getPanel("skills_panel")
		
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
				main_menu:SizeToChildren(true, true)
			end)
		end

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
				main_menu:SizeToChildren(true, true)
			end)
		end

		main_menu:setTitle("TEAM")
	end)

	main_menu:openCategory("a")
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