local ELEMENT = {}
function ELEMENT:Init()

	self.name = name

	self.callback = function() end

end

function ELEMENT:setIcon(icon)

	self.icon = icon

end

function ELEMENT:setName(name)

	self.name = name

end

function ELEMENT:setCallback(callback)

	self.callback = callback

end

function ELEMENT:OnCursorEntered()

	self.hovered = true

end

function ELEMENT:OnCursorExited()

	self.hovered = false

end

function ELEMENT:Paint(w, h)

	if self.hovered then

		if self.icon then

			surface.SetDrawColor(deadremains.ui.colors.clr16)
			surface.SetMaterial(self.icon)
			surface.DrawTexturedRect(w - 40 - 10, 0, 40, 40)

		end

		draw.SimpleText(self.name, "deadremains.notification.action", 10, h / 2, deadremains.ui.colors.clr16, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	else

		if self.icon then

			surface.SetDrawColor(deadremains.ui.colors.clr14)
			surface.SetMaterial(self.icon)
			surface.DrawTexturedRect(w - 40 - 10, 0, 40, 40)

		end

		draw.SimpleText(self.name, "deadremains.notification.action", 10, h / 2, deadremains.ui.colors.clr14, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

end
vgui.Register("deadremains.action_menu_action", ELEMENT, "Panel")