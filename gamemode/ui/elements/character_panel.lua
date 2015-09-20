local ELEMENT = {}
function ELEMENT:Init()

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.character_panel", ELEMENT, "Panel")