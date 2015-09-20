local ELEMENT = {}
function ELEMENT:Init()

	self.skills = {}
	self.chars = {}

end

function ELEMENT:Think()

end

function ELEMENT:updateLayout()

	local w, _ = self:GetSize()

	for _, skills in pairs(self.skills) do

		local col = skills._pos
		local cols = table.Count(self.skills) + 1

		local row = 1
		for k, panel in pairs(skills) do

			if k != "_pos" then

				panel:SetPos((w / cols) * col - 64 / 2, 45 + 45 + 90 * (row - 1))

				row = row + 1

			end

		end

	end

	local col = 1
	local cols = table.Count(self.chars) + 1
	for _, char in pairs(self.chars) do

		char:SetPos((w / cols) * col - 32, 530)

		col = col + 1

	end

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 0, w, 370)

	local cols = table.Count(self.skills) + 1
	for title, v in pairs(self.skills) do

		draw.SimpleText(title, "deadremains.menu.skill_category", (w / cols) * v._pos, 45, deadremains.ui.colors.clr3, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 372, w, 100)

	draw.SimpleText("CHARACTERISTICS", "deadremains.menu.title", w / 2, 372 + 50, deadremains.ui.colors.clr3, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 474, w, 186)

	surface.SetDrawColor(deadremains.ui.colors.clr5)
	surface.DrawRect(0, h - 1, w, 1)

end

local pos = 1
function ELEMENT:addCategory(title)

	self.skills[title] = {_pos = pos}

	pos = pos + 1

end

function ELEMENT:addSkill(unique, name, icon, type)

	local skill = vgui.Create("deadremains.skill_button", self)
	skill:SetSize(64, 64)
	skill:setName(name)
	skill:setIcon(icon)
	skill:setUnique(unique)

	table.insert(self.skills[type], skill)

end

function ELEMENT:addCharacteristic(id, name, default, icon)

	local char = vgui.Create("deadremains.characteristic_icon", self)
	char:SetSize(64, 64)
	char:setID(id)
	char:setName(name)
	char:setIcon(icon)
	char:setLevel(default)

	table.insert(self.chars, char)

end
vgui.Register("deadremains.skills_panel", ELEMENT, "Panel")