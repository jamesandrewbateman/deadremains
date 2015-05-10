-- The size of a single rectangle.
local slot_size = 60
local color_line = Color(255, 255, 255, 15)

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self.rows = 2
	self.columns = 2

	self.slots = {}
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getSlotsAtArea(start_x, start_y, end_x, end_y)
	local result = {}

	for y = 1, self.rows do
		for x = 1, self.columns do
			local slot_x, slot_y = x *slot_size -slot_size, y *slot_size -slot_size
			local width, height = slot_size, slot_size
			
			--width, height = width -1, height -1
	
			if (start_x > slot_x +width) then continue end
			if (start_y > slot_y +height) then continue end
			if (slot_x > end_x) then continue end
			if (slot_y > end_y) then continue end
	
			table.insert(result, {x = slot_x, y = slot_y})
		end
	end

	return result
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getItemsAtArea(start_x, start_y, end_x, end_y)
	local result = {}

	for i = 1, #self.slots do
		local slot = self.slots[i]
		local slot_x, slot_y = slot:GetPos()
		local width, height = slot:GetSize()
		
		width, height = width -1, height -1

		if (start_x > slot_x +width) then continue end
		if (start_y > slot_y +height) then continue end
		if (slot_x > end_x) then continue end
		if (slot_y > end_y) then continue end

		table.insert(result, slot)
	end

	return result
end
  
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------
 
