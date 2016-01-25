local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.name = ""
	self.active = false
	self.icon = matCircle
	self.unique = ""

	self.circle_rad = 20
	self.circle_rad_to = 20

end

function ELEMENT:setName(name)

	self.name = name

end

function ELEMENT:setUnique(unique)

	self.unique = unique

end

function ELEMENT:setIcon(icon)

	self.icon = Material(icon, "noclamp smooth")

end

function ELEMENT:setActive(b)

	self.active = b

	if !b then

		self.circle_rad_to = 20

	end

end

function ELEMENT:Paint(w, h)

	self.circle_rad = deadremains.ui.lerp(0.15, self.circle_rad, self.circle_rad_to)

	if LocalPlayer():hasSkill(self.unique) and !self.active then

		surface.SetDrawColor(deadremains.ui.colors.clr4)
		draw.NoTexture()
		draw.Circle(w / 2, h / 2, self.circle_rad, 32)

		surface.SetDrawColor(deadremains.ui.colors.clr12)
		surface.SetMaterial(matCircle)
		surface.DrawTexturedRect(6, 6, w - 12, h - 12)

		surface.SetDrawColor(deadremains.ui.colors.clr4)
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(6, 6, w - 12, h - 12)

	elseif !self.active then

		surface.SetDrawColor(deadremains.ui.colors.clr4)
		draw.NoTexture()
		draw.Circle(w / 2, h / 2, self.circle_rad, 32)

		surface.SetDrawColor(deadremains.ui.colors.clr13)
		surface.SetMaterial(matCircle)
		surface.DrawTexturedRect(6, 6, w - 12, h - 12)

		surface.SetDrawColor(deadremains.ui.colors.clr6)
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(6, 6, w - 12, h - 12)

	else

		surface.SetDrawColor(deadremains.ui.colors.clr4)
		draw.NoTexture()
		draw.Circle(w / 2, h / 2, self.circle_rad, 32)

		surface.SetDrawColor(deadremains.ui.colors.clr11)
		surface.SetMaterial(matCircle)
		surface.DrawTexturedRect(6, 6, w - 12, h - 12)

		surface.SetDrawColor(deadremains.ui.colors.clr4)
		surface.SetMaterial(self.icon)
		surface.DrawTexturedRect(6, 6, w - 12, h - 12)

	end

end

function ELEMENT:OnMousePressed(m)

	if self.active then return end

	local activeMenu = deadremains.ui.getActiveActionMenu()
	if activeMenu then

		activeMenu:Remove()

	end

	self.active = true

	local w, _ = self:GetSize()
	self.circle_rad_to = w / 2

	local x, y = gui.MousePos()
	local actionMenu = vgui.Create("deadremains.skill_action_menu")
	actionMenu:SetSize(190, 40)
	actionMenu:setTitle(self.name)
	actionMenu:setOrigin(x + 15, y)
	actionMenu:setDisableFunc(function() self:setActive(false) end)
	if LocalPlayer():hasSkill(self.unique) then

		actionMenu:addAction("Share", function() end, Material("deadremains/characteristics/sprintspeed.png", "noclamp smooth"))

	else

		actionMenu:addAction("Unlock", function() end, Material("deadremains/characteristics/sprintspeed.png", "noclamp smooth"))

	end

	deadremains.ui.activeActionMenu = actionMenu

end

function ELEMENT:OnCursorEntered()

	self.hovered = true

	if !self.active then

		local w, _ = self:GetSize()
		self.circle_rad_to = w / 2 - 4

	end

end

function ELEMENT:OnCursorExited()

	self.hovered = false

	if !self.active then

		self.circle_rad_to = 20

	end

end
vgui.Register("deadremains.skill_button", ELEMENT, "Panel")