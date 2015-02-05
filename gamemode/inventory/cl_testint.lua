//tt
local PANEL = {}

AccessorFunc( PANEL, "m_Item", "Item" )

local function ColorLightness( c, l )
	return Color( c.r * l, c.g * l, c.b * l, c.a )
end

local function DrawBox( w, h, c )	
	surface.SetDrawColor( ColorLightness( c, 1.6 ) )
	surface.DrawOutlinedRect( 0, 0, w, h )
	
	surface.SetDrawColor( c )
	surface.DrawRect( 1, 1, w - 2, h - 2 )
end

local DefaultColor = Color( 64, 64, 64 )
local HoveredColor = ColorLightness( DefaultColor, 1.5 )

function PANEL:Init()
	self:Receiver( "Item", function( self, panels, dropped, menuIndex, x, y )
		if dropped then
			self:SetItem( panels[1] )
		end
	end)
	
	self:SetSize( 60, 60 )
end

function PANEL:SetItem( item )
	-- new item's current slot. (soon to be previous)
	local parent = item:GetParent()
	
	-- idk
	if parent == self then
		return
	end
	
	-- if this slot has an item already,
	-- we'll just go ahead and toss that into
	-- the new item's slot. effectively swapping
	if self.m_Item then
		parent.m_Item = self.m_Item
		self.m_Item:SetParent( parent )
	else
		-- we aren't swapping, so the previous item's
		-- slot no longer owns an item.
		parent.m_Item = nil
	end
	
	-- set parent is good, since it's a derma control
	item:SetParent( self )
	
	-- keep track of it I guess.
	self.m_Item = item
end

function PANEL:Paint( w, h )
	local c = DefaultColor
	
	-- so we can highlight for item hovers aswell
	if self:IsHovered() or self:IsChildHovered( 1 ) then
		c = HoveredColor
	end
	
	DrawBox( w, h, c )
end

derma.DefineControl( "ItemSlot", "", PANEL, "DPanel" )


//Item
PANEL = {}

AccessorFunc( PANEL, "m_ItemObject", "Object" )
AccessorFunc( PANEL, "m_Material", "Material" )

function PANEL:Init()
	self:Droppable( "Item" )
	self:Dock( FILL )
	//self:SetMaterial( table.Random( mat ) )
	
	self:Receiver( "Item", function( self, panels, dropped, menuIndex, x, y )
		if dropped then
			self:GetParent():SetItem( panels[1] )
		end
	end)
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( color_white )
	//surface.SetMaterial( self.m_Material )
	surface.DrawTexturedRect( 0, 0, w, h )
end

derma.DefineControl( "Item", "", PANEL, "DPanel" )