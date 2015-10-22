local PANEL = {}

function PANEL:Init()
	self:SetTitle("")
	self:SetSize(256, 256)
	self:Center()
	self:SetDeleteOnClose(true)

	local yesButton = vgui.Create("DButton", self)
	yesButton:SetText("Yes")
	yesButton:SetSize(60, 50)
	yesButton:SetPos(256 - 60, 256 - 50)
	yesButton.DoClick = function(self)
		net.Start("deadremains.notifyer.receive")
			net.WriteUInt(1, 8)
		net.SendToServer()
	end
	yesButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, deadremains.ui.colors.clr3)
	end

	local noButton = vgui.Create("DButton", self)
	noButton:SetText("No")
	noButton:SetSize(60, 50)
	noButton:SetPos(0, 256-50)
	noButton.DoClick = function(self)
		net.Start("deadremains.notifyer.receive")
			net.WriteUInt(2, 8)
		net.SendToServer()
	end
	noButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, deadremains.ui.colors.clr3)
	end
end

function PANEL:SetMessage(msg)
	if self.Message == nil then
		self.Message = vgui.Create("DLabel", self)
		self.Message:SetPos(10, 0)
		self.Message:SetText(msg)
		self.Message:SetSize(236, 216)
		self.Message:SetWrap(true)
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, deadremains.ui.colors.clr1)
end

vgui.Register("YesNoNotification", PANEL, "DFrame")


local PANEL = {}

function PANEL:Init()
	self:SetTitle("")
	self:SetSize(256, 256)
	self:Center()
	self:SetDeleteOnClose(true)

	local yesButton = vgui.Create("DButton", self)
	yesButton:SetText("Ok")
	yesButton:SetSize(60, 50)
	yesButton:SetPos(256 - 60, 256 - 50)
	yesButton.DoClick = function(self)
		net.Start("deadremains.notifyer.receive")
			net.WriteUInt(3, 8)
		net.SendToServer()
	end
	yesButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, deadremains.ui.colors.clr3)
	end
end

function PANEL:SetMessage(msg)
	if self.Message == nil then
		self.Message = vgui.Create("DLabel", self)
		self.Message:SetPos(10, 0)
		self.Message:SetText(msg)
		self.Message:SetSize(236, 216)
		self.Message:SetWrap(true)
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, deadremains.ui.colors.clr1)
end

vgui.Register("OkNotification", PANEL, "DFrame")

function ShowNotification(title, message, yesCallback, noCallback)
	local p = vgui.Create("YesNoNotification")
	p:MakePopup()
	p:SetMessage(message)
end

net.Receive("deadremains.notifyer.popup", function(bits, ply)
	local message = net.ReadString()
	local mode = net.ReadUInt(8)

	if (mode == 1) then
		-- yes/no dialog
		local p = vgui.Create("YesNoNotification")
		p:MakePopup()
		p:SetMessage(message)
	elseif (mode == 2) then
		-- ok dialog
		local p = vgui.Create("OkNotification")
		p:MakePopup()
		p:SetMessage(message)
	end
end)