local ELEMENT = {}
function ELEMENT:Init()

	self.title = ""

	self.actions = {}

	self.origin_x = 0
	self.origin_y = 0

	self.removeButton = vgui.Create("deadremains.close_button", self)
	self.removeButton:SetSize(15, 15)
	self.removeButton.toRemove = self

end

function ELEMENT:setOrigin(x, y)

	self.origin_x = x
	self.origin_y = y

	self:SetPos(x, y - 40)

	local w, h = self:GetSize()
	self.removeButton:SetPos(w - 25, 12)

end

function ELEMENT:addAction(name, callback, icon)

	local actions = table.Count(self.actions)
	local w, h = self:GetSize()

	local action = vgui.Create("deadremains.action_menu_action", self)
	action:SetPos(20, 35 + 40 * actions)
	action:SetSize(w - 20, 45)
	action:setName(name)
	action:setCallback(callback)
	if icon then action:setIcon(icon) end

	self:SetSize(w, h + 40)

	table.insert(self.actions, action)

end

function ELEMENT:setTitle(title)

	self.title = title

end

function ELEMENT:OnMousePressed(m)

	if m == MOUSE_RIGHT then

		self:Remove()

	end

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr15)
	surface.DrawRect(20, 0, w - 20 - 2, h - 2)

	surface.SetDrawColor(20, 20, 20, 60)
	surface.DrawRect(20, h - 2, w - 20 - 2, 2)
	surface.DrawRect(20 + w - 20 - 2, 0, 2, h)

	draw.SimpleText(self.title, "deadremains.notification.title", 20 + 15, 10, deadremains.ui.colors.clr14, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	local triangle = {

		{x = 0, y = 40},
		{x = 20, y = 30},
		{x = 20, y = 50}

	}

	draw.NoTexture()
	surface.SetDrawColor(deadremains.ui.colors.clr15)
	surface.DrawPoly(triangle)

end
vgui.Register("deadremains.action_menu", ELEMENT, "Panel")