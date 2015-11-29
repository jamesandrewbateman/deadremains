--local invs = deadremains.settings.get("default_inventories")
LocalPlayer().Inventories = {}

net.Receive("deadremains.networkinventory", function(bits)
	local itemCount = net.ReadUInt(16)

	LocalPlayer().Inventories = {}

	for i=1, itemCount do
		local invName = net.ReadString()
		local invSize = net.ReadVector()
		local invMaxWeight = net.ReadUInt(16)
		local invCurrentWeight = net.ReadUInt(16)

		local itemName = net.ReadString()
		local itemSlotPos = net.ReadVector()

		table.insert(LocalPlayer().Inventories, {
				InventoryName = invName,
				InventorySize = invSize,
				InventoryMaxWeight = invMaxWeight,
				InventoryCurrentWeight = invCurrentWeight,
				ItemUnique = itemName,
				SlotPosition = itemSlotPos
			})
	end

	--PrintTable(LocalPlayer().Inventories)
	
	deadremains.ui.rebuildInventory()
	
end)

function player_meta:InventoryItemAction(action_name, inventory_name, item_unique, item_slot_position)
	net.Start("deadremains.itemaction")
		net.WriteString(action_name)
		net.WriteString(inventory_name)
		net.WriteString(item_unique)
		net.WriteVector(item_slot_position)
	net.SendToServer()

	timer.Simple(0.5, function()
		LocalPlayer():ConCommand("Networkinv")
	end)
end