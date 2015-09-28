include("shared.lua")

function ENT:Initialize()
	self.Meta = {}
	self.Meta["Items"] = {}

	net.Receive(self:GetNetworkName(), function(bits)
		self.Meta["Items"] = {}

		local item_count = net.ReadUInt(16)

		for i=1, item_count do
			local item_name = net.ReadString()
			local slot_position = net.ReadVector()

			table.insert(self.Meta["Items"], {
				Unique = item_name,
				SlotPosition = slot_position
			})
		end
	end)

	-- ui hooks to serverside.
	net.Receive(self:GetNetworkName() .. ":OpenUI", function(bits)
		print("Opening panel...")
		local frame = vgui.Create("deadremains.container.frame")
	end)
end


function ENT:Draw()
	self:DrawModel()
end

-- clientside UI
local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()
	local dWidth, dHeight = 400, 300

	local scaleWidth = scrW / dWidth
	local scaleHeight = scrH / dHeight

	local width, height = 400 * scaleWidth, 300 * scaleHeight

	self:SetSize(width, height)
	self:SetColor(Color(245, 245, 245, 200))
	self:MakePopup()
end

function PANEL:SetSlotPosition(newPosition)
	self.SlotPosition = newPosition
	self:SetPos()
end

vgui.Register("deadremains.container.frame", PANEL, "DFrame")
