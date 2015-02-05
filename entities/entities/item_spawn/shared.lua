AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "item_spawn"
ENT.Author			= "Alig96"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""


function ENT:Initialize()
	self:SetModel( "models/props_c17/chair02a.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor(0, 255, 0, 255) 
	self:DrawShadow( false )
end

if CLIENT then
	function ENT:Draw()
		if CREATEMODE == nil then return end
		if CREATEMODE == true then
			self:DrawModel()
		end
	end
	hook.Add( "PreDrawHalos", "item_spawn_halos", function()
		if CREATEMODE == nil then return end
		if CREATEMODE == true then
			halo.Add( ents.FindByClass( "item_spawn" ), Color( 0, 0, 255 ), 0, 0, 0.1, 0, 1 )
		end
	end )
end