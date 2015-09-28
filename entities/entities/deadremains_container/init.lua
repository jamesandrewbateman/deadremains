AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_trainstation/trainstation_post001.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:PhysWake()

	self.Meta = {}
	self.Meta["Type"] = "CONTAINER"
	self.Meta["Owner"] = nil
	self.Meta["Capacity"] = {width=10, height=10}

	self:SetNetworkName("ENTID" .. self:EntIndex())

	self.Meta["Flags"] = {}
	self.Meta["Flags"]["Trapped"] = 0
	self.Meta["Flags"]["Locked"] = 0

	self.Meta["Items"] = {}

	table.insert(self.Meta["Items"], {Unique = "tin_beans", SlotPosition = Vector(0, 0, 0)})

	util.AddNetworkString(self:GetNetworkName())
end

function ENT:Think()
end

function ENT:Use(player)
	self:NetworkItems()

	-- hack: can be used to make sure items aren't stolen
	-- 		 when you dc?
	if not self:IsOwner(player) and self:HasFlag("Trapped") then
		sound.Play("ambient/explosions/exp1.wav", self:GetPos(), 75, 100, 0.25)
		util.BlastDamage(self, player, self:GetPos(), 256, math.random(0, 20))

		self:UnsetFlag("Trapped")
		return
	end

	-- unlock and own if no valid owner
	if not self:HasOwner() then
		self:Own(player)
		self:Lock(player)
	end

	self:Open()
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
	-- new container owner.
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
	else
		self:Own()
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
	if self:IsLocked() then print("Container locked.") return end

	net.Start(self:GetNetworkName()..":OpenUI")
	net.Send(player)
end

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