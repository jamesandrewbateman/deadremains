local ELEMENT = {}
function ELEMENT:Init()

	self.title = ""

	self.actions = {}

	self.origin_x = 0
	self.origin_y = 0

end

function ELEMENT:setOrigin(x, y)

	self.origin_x = x
	self.origin_y = y

	self:SetPos(x, y - 40)

end

function ELEMENT:addAction(name, callback, icon)

	local actions = table.Count(self.actions)
	local w, h = self:GetSize()

	local action = vgui.Create("deadremains.inventory_action_menu_action", self)
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

	local triangle = {

		{x = 0, y = 25},
		{x = 20, y = 15},
		{x = 20, y = 35}

	}

	draw.NoTexture()
	surface.SetDrawColor(deadremains.ui.colors.clr15)
	surface.DrawPoly(triangle)

end
vgui.Register("deadremains.inventory_action_menu", ELEMENT, "Panel")