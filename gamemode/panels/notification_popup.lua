function ShowNotification(title, message, callback_yes, callback_no, mode, position, size)
	local frame = vgui.Create("DFrame")
	if not position then
		frame:SetPos(5, ScrH() / 2)
	else
		frame:SetPos(position.x, position.y)
	end

	if not size then
		frame:SetSize(200, 200)
	else
		frame:SetSize(size.x, size.y)
	end
	frame:SetTitle(title)
	frame:SetVisible(true)
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()

	frame.Paint = function(self, w,h)
		draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
	end

	-- used to scale buttons/labels
	local frame_width, frame_height = frame:GetSize()
	local xScale, yScale = frame_width/200, frame_height/200
	xScale = math.Clamp(xScale, 1, 2)
	yScale = math.Clamp(yScale, 1, 2)

	local frame_message = vgui.Create("DLabel")
	frame_message:SetParent(frame)
	frame_message:SetPos(10 * xScale, 30 * yScale)
	frame_message:SetText(message)
	frame_message:SizeToContents()

	if not mode then
		local frame_yes = vgui.Create("DButton")
		frame_yes:SetParent(frame)
		frame_yes:SetSize(50 * xScale, 50 * yScale)
		frame_yes:SetPos(10 * xScale, 140 * yScale)
		frame_yes:SetText("Yes")
		frame_yes.DoClick = function()
			callback_yes()
			frame:Close()
		end

		local frame_no = vgui.Create("DButton")
		frame_no:SetParent(frame)
		frame_no:SetSize(50 * xScale, 50 * yScale)
		frame_no:SetPos(140 * xScale, 140 * yScale)
		frame_no:SetText("No")
		frame_no.DoClick = function()
			callback_no()
			frame:Close()
		end
	elseif mode == 1 then
		local frame_ok = vgui.Create("DButton")
		frame_ok:SetParent(frame)
		frame_ok:SetSize(50 * xScale, 50 * yScale)
		frame_ok:SetPos(140 * xScale, 140 * yScale)
		frame_ok:SetText("Ok")
		frame_ok.DoClick = function()
			if (callback_yes) then callback_yes() end
			if (callback_no) then callback_no() end
			frame:Close()
		end
	end
end

net.Receive("deadremains.shownotification_ok", function(bits)
	local title = net.ReadString()
	local message = net.ReadString()

	ShowNotification(title, message, nil, nil, 1)
end)

concommand.Add("shown", function()
	ShowNotification("Title", "My message my message my message", function() print("hey") end, function() print("hy") end)
end)