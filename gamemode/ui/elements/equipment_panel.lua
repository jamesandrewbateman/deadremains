local ELEMENT = {}
function ELEMENT:Init()

	self.head = vgui.Create("deadremains.inventory_grid", self)
	self.head:SetPos(20, 40)
	self.head:setGridSize(2, 2)

	self.headTitle = vgui.Create("deadremains.inventory_grid_title", self)
	self.headTitle:SetPos(20, 12)
	self.headTitle:setTitle("HEAD")


	self.chest = vgui.Create("deadremains.inventory_grid", self)
	self.chest:SetPos(20, 40 + 160)
	self.chest:setGridSize(2, 2)

	self.chestTitle = vgui.Create("deadremains.inventory_grid_title", self)
	self.chestTitle:SetPos(20, 12 + 160)
	self.chestTitle:setTitle("CHEST")


	self.feet = vgui.Create("deadremains.inventory_grid", self)
	self.feet:SetPos(20, 40 + 160 + 160)
	self.feet:setGridSize(2, 2)

	self.feetTitle = vgui.Create("deadremains.inventory_grid_title", self)
	self.feetTitle:SetPos(20, 12 + 160 + 160)
	self.feetTitle:setTitle("FEET")


	self.primary = vgui.Create("deadremains.inventory_grid", self)
	self.primary:SetPos(20, 40 + 160 + 160 + 160)
	self.primary:setGridSize(5, 2)

	self.primaryTitle = vgui.Create("deadremains.inventory_grid_title", self)
	self.primaryTitle:SetPos(20, 12 + 160 + 160 + 160)
	self.primaryTitle:setTitle("PRIMARY")


	self.secondary = vgui.Create("deadremains.inventory_grid", self)
	self.secondary:SetPos(20 + 300 + 20, 40 + 160 + 160 + 160)
	self.secondary:setGridSize(3, 2)

	self.secondaryTitle = vgui.Create("deadremains.inventory_grid_title", self)
	self.secondaryTitle:SetPos(20 + 300 + 20, 12 + 160 + 160 + 160)
	self.secondaryTitle:setTitle("SECONDARY")


	self.legs = vgui.Create("deadremains.inventory_grid", self)
	self.legs:SetPos(20 + 300 + 20 + 60, 40 + 160 + 160)
	self.legs:setGridSize(2, 2)

	self.legsTitle = vgui.Create("deadremains.inventory_grid_title", self)
	self.legsTitle:SetPos(20 + 300 + 20 + 60, 12 + 160 + 160)
	self.legsTitle:setTitle("LEGS")


	self.back = vgui.Create("deadremains.inventory_grid", self)
	self.back:SetPos(20 + 300 + 20 + 60, 40)
	self.back:setGridSize(2, 4)

	self.backTitle = vgui.Create("deadremains.inventory_grid_title", self)
	self.backTitle:SetPos(20 + 300 + 20 + 60, 12)
	self.backTitle:setTitle("BACK")


end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 0, w, h)

end
vgui.Register("deadremains.equipment_panel", ELEMENT, "Panel")