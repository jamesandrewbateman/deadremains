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
	self.list:SizeToChildren(true, true)
	
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