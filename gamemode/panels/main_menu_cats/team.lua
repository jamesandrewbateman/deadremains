local panel = {}


----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	if not LocalPlayer():inTeam() then
		self.create_button = self:Add("deadremains.button")
		self.create_button:setName("Create")

		function self.create_button:doClick()
			deadremains.team.create()
		end
	end
end

function panel:PerformLayout()
	if not LocalPlayer():inTeam() then
		local w, h = self:GetSize()

		self.create_button:SetPos(10, 10)
		self.create_button:SetSize(104, 30)
	end
end

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, h, Color(255, 0, 0, 255))
end
vgui.Register("deadremains.team", panel, "EditablePanel")