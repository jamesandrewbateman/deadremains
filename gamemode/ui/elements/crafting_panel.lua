ItemList = ItemList or {}

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
	--PrintTable(items)
	local inv = LocalPlayer().Inventories

	if ItemList ~= nil then

		if ItemList.Weapons ~= nil then

			for k,v in pairs(ItemList.Weapons) do

				v:Remove()

			end

		end

		if ItemList.Consumables ~= nil then

			for k,v in pairs(ItemList.Consumables) do

				v:Remove()

			end

		end

		if ItemList.CraftingItems ~= nil then

			for k,v in pairs(ItemList.CraftingItems) do

				v:Remove()

			end

		end			
	end

	for k,v in pairs(self:GetChildren()) do

		v:Remove()

	end

	ItemList = {}
	ItemList.Weapons = {}
	ItemList.Consumables = {}
	ItemList.CraftingItems = {}

	local entry_size = 64

	local consumes_cat = deadremains.crafting.GetRecipeCategory("consumables")
	local consumes_width = table.Count(consumes_cat) * entry_size

	local weapons_cat = deadremains.crafting.GetRecipeCategory("weapons")
	local weapons_width = table.Count(weapons_cat) * entry_size

	local crftitems_cat = deadremains.crafting.GetRecipeCategory("craftingitems")
	local crftitems_width = table.Count(crftitems_cat) * entry_size


	local current_bottom = 0

	local consume_panel = vgui.Create("deadremains.crafting_panel_category", self)
	consume_panel:SetPos(10, 10)
	consume_panel:SetTitle("Consumables")

	current_bottom = 42

	local depth = 0

	for k,v in pairs(consumes_cat) do

		local listItem = vgui.Create("deadremains.crafting_panel_entry", self)

		listItem:SetItemName(v.item_name)

		listItem:SetPrintName(v.print_name)

		listItem:SetQuantity(v.quantity)

		listItem:SetPos( 14, current_bottom)

		listItem:SetCraftable(items[v.item_name] ~= nil)

		current_bottom = current_bottom + 80

		table.insert(ItemList.Consumables, listItem)

		depth = depth + 1

	end

	current_bottom = current_bottom + 15

	local weapons_panel = vgui.Create("deadremains.crafting_panel_category", self)
	weapons_panel:SetPos(10, current_bottom)
	weapons_panel:SetTitle("Weapons")

	depth = 0

	current_bottom = current_bottom + 32
	for k,v in pairs(weapons_cat) do

		local listItem = vgui.Create("deadremains.crafting_panel_entry", self)

		listItem:SetItemName(v.item_name)

		listItem:SetPrintName(v.print_name)

		listItem:SetQuantity(v.quantity)

		listItem:SetPos( 14, current_bottom)

		listItem:SetCraftable(items[v.item_name] ~= nil)

		current_bottom = current_bottom + 80

		table.insert(ItemList.Weapons, listItem)

		depth = depth + 1

	end

	current_bottom = current_bottom + 15

	local weapons_panel = vgui.Create("deadremains.crafting_panel_category", self)
	weapons_panel:SetPos(10, current_bottom)
	weapons_panel:SetTitle("Crafting Items")

	depth = 0

	current_bottom = current_bottom + 32
	for k,v in pairs(crftitems_cat) do

		local listItem = vgui.Create("deadremains.crafting_panel_entry", self)
		
		listItem:SetItemName(v.item_name)

		listItem:SetPrintName(v.print_name)

		listItem:SetQuantity(v.quantity)

		listItem:SetPos( 14, current_bottom)

		listItem:SetCraftable(items[v.item_name] ~= nil)

		current_bottom = current_bottom + 80

		table.insert(ItemList.CraftingItems, listItem)

		depth = depth + 1

	end
end

function ELEMENT:Think()
end

function ELEMENT:OnMouseWheeled(dt)

	for k,v in pairs(self:GetChildren()) do

		local x,y = v:GetPos()

		v:SetPos(x, y + dt*15)

	end

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr1)

	surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.crafting_panel", ELEMENT, "Panel")


