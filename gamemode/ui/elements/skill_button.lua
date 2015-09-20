local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.name = ""
	self.available = false
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
	self.available = LocalPlayer():hasSkill(unique)

end

function ELEMENT:setIcon(icon)

	self.icon = Material(icon, "noclamp smooth")

end

function ELEMENT:Paint(w, h)

	self.circle_rad = deadremains.ui.lerp(0.15, self.circle_rad, self.circle_rad_to)

	if self.available and !self.active then

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

	if self.available then

		self.active = true

		local w, _ = self:GetSize()
		self.circle_rad_to = w / 2

	end

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

		local w, _ = self:GetSize()
		self.circle_rad_to = 20

	end

end
vgui.Register("deadremains.skill_button", ELEMENT, "Panel")