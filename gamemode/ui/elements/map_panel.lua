local ELEMENT = {}
function ELEMENT:Init()
	self.MapImage = Material("materials/bambo/gm_fork_map.png")
	self.MarkerImage = Material("materials/bambo/cross-mark.png") --32x32

	self.Markers = {}

	--[[ setup cam for rendering
	self.ViewData = {}

	self.ViewData.angles = Angle(90, 0, -90)
	self.ViewData.origin = Vector(0, 0, 1000)

	self.ViewData.drawhud = false
	self.ViewData.drawviewmodel = false
	self.ViewData.dopostprocess = false
	self.ViewData.drawmonitors = false

	self.ViewData.ortho = true
	self.ViewData.ortholeft = -15000
	self.ViewData.orthoright = 15000
	self.ViewData.orthotop = -15000
	self.ViewData.orthobottom = 15000]]

end

function ELEMENT:Think()

end

function ELEMENT:OnMouseWheeled(dt)
end

function ELEMENT:OnMousePressed(keycode)
	
	local x, y = self:ScreenToLocal(gui.MousePos())
	local mousePos = Vector(x,y,0)

	if keycode == MOUSE_LEFT then


		table.insert(self.Markers, mousePos)

	else

		local removeIndex = -1
		local thresholdDist = 32

		local closestMarkerDist = 1000

		for k,v in pairs(self.Markers) do

			local thisDist = v:Distance(mousePos)

			if thisDist <= thresholdDist then

				if thisDist <= closestMarkerDist then

					closestMarkerDist = thisDist

					removeIndex = k

				end

			end

		end

		if removeIndex > 0 then

			table.remove(self.Markers, removeIndex)

		end

	end

end

function ELEMENT:Paint(w, h)
	surface.SetDrawColor(deadremains.ui.colors.clr1)
	surface.DrawRect(0, 0, w, h)

	surface.SetMaterial(self.MapImage)
	surface.SetDrawColor(Color(255,255,255,255))
	surface.DrawTexturedRectUV(0,0, 540,540, 0,0,1,1)

	--[[
	local screenPanelX, screenPanelY = self:LocalToScreen(0, 0)
	self.ViewData.x = screenPanelX
	self.ViewData.y = screenPanelY
	self.ViewData.w = w
	self.ViewData.h = w

	render.RenderView(self.ViewData)


	calculating position of player in 2d space.
	local meWorldPos = LocalPlayer():GetPos()
	local meWorldLen = meWorldPos:Length2D()
	local meWorldDir = LocalPlayer():GetPos():GetNormalized()

	local meWorldViewScale = 0.036 -- 540 / 15000

	local mePanelLen = meWorldLen * meWorldViewScale
	meWorldDir:Mul(mePanelLen)

	surface.DrawCircle((w/2) + meWorldDir.x, (w/2) - meWorldDir.y, 50, Color(0, 230, 0, 255))
	]]

	for k,v in pairs(self.Markers) do

		surface.SetMaterial(self.MarkerImage)
		surface.SetDrawColor(Color(255,255,255,230))
		surface.DrawTexturedRectUV(v.x-16,v.y-16, 32,32, 0,0,1,1)

	end

	-- mouse info
	surface.SetTextPos( 25, h-64 )
	local mx, my = input.GetCursorPos()
	local nx, ny = self:ScreenToLocal(mx, my)
	surface.DrawText("Looking at: (" .. nx .. ", " .. ny .. ")")
end

vgui.Register("deadremains.map_panel", ELEMENT, "Panel")