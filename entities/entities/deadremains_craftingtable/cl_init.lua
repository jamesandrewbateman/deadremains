include("shared.lua")

function ENT:Initialize()
	self.Meta = {}
	self.Meta["Capacity"] = {width = 5, height = 5}
	self.Meta["Items"] = {}
	self.Meta["CraftableItems"] = {}

	-- ui hooks to serverside.
	local this = self
	this.LinkedFrame = 0
	this.IsOpen = false

	net.Receive(self:GetNetworkName(), function(bits)
		this.Meta["Items"] = {}

		local item_count = net.ReadUInt(16)

		for i=1, item_count do
			local item_name = net.ReadString()
			local slot_position = net.ReadVector()

			table.insert(this.Meta["Items"], {
				Unique = item_name,
				SlotPosition = slot_position
			})
		end

		if (this.LinkedFrame ~= 0) then
			if this.LinkedFrame:IsValid() then
				this.LinkedFrame:RebuildCraftingPanel()
			end
		end
	end)

	-- sent on player use. called before openUI
	net.Receive(self:GetNetworkName() .. ":ContainerSize", function(bits)
		-- print("Updating container size...")
		this.Meta["Capacity"].width = net.ReadUInt(8)
		this.Meta["Capacity"].height = net.ReadUInt(8)
	end)

	net.Receive(self:GetNetworkName() .. ":OpenUI", function(bits)
		if (this.LinkedFrame ~= 0) then this.LinkedFrame:Remove() this.LinkedFrame = 0 end

		this.IsOpen = false

		-- print("Opening panel...")
		this.LinkedFrame = vgui.Create("deadremains.container.frame")
		this.LinkedFrame:SetGridSize(this.Meta["Capacity"].width, this.Meta["Capacity"].height)

		-- for slot_grid bg colour drawing
		-- get items.
		this.LinkedFrame:LinkEntity(this)
	end)

	net.Receive(self:GetNetworkName() .. ":UpdateCraftables", function(bits)
		if (this.LinkedFrame == 0) then return end

		this.Meta["CraftableItems"] = {}

		local item_count = net.ReadUInt(16)

		for i=1, item_count do
			local item_name = net.ReadString()

			table.insert(this.Meta["CraftableItems"], item_name)
		end

		if (this.LinkedFrame ~= 0) then
			timer.Simple(1, function()
				if this.LinkedFrame:IsValid() then
					this.LinkedFrame:RebuildCraftablesPanel()
				end
			end)
		end
	end)

	self.label = "Crafting\nTable"
end


function ENT:Draw()
	self:DrawModel()
end


-- clientside UI
local PANEL = {}

function PANEL:OnRemove()
	if IsValid(self.LinkedEntity) then
		self.LinkedEntity.IsOpen = true
		net.Start(self.LinkedEntity:GetNetworkName() .. ":CloseUI")
		net.SendToServer()
	end
end

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
	self:SetTitle("Crafting Table")
	self:MakePopup()
end

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0,0, w,50, Color(25,25,25, 255))
end

-- in slots.
function PANEL:SetGridSize(width, height)
	self.GridSize = {width = width, height = height}
end

function PANEL:LinkEntity(ent)
	self.LinkedEntity = ent

	-- now we can open this panel
	self.slots_background = vgui.Create("deadremains.container.slot_grid", self)
	self.slots_background.LinkedEntity = ent
end

function PANEL:Rebuild()
	if (self.slots_background) then
		self.slots_background:Rebuild()
	end
end

function PANEL:RebuildCraftablesPanel()
	if (self.slots_background) then
		self.slots_background:RebuildCraftableItemPanel()
	end
end

function PANEL:RebuildCraftingPanel()
	if (self.slots_background) then
		self.slots_background:RebuildCraftingItemsPanel()
	end
end

-- where i handle all the clicking events.
function PANEL:SetTargetPos(slot_x, slot_y)
	self.TargetSlot = {x = slot_x, y = slot_y}

	-- slot_x, slot_y are relative to the frame position.
	-- inside the x/y bounds of this panel..
	if self.TargetSlot.x > self.GridSize.width or self.TargetSlot.x < 0 or self.TargetSlot.y > self.GridSize.height or self.TargetSlot.y < 0 then
		-- move the item
		--print("Move item: ", self.SelectedSlot.x .. ", " .. self.SelectedSlot.y)
		--print("to:", self.TargetSlot.y .. ", " .. self.TargetSlot.y)
	else
		--print("Take item: ", self.SelectedSlot.x .. ", " .. self.SelectedSlot.y)
		--print("to:", self.TargetSlot.y .. ", " .. self.TargetSlot.y)
	end
end

vgui.Register("deadremains.container.frame", PANEL, "DFrame")


-- this panel is just a display under the floating panel icons.
local PANEL = {}

function PANEL:Rebuild()
	self:RebuildCraftingItemsPanel()
	self:RebuildCraftableItemPanel()
end

