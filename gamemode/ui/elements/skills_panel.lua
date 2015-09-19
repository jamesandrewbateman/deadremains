local ELEMENT = {}
function ELEMENT:Init()

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(255, 255, 255, 180)
	surface.DrawRect(0, 0, w - 100, h)

end
vgui.Register("deadremains.skills_panel", ELEMENT, "Panel")