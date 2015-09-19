local matBlur = Material( "pp/blurscreen" )

local ELEMENT = {}
function ELEMENT:Init()

	matBlur:SetFloat( "$blur", 3 )
	matBlur:Recompute()

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

	if deadremains.ui.enableBlur and deadremains.ui.isMenuOpen() then

		surface.SetMaterial(matBlur)
		surface.SetDrawColor(255, 255, 255, 255)

		for i = 0.2, 1, 0.2 do

			matBlur:SetFloat("$blur", 5 * i)
			matBlur:Recompute()

			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0, 0, w, h)

		end

	end

end
vgui.Register("deadremains.blur_screen", ELEMENT, "Panel")