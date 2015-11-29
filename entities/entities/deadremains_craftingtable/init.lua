AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_storagecloset001b.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:PhysWake()

	self.Meta = {}
	self.Meta["Type"] = "CONTAINER"	-- for keys swep to id this ent.
	self.Meta["Owner"] = nil		-- set to the player who is current using it. (UI close detection)
	self.Meta["Capacity"] = {width=5, height=5}	-- default

	self:SetNetworkName("ENTID" .. self:EntIndex())

	self.Meta["Flags"] = {}
	self.Meta["Flags"]["Trapped"] = 0
	self.Meta["Flags"]["Locked"] = 0
	self.Meta["Flags"]["Open"] = 1		-- start open

	self.Meta["Items"] = {}

	util.AddNetworkString(self:GetNetworkName())
	util.AddNetworkString(self:GetNetworkName() .. ":OpenUI")
	util.AddNetworkString(self:GetNetworkName() .. ":ContainerSize")
	util.AddNetworkString(self:GetNetworkName() .. ":TakeItem")
	util.AddNetworkString(self:GetNetworkName() .. ":PutItem")
	util.AddNetworkString(self:GetNetworkName() .. ":CloseUI")
	util.AddNetworkString(self:GetNetworkName() .. ":CraftItem")
	util.AddNetworkString(self:GetNetworkName() .. ":UpdateCraftables")

	net.Receive(self:GetNetworkName() .. ":TakeItem", function(bits, ply)
		if not (self.Meta["Owner"] == ply) then print("Begon!") return end

		local slot_position = net.ReadVector()
		local item = self:GetItemAtSlotPos(slot_position)

		local rFlag = ply:AddItemToInventory("feet", item.unique)
		if rFlag then
			self:RemoveItemAtSlotPos(slot_position)
		end

		self:UpdateCraftables()

		self:NetworkItems()
	end)

	net.Receive(self:GetNetworkName() .. ":PutItem", function(bits, ply)
		if not (self.Meta["Owner"] == ply) then print("Begon you sly person!") return end

		local item_unique = net.ReadString()
		local item_inventory = net.ReadString()
		local item_slot_position = net.ReadVector()

		-- check distance of player.etc

		-- put item into this crafting table, network.
		local isPut = self:AddItem(item_unique)
		if isPut then
			-- remove item from player inventory sv then network cl.
			ply:RemoveItem(item_inventory, item_slot_position)
			ply:NetworkInventory()
		end

		self:UpdateCraftables()

		self:NetworkItems()
	end)

	net.Receive(self:GetNetworkName() .. ":CraftItem", function(bits, ply)
		self:UpdateCraftables()		

		if not (self.Meta["Owner"] == ply) then print("Begon you sly person!") return end

		local requested_craftable_item = net.ReadString()
		local requested_item_quantity = net.ReadInt(8)

		-- check craft item against serverside items and serverside recipes
		local canCraft, craft_count = deadremains.crafting.canCraft(self, requested_craftable_item)

		if not canCraft or not craft_count then ply:ChatPrint("Cannot craft that, bugger off scrublord.") return end

		local item = deadremains.item.get(deadremains.crafting.craft(self, requested_craftable_item))

		-- we can craft
		for i=1, craft_count do
			if ply:AddItemToInventory("feet", item.unique) then
				ply:ChatPrint("Crafted " .. item.unique .. "!")
			else
				ply:ChatPrint("Cannot craft", item.unique)
			end
		end

		self:UpdateCraftables()

		-- now items are removed from the table and the player has the item.
		self:NetworkItems()
	end)

	-- player closes this, then we open it.
	net.Receive(self:GetNetworkName() .. ":CloseUI", function(bits, ply)
		self:SetFlag("Open")

		ply:SetNWString("OpenedContainerID", "")
	end)

	self.label = "Crafting\nTable"
end

function ENT:Think()
end

function ENT:Use(player)
	self:NetworkContainerSize()
	self:NetworkItems()

	-- hack: can be used to make sure items aren't stolen
	-- 		 when you dc?
	if not self:IsOwner(player) and self:HasFlag("Trapped") then
		sound.Play("ambient/explosions/exp1.wav", self:GetPos(), 75, 100, 0.25)
		util.BlastDamage(self, player, self:GetPos(), 256, math.random(0, 20))

		self:UnsetFlag("Trapped")
		return
	end

	self:Open(player)
end

function ENT:StartTouch(entity)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

-- flag functions
function ENT:HasFlag(name)
	return self.Meta["Flags"][name] == 1
end

function ENT:SetFlag(name)
	self.Meta["Flags"][name] = 1
end

function ENT:UnsetFlag(name)
	self.Meta["Flags"][name] = 0
end

-- frontend functions
function ENT:Own(player)
	self.Meta["Owner"] = player
end

function ENT:HasOwner()
	if not IsValid(self.Meta["Owner"]) then return false end

	return self.Meta["Owner"] ~= nil
end

function ENT:IsOwner(player)
	return self.Meta["Owner"] == player
end

function ENT:Lock(player)
	if self:IsOwner(player) then
		self:SetFlag("Locked")
	elseif not self:HasOwner() then	-- no owner, lets own it. :)
		self:Own(player)
		self:SetFlag("Locked")
	end
end

function ENT:Unlock(player)
	if self:IsOwner(player) then
		self:UnsetFlag("Locked")
	end
end

function ENT:IsLocked()
	return self:HasFlag("Locked")
end

function ENT:Open(player)
	if self:IsLocked() then return end
	if not self:HasFlag("Open") then player:ChatPrint("Container already in use.") return end

	local selfPos = self:GetPos()
	local plyPos = player:GetPos()

	if (math.Distance(plyPos.X,plyPos.Y, selfPos.X,selfPos.Y) > 250) then
		return false
	else
		self:UnsetFlag("Open")
		
		net.Start(self:GetNetworkName()..":OpenUI")
		net.Send(player)

		player:SetNWString("OpenedContainerID", self:GetNetworkName())
	end
