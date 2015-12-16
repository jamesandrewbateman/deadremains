local ELEMENT = {}
function ELEMENT:Init()
	self.MapImage = Material("materials/bambo/gm_fork_map.png")

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
	]]

	local meWorldPos = LocalPlayer():GetPos()
	local meWorldLen = meWorldPos:Length2D()
	local meWorldDir = LocalPlayer():GetPos():GetNormalized()

	local meWorldViewScale = 0.036 -- 540 / 15000

	local mePanelLen = meWorldLen * meWorldViewScale
	meWorldDir:Mul(mePanelLen)

	surface.DrawCircle((w/2) + meWorldDir.x, (w/2) - meWorldDir.y, 50, Color(0, 230, 0, 255))

	surface.SetTextPos( 25, h-64 )
	local mx, my = input.GetCursorPos()
	local nx, ny = self:ScreenToLocal(mx, my)
	surface.DrawText("Looking at: (" .. nx .. ", " .. ny .. ")")
end

vgui.Register("deadremains.map_panel", ELEMENT, "Panel")