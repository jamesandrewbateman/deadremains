local PANEL = {}

function PANEL:Init()
	self:SetSize(256, 256)
	self:Center()

	local yesButton = vgui.Create("DButton", self)
	yesButton:SetSize(40, 30)
	yesButton:SetPos(256 - 40, 256 - 30)
	yesButton.DoClick = function(self)
		net.Start("deadremains.notifyer.receive")
			net.WriteUInt(1, 8)
		net.SendToServer()
	end

	local noButton = vgui.Create("DButton", self)
	noButton:SetSize(40, 30)
	noButton:SetPos(0, 256-30)
	noButton.DoClick = function(self)
		net.Start("deadremains.notifyer.receive")
			net.WriteUInt(2, 8)
		net.SendToServer()
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
end

vgui.Register("YesNoNotification", PANEL, "Panel")



net.Receive("deadremains.notifyer.popup", function(bits, ply)
	local message = net.ReadString()
	local mode = net.ReadUInt(8)

	if (mode == 1) then
		-- yes/no dialog
		local p = vgui.Create("YesNoNotification")
		p:MakePopup()
	elseif (mode == 2) then
		-- ok dialog
	end
end)