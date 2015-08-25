surface.CreateFont("deadremains.slot.context.menu", {font = "Bebas Neue", size = 25, weight = 400})

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	local x, y = gui.MousePos()

	self:SetPos(x, y)
	self:MakePopup()
	self:SetDrawOnTop(true)

	self.last_width = 0

	RegisterDermaMenuForClose(self)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:GetDeleteSelf()
	return true
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:addOption(name, callback, slot)
	local width, height = util.getTextSize("deadremains.slot.context.menu", name)

	if (width > self.last_width) then
		self:SetWide(width +24)

		self.last_width = width
	end

	local panel = self:Add("Panel")
	panel:Dock(TOP)
	panel:SetTall(height +12)
	panel:SetCursor("hand")

	function panel.OnMousePressed()
		callback(slot)

		self:Remove()
	end

	function panel:Paint(w, h)
		draw.SimpleText(name, "deadremains.slot.context.menu", 12, h *0.5, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		if (self.Hovered) then
			draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 80))
		end
	end

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:populate(item, slot)
	if (item.context_menu) then
		for i = 1, #item.context_menu do
			local data = item.context_menu[i]

			self:addOption(data.name, data.callback, slot)
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255, 220))
end

vgui.Register("deadremains.slot.context.menu", panel, "EditablePanel")