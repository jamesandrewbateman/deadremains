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

	local frame_message = vgui.Create("DLabel")
	frame_message:SetParent(frame)
	frame_message:SetPos(10, 30)
	frame_message:SetText(message)
	frame_message:SizeToContents()

	local frame_yes = vgui.Create("DButton")
	frame_yes:SetParent(frame)
	frame_yes:SetSize(50, 50)
	frame_yes:SetPos(10, 140)
	frame_yes:SetText("Yes")
	frame_yes.DoClick = function()
		callback_yes()
		frame:Close()
	end

	local frame_no = vgui.Create("DButton")
	frame_no:SetParent(frame)
	frame_no:SetSize(50, 50)
	frame_no:SetPos(140, 140)
	frame_no:SetText("No")
	frame_no.DoClick = function()
		callback_no()
		frame:Close()
	end
end
concommand.Add("shown", function()
	ShowNotification("Title", "My message my message my message", function() print("hey") end, function() print("hy") end)
end)