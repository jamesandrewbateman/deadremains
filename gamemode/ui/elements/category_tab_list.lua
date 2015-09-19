local ELEMENT = {}
function ELEMENT:Init()

	self.cats = {}
	self.cats_tabs = {}

end

function ELEMENT:Paint()

end

function ELEMENT:setActiveCategory(pos)

	local ntab = self.cats_tabs[pos]
	ntab:setActive(true)

	local curTabT = self.cats[1]
	local curPos = curTabT.pos
	local curTab = self.cats_tabs[1]
	print(curPos)
	curTab:SetPos(0, (100 + 2) * (curPos - 1))

	table.remove(self.cats, pos)
	table.remove(self.cats_tabs, pos)

	table.insert(self.cats, curPos, curTabT)
	table.insert(self.cats_tabs, curPos, curTab)

	for kpos, vtab in pairs(self.cats_tabs) do

		vtab:SetPos(0, (100 + 2) * (kpos - 1))

	end

	PrintTable(self.cats)
	PrintTable(self.cats_tabs)

end

function ELEMENT:addCategory(icon, p, pos)

	self.cats[pos] = {icon = icons, panel = p, pos = pos}

	self.cats_tabs[pos] = vgui.Create("deadremains.category_tab", self)
	self.cats_tabs[pos]:SetPos(0, (100 + 2) * (pos - 1))
	self.cats_tabs[pos]:SetSize(100, 100)
	self.cats_tabs[pos]:setPanel(p)
	self.cats_tabs[pos]:setIcon(icon)
	self.cats_tabs[pos]:setActive(false)
	self.cats_tabs[pos].DoClick = function()

		for _, v in pairs(self.cats_tabs) do

			v:setActive(false)

		end

		self:setActiveCategory(pos)

	end

	if pos == 1 then self.cats_tabs[pos]:setActive(true) end

end
vgui.Register("deadremains.category_tab_list", ELEMENT, "Panel")