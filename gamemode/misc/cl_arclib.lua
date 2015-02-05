
-- startang and endang are in degrees.
-- radius is the total radius of the outside edge to the center.
function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise)
	local triarc = {}
	local deg2rad = math.pi / 180
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	if bClockwise and (startang < endang) then
		local temp = startang
		startang = endang
		endang = temp
		temp = nil
	elseif (startang > endang) then 
		local temp = startang
		startang = endang
		endang = temp
		temp = nil
	end
	
	
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	if bClockwise then
		step = math.abs(roughness) * -1
		step = -1
	end
	
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(inner, {
			x=cx+(math.cos(rad)*r),
			y=cy+(math.sin(rad)*r)
		})
	end
	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(outer, {
			x=cx+(math.cos(rad)*radius),
			y=cy+(math.sin(rad)*radius)
		})
	end
	
	
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
	-- Return a table of triangles to draw.
	return triarc
	
end

function surface.DrawArc(arc)
	for k,v in ipairs(arc) do
		
		surface.DrawPoly(v)
		
	end
end

function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color,bClockwise)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise))
end

concommand.Add("test_arc", function()
	hook.Remove("HUDPaint", "arcTest")
	
	local arcs = {}
	
	local function AddArc()
		local r = 255
		table.insert(arcs, {
			r = r,
			t = 100,
			x = ScrW()/2,
			y = ScrH()/2,
			sa = -90, 
			ea = 270,
			rough = 0,
			c = Color(math.random(255),math.random(255),math.random(255),math.random(200,255))
		})
	end
	AddArc()
	//timer.Create("AddArc", .5,0,AddArc)
	timer.Simple(5, function()
	hook.Add("HUDPaint", "arcTest", function()
		for k,arc in pairs(arcs)do
			//arc.sa = math.max(arc.sa - 5, 0)
			arc.ea = math.max(arc.ea - 5, -90)
			draw.Arc(arc.x,arc.y,arc.r,arc.t,arc.sa,arc.ea,arc.rough,arc.c, true)
		end
	end)
	end)
end)