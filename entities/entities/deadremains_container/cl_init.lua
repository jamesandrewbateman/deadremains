include("shared.lua")

function ENT:Initialize()
	self.Meta = {}
	self.Meta["Capacity"] = {width = 1, height = 1}
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

	-- sent on player use. called before openUI
	net.Receive(self:GetNetworkName() .. ":ContainerSize", function(bits)
		print("Updating container size...")
		self.Meta["Capacity"].width = net.ReadUInt(8)
		self.Meta["Capacity"].height = net.ReadUInt(8)
	end)

	net.Receive(self:GetNetworkName() .. ":OpenUI", function(bits)
		print("Opening panel...")
		local frame = vgui.Create("deadremains.container.frame")
		frame:SetGridSize(self.Meta["Capacity"].width, self.Meta["Capacity"].height)

		-- for slot_grid bg colour drawing.
		frame:LinkEntity(self)
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
	local sWidth, sHeight = 32, 32

	self.ScaleWidth = math.Clamp(1, 2, scrW / dWidth)
	self.ScaleHeight = math.Clamp(1, 2, scrH / dHeight)

	self.SlotWidth = self.ScaleWidth * sWidth
	self.SlotHeight = self.ScaleHeight * sHeight

	self.SlotGridMarginX = 18 * self.ScaleWidth
	self.SlotGridMarginY = 18 * self.ScaleHeight

	self.SlotGridPaddingX = 9 * self.ScaleWidth
	self.SlotGridPaddingY = 18 * self.ScaleWidth

	self.SelectedSlot = {}
	self.TargetSlot = {}
	self.FirstSelect = true

	-- so we can reference the entity container when items move.
	self.LinkedEntity = nil

	self:SetDeleteOnClose(true)
	self:SetTitle("Container")
	self:MakePopup()
end

-- in slots.
function PANEL:SetGridSize(width, height)
	self.GridSize = {width = width, height = height}
end

function PANEL:LinkEntity(ent)
	self.LinkedEntity = ent

	-- now we can open this panel
	local slots_background = vgui.Create("deadremains.container.slot_grid", self)
end

function PANEL:SetTargetPos(slot_x, slot_y)
	self.TargetSlot = {x = slot_x, y = slot_y}
end

vgui.Register("deadremains.container.frame", PANEL, "DFrame")


-- this panel is just a display under the floating panel icons.
local PANEL = {}

function PANEL:Init()
	if not self:GetParent() then
		print("NO PARENT FOR SLOT GRID")
		return
	end

	if not IsValid(self:GetParent().LinkedEntity) then
		print("NO ENTITY LINKED TO FRAME")
	end


	local gridSize = self:GetParent().GridSize
	-- size in slots.
	local width, height = gridSize.width, gridSize.height

	-- calculate the size in pixels needed to contain this number of slots.
	local slotWidth, slotHeight = self:GetParent().SlotWidth, self:GetParent().SlotHeight
	self:SetSize(slotWidth * width, slotHeight * height)

	-- resize our frame to fit these slots
	local currentWidth, currentHeight = self:GetSize()
	self:GetParent():SetSize(currentWidth + self:GetParent().SlotGridMarginX,
							currentHeight + self:GetParent().SlotGridMarginY + self:GetParent().SlotGridPaddingY)

	-- reposition our frame (clipping occurs else.)
	local oX, oY = self:GetParent():GetPos()
	oX = oX + self:GetParent().SlotGridPaddingX
	oY = oY + self:GetParent().SlotGridPaddingY

	self:SetPos(oX, oY)


	-- build a table of model panels for items.
	self.ItemModelPanels = {}
	for k,v in pairs(self:GetParent().LinkedEntity.Meta["Items"]) do
		local unique = v.Unique
		local slotpos = v.SlotPosition

		local i_data = deadremains.item.get(unique)

		local i = vgui.Create("DModelPanel", self)
		i:SetSize(i_data.slots_horizontal * slotWidth, i_data.slots_vertical * slotHeight)
		i:SetPos(slotpos.X * slotWidth, slotpos.Y * slotHeight)
		i:SetModel(i_data.model)
	end 
end

function PANEL:Paint(w, h)
	local gridSize = self:GetParent().GridSize
	-- size in slots.
	local width, height = gridSize.width, gridSize.height

	local slotWidth, slotHeight = self:GetParent().SlotWidth, self:GetParent().SlotHeight

	for y = 0, width do
		for x = 0, height do
			draw.RoundedBox(0, x * slotWidth - 2, y * slotHeight - 2, slotWidth + 4, slotHeight + 4, Color(55, 55, 55, 255))
			draw.RoundedBox(0, x * slotWidth, y * slotHeight, slotWidth, slotHeight, Color(45, 45, 45, 165))
		end
	end

	local items = self:GetParent().LinkedEntity.Meta["Items"]
	for k,v in pairs(items) do
		local i = deadremains.item.get(v.Unique)

		local ox = v.SlotPosition.X * slotWidth
		local oy = v.SlotPosition.Y * slotHeight

		local w = i.slots_horizontal * slotWidth
		local h = i.slots_vertical * slotHeight

		draw.RoundedBox(2, ox, oy, w, h, Color(55, 0, 0, 255))
	end
end

function PANEL:OnMousePressed()
	local slot_x, slot_y = self:MouseGridPos()

	if self:GetParent().FirstSelect then
		self:GetParent().SelectedSlot = {x = slot_x, y = slot_y}
	else
		self:GetParent():SetTargetPos(slot_x, slot_y)
	end

	-- flip the selector.
	self:GetParent().FirstSelect = !self:GetParent().FirstSelect
end

function PANEL:MouseGridPos()
	local x, y = input.GetCursorPos()
	x, y = self:ScreenToLocal(x, y)
	-- this is now dx,dy from panel origin.

	local gridX = math.ceil(x / self:GetParent().SlotWidth) - 1
	local gridY = math.ceil(y / self:GetParent().SlotWidth) - 1
	return gridX, gridY

	-- send message to server saying we clicked at this position.

	-- we are then in a state of moving the item or null.
	-- if moving then next mouse press is the attempt assign to position command.
end

vgui.Register("deadremains.container.slot_grid", PANEL, "DPanel")