end


function ENT:AddItem(item_unique)
	local selectedItemCore = deadremains.item.get(item_unique)

	for ox = 0, self.Meta["Capacity"].width - selectedItemCore.slots_horizontal do
		for oy = 0, self.Meta["Capacity"].height - selectedItemCore.slots_vertical do

			local testOriginItem = self:GetItemAt(Vector(ox, oy, 0))
			local slotArea = 0
			-- this one is empty, what about the others?
			if testOriginItem == 0 then
				-- for each slot within the projected new position, is there an item present?
				for dx = 0, selectedItemCore.slots_horizontal - 1 do
					for dy = 0, selectedItemCore.slots_vertical - 1 do
						local testItem = self:GetItemAt(Vector(ox, oy, 0) + Vector(dx, dy, 0))
						if testItem == 0 then
							slotArea = slotArea + 1
						end
					end
				end

				if slotArea >= (selectedItemCore.slots_horizontal * selectedItemCore.slots_vertical) then
					table.insert(self.Meta["Items"], {Unique = item_unique, SlotPosition = Vector(ox, oy, 0)})
					return true
				end
			else
				--print(testOriginItem.Unique)
			end
		end
	end

	return false
end

-- ITEM MOVEMENTS
function ENT:MoveItem(SelectedPos, TargetPos)
	local selectedItem = self:GetItemAt(SelectedPos)
	local targetItem = self:GetItemAt(TargetPos)

	-- empy space where we want to place
	if (targetItem == 0) then
		-- but if we move it here will it overlap another items bounds?

		-- for each slot within the projected new position, is there an item present?
		local selectedItemCore = deadremains.item.get(selectedItem.Unique)
		for dx = 0, selectedItemCore.slots_horizontal do
			for dy = 0, selectedItemCore.slots_vertical do

				-- todo if we find another item which is not itself in this position, fail.
				local testItem = self:GetItemAt(TargetPos + Vector(dx, dy, 0))

				if testItem == 1 then
					return "Could not fit item here."
				end
			end
		end

		-- now we know that SelectedPos item can move to TargetPos
		-- with no collisions.
		selectedItem.SlotPosition = TargetPos
		self:NetworkItems()

		return "Done!"
	else
		return "Could not fit item here sorry."
	end
end

function ENT:RemoveItemAtSlotPos(position)
	local items = self.Meta["Items"]
	local selected_item_index = -1

	for k,v in pairs(items) do
		if v.SlotPosition == position then
			selected_item_index = k
		end
	end

	if selected_item_index > -1 then
		table.remove(self.Meta["Items"], selected_item_index)

		return true
	else
		return false
	end
end

function ENT:GetItemAtSlotPos(position)
	local items = self.Meta["Items"]
	local selected_item = 0

	for k,v in pairs(items) do
		if v.SlotPosition == position then
			selected_item = deadremains.item.get(v.Unique)
		end
	end

	return selected_item
end

function ENT:GetItemAt(position)
	local items = self.Meta["Items"]
	local selected_item = 0

	-- get the item which this point lands inside of.
	for k,v in pairs(items) do
		local x,y,w,h = self:GetItemSlotBBox(v.SlotPosition, v.Unique)

		if position.X >= x and position.X <= x + w then
			if position.Y >= y and position.Y <= y + h then
				-- found an item to select
				selected_item = v
			end
		end
	end

	return selected_item
end

function ENT:CanPlace(position)
end

-- bbox in slots
function ENT:GetItemSlotBBox(slot_position, item_unique)
	local i = deadremains.item.get(item_unique)

	local width = i.slots_horizontal - 1
	local height = i.slots_vertical - 1

	local oX = slot_position.x
	local oY = slot_position.y

	return oX,oY, width,height
end

function ENT:GetItemCount(item_unique)
	local item_count = 0

	for k,v in pairs(self.Meta["Items"]) do
		if (v.Unique == item_unique) then
			item_count = item_count + 1
		end
	end

	return item_count
end

function ENT:RemoveItem(item_unique)
	local remove_list = {}

	local done = false
	for k,v in pairs(self.Meta["Items"]) do
		if not done then
			if (v.Unique == item_unique) then
				table.insert(remove_list, v.SlotPosition)
				done = true
			end
		end
	end

	for k,v in pairs(remove_list) do
		self:RemoveItemAtSlotPos(v)
	end
end

-- NETWORKING
function ENT:NetworkItems()
	local items = self.Meta["Items"]

	net.Start(self:GetNetworkName())
		net.WriteUInt(#items, 16)

		for i=1, #items do
			local thisItem = items[i]
			net.WriteString(thisItem.Unique)
			-- thisItem.Contains is only serverside!
			-- needs a new panel to view contents.
			net.WriteVector(thisItem.SlotPosition)
		end

	-- send to everyone?
	net.Broadcast()
end

function ENT:NetworkContainerSize()
	net.Start(self:GetNetworkName() .. ":ContainerSize")
		net.WriteUInt(self.Meta["Capacity"].width, 8)
		net.WriteUInt(self.Meta["Capacity"].height, 8)
	net.Broadcast()
end

function ENT:UpdateCraftables()
	local craftable_items = deadremains.crafting.getCraftables(self)

	net.Start(self:GetNetworkName() .. ":UpdateCraftables")

		net.WriteUInt(table.Count(craftable_items), 16)

		for k,v in pairs(craftable_items) do
			local thisName = k

			net.WriteString(thisName)
		end

	-- send to everyone?
	net.Broadcast()
end