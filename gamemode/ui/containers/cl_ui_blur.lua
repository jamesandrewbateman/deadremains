
local BLUR_PANEL
function deadremains.ui.createBlur()

	BLUR_PANEL = vgui.Create("deadremains.blur_screen")
	BLUR_PANEL:SetPos(0, 0)
	BLUR_PANEL:SetSize(deadremains.ui.screenSizeX, deadremains.ui.screenSizeY)

end