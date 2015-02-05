//Slot
local PANEL = {}

//Fancy Stuff////////////////////////
local function ColorLightness( c, l )
	return Color( c.r * l, c.g * l, c.b * l, c.a )
end

local function DrawBox( w, h, c )	
	surface.SetDrawColor( ColorLightness( c, 1.6 ) )
	surface.DrawOutlinedRect( 0, 0, w, h )
	
	surface.SetDrawColor( c )
	surface.DrawRect( 1, 1, w - 2, h - 2 )
end

local DefaultColor = Color( 65, 65, 65 )
local HoveredColor = ColorLightness( DefaultColor, 1.5 )
////////////////////////////////////
//Color(20,40,55)
function PANEL:Init()
	self:SetPos( 0, 0 )
	self:SetSize( self:GetParent().Data.factor, self:GetParent().Data.factor )
	self:Receiver( "item", 
		function(pnl, tbl, dropped, menuIndex) 
			
			if dropped then
				print("FROM")
				PrintTable(tbl[1].OldPos)
				print("TO")
				PrintTable(self.Pos)
				//Request to change the position on the server using self.Pos
				local owner = LocalPlayer()
				//Just to keep consistent with client; handle it client-side too
				//Make function to check if the space is free
				local free = dr.Inventory.Functions.HasSpace( owner, self:GetParent().Data.Inv, tbl[1].DSize, self.Pos, {self:GetParent().Data.maxX, self:GetParent().Data.maxY} )
				if free != false then
					tbl[1]:SetPos( pnl:GetPos() )
					
					dr.Inventory.Functions.SendRequest( "MoveItem", {
						["ply"] = owner, 
						["inv"] = self:GetParent().Data.Inv, 
						["slot"] = tbl[1].OldPos, 
						["moveto"] = {
							["Ent"] = owner,
							["Inv"] = self:GetParent().Data.Inv,
							["Pos"] = self.Pos,
						}} )
					tbl[1].OldPos = self.Pos
				end
				
			end
		end, {"Test"} )
end

function PANEL:Paint( w, h )
	local c = DefaultColor
	
	-- so we can highlight for item hovers aswell
	if self:IsHovered() or self:IsChildHovered( 1 ) then
		c = HoveredColor
	end
	
	DrawBox( w, h, c )
end

vgui.Register( "Inventory.Slot", PANEL, "DPanel" )

//Item
local PANEL = {}

function PANEL:Init()
	self:SetPos( 0, 0 )
	self:SetSize( self:GetParent().Data.factor, self:GetParent().Data.factor )
	self:Droppable("item")
	//Copy from the Slot funct
	self:Receiver( "item", function(pnl, tbl, dropped, menuIndex) print("AYY") end, {"Test1"} )
end

function PANEL:SetItemSize( size )
	self.DSize = size
	self:SetSize( self:GetParent().Data.factor * size[2], self:GetParent().Data.factor * size[1] )
end

function PANEL:Paint( w, h )
		draw.NoTexture()
		surface.SetDrawColor( Color(20, 40, 55, 200))
		surface.DrawRect( 1, 1, w-2, h-2 )
end

vgui.Register( "Inventory.Item", PANEL, "DPanel" )

//Main Panel
local PANEL = {}

function PANEL:Init()
	self.Data = {factor = 60, preX = 0, preY = 0, maxX = 0, maxY = 0}
	self:SetSize( 360, 240 )
	self:Center() 
end

function PANEL:SetInv( data )
	self.Data.Inv = data
	data = LocalPlayer().Inventories[data]
	//Set the background panels
	for k,v in pairs(data) do
		for k2,v2 in pairs(v) do
		
			self.Data.preX = math.Max(k2 - 1, 0)*self.Data.factor
			self.Data.preY = math.Max(k - 1, 0)*self.Data.factor
			//print("BACK SLOTS: ", k,k2)
			local bk_slot = vgui.Create("Inventory.Slot", self)
			bk_slot:SetPos( self.Data.preX, self.Data.preY )	
			self:SetSize( self.Data.preX + self.Data.factor, self.Data.preY + self.Data.factor )
			bk_slot.Pos = {k,k2}
			self.Data.maxX, self.Data.maxY = k2, k
		end
	end
	//Reset the x/y
	self.Data.preX = 0
	self.Data.preY = 0
	//Set the item panels
	for k,v in pairs(data) do
		for k2,v2 in pairs(v) do
			if v2 != false then
				if v2.Status == "M" then
					self.Data.preX = math.Max(k2 - 1, 0)*self.Data.factor
					self.Data.preY = math.Max(k - 1, 0)*self.Data.factor
					
					local item = vgui.Create("Inventory.Item", self)
					item.OldPos = {k,k2}
					item:SetPos( self.Data.preX, self.Data.preY )
					item:SetSize( self.Data.factor, self.Data.factor )
					item:SetItemSize( dr.Items.Data.MItems[v2.ItemID].Size )
				end
			end
		end
	end
	

end

vgui.Register( "Inventory", PANEL, "DFrame" )

concommand.Add( "test", function(ply, text) 
	timer.Simple(1, function() 
		if LocalPlayer().Inventories != nil then
			local frame = vgui.Create("Inventory")
			frame:SetInv( "BASIC" )
			frame:MakePopup()
			timer.Simple(10, function() frame:Close() end)
		end
	end)
end)

