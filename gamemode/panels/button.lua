surface.CreateFont("deadremains.button", {font = "Bebas Neue", size = 40, weight = 400})

local last_selected

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self.name = ""
	self.disabled = false

	self:SetCursor("hand")
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setDisabled(bool)
	self.disabled = bool

	if (bool) then
		self:SetCursor("arrow")
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:setName(name)
	self.name = name
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:doClick()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:OnMousePressed(code)
	if (!self.disabled) then
		if (code == MOUSE_LEFT) then
			self:doClick()
	
			last_selected = self
		end
	end
end
	
----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(3, 0, 0, w, h, panel_color_background)

	if (!self.disabled) then
		if (last_selected == self or self.Hovered) then
			draw.SimpleOutlined(0, 0, w, h, panel_color_text)
		end
	
		draw.SimpleText(self.name, "deadremains.button", w *0.5, h *0.5, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

vgui.Register("deadremains.button", panel, "EditablePanel")