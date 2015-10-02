local ELEMENT = {}
function ELEMENT:Init()

	self.text = "XXXX"

end

function ELEMENT:setTitle(txt)

	self.text = txt

end

function ELEMENT:Paint(w, h)

	local clr = deadremains.ui.colors.clr8

	if self.hovered then

		clr = deadremains.ui.colors.clr3

	end

	draw.SimpleText(self.text, "deadremains.menu.inventoryTitle", w / 2, h / 2, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if !self.maximized then

		draw.SimpleText("+", "deadremains.menu.inventoryTitle", w - 40, h / 2, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	else

		draw.SimpleText("-", "deadremains.menu.inventoryTitle", w - 40, h / 2, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

end

function ELEMENT:OnCursorEntered()

	self.hovered = true

end

function ELEMENT:OnCursorExited()

	self.hovered = false

end

function ELEMENT:OnMousePressed()

	if self.maximized then

		local inv = self:GetParent()
		inv:minimize()
		self.maximized = false

	else

		local inv = self:GetParent()
		inv:maximize()
		self.maximized = true

	end

end
vgui.Register("deadremains.inventory_title", ELEMENT, "Panel")