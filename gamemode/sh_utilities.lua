if (CLIENT) then



----------------------------------------------------------------------
-- Purpose:
--		Paints a circle. CREDITS: _Kilburn
----------------------------------------------------------------------

local function drawSection(x, y, w, h, s, a0, a1, cw)
	if cw then a0, a1 = a1, a0 end
	
	a0 = math.tan(math.rad(a0 - s.ang))
	a1 = math.tan(math.rad(a1 - s.ang))
	
	local u1, v1 = 0.5 + s.dx + s.dy * a1, 0.5 + s.dy - s.dx * a1
	local u2, v2 = 0.5 + s.dx + s.dy * a0, 0.5 + s.dy - s.dx * a0
	
	surface.DrawPoly{
		{
			x = x + w * 0.5;
			y = y + h * 0.5;
			u = 0.5;
			v = 0.5;
		};
		{
			x = x + w * u1;
			y = y + h * v1;
			u = u1;
			v = v1;
		};
		{
			x = x + w * u2;
			y = y + h * v2;
			u = u2;
			v = v2;
		};
	}
end

local function angDiff(a, b, cw)
	local d
	if cw then
		d = b - a
	else
		d = a - b
	end
	
	d = math.NormalizeAngle(d)
	if d < 0 then d = d + 360 end
	return d
end

local function angBetween(x, a, b, cw)
	return angDiff(x, a, cw) < angDiff(b, a, cw)
end

--[[
\ 2 /
3 x 1
/ 4 \
]]

local segs = {
	{ang = 0, dx = 0.5, dy = 0};
	{ang = 90, dx = 0, dy = -0.5};
	{ang = 180, dx = -0.5, dy = 0};
	{ang = -90, dx = 0, dy = 0.5};
}

function surface.DrawSection(x, y, w, h, ang_start, ang_end, clockwise)
	local ang_dist = angDiff(ang_end, ang_start, clockwise)
	
	for _,s in ipairs(segs) do
		local a0, a1
		
		if clockwise then
			a0, a1 = s.ang + 45, s.ang - 45
		else
			a0, a1 = s.ang - 45, s.ang + 45
		end
		
		local startsInSection = angBetween(ang_start, a0, a1, clockwise)
		local endsInSection = angBetween(ang_end, a0, a1, clockwise)
		local containsSection = angBetween(a0, ang_start, ang_end, clockwise) and angBetween(a1, ang_start, ang_end, clockwise)
		
		if startsInSection or endsInSection then
			if startsInSection and endsInSection and ang_dist <= 90 then
				-- starts and ends within this section
				drawSection(x, y, w, h, s, ang_start, ang_end, clockwise)
			else
				if startsInSection then
					-- starts inside this section, ends outside
					drawSection(x, y, w, h, s, ang_start, a1, clockwise)
				end
				
				if endsInSection then
					-- starts outside this section, ends inside
					drawSection(x, y, w, h, s, a0, ang_end, clockwise)
				end
			end
		elseif containsSection then
			-- traverses the entire section
			drawSection(x, y, w, h, s, a0, a1, clockwise)
		end
	end
end



end