local ELEMENT = {}
function ELEMENT:Init()

	self.cats = {}
	self.cats_tabs = {}

end

function ELEMENT:Paint()

end

function ELEMENT:updateOrder(tab)

	local newActive = tab.order

	for _, v in pairs(self.cats_tabs) do

		v:Remove()

	end

	local pos = 2
	for _, v in SortedPairsByMemberValue(self.cats, "pos") do

		print("Pos", pos)
		PrintTable(v)

		if v.pos == newActive then

			self.cats_tabs[1] = vgui.Create("deadremains.category_tab", self)
			self.cats_tabs[1]:SetPos(0, 0)
			self.cats_tabs[1]:SetSize(100, 100)
			self.cats_tabs[1]:setPanel(v.panel)
			self.cats_tabs[1]:setIcon(v.icon)
			self.cats_tabs[1]:setActive(true)
			self.cats_tabs[1].order = v.pos
			self.cats_tabs[1].DoClick = function(tab)

				for _, v in pairs(self.cats_tabs) do

					v:setActive(false)

				end

				tab:setActive(true)

				self:updateOrder(tab)

			end

		else

			self.cats_tabs[pos] = vgui.Create("deadremains.category_tab", self)
			self.cats_tabs[pos]:SetPos(0, (100 + 2) * (pos - 1))
			self.cats_tabs[pos]:SetSize(100, 100)
			self.cats_tabs[pos]:setPanel(v.panel)
			self.cats_tabs[pos]:setIcon(v.icon)
			self.cats_tabs[pos]:setActive(false)
			self.cats_tabs[pos].order = v.pos
			self.cats_tabs[pos].DoClick = function(tab)

				for _, v in pairs(self.cats_tabs) do

					v:setActive(false)

				end

				tab:setActive(true)

				self:updateOrder(tab)

			end

			pos = pos + 1

		end

	end

end

function ELEMENT:addCategory(icon, p, pos)

	self.cats[pos] = {icon = icon, panel = p, pos = pos}

	self.cats_tabs[pos] = vgui.Create("deadremains.category_tab", self)
	self.cats_tabs[pos]:SetPos(0, (100 + 2) * (pos - 1))
	self.cats_tabs[pos]:SetSize(100, 100)
	self.cats_tabs[pos]:setPanel(p)
	self.cats_tabs[pos]:setIcon(icon)
	self.cats_tabs[pos]:setActive(false)
	self.cats_tabs[pos].order = pos
	self.cats_tabs[pos].DoClick = function(tab)

		for _, v in pairs(self.cats_tabs) do

			v:setActive(false)

		end

		tab:setActive(true)

		self:updateOrder(tab)

	end

	if pos == 1 then

		self.cats_tabs[pos]:setActive(true)

	end

end
vgui.Register("deadremains.category_tab_list", ELEMENT, "Panel")