local color_line = Color(255, 255, 255, 25)

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self.rows = 2
	self.columns = 2
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setInventoryIndex(index)
	self.inventory_index = index
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setInventoryID(inventory_id)
	self.inventory_id = inventory_id
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getInventoryID()
	return self.inventory_id
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getInventoryIndex()
	return self.inventory_index
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:clear()
	local children = self:GetChildren()

	for k, child in pairs(children) do
		if (IsValid(child)) then
			child:Remove()
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:rebuild()
	print("SLOT REBUILDING")
	local inventory = deadremains.inventory.getc(self.inventory_index)

	for i = 1, #inventory.slots do
		local data = inventory.slots[i]

		--PrintTable(data)
		local slot = self:Add("deadremains.slot")
		print("DATA", data.x, data.y, data.width, data.height, data.item.unique)
		slot:SetPos(data.x, data.y)
		slot:SetSize(data.width, data.height)
		slot:setItem(data.item)
		slot:setInventoryIndex(data.inventory_index)

		data.slot_panel = slot
	end
end
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addItem(data)
	local slot = self:Add("deadremains.slot")
	slot:SetPos(data.x, data.y)
	print("Slot added at " .. data.x .. ", " .. data.y .. " with size " .. data.width .. "x" .. data.height)
	slot:SetSize(data.width, data.height)
	slot:setItem(data.item)
	slot:setInventoryIndex(data.inventory_index)

	data.slot_panel = slot
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:createSlots(columns, rows)
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

local function isWithin(slot, target_slot)
	local slot_x, slot_y = target_slot.parent:ScreenToLocal(slot:GetPos())
	local slot_width, slot_height = slot:GetSize()

	local target_slot_x, target_slot_y = target_slot.x, target_slot.y
	--print("SLOT", slot_x, slot_y)
	--print("TARGET_SLOT", target_slot_x, target_slot_y)
	local target_slot_width, target_slot_height = target_slot.width, target_slot.height
	
	local within = slot_x +slot_width *0.1 >= target_slot_x and slot_x +slot_width *0.9 <= target_slot_x +target_slot_width and slot_y +slot_height *0.1 >= target_slot_y and slot_y +slot_height *0.9 <= target_slot_y +target_slot_height
	return within
end

