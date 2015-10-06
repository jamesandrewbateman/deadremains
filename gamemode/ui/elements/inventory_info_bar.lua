local ELEMENT = {}
function ELEMENT:Init()

	self.title = ""
	self.max = 0
	self.current = 0

end

function ELEMENT:setMax(num)

	self.max = num

end

function ELEMENT:setCurrent(num)

	self.current = num

end

function ELEMENT:add(num)

	self.current = math.Clamp(self.current + num, 0, self.max)

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr15)
	surface.DrawRect(0, 0, w, h)

	local str = self.current .. "/" .. self.max
	draw.SimpleText(str, "deadremains.menu.infoNumber", w / 2, h / 2, deadremains.ui.colors.clr14, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	surface.SetFont("deadremains.menu.infoNumber")
	local strW, strH = surface.GetTextSize(str)

	draw.SimpleText(self.title, "deadremains.menu.infoText", w / 2 + strW / 2 + 15, h / 2 - strH / 2, deadremains.ui.colors.clr14, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	local frac = math.Clamp(self.current / self.max, 0, 1)
	surface.SetDrawColor(deadremains.ui.colors.clr14)
	surface.DrawRect(0, h - 6, w * frac, 4)

end

function ELEMENT:setTitle(title)

	self.title = title

end
vgui.Register("deadremains.inventory_info_bar", ELEMENT, "Panel")