function ShowNotification(title, message, callback_yes, callback_no)
	local frame = vgui.Create("DFrame")
	frame:SetPos(5, ScrH() / 2)
	frame:SetSize(200, 200)
	frame:SetTitle(title)
	frame:SetVisible(true)
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()

	frame.Paint = function(self, w,h)
		draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
	end
end