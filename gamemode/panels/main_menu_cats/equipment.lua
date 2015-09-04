local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	local data = deadremains.inventory.get("head")

	self.inventory_head = self:Add("deadremains.inventory")
	self.inventory_head:setInventory(inventory_index_head, data)

	data = deadremains.inventory.get("chest")

	self.inventory_chest = self:Add("deadremains.inventory")
	self.inventory_chest:setInventory(inventory_index_chest, data)

	data = deadremains.inventory.get("feet")

	self.inventory_feet = self:Add("deadremains.inventory")
	self.inventory_feet:setInventory(inventory_index_feet, data)

	data = deadremains.inventory.get("primary")

	self.inventory_primary = self:Add("deadremains.inventory")
	self.inventory_primary:setInventory(inventory_index_primary, data)

	data = deadremains.inventory.get("secondary")

	self.inventory_secondary = self:Add("deadremains.inventory")
	self.inventory_secondary:setInventory(inventory_index_secondary, data)

	data = deadremains.inventory.get("back")

	self.inventory_back = self:Add("deadremains.inventory")
	self.inventory_back:setInventory(inventory_index_back, data)

	data = deadremains.inventory.get("legs")

	self.inventory_legs = self:Add("deadremains.inventory")
	self.inventory_legs:setInventory(inventory_index_legs, data)

	self.model = self:Add("DModelPanel")
	self.model:SetModel(LocalPlayer():GetModel())
	self.model:SetSize(264, 500)
	self.model:SetFOV(36)

	function self.model.LayoutEntity(_self, entity)
		local sequence = entity:LookupSequence("idle")
		
		entity:SetAngles(Angle(0, 45, 0))
		entity:ResetSequence(sequence)
		
		--if (!self.bodyGroups) then
		--	self.skins = entity:SkinCount()
		--	self.bodyGroups = entity:GetNumBodyGroups()
		--end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local w, h = self:GetSize()

	local padding_x = 25 * STORE_SCALE_X
	local padding_y = 25 * STORE_SCALE_Y
	local seperator_x = 16 * STORE_SCALE_X
	local seperator_y = 16 * STORE_SCALE_Y

	-- for each inventory, we must scale it according to the size of the parent panel?
	-- print(w, h)
	-- 700 593
	-- 700 480
	self.inventory_head:SetPos(padding_x, padding_y)

	local height = padding_y + self.inventory_head:GetTall() + seperator_y
	self.inventory_chest:SetPos(padding_x, height)

	height = height + self.inventory_chest:GetTall() + seperator_y
	self.inventory_feet:SetPos(padding_x, height)

	local width = padding_x + self.inventory_back:GetWide()
	self.inventory_back:SetPos(w - width, padding_y)

	width = padding_x + self.inventory_legs:GetWide()
	height = padding_y + self.inventory_secondary:GetTall() + self.inventory_legs:GetTall() + seperator_y

	local back_x, back_y = self.inventory_back:GetPos()
	self.inventory_legs:SetPos(w - width, back_y + self.inventory_back:GetTall() + seperator_y)


	self.model:SetPos(w * 0.5 - self.model:GetWide() * 0.5, -50 * STORE_SCALE_Y)

	local model_x, model_y = self.model:GetPos()
	model_y = model_y + self.model:GetTall()

	height = padding_y + self.inventory_primary:GetTall()
	self.inventory_primary:SetPos(padding_x, model_y - padding_y)

	local legs_x, legs_y = self.inventory_legs:GetPos()
	local primary_x, primary_y = self.inventory_primary:GetPos()

	width = padding_x + self.inventory_secondary:GetWide()
	self.inventory_secondary:SetPos(w - width, primary_y)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	a=self
	draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
end

vgui.Register("deadremains.equipment", panel, "EditablePanel")