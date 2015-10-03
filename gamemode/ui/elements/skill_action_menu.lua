local ELEMENT = {}
function ELEMENT:Init()

	self.title = ""

	self.actions = {}

	self.origin_x = 0
	self.origin_y = 0

	self.removeButton = vgui.Create("deadremains.close_button", self)
	self.removeButton:SetSize(10, 10)
	self.removeButton.toRemove = self

end

function ELEMENT:setOrigin(x, y)

	self.origin_x = x
	self.origin_y = y

	self:SetPos(x, y - 40)

	local w, h = self:GetSize()
	self.removeButton:SetPos(w - 20, 10)

end

function ELEMENT:addAction(name, callback, icon)

	local actions = table.Count(self.actions)
	local w, h = self:GetSize()

	local action = vgui.Create("deadremains.skill_action_menu_action", self)
	action:SetPos(20, 35 + 40 * actions)
	action:SetSize(w - 20, 45)
	action:setName(name)
	action:setCallback(callback)
	if icon then action:setIcon(icon) end

	self:SetSize(w, h + 40)

	table.insert(self.actions, action)

end

function ELEMENT:setDisableFunc(func)

	self.disable = func

end

function ELEMENT:OnRemove()

	self.disable()

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

	draw.SimpleText(self.title, "deadremains.notification.title", 20 + 15, 8, deadremains.ui.colors.clr14, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	local triangle = {

		{x = 0, y = 25},
		{x = 20, y = 15},
		{x = 20, y = 35}

	}

	draw.NoTexture()
	surface.SetDrawColor(deadremains.ui.colors.clr15)
	surface.DrawPoly(triangle)

end
vgui.Register("deadremains.skill_action_menu", ELEMENT, "Panel")