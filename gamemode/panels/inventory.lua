surface.CreateFont("deadremains.inventory", {font = "Bebas Neue", size = 25, weight = 400})

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self.name = ""
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setInventory(unique, data)
	self.slots = self:Add("deadremains.slots")
	self.slots:SetPos(0, 32)
	self.slots:createSlots(data.horizontal, data.vertical)

	self:setName(data.name)

	self:InvalidateLayout(true)
	self:SizeToChildren(true, true)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setName(name)
	self.name = tostring(name)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.SimpleText(self.name, "deadremains.inventory", 0, 0, panel_color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end

vgui.Register("deadremains.inventory", panel, "EditablePanel")