function PANEL:Init()
	if not self:GetParent() then
		--print("NO PARENT FOR SLOT GRID")
		return
	end

	if not IsValid(self:GetParent().LinkedEntity) then
		--print("NO ENTITY LINKED TO FRAME")
	end


	local gridSize = self:GetParent().GridSize
	-- size in slots.
	local width, height = gridSize.width, gridSize.height

	-- calculate the size in pixels needed to contain this number of slots.
	local slotWidth, slotHeight = self:GetParent().SlotWidth, self:GetParent().SlotHeight
	self:SetSize(slotWidth * width, (slotHeight * height) + 128)

	-- resize our frame to fit these slots
	local currentWidth, currentHeight = self:GetSize()
	self:GetParent():SetSize(currentWidth + self:GetParent().SlotGridMarginX,
							currentHeight + self:GetParent().SlotGridMarginY + self:GetParent().SlotGridPaddingY/2)

	-- reposition our frame (clipping occurs else.)
	local oX, oY = self:GetParent():GetPos()
	oX = oX + self:GetParent().SlotGridPaddingX
	oY = oY + self:GetParent().SlotGridPaddingY

	self:SetPos(oX, oY)

	-- craftable items currently
	self.CraftableItems = {}

	self:Rebuild()
end

function PANEL:RebuildCraftingItemsPanel()
	if (self.ItemModelPanels ~= nil) then
		for k,v in pairs(self.ItemModelPanels) do
			v:Remove()
		end
	end

	-- build a table of model panels for items.
	self.ItemModelPanels = {}
	local slotWidth, slotHeight = self:GetParent().SlotWidth, self:GetParent().SlotHeight

	for k,v in pairs(self:GetParent().LinkedEntity.Meta["Items"]) do
		local unique = v.Unique
		local slotpos = v.SlotPosition

		local i_data = deadremains.item.get(unique)

		local i = vgui.Create("DModelPanel", self)
		i:SetSize(i_data.slots_horizontal * slotWidth, i_data.slots_vertical * slotHeight)
		i:SetPos(slotpos.X * slotWidth, slotpos.Y * slotHeight)
		i.SlotPosition = {x=slotpos.X, y=slotpos.Y}
		i:SetModel(i_data.model)
		i:SetFOV(i_data.fov)
		i:SetLookAt(i_data.look_at)
		i:SetCamPos(i_data.cam_pos)
		i.DoClick = function(self)
			local grid_panel = self:GetParent()
			grid_panel:DModelPanelMousePressed(self.SlotPosition.x, self.SlotPosition.y)
		end

		table.insert(self.ItemModelPanels, i)
	end

end

function PANEL:RebuildCraftableItemPanel()
	local slotWidth, slotHeight = self:GetParent().SlotWidth, self:GetParent().SlotHeight
	local width, height = self:GetSize()

	if (self.CraftableItemModelPanels ~= nil) then
		for k,v in pairs(self.CraftableItemModelPanels) do
			v:Remove()
		end
	end

	self.CraftableItemModelPanels = {}

	for k,v in pairs(self:GetParent().LinkedEntity.Meta["CraftableItems"]) do
		local unique = tostring(v)
		local i_data = deadremains.item.get(unique)

		local i = vgui.Create("DModelPanel", self:GetParent())
		i:SetSize(slotWidth, slotHeight)

		local offsetX = (slotWidth/4) + ((slotWidth) * (k-1))
		i:SetPos(offsetX, self:GetParent():GetTall()-slotHeight)
		i:SetModel(i_data.model)
		i:SetCamPos(i_data.cam_pos)
		i:SetLookAt(i_data.look_at)
		i:SetFOV(i_data.fov)

		i.Unique = i_data.unique
		i.DoClick = function(self)
			net.Start(self:GetParent().LinkedEntity:GetNetworkName() .. ":CraftItem")
				net.WriteString(i.Unique)
			net.SendToServer()
		end

		table.insert(self.CraftableItemModelPanels, i)
	end
end

function PANEL:Paint(w, h)
	local gridSize = self:GetParent().GridSize
	-- size in slots.
	local width, height = gridSize.width, gridSize.height
	local slotWidth, slotHeight = self:GetParent().SlotWidth, self:GetParent().SlotHeight

	draw.RoundedBox(0, 0, 0, w, h + slotHeight*((#self.CraftableItemModelPanels - 1) / width), Color(55, 55, 55, 255))

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

-- called when any slot model panel is pressed.
function PANEL:DModelPanelMousePressed(slot_x, slot_y)
	print("pressed model panel at ", slot_x, slot_y)

	-- take item from table to inventory.
	net.Start(self:GetParent().LinkedEntity:GetNetworkName() .. ":TakeItem")
		net.WriteVector(Vector(slot_x, slot_y, 0))
	net.SendToServer()
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

local PANEL = {}

function PANEL:Init()

end

function PANEL:Paint(w, h)

end

vgui.Register("deadremains.craftingtable.craftable_item_icon", PANEL, "DPanel")