//Health
Q.CalcPerc = function( value, max )
	return value / max
end

local huds = {
	["Health"] = {
	
		r = 60,
		t = 5,
		x = ScrW()*0.075,
		y = ScrH()*0.8 - 10,
		sa = -90, 
		ea = 270,
		rough = 1,
		c = Color(159, 226, 7, 240),//Color(247, 152, 37,240),
		
		getPerc = function() return Q.CalcPerc(LocalPlayer():Health(), 100) end,
		getVal = function() return LocalPlayer():Health() end,
		getColour = function() local per = Q.CalcPerc(LocalPlayer():Health(), 100) return Color(Lerp(per, 236, 159), Lerp(per, 32, 226), Lerp(per, 36, 37), 240 ) end,
	},
	["Thirst"] = {
	
		r = 50,
		t = 5,
		x = ScrW()*0.075 + 130,
		y = ScrH()*0.8,
		sa = -90, 
		ea = 270,
		rough = 1,
		c = Color( 41, 170, 225,240),
		
		getPerc = function() if LocalPlayer().Vitals == nil then return 1 else return Q.CalcPerc(LocalPlayer().Vitals.Thirst.Value,LocalPlayer().Vitals.Thirst.Max) end end,
		getVal = function() if LocalPlayer().Vitals == nil then return 1 else return  math.Round(Q.CalcPerc(LocalPlayer().Vitals.Thirst.Value,LocalPlayer().Vitals.Thirst.Max) * 100) end end
	},
	["Hunger"] = {
	
		r = 50,
		t = 5,
		x = ScrW()*0.075 + 250,
		y = ScrH()*0.8,
		sa = -90, 
		ea = 270,
		rough = 1,
		c = Color(236, 32, 36),//Color(150,240,40,240),
		
		getPerc = function() if LocalPlayer().Vitals == nil then return 1 else return Q.CalcPerc(LocalPlayer().Vitals.Hunger.Value,LocalPlayer().Vitals.Hunger.Max) end end,
		getVal = function() if LocalPlayer().Vitals == nil then return 1 else return math.Round(Q.CalcPerc(LocalPlayer().Vitals.Hunger.Value,LocalPlayer().Vitals.Hunger.Max) * 100) end end
	}
}
local bg_colour = Color(240,240,240, 30)

hook.Add("HUDPaint", "dr.hud.Vitals", function()
	if LocalPlayer().Vitals != nil then
		for k,arc in pairs(huds)do
			//Text
			surface.SetFont( "dr.hud.vitals" )
			local w, h = surface.GetTextSize( arc.getVal() )
			draw.DrawText( arc.getVal(), "dr.hud.vitals", arc.x - 1, arc.y - (h/2), arc.c, TEXT_ALIGN_CENTER )
			
			arc.ea = math.Round(Lerp( 8 * FrameTime(), arc.ea, math.min(math.max((arc.getPerc() * 360) - 90 , -90), 270) ))
			//if the its hp, change the color to something fancy
			if k == "Health" then arc.c = arc.getColour() end
			draw.Arc(arc.x,arc.y,arc.r*0.95,arc.t*0.5,0,360,arc.rough,bg_colour, true)
			draw.Arc(arc.x,arc.y,arc.r,arc.t,arc.sa,arc.ea,arc.rough,arc.c, true)
		end
	end
end)

//Remove default HUD
hook.Add( "HUDShouldDraw", "hide hud", function( name )
	 if name == "CHudHealth" then//or name == "CHudBattery" then
		 return false
	 end
end )