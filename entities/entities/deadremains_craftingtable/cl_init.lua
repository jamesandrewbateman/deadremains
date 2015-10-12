include("shared.lua")

function ENT:Initialize()
	self.Meta = {}
	self.Meta["Capacity"] = {width = 5, height = 5}
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
		-- print("Updating container size...")
		self.Meta["Capacity"].width = net.ReadUInt(8)
		self.Meta["Capacity"].height = net.ReadUInt(8)
	end)

	net.Receive(self:GetNetworkName() .. ":OpenUI", function(bits)
		-- print("Opening panel...")
		local frame = vgui.Create("deadremains.container.frame")
		frame:SetGridSize(self.Meta["Capacity"].width, self.Meta["Capacity"].height)

		-- for slot_grid bg colour drawing
		-- get items.
		frame:LinkEntity(self)
	end)


	self.label = "Crafting\nTable"
end


function ENT:Draw()
	self:DrawModel()
end

-- clientside UI
local PANEL = {}

function PANEL:OnRemove()
	print("re-opening the container.")
	if IsValid(self.LinkedEntity) then
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
	local slots_background = vgui.Create("deadremains.container.slot_grid", self)
	slots_background.LinkedEntity = ent
end

-- where i handle all the clicking events.
function PANEL:SetTargetPos(slot_x, slot_y)
	self.TargetSlot = {x = slot_x, y = slot_y}

	-- slot_x, slot_y are relative to the frame position.
	-- inside the x/y bounds of this panel..
	if self.TargetSlot.x > self.GridSize.width or self.TargetSlot.x < 0 or self.TargetSlot.y > self.GridSize.height or self.TargetSlot.y < 0 then
		-- move the item
		print("Move item: ", self.SelectedSlot.x .. ", " .. self.SelectedSlot.y)
		print("to:", self.TargetSlot.y .. ", " .. self.TargetSlot.y)
	else
		print("Take item: ", self.SelectedSlot.x .. ", " .. self.SelectedSlot.y)
		print("to:", self.TargetSlot.y .. ", " .. self.TargetSlot.y)
	end
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
	self:SetSize(slotWidth * width, slotHeight * height + 32)

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
	table.insert(self.CraftableItems, deadremains.item.get("tin_beans"))
	table.insert(self.CraftableItems, deadremains.item.get("hunting_backpack"))

	-- build a table of model panels for items.
	self.ItemModelPanels = {}
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
	end

	-- now the craftable item section

	-- craft button.
	local button = vgui.Create("DButton", self)
	local pWidth, pHeight = self:GetSize()
	button:SetText("CRAFT")
	button:SetPos(0, pHeight-32)
	button:SetSize(pWidth, 32)
	button.Paint = function (self, w, h)
		draw.RoundedBox(0, 0,0, w,h, Color(30, 30, 30, 255))
	end
	button.DoClick = function (self)
		sound.Play("ambient/energy/spark6.wav", LocalPlayer():GetPos(), 75, 100, 0.25)

		local effPos = self:GetParent().LinkedEntity:GetPos()
		local effData = EffectData()
		effData:SetStart(effPos)
		effData:SetOrigin(effPos)
		effData:SetScale(25)
		util.Effect("ManhackSparks", effData)
	end

	self:RebuildCraftableItemPanel()
end

function PANEL:RebuildCraftableItemPanel()
	local slotWidth, slotHeight = self:GetParent().SlotWidth, self:GetParent().SlotHeight

	local width, height = self:GetSize()

	for k,v in pairs(self.CraftableItems) do
		local unique = v.unique
		local i_data = deadremains.item.get(unique)

		local i = vgui.Create("DModelPanel", self:GetParent())
		i:SetSize(slotWidth/2, slotHeight/2)

		local offsetX = (slotWidth/4) + ((slotWidth/2) * (k-1))
		i:SetPos(offsetX, height + 4)

		i:SetModel(i_data.model)
		i:SetCamPos(i_data.cam_pos)
		i:SetLookAt(i_data.look_at)
		i:SetFOV(i_data.fov)

		i.Unique = unique
		i.DoClick = function(self)
			print(self.Unique)
		end
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