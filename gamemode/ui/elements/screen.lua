local ELEMENT = {}
function ELEMENT:Init()

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(255, 255, 255, 10)
	surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.screen", ELEMENT, "Panel")