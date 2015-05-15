include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

--local outlineWhiteMaterial = Material("models/debug/debugwhite")

function ENT:Initialize()
	--self.itemData = nil
	
	--self.nextPulse = CurTime()
	--self.pulseAlpha = 0.5
end

--function ENT:Think()
	--local item_id = self:GetItemID()
	
	--if (item_id and self.itemData == nil) then
	--	self.itemData = ecrp.item.GetByNetwork(item_id)
	--end
	
	--self:NextThink(CurTime() +0.5)
	
--	--return true
--end

function ENT:Draw()
	self:DrawModel()
--[[
	if (self.nextPulse < CurTime() and self.itemData and !self.itemData.hidePulsing) then
		self.pulseAlpha = math.Clamp(self.pulseAlpha -0.90 *FrameTime(), 0, 1)
		
		render.SuppressEngineLighting(true)
		render.SetAmbientLight(1, 1, 1)
		render.SetBlend(self.pulseAlpha)
		
		render.SetColorModulation(1, 1, 1)
		
		render.MaterialOverride(outlineWhiteMaterial)
		self:SetModelScale(1.05, 0)
		self:DrawModel()
		
		render.MaterialOverride(0)
		self:SetModelScale(1.0, 0)
		
		render.SuppressEngineLighting(false)
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(self.pulseAlpha)
		
		if (self.pulseAlpha <= 0) then
			self.nextPulse = CurTime() +3
			self.pulseAlpha = 0.5
		end
	end
]]
end