if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Keys"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Rick Darkaliono, philxyz. Bambo revamp."
SWEP.Instructions = "Left click to lock. Right click to unlock"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

if CLIENT then
	SWEP.FrameVisible = false
end

function SWEP:Initialize()
	if SERVER then self:SetWeaponHoldType("normal") end
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local trace = self.Owner:GetEyeTrace()

	if not IsValid(trace.Entity) or not trace.Entity.Meta then
		return
	end

	if not (trace.Entity.Meta["Type"] == "CONTAINER") then
		return
	end
	
	if self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 256 then
		return
	end
	
	print("Locking...")
	trace.Entity:Lock(self.Owner)

	self.Owner:EmitSound(self.Sound)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	local trace = self.Owner:GetEyeTrace()

	if not IsValid(trace.Entity) or not trace.Entity.Meta then
		return
	end

	if not (trace.Entity.Meta["Type"] == "CONTAINER") then
		return
	end
	
	if self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 256 then
		return
	end

	if trace.Entity:IsLocked() then
		print("Unlocking...")
		trace.Entity:Unlock(self.Owner)

		self.Owner:EmitSound(self.Sound)
	end

	self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
end