local ELEMENT = {}
function ELEMENT:Init()

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(0, 255, 0, 180)
	surface.DrawRect(0, 0, w - 50, h)

end
vgui.Register("deadremains.map_panel", ELEMENT, "Panel")