deadremains.netrequest.create("deadremains.syncdata", function() print("Synced data") end)

concommand.Add("deadremains.syncdata", function()
	deadremains.netrequest.trigger("deadremains.syncdata")
end)


hook.Add("PostDrawOpaqueRenderables", "drawItemTooltip", function()
	local trace = LocalPlayer():GetEyeTrace()

	if not IsValid(trace.Entity) then return false end
	if trace.Entity.label == nil then return false end

	local pos = trace.HitPos
	local angle = trace.HitNormal:Angle()

	angle:RotateAroundAxis(angle:Right(), -90)
	angle:RotateAroundAxis(angle:Up(), 90)

	local tW, tH = surface.GetTextSize(trace.Entity.label)
	local scaleSize = sW

	local lines = string.Explode("\n", trace.Entity.label)

	cam.Start3D2D(pos + angle:Up(), angle, 0.5)
			surface.SetFont("deadremains.menu.infoText")
			surface.SetTextColor(Color(230, 230, 230, 240))

			local totalHeight = (table.Count(lines)-1) * 20 + 20
			local maxWidth = 0
			for k,v in pairs(lines) do
				local w, h = surface.GetTextSize(v)
				local ox, oy = -w/2, -h/2

				surface.SetTextPos(ox, oy + (20*(k-1)))
				surface.DrawText(v)

				if ox < maxWidth then maxWidth = ox end
			end

			--surface.DrawText(maxWidth)
			if (trace.Entity.IsOpen) then
				surface.SetDrawColor(0,255,0)
			else
				surface.SetDrawColor(255,0,0)
			end

			surface.DrawRect(-8, totalHeight-8, 16,16)
	cam.End3D2D()
end)