function panel:addItem(item, x, y)
	if (x and y) then
		local slot = self:Add("deadremains.slot")
		slot:SetPos(x, y)
		slot:SetSize(item.slots_horizontal *slot_size, item.slots_vertical *slot_size)
		slot:setItem(item)
		
		table.insert(self.slots, slot)
	else
		for y = 1, self.rows do
			for x = 1, self.columns do
				local start_x, start_y = x *slot_size -slot_size +1, y *slot_size -slot_size +1
				local end_x, end_y = start_x +item.slots_horizontal *slot_size -2, start_y +item.slots_vertical *slot_size -2
				
				if (end_x <= self:GetWide() and end_y <= self:GetTall()) then
					local slots = self:getItemsAtArea(start_x, start_y, end_x, end_y)
		
					if (#slots <= 0) then
						local slot = self:Add("deadremains.slot")
						slot:SetPos(start_x, start_y)
						slot:SetSize(item.slots_horizontal *slot_size, item.slots_vertical *slot_size)
						slot:setItem(item)
		
						table.insert(self.slots, slot)
		
						return
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addSlot(slot)
	table.insert(self.slots, slot)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:removeSlot(slot)
	for i = 1, #self.slots do
		if (self.slots[i] == slot) then
			table.remove(self.slots, i)

			break
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:createInventory(columns, rows)
	self.rows = rows
	self.columns = columns

	self:SetSize(self.columns *slot_size, self.rows *slot_size)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local moving_slot = nil
local moving_slot_receiver = nil

function panel:Paint(w, h)
	draw.SimpleRect(0, 0, w, h, Color(0, 0, 30, 200))
	draw.SimpleOutlined(0, 0, w, h, color_line)

	surface.SetDrawColor(color_line)

	for x = 1, self.columns -1 do
		surface.DrawRect(x *slot_size, 0, 1, h)
	end
	
	for y = 1, self.rows -1 do
		surface.DrawRect(0, y *slot_size, w, 1)
	end

	if (IsValid(moving_slot)) then
		local moving_x, moving_y = moving_slot:GetPos()
		local parent_x, parent_y = self:LocalToScreen(0, 0)
		local width, height = moving_slot:GetSize()
		
		if (moving_x >= parent_x -width *0.5 and moving_x +width *0.5 <= parent_x +w and moving_y >= parent_y -height *0.5 and moving_y +height *0.5 <= parent_y +h) then
			local x, y = self:ScreenToLocal(moving_x, moving_y)
			local slots = self:getSlotsAtArea(x +slot_size *0.5, y +slot_size *0.5, x +width -slot_size *0.5, y +height -slot_size *0.5)
			local slots_free = {}

			for i = 1, #slots do
				local items = self:getItemsAtArea(slots[i].x +1, slots[i].y +1, slots[i].x +slot_size -2, slots[i].y +slot_size -2)

				if (#items <= 0) then
					table.insert(slots_free, i)
				else
					draw.SimpleRect(slots[i].x, slots[i].y, slot_size, slot_size, Color(255, 0, 0, 20))
				end
			end
			
			if (moving_slot.size == #slots_free) then
				for k = 1, moving_slot.size do
					local i = slots_free[k]

					draw.SimpleRect(slots[i].x, slots[i].y, slot_size, slot_size, Color(0, 255, 0, 20))
				end
				
				moving_slot_receiver = {parent = self, x = slots[slots_free[1]].x, y = slots[slots_free[1]].y}
			else
				moving_slot_receiver = nil

				for k = 1, moving_slot.size do
					local i = slots_free[k]

					if (i and slots[i]) then
						draw.SimpleRect(slots[i].x, slots[i].y, slot_size, slot_size, Color(255, 0, 0, 20))
					end
				end
			end
		end
	end

	--local mouse_x, mouse_y = self:LocalCursorPos()

	--if (mouse_x >= 0 and mouse_y >= 0) then
	--	local slots = self:getSlotsAtArea(mouse_x, mouse_y, mouse_x +slot_size *2, mouse_y)
	
	--	for i = 1, #slots do
	--		draw.SimpleRect(slots[i].x, slots[i].y, slot_size, slot_size, Color(255, 255, 255, 100))
	--	end
	--end
	
	--[[
	for y = 1, self.rows do
		for x = 1, self.columns do
			if (mouse_x >= x *slot_size -slot_size and mouse_x <= (x *slot_size) *2 and mouse_y >= y *slot_size -slot_size and mouse_y <= y *slot_size) then
				draw.SimpleRect(x *slot_size -slot_size, y *slot_size -slot_size, slot_size, slot_size, Color(255, 255, 255, 100))
			end
		end
	end
	]]
end

vgui.Register("deadremains.inventory", panel, "EditablePanel")

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self:SetCursor("hand")
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setItem(item)
	self.size = item.slots_vertical +item.slots_horizontal
	self.unique = item.unique
	self.slots_vertical = item.slots_vertical
	self.slots_horizontal = item.slots_horizontal

	if (item.model) then
		self.model = self:Add("DModelPanel")
		self.model:Dock(FILL)
		self.model:SetModel(item.model)
		self.model:SetLookAt(item.look_at)
		self.model:SetCamPos(item.cam_pos)
		self.model:SetFOV(item.fov)
		self.model:SetMouseInputEnabled(false)

		function self.model.LayoutEntity(_self, entity)
			local sequence = entity:LookupSequence("idle_subtle")
			
			entity:SetAngles(Angle(0, item.rotate or 0, 0))
			entity:ResetSequence(sequence)
			
			--if (!self.bodyGroups) then
			--	self.skins = entity:SkinCount()
			--	self.bodyGroups = entity:GetNumBodyGroups()
			--end
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:OnMousePressed(code)
	if (code == MOUSE_LEFT) then
		local parent = self:GetParent()

		self.origin = {parent = parent, x = self.x, y = self.y}
	
		self:SetParent(nil)
		self:SetDrawOnTop(true)
		self:MouseCapture(true)

		moving_slot = self
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:OnMouseReleased(code)
	if (code == MOUSE_LEFT) then
		if (self.origin) then
			self:MouseCapture(false)

			if (moving_slot_receiver) then
				self.origin.parent:removeSlot(self)

				moving_slot_receiver.parent:addSlot(self)

				self:SetParent(moving_slot_receiver.parent)
				self:SetPos(moving_slot_receiver.x, moving_slot_receiver.y)
			else
				self:SetParent(self.origin.parent)
				self:SetPos(self.origin.x, self.origin.y)
			end
			
			self.origin = nil

			moving_slot = nil
			moving_slot_receiver = nil
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Think()
	if (self.origin) then
		local x, y = gui.MousePos()
		local w, h = self:GetSize()

		self:SetPos(x -w *0.5, y -h *0.5)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	--draw.SimpleRect(0, 0, w, h, Color(255, 255, 255, 10))
end

vgui.Register("deadremains.slot", panel, "EditablePanel")