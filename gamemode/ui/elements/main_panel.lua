local ELEMENT = {}
function ELEMENT:Init()

	self.title_bar = vgui.Create("deadremains.panel_title_bar", self)
	self.title_bar:SetSize(640, 100)
	self.title_bar:SetPos(0, 0)

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(255, 255, 255, 10)
	surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.main_panel", ELEMENT, "Panel")