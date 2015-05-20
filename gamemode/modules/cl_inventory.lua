deadremains.inventory = {}

local stored = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.inventory.add(inventory_id, panel)
	stored[inventory_id] = panel
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.getitem", function(bits)
	local inventory_id = net:ReadString()
	local unique = net.ReadString()
	local amount = net.ReadUInt(32)
	local x = net.ReadUInt(32)
	local y = net.ReadUInt(32)

	local item = deadremains.item.get(unique)

	if (item) then
		local panel = stored[inventory_id]
	
		if (IsValid(panel)) then
			panel:addItem(item, amount, x, y)
		end
	end
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.removeitem", function(bits)
	local inventory_id = net:ReadString()
	local unique = net.ReadString()
	local amount = net.ReadUInt(32)
	local x = net.ReadUInt(32)
	local y = net.ReadUInt(32)

	local item = deadremains.item.get(unique)

	if (item) then
		local panel = stored[inventory_id]
	
		if (IsValid(panel)) then
			panel:removeItem(item, amount, x, y)
		end
	end
end)

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

net.Receive("deadremains.itemamount", function(bits)
	local inventory_id = net:ReadString()
	local unique = net.ReadString()
	local x = net.ReadUInt(32)
	local y = net.ReadUInt(32)
	local amount = net.ReadUInt(32)

	local item = deadremains.item.get(unique)

	if (item) then
		local panel = stored[inventory_id]
	
		if (IsValid(panel)) then
			panel:setItemAmount(item, x, y, amount)
		end
	end
end)