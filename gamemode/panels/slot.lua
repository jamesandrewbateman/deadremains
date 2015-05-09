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
 
function panel:addItem(item)
	for y = 1, self.rows do
		for x = 1, self.columns do
			local start_x, start_y = x *slot_size -slot_size +1, y *slot_size -slot_size +1
			local end_x, end_y = start_x +item.slots_horizontal *slot_size -2, start_y +item.slots_vertical *slot_size -2
			
			if (end_x <= self:GetWide() and end_y <= self:GetTall()) then
				local slots = self:getSlotsAtArea(start_x, start_y, end_x, end_y)

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

	local mouse_x, mouse_y = self:LocalCursorPos()

	for y = 1, self.rows do
		for x = 1, self.columns do
			if (mouse_x >= x *slot_size -slot_size and mouse_x <= x *slot_size and mouse_y >= y *slot_size -slot_size and mouse_y <= y *slot_size) then
				draw.SimpleRect(x *slot_size -slot_size, y *slot_size -slot_size, slot_size, slot_size, Color(255, 255, 255, 100))
			end
		end
	end
end

vgui.Register("deadremains.inventory", panel, "EditablePanel")

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setItem(item)
	self.unique = item.unique

	if (item.model) then
		self.model = self:Add("DModelPanel")
		self.model:Dock(FILL)
		self.model:SetModel(item.model)
		self.model:SetLookAt(item.look_at)
		self.model:SetCamPos(item.cam_pos)
		self.model:SetFOV(item.fov)

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

function panel:Paint(w, h)
	draw.SimpleRect(0, 0, w, h, Color(255, 255, 255, 10))
end

vgui.Register("deadremains.slot", panel, "EditablePanel")


--[[
SHIT = vgui.Create("Panel")
SHIT:SetSize(500, 500)
SHIT:Center()
SHIT.x=100

function SHIT:Paint(w,h)
	--Derma_DrawBackgroundBlur(self)

	draw.RoundedBox(2,0,0,w,h,Color(0,0,0,220))
end

local slots = SHIT:Add("deadremains.inventory")
slots:SetPos(100, 100)
slots:createInventory(5, 6)

--slots:addItem({slots_vertical = 2, slots_horizontal = 1})
slots:addItem({slots_vertical = 3, slots_horizontal = 2, color=Color(0,255,0,100)})
slots:addItem({slots_vertical = 2, slots_horizontal = 3, color=Color(255,0,0,100)})
slots:addItem({slots_vertical = 3, slots_horizontal = 2, color=color_orange})
slots:addItem({slots_vertical = 1, slots_horizontal = 1, color=color_white})
slots:addItem({slots_vertical = 1, slots_horizontal = 1, color=color_white})
slots:addItem({slots_vertical = 1, slots_horizontal = 1, color=color_white})
slots:addItem({slots_vertical = 1, slots_horizontal = 2, color=color_white})
--slots:addItem({slots_vertical = 1, slots_horizontal = 1})
--slots:addItem({slots_vertical = 1, slots_horizontal = 1})
--slots:addItem({slots_vertical = 2, slots_horizontal = 1})
]]
