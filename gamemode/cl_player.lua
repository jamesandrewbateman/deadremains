deadremains.netrequest.create("deadremains.syncdata", function() print("Synced data") end)

concommand.Add("deadremains.syncdata", function()
	deadremains.netrequest.trigger("deadremains.syncdata")
end)


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