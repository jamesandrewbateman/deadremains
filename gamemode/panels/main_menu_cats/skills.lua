local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	--self:DockPadding(25, 25, 25, 25)
	--self:SetTall(340 * STORE_SCALE_Y)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

local skill_circle = Material("materials/deadremains/skills/circle.png")

surface.CreateFont("deadremains.skill", {font = "Bebas Neue", size = 36, weight = 400})

function panel:addCategory(name, type)
	local panel = self:Add("Panel")
	function panel:Paint(w, h)
		draw.SimpleText(name, "deadremains.skill", w *0.5, 0, panel_color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		--draw.simpleOutlined(0,0,w,h,color_red)
	end

	-- this panel is 350 wide 
	local skills = deadremains.settings.get("skills")

	local y = 64 * STORE_SCALE_Y

	for unique, data in pairs(skills) do
		if (data.type == type) then
			local icon = panel:Add("DImage")
			icon:SetImage(data.icon)
			icon:SetSize(64 * STORE_SCALE_X, 64 * STORE_SCALE_Y)
			icon:SetPos((64*STORE_SCALE_X)*0.5, y)
			icon:SetMouseInputEnabled(true)

			function icon:Paint(w, h)
				local alpha = self:GetAlpha()
				local has_skill = LocalPlayer():hasSkill(unique)

				if (has_skill) then

					if (self.Hovered) then
						draw.material(0, 0, w, h, color_white, skill_circle)
						draw.material(4, 4, w -8, h -8, Color(240, 155, 28), skill_circle)
					else
						draw.material(0, 0, w, h, Color(85, 161, 63), skill_circle)
					end
					
					if (alpha != 255) then
						self:SetAlpha(255)
					end
				else
					draw.material(0, 0, w, h, Color(255, 255, 255, 80), skill_circle)

					if (alpha != 80) then
						self:SetAlpha(80)
					end
				end

				DImage.Paint(self, w, h)
			end
			
			y = y + (32 * STORE_SCALE_Y) + (48 * STORE_SCALE_Y)
		end
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local w, h = self:GetSize()
	local children = self:GetChildren()

	for k, child in pairs(children) do
		local width = math.Round(math.ceil(w /5 -25 *0.5))

		child:SetPos(width *(k -1) +25, 25)
		child:SetSize(width, h -25 *2)
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	draw.RoundedBox(2, 0, 0, w, h, panel_color_background)
end

vgui.Register("deadremains.skills", panel, "EditablePanel")