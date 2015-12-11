local ELEMENT = {}
function ELEMENT:Init()

	self:RebuildList()

	self.ScrollOffset = 0

end

function ELEMENT:Rebuild()

	print("rebuilding crafting panel")

	self:RebuildList()

end

function ELEMENT:RebuildList()

	local items = deadremains.crafting.GetCraftableItems(LocalPlayer())
	local inv = LocalPlayer().Inventories

	if self.ItemList ~= nil then

		local toRemove = {}

		for k,v in pairs(self.ItemList) do

			v:Remove()

			table.insert(toRemove, k)

		end

		for k,v in pairs(toRemove) do

			table.remove(self.ItemList, v)

		end

	end

	self.ItemList = {}

	local depth = 0

	for k,v in pairs(deadremains.crafting.recipes) do

		local listItem = vgui.Create("deadremains.crafting_panel_entry", self)

		listItem:SetItemName(k)

		listItem:SetPos(10, depth * 128)

		table.insert(self.ItemList, listItem)

		depth = depth + 1
	end

end

function ELEMENT:Think()

end

function ELEMENT:OnMouseWheeled(dt)
	self.ScrollOffset = self.ScrollOffset or 0
	self.ScrollOffset = self.ScrollOffset - (dt*25)

	if (self.ScrollOffset <= 0) then return end

	local max_y = 0

	for _, v in pairs(self.ItemList) do

			max_y = max_y + v:GetTall()

	end

	if (self.ScrollOffset >= max_y) then return end

	for _, v in pairs(self.ItemList) do

		local x, y = v:GetPos()


		local testY = y + dt * 25

		v:SetPos(10, testY)

	end

end

function ELEMENT:Paint(w, h)

	--surface.SetDrawColor(deadremains.ui.colors.clr1)

	--surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.crafting_panel", ELEMENT, "Panel")


local ELEMENT = {}
function ELEMENT:Init()

end

function ELEMENT:SetItemName( item_name )

	self.ItemName = item_name

	if (self.ItemSpawnIcon) then self.ItemSpawnIcon:Remove() end

	local item_info = deadremains.item.get(item_name)

	if not item_info then return end

	self.ItemSpawnIcon = vgui.Create("SpawnIcon", self)

	self.ItemSpawnIcon:SetModel(item_info.model)

	self.ItemSpawnIcon:SetSize(128, 128)

	self.ItemSpawnIcon:SetTooltip(item_info.label)

	self:SetSize(self:GetParent():GetWide(), 128)

end

function ELEMENT:Paint(w,h)

	surface.SetDrawColor(deadremains.ui.colors.clr14)

	surface.DrawRect(0, 0, w-10, h)

end
vgui.Register("deadremains.crafting_panel_entry", ELEMENT, "DPanel")


local ELEMENT = {}
function ELEMENT:Init()

end

function ELEMENT:Paint(w,h)

	--surface.SetDrawColor(deadremains.ui.colors.clr14)
	--surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.crafting_panel_entry_title", ELEMENT, "Panel")