local ELEMENT = {}
function ELEMENT:Init()

	self.ItemName = "Loading..."

	self.PrintName = "Loading..."

	self.CraftEnable = false

	self.Quantity = 0

end

function ELEMENT:SetItemName( item_name )

	self.ItemName = item_name

	if (self.ItemSpawnIcon) then self.ItemSpawnIcon:Remove() end
	if (self.ItemCraftList) then
		self.ItemCraftList:Clear()
		self.ItemCraftList:Remove()
	end

	local item_info = deadremains.item.get(item_name)

	if not item_info then return end

	-- icon setup
	self.ItemSpawnIcon = vgui.Create("SpawnIcon", self)

	self.ItemSpawnIcon:SetModel(item_info.model)

	self.ItemSpawnIcon:SetSize(64, 64)

	self.ItemSpawnIcon:SetTooltip(item_info.label)

	self:SetSize(self:GetParent():GetWide(), self:GetParent():GetWide())

	self.ItemCraftList = vgui.Create( "DScrollPanel", self )
	self.ItemCraftList:SetSize( 180, 64 )
	self.ItemCraftList:SetPos( self:GetParent():GetWide() - 200, 0 )

	-- crafting details setup
	local craft_info = deadremains.crafting.GetItemInfo(item_name)

	local offset = 0
	for k,v in pairs(craft_info.required_mats) do

		if tostring(k) ~= "entry_count" then

			local label_contents = ""

			if type(v) == "table" then

				local item_count = table.Count(v)

				local current_item_index = 1

				for i,j in pairs(v) do
				
					if (current_item_index < item_count) then

						label_contents = label_contents .. tostring(j) .. "x " .. tostring(i) .. "/"
					
					else

						label_contents = label_contents .. tostring(j) .. "x " .. tostring(i)

					end

					current_item_index = current_item_index + 1
				end

			else

				label_contents = tostring(v) .. "x " .. tostring(k)

			end

			local label = vgui.Create("DLabel")

			label:SetText(label_contents)


			label:SetPos(0, offset)


			label:SizeToContents()

			self.ItemCraftList:AddItem(label)

			offset = offset + 15
		end

	end

end

function ELEMENT:SetPrintName( print_name )

	self.PrintName = print_name

end

function ELEMENT:SetQuantity( quantity )

	self.Quantity = quantity

end

function ELEMENT:SetCraftable( craft_bool )

	self.CraftEnable = craft_bool

end

deadremains.netrequest.create("deadremains.craftitem", function(data)
	print("crafted item ", data.name)
end)


function ELEMENT:OnMousePressed()

	if self.CraftEnable then

		deadremains.netrequest.trigger("deadremains.craftitem", { name = self.ItemName })

	end

end

function ELEMENT:Paint(w,h)

	--surface.DisableClipping(true)


	if self:IsHovered() and self.CraftEnable then

		surface.SetDrawColor(deadremains.ui.colors.clr18)

	else

		surface.SetDrawColor(deadremains.ui.colors.clr17)

	end
	-- background
	surface.DrawRect(0,0, self:GetParent():GetWide() - 32, 64)


	-- border
	surface.SetDrawColor(deadremains.ui.colors.clr6)

	surface.DrawOutlinedRect(0, 0, self:GetParent():GetWide() - 31, 65 )

	-- main nname
	draw.SimpleText(self.Quantity .. "x " .. self.PrintName, "deadremains.menu.gridTitle", 14 + 64 + 14, 16, deadremains.ui.colors.clr3, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	--surface.DisableClipping(false)

end
vgui.Register("deadremains.crafting_panel_entry", ELEMENT, "DPanel")


local ELEMENT = {}
function ELEMENT:Init()

	self.Text = "Loading..."

end

function ELEMENT:SetTitle(title)

	self.Text = title

	surface.SetFont("deadremains.menu.gridTitle")

	local w, h = surface.GetTextSize(title)

	self:SetSize(w + 4, h + 4)

end

function ELEMENT:Paint(w, h)

	draw.SimpleText(self.Text, "deadremains.menu.gridTitle", 0, 0, deadremains.ui.colors.clr3, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

end
vgui.Register("deadremains.crafting_panel_category", ELEMENT, "Panel")
