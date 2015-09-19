local material_health = Material("deadremains/hud/outercircle.png", "noclamp smooth")
local material_health_shadow = Material("vgui/hsv", "noclamp smooth")
local material_health_background = Material("deadremains/hud/innercircle.png", "noclamp smooth")

local health_x, health_y = 100, 256
local health_size = 200


local color_circle_inner = Color(0, 0, 0, 100)
local color_circle_shadow = Color(0, 0, 0, 80)

local ELEMENT = {}
function ELEMENT:Init()

	self:SetSize(deadremains.ui.screenSizeX, deadremains.ui.screenSizeY)
	self:SetPos(0, 0)

	self.offset_hp_x = 0
	self.offset_hp_y = 0

	self.offset_t_x = 0
	self.offset_t_y = 0

	self.offset_h_x = 0
	self.offset_h_y = 0


	self.offset_hp_x_to = 0
	self.offset_t_x_to = 0
	self.offset_h_x_to = 0

	self.offset_hp_y_to = 0
	self.offset_t_y_to = 0
	self.offset_h_y_to = 0


	self.scale = 1
	self.scale_to = 1


	self.health_value = LocalPlayer():Health()
	self.thirst_value = LocalPlayer():GetNWInt("dr_thirst", 0)
	self.hunger_value = LocalPlayer():GetNWInt("dr_hunger", 0)

end

function ELEMENT:minimize()

	self.scale_to = 0.7

	self.offset_hp_x_to = -health_x + deadremains.ui.screenSizeX / 2 - 35 / 2 - 640 - health_size * self.scale_to - 20 + 100
	self.offset_t_x_to = -health_x - 256 + deadremains.ui.screenSizeX / 2 - 35 / 2 - 640 - health_size * self.scale_to * 0.8 - 20 + 100
	self.offset_h_x_to = -health_x - 256 - 192 + deadremains.ui.screenSizeX / 2 - 35 / 2 - 640 - health_size * self.scale_to * 0.8 - 20 + 100

	self.offset_hp_y_to = -health_y + 15
	self.offset_t_y_to = -health_y + 145 + 125
	self.offset_h_y_to = -health_y + 145

end

function ELEMENT:maximize()

	self.scale_to = 1

	self.offset_hp_x_to = 0
	self.offset_t_x_to = 0
	self.offset_h_x_to = 0

	self.offset_hp_y_to = 0
	self.offset_t_y_to = 0
	self.offset_h_y_to = 0

end

function ELEMENT:Paint(w, h)

	self.scale = deadremains.ui.lerp(0.05, self.scale, self.scale_to)

	self.offset_hp_x = deadremains.ui.lerp(0.05, self.offset_hp_x, self.offset_hp_x_to)
	self.offset_hp_y = deadremains.ui.lerp(0.05, self.offset_hp_y, self.offset_hp_y_to)

	self.offset_t_x = deadremains.ui.lerp(0.05, self.offset_t_x, self.offset_t_x_to)
	self.offset_t_y = deadremains.ui.lerp(0.05, self.offset_t_y, self.offset_t_y_to)

	self.offset_h_x = deadremains.ui.lerp(0.05, self.offset_h_x, self.offset_h_x_to)
	self.offset_h_y = deadremains.ui.lerp(0.05, self.offset_h_y, self.offset_h_y_to)

	local health = LocalPlayer():Health()

	if (math.Round(self.health_value) != health) then
		self.health_value = math.Approach(self.health_value, health, 0.7)
	end

	local health_angle = math.NormalizeAngle(360.001 * (1 -self.health_value / 100))

	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x -5 + self.offset_hp_x, h -(health_y + 5) + self.offset_hp_y, health_size * self.scale + 10, health_size * self.scale + 10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x + self.offset_hp_x, h -health_y + self.offset_hp_y, health_size * self.scale, health_size * self.scale)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(248, 153, 36, 255 * 0.9))
	surface.drawSection(health_x + self.offset_hp_x, h -health_y + self.offset_hp_y, health_size * self.scale, health_size * self.scale, 90, 90.001 + health_angle, true)

	draw.SimpleText(LocalPlayer():Health(), "deadremains.hud.big", health_x + health_size * self.scale * 0.5 + self.offset_hp_x, h -(health_y -health_size * self.scale * 0.5) + self.offset_hp_y, Color(248, 153, 36, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


	local thirst = LocalPlayer():GetNWInt("dr_thirst", 0)

	if (math.Round(self.thirst_value) != thirst) then
		self.thirst_value = math.Approach(self.thirst_value, thirst, 0.7)
	end

	local thirst_angle = math.NormalizeAngle(360.001 * (1 -self.thirst_value / 100))

	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x + 256 -5 + self.offset_t_x, h -((health_y -health_size * self.scale * 0.2) + 5) + self.offset_t_y, health_size * self.scale * 0.8 + 10, health_size * self.scale * 0.8 + 10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x + 256 + self.offset_t_x, h -(health_y -health_size * self.scale * 0.2) + self.offset_t_y, health_size * self.scale * 0.8, health_size * self.scale * 0.8)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(0, 174, 239, 255 * 0.9))
	surface.drawSection(health_x + 256 + self.offset_t_x, h -(health_y -health_size * self.scale * 0.2) + self.offset_t_y, health_size * self.scale * 0.8, health_size * self.scale * 0.8, 90, 90.001 + thirst_angle, true)

	draw.SimpleText(thirst, "deadremains.hud.big", health_x + 256 + (health_size * self.scale * 0.8) * 0.5 + self.offset_t_x, h -(health_y -(health_size * self.scale * 1.2) * 0.5) + self.offset_t_y, Color(0, 174, 239, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


	local hunger = LocalPlayer():GetNWInt("dr_hunger", 0)

	if (math.Round(self.hunger_value) != hunger) then
		self.hunger_value = math.Approach(self.hunger_value, hunger, 0.7)
	end

	local hunger_angle = math.NormalizeAngle(360.001 * (1 -self.hunger_value / 100))

	surface.SetMaterial(material_health_shadow)
	surface.SetDrawColor(color_circle_shadow)
	surface.DrawTexturedRect(health_x + 256 + 192 -5 + self.offset_h_x, h -((health_y -health_size * self.scale * 0.2) + 5) + self.offset_h_y, health_size * self.scale * 0.8 + 10, health_size * self.scale * 0.8 + 10)

	surface.SetMaterial(material_health_background)
	surface.SetDrawColor(color_circle_inner)
	surface.DrawTexturedRect(health_x + 256 + 192 + self.offset_h_x, h -(health_y -health_size * self.scale * 0.2) + self.offset_h_y, health_size * self.scale * 0.8, health_size * self.scale * 0.8)

	surface.SetMaterial(material_health)
	surface.SetDrawColor(Color(0, 235, 30, 255 * 0.9))
	surface.drawSection(health_x + 256 + 192 + self.offset_h_x, h -(health_y -health_size * self.scale * 0.2) + self.offset_h_y, health_size * self.scale * 0.8, health_size * self.scale * 0.8, 90, 90.001 + hunger_angle, true)

	draw.SimpleText(hunger, "deadremains.hud.big", health_x + 256 + 192 + (health_size * self.scale * 0.8) * 0.5 + self.offset_h_x, h -(health_y -(health_size * self.scale * 1.2) * 0.5) + self.offset_h_y, Color(0, 235, 30, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end
vgui.Register("deadremains.hud_stats", ELEMENT, "Panel")