deadremains.netrequest.create("deadremains.syncdata", function() print("Synced data") end)

concommand.Add("deadremains.syncdata", function()
	deadremains.netrequest.trigger("deadremains.syncdata")
end)

deadremains.assets = {}
deadremains.assets.icons = {}
deadremains.assets.icons["FULL"] = Material("bambo/icon_full.png")
deadremains.assets.icons["HYDRATED"] = Material("bambo/icon_hydrated.png")
deadremains.assets.icons["HEALTHY"] = Material("bambo/icon_healthy.png")
deadremains.assets.icons["WARM"] = Material("bambo/icon_warm.png")
deadremains.assets.icons["BOOST"] = Material("bambo/icon_boost.png")
deadremains.assets.icons["PAUSE"] = Material("bambo/icon_pause.png")
deadremains.assets.icons["ATHLETIC"] = Material("bambo/icon_sprint.png")
deadremains.assets.icons["RIPPED"] = Material("bambo/icon_ripped.png")
deadremains.assets.icons["IRON_MAN"] = Material("bambo/icon_ironman.png")

deadremains.assets.icons["COLD"] = Material("bambo/icon_cold.png")
deadremains.assets.icons["STARVATION"] = Material("bambo/icon_starvation.png")
deadremains.assets.icons["DEHYDRATION"] = Material("bambo/icon_dehydration.png")
deadremains.assets.icons["TIREDNESS"] = Material("bambo/icon_tiredness.png")
deadremains.assets.icons["DEPRESSION"] = Material("bambo/icon_depression.png")
deadremains.assets.icons["SICKNESS"] = Material("bambo/icon_sickness.png")
deadremains.assets.icons["BLEEDING"] = Material("bambo/icon_bleeding.png")
deadremains.assets.icons["ZINFECTED_HIT"] = Material("bambo/icon_infected.png")
deadremains.assets.icons["UNCONCIOUS"] = Material("bambo/icon_unconcious.png")
deadremains.assets.icons["HEART_ATTACK"] = Material("bambo/icon_heartattack.png")


hook.Add("RenderScreenspaceEffects", "drawItemTooltip", function()
	local trace = LocalPlayer():GetEyeTrace()

	if not IsValid(trace.Entity) then return false end

	local text = ""
	
	if trace.Entity.GetDRName ~= nil then
		text = trace.Entity:GetDRName()
	elseif trace.Entity.label ~= nil then
		text = trace.Entity.label
	else
		return false
	end

	if (text == nil) then return false end

	--local pos = trace.HitPos
	local pos = trace.Entity:GetPos():ToScreen()

	local tW, tH = surface.GetTextSize(text)
	local scaleSize = sW

	local oldW, oldH = ScrW(), ScrH()
	local lines = string.Explode("\n", text)

	cam.Start2D()
		surface.SetFont("deadremains.menu.label")
		surface.SetTextColor(255,255,255,255)

		local totalHeight = (table.Count(lines)-1) * 20 + 20
		local maxWidth = 0
		for k,v in pairs(lines) do
			local w, h = surface.GetTextSize(v)
			local ox, oy = pos.x-w/2, pos.y-h/2

			surface.SetTextPos(ox, oy + (20*(k-1)))
			surface.DrawText(v)

			if ox < maxWidth then maxWidth = ox end
		end
	cam.End2D()
end)

hook.Add("PostRenderVGUI", "deadremains_draw_status_effects", function()
	local x, y = 0, ScrH()-32

	cam.Start2D()

		surface.SetDrawColor( Color(255,255,255,255) )

		local offset = 0

		for k,v in pairs(deadremains.assets.icons) do

			if LocalPlayer():hasBuffOrDebuff(k) ~= nil then
				if LocalPlayer():hasBuffOrDebuff(k) == 1 then

					surface.SetMaterial(v)
					surface.DrawTexturedRect(x+offset,y,32,32)

					offset = offset + 32
				end
			end

		end

	cam.End2D()
end)