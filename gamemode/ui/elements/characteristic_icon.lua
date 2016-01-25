local matCircleSeg = Material("deadremains/characteristics/circle_segment.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.icon = matCircleSeg
	self.name = ""

	self.level = 0

	self.default = 0

	self.id = 0

end

function ELEMENT:setName(name)

	self.name = name

end

function ELEMENT:setIcon(icon)

	self.icon = Material(icon, "noclamp smooth")

end

function ELEMENT:setLevel(num)

	self.level = num

end

function ELEMENT:setDefault(num)

	self.default = num

end

function ELEMENT:setID(num)

	self.id = num

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr4)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(12, 12, w - 24, h - 24)

	for i = 1, 9 do

		surface.SetDrawColor(deadremains.ui.colors.clr13)
		surface.SetMaterial(matCircleSeg)
		surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, -40 * (i - 1))
	end

	if self.level and self.default then

		for i = 1, math.floor(self.default/self.level) * 10 do

			surface.SetDrawColor(deadremains.ui.colors.clr3)
			surface.SetMaterial(matCircleSeg)
			surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, -40 * (i - 1))

		end

	end
end
vgui.Register("deadremains.characteristic_icon", ELEMENT, "Panel")