function panel:Paint(w, h)
	draw.simpleRect(0, 0, w, h, Color(0, 0, 30, 200))
	draw.simpleOutlined(0, 0, w, h, color_line)

	-- Draw the lines.
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
			local inventory = deadremains.inventory.getc(self.inventory_index)
			local x, y = self:ScreenToLocal(moving_x, moving_y)
			local slots = inventory:getSlotsAtArea(x +slot_size *0.5, y +slot_size *0.5, x +width -slot_size *0.5, y +height -slot_size *0.5)
			local slots_free = {}

			for i = 1, #slots do
				local items = inventory:getItemsAtArea(slots[i].x +1, slots[i].y +1, slots[i].x +slot_size -2, slots[i].y +slot_size -2)
				
				if (#items <= 0) then
					table.insert(slots_free, i)
				else

					local within = isWithin(moving_slot, items[1])

					if (within and moving_slot.size == items[1].size) then
						table.insert(slots_free, i)
					else
						draw.simpleRect(slots[i].x, slots[i].y, slot_size, slot_size, Color(255, 0, 0, 20))
					end
					
				end
			end
			if (moving_slot.size == #slots_free) then
				for k = 1, moving_slot.size do
					local i = slots_free[k]

					draw.simpleRect(slots[i].x, slots[i].y, slot_size, slot_size, Color(0, 255, 0, 20))
				end

				moving_slot_receiver = {parent = self, x = slots[slots_free[1]].x, y = slots[slots_free[1]].y}
			else
				moving_slot_receiver = nil

				for k = 1, moving_slot.size do
					local i = slots_free[k]

					if (i and slots[i]) then
						draw.simpleRect(slots[i].x, slots[i].y, slot_size, slot_size, Color(255, 0, 0, 20))
					end
				end
			end
		end
	end
end

vgui.Register("deadremains.slots", panel, "EditablePanel")

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

function panel:setInventoryIndex(index)
	self.inventory_index = index
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setInventoryID(inventory_id)
	self.inventory_id = inventory_id
	print("Setting inv_id... " .. self.inventory_id)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getInventoryID()
	return self.inventory_id
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------
 
function panel:setItem(item)
	print("Setted item ------------" .. item.unique)
	self.size = item.slots_vertical *item.slots_horizontal
	self.unique = item.unique
	self.slots_vertical = item.slots_vertical
	self.slots_horizontal = item.slots_horizontal
	self:SetSize(slot_size, slot_size)

	if (item.model) then
		self.model = self:GetParent():Add("DModelPanel")
		--self.model:Dock(FILL)
		self.model:SetModel(item.model)
		self.model:SetSize(slot_size * item.slots_horizontal, slot_size * item.slots_vertical)
		--self.model:SetSize(64, 64)
		self.model:SetDrawOnTop(true)
		print("Model view size", slot_size * item.slots_horizontal, slot_size * item.slots_vertical)
		local sx, sy = self:GetPos()

		self.model:SetPos(sx, sy)
		self.model:SetLookAt(item.look_at)
		self.model:SetCamPos(item.cam_pos)
		self.model:SetFOV(item.fov)
		self.model:SetMouseInputEnabled(false)

		function self.model.LayoutEntity(_self, entity)
			local sequence = entity:LookupSequence("idle_subtle")
			
			entity:SetAngles(Angle(0, item.rotate or 0, 0))
			entity:ResetSequence(sequence)
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
		local sx, sy = self:GetPos()

		self.origin = {parent = parent, x = self.x, y = self.y}

		self:SetParent(nil)
		self:SetDrawOnTop(true)
		self:MouseCapture(true)

		if (self.model) then
			self.model:SetVisible(false)
		end

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
				local inventory_index = moving_slot_receiver.parent:getInventoryIndex()
				
				-- moving_slot_receiver.x != self.origin.x and moving_slot_receiver.y != self.origin.y
				--if (inventory_index == self.origin.parent:getInventoryIndex()) then
			
				net.Start("deadremains.moveitem")
					net.WriteUInt(inventory_index, 8) -- In what inventory we want to put this item.
					net.WriteUInt(self.inventory_index, 8) -- In what inventory we are currently.
					net.WriteString(self.unique) -- The item that we have.
					net.WriteUInt(self.origin.x, 32) -- Where we come from.
					net.WriteUInt(self.origin.y, 32) -- Where we come from.
					net.WriteUInt(moving_slot_receiver.x, 32) -- Where we want to go.
					net.WriteUInt(moving_slot_receiver.y, 32) -- Where we want to go.
				net.SendToServer()
			end
			
			self:SetVisible(false)
			self:SetParent(self.origin.parent)
			self:SetPos(self.origin.x, self.origin.y)	
			
			-- wait for the server to respond to the request
			timer.Simple(LocalPlayer():Ping() *0.001, function()
				print(self)

				if (IsValid(self)) then
					print("Reset to true")
					self:SetVisible(true)

					if (self.model) then
						local sx, sy = self:GetPos()
						self.model:SetPos(sx, sy)
						self.model:SetVisible(true)
					end
				end
			end)
		

			self.origin = nil

			moving_slot = nil
			moving_slot_receiver = nil
		end
	elseif (code == MOUSE_RIGHT) then
		local item = deadremains.item.get(self.unique)

		local context_menu = vgui.Create("deadremains.slot.context.menu")
		context_menu:populate(item, self)
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
	--draw.simpleRect(0, 0, w, h, Color(255, 255, 255, 10))
end

vgui.Register("deadremains.slot", panel, "EditablePanel")



















--[[
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getSlotsAtArea(start_x, start_y, end_x, end_y, return_one)
	local result = {}

	for y = 1, self.rows do
		for x = 1, self.columns do
			local slot_x, slot_y = x *slot_size -slot_size, y *slot_size -slot_size

			if (start_x > slot_x +slot_size) then continue end
			if (start_y > slot_y +slot_size) then continue end
			if (slot_x > end_x) then continue end
			if (slot_y > end_y) then continue end
	
			if (return_one) then
				return {x = slot_x, y = slot_y}
			else
				table.insert(result, {x = slot_x, y = slot_y})
			end
		end
	end

	return result
end
 
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:getItemsAtArea(start_x, start_y, end_x, end_y, return_one)
	local result = {}

	for i = 1, #self.slots do
		local slot = self.slots[i]
		local slot_x, slot_y = slot:GetPos()
		local width, height = slot:GetSize()
		
		if (start_x > slot_x +width) then continue end
		if (start_y > slot_y +height) then continue end
		if (slot_x > end_x) then continue end
		if (slot_y > end_y) then continue end

		if (return_one) then
			return slot
		else
			table.insert(result, slot)
		end
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
		slot:setInventoryID(self.inventory_id)

		self:addSlot(slot)
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
						slot:setInventoryID(self.inventory_id)

						self:addSlot(slot)
		
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

function panel:removeItem(item, x, y)
	local slot = self:getItemsAtArea(x +1, y +1, x +item.slots_horizontal *slot_size -2, y +item.slots_vertical *slot_size -2, true)

	if (slot) then
		self:removeSlot(slot)

		slot:Remove()
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
]]