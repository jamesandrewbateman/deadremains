local ELEMENT = {}
function ELEMENT:Init()

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(255, 0, 0, 180)
	surface.DrawRect(0, 0, w - 200, h)

end
vgui.Register("deadremains.character_panel", ELEMENT, "Panel")