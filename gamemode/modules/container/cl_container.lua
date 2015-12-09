local containers = containers or {}

local containerUIOpen = false
local containerKeyDown = false
local containerOpenKey = KEY_T

hook.Add("Think", "OpenContainerThink", function()
	if !containerKeyDown then

		if input.IsKeyDown(containerOpenKey) then

			containerKeyDown = true

			if not containerUIOpen then

				deadremains.containers.openUI()

				gui.EnableScreenClicker(true)

				containerUIOpen = true

			end

		end

	end

	if containerKeyDown then

		if !input.IsKeyDown(containerOpenKey) then

			containerKeyDown = false

			if containerUIOpen then

				deadremains.containers.hideUI()

				gui.EnableScreenClicker(false)
				
				containerUIOpen = false

			end

		end

	end


end)

net.Receive("deadremains.networkcontainers", function(bits)
	local nContainerIndex = net.ReadUInt(16)
	local nContainerName = net.ReadString()
	local nContainerSlotX = net.ReadUInt(8)
	local nContainerSlotY = net.ReadUInt(8)

	deadremains.log.write("general", "Rebuilding container (" .. nContainerIndex .. ") " .. nContainerName)

	containers[nContainerIndex] = {
		Name = nContainerName,
		SlotX = nContainerSlotX,
		SlotY = nContainerSlotY,
		Items = {
			-- tin_tuna, tin_beans
		}
	}

	local nItemCount = net.ReadUInt(8)

	for i = 1, nItemCount do

		local nItemName = net.ReadString()

		table.insert(containers[nContainerIndex].Items, nItemName)

		deadremains.log.write("general", "Recieved item " .. nItemName)

	end
end)

deadremains.netrequest.create("deadremains.updatecontainerui", function(data)

	-- called when the container changes serverside.

	-- MAGIC
	print("got update container ui")

	if data then

		local ContainerIndex = data.ContainerIndex

		if base == 0 then

			base = vgui.Create("CONTAINER_BASE")

			base:LoadContainer(ContainerIndex)

		else

			if IsValid(base) then

				base:LoadContainer(ContainerIndex)

			else

				base = vgui.Create("CONTAINER_BASE")

				base:LoadContainer(ContainerIndex)

			end

		end

	end
	
end, true)

-- popup panel --
local CONTAINER_BASE = {}

function CONTAINER_BASE:Init()


end

function CONTAINER_BASE:SetSlotsSize(pSlotX, pSlotY)

	self:SetSize(pSlotX * 70, pSlotY * 70)

	self:Center()

end

function CONTAINER_BASE:LoadContainer(pContainerIndex)

	local thisContainer = containers[pContainerIndex]

	if (thisContainer == nil) then return end

	self:SetSlotsSize(thisContainer.SlotX, thisContainer.SlotY)

	for k,v in pairs(self:GetChildren()) do

		v:Remove()

	end

	local grid = vgui.Create("CONTAINER_GRID", self)

	grid:LoadContainer(pContainerIndex)

end

function CONTAINER_BASE:Paint(w, h)

end
vgui.Register("CONTAINER_BASE", CONTAINER_BASE, "Panel")





-- panel grid --
local CONTAINER_GRID = {}

function CONTAINER_GRID:Init()

	local parentWidth, parentHeight = self:GetParent():GetSize()

	self:SetSize(parentWidth, parentHeight)

	self:SetPos(5, 5)

	--[[
	self:Receiver("dr_container_slot_droppable", function(receiver, droppedPanelsTbl, isDropped, menuIndex, mouseX, mouseY)
		local pnl = droppedPanelsTbl[1]

		local x, y = pnl:GetPos()

		local w, h = pnl:GetSize()

		if isDropped then

			pnl:SetPos(mouseX - w/2, mouseY - h/2)

			--gui.EnableScreenClicker(true)
			self:SetWorldClicker(true)
		end

	end, {})
	]]

end

function CONTAINER_GRID:LoadContainer(pContainerIndex)

	local thisContainer = containers[pContainerIndex]

	if thisContainer == nil then return end

	for k,v in pairs(self:GetChildren()) do

		v:Remove()

	end


	for k,v in pairs(thisContainer.Items) do

		self:AddItem(v, thisContainer.SlotX, thisContainer.SlotY)

	end

	self.ContainerIndex = pContainerIndex

end

function CONTAINER_GRID:AddItem(pItemName, pParentWidth, pParentHeight)

	pParentWidth = pParentWidth * 64
	pParentHeight = pParentHeight * 64

	local listItem = vgui.Create("CONTAINER_SLOT", self)

	listItem:SetItemName(pItemName)

	listItem:SetPos(math.random(-32, pParentWidth - 32), math.random(-32, pParentHeight - 32))

end

function CONTAINER_GRID:RebuildItems()

	self:InvalidateChildren(true)

end

function CONTAINER_GRID:Paint(w, h)

	draw.RoundedBox(4, 0, 0, w, h, Color(155, 155, 155, 100))

end

vgui.Register("CONTAINER_GRID", CONTAINER_GRID, "Panel")




local CONTAINER_SLOT = {}

function CONTAINER_SLOT:Init()

	--self:Droppable("dr_container_slot_droppable")

	self:SetSize(64, 64)

end


function CONTAINER_SLOT:SetItemName(pItemName)

	self.ItemName = pItemName

	local item = deadremains.item.get(pItemName)

	self:SetModel(item.model)

	self:SetLookAt(item.look_at)

	self:SetFOV(item.fov)

	self:SetSize(64 * item.slots_horizontal, 64 * item.slots_vertical)

end

function CONTAINER_SLOT:OnMousePressed()

	if not IsValid(base) or not self:GetParent().ContainerIndex or not self.ItemName then return end

	deadremains.netrequest.trigger("deadremains.updatecontainerui", { container_id = self:GetParent().ContainerIndex, item_action = "take", item_name = self.ItemName })

end

vgui.Register("CONTAINER_SLOT", CONTAINER_SLOT, "DModelPanel")



base = base or 0

function deadremains.containers.openUI()

	local traceEnt = LocalPlayer():GetEyeTrace().Entity

	if traceEnt.isContainer then

		deadremains.netrequest.trigger("deadremains.updatecontainerui", { container_id = traceEnt:GetContainerIndex() })

	end

end

function deadremains.containers.refreshUI()

	if base == nil or base == 0 then return end

end

function deadremains.containers.hideUI()
	
	if base ~= 0 then

		if IsValid(base) then

			base:Remove()

		end

	end
end