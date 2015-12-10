concommand.Add("dr_open_deadmin", function()
	local frame = vgui.Create("DFrame")
	frame:SetTitle("Deadmin")
	frame:MakePopup()
	frame:SetSize(256, 350)

	local flag_list = vgui.Create("DListView", frame)
	flag_list:SetMultiSelect(false)
	flag_list:SetPos(3, 64)
	flag_list:SetSize(250, 256)
	flag_list:AddColumn("Flag")
	flag_list:AddColumn("Enabled")

	local command_input = vgui.Create("DTextEntry", frame)
	command_input:SetPos(3, 32)
	command_input:SetSize(250, 32)
	command_input:SetText("enter command...")
	command_input.OnEnter = function (self)
		LocalPlayer():ConCommand(self:GetValue())
		flag_list:Clear()

		if (buffs) then
			for k,v in pairs(buffs) do
				flag_list:AddLine(k, v)
			end
		end

		if (debuffs) then
			for k,v in pairs(debuffs) do
				flag_list:AddLine(k, v)
			end
		end
	end

	local flag_refresh = vgui.Create("DButton", frame)
	flag_refresh:SetPos(3, 280)
	flag_refresh:SetSize(250, 64)
	flag_refresh:SetText("REFRESH UI")
	flag_refresh.DoClick = function(self)
		flag_list:Clear()

		if (buffs) then
			for k,v in pairs(buffs) do
				flag_list:AddLine(k, v)
			end
		end

		if (debuffs) then
			for k,v in pairs(debuffs) do
				flag_list:AddLine(k, v)
			end
		end		
	end
end)