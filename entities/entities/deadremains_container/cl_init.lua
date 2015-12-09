include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self.nextPulse = CurTime()
	self.pulseAlpha = 0.8
	self.enabled = false

	self.isContainer = true
end

function ENT:Think()
	if input.IsKeyDown(KEY_Z) and not self.enabled then
		self.enabled = true
	end

	self:NextThink(CurTime() + 0.8)
	return true
end

function ENT:Draw()
	self:DrawModel()

	if (self.nextPulse < CurTime()) and self.enabled then
		self.pulseAlpha = math.Clamp(self.pulseAlpha -0.90 *FrameTime(), 0, 1)
		
		render.SuppressEngineLighting(true)
		render.SetAmbientLight(1, 1, 1)
		render.SetBlend(self.pulseAlpha)
		
		render.SetColorModulation(1, 1, 1)
		
		render.MaterialOverride(outlineWhiteMaterial)
		self:SetModelScale(1.15, 0)
		self:DrawModel()
		
		render.MaterialOverride(0)
		self:SetModelScale(1.0, 0)
		
		render.SuppressEngineLighting(false)
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(self.pulseAlpha)
		
		if (self.pulseAlpha <= 0) then
			self.nextPulse = CurTime() + 1.5
			self.pulseAlpha = 0.8
			self.enabled = false
		end
	end

end