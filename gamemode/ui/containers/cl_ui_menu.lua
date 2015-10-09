
deadremains.ui.key = KEY_F9

deadremains.ui.enableBlur = true

deadremains.ui.inventories = {}

local UI_MAIN

local keyDown = false
local menuOpen = false

hook.Add("Think", "deadremains.ui.detectKey", function()

	if !keyDown then

		if input.IsKeyDown(deadremains.ui.key) then

			keyDown = true

			deadremains.ui.createMenu()

			timer.Simple(0.5, function() keyDown = false end)

		elseif input.IsKeyDown(KEY_F10) then

			keyDown = true

			deadremains.ui.hideMenu()

			timer.Simple(0.5, function() keyDown = false end)

		end

	end

end)

function deadremains.ui.getMenu()

	return UI_MAIN

end

function deadremains.ui.rebuildInventory()

	local UI_MAIN = deadremains.ui.getMenu()

	for _, inv in pairs(deadremains.ui.inventories) do

		inv.items = {}

	end

	local items = LocalPlayer().Inventories
	for _, v in pairs(items) do

		if !deadremains.ui.inventories[v.InventoryName] then

			deadremains.ui.addInventory(v.InventoryName, v.InventorySize)

		else

			UI_MAIN.sec:clearAllItems(v.InventoryName)

		end

	end

	for _, v in pairs(items) do

		deadremains.ui.addItem(v.InventoryName, v.ItemUnique, v.SlotPosition)

	end

end

function deadremains.ui.addInventory(invName, vec)

	local UI_MAIN = deadremains.ui.getMenu()

	UI_MAIN.sec:addInventory(invName, invName, vec.x, vec.y, 50)
	deadremains.ui.inventories[invName] = {size = vec, items = {}}

end

function deadremains.ui.addItem(invName, itemName, vec)

	local UI_MAIN = deadremains.ui.getMenu()

	table.insert(deadremains.ui.inventories[invName].items, {name = itemName, slot = vec})

	UI_MAIN.sec:addItem(invName, itemName, vec)

end

function deadremains.ui.getActiveActionMenu()

	return deadremains.ui.activeActionMenu

end

function deadremains.ui.isMenuOpen()

	return menuOpen

end

function deadremains.ui.createMenu()

	-- Do not re-create the whole menu so players can stay on the same tab when re-opening
	if UI_MAIN then

		UI_MAIN:Show()
		gui.EnableScreenClicker(true)
		menuOpen = true

		deadremains.ui.getHUD():minimize()

	else

		gui.EnableScreenClicker(true)
		menuOpen = true

		if !deadremains.ui.getHUD() then deadremains.ui.createHUD() end
		deadremains.ui.getHUD():minimize()

		UI_MAIN = vgui.Create("deadremains.screen")
		UI_MAIN:SetSize(deadremains.ui.screenSizeX, deadremains.ui.screenSizeY)
		UI_MAIN:SetPos(0, 0)

		local main_panel = vgui.Create("deadremains.main_panel", UI_MAIN)
		main_panel:SetSize(640, 761)
		main_panel:SetPos(deadremains.ui.screenSizeX / 2 - 35 / 2 - 640, deadremains.ui.screenSizeY / 2 - 761 / 2)

		UI_MAIN.sec = vgui.Create("deadremains.secondary_inventory_panel", UI_MAIN)
		UI_MAIN.sec:SetSize(540, 761)
		UI_MAIN.sec:SetPos(deadremains.ui.screenSizeX / 2 + 35 / 2, deadremains.ui.screenSizeY / 2 - 761 / 2)

		for k, v in pairs(deadremains.ui.inventories) do

			deadremains.ui.addInventory(k, v.size)

		end

	end

end

function deadremains.ui.hideMenu()

	if UI_MAIN then

		UI_MAIN:Hide()

		gui.EnableScreenClicker(false)
		menuOpen = false

		if deadremains.ui.getHUD() then

			deadremains.ui.getHUD():maximize()

		end

	end

end

function deadremains.ui.destroyMenu()

	if UI_MAIN then

		UI_MAIN:Remove()
		UI_MAIN = nil

		gui.EnableScreenClicker(false)
		menuOpen = false

		deadremains.ui.getHUD():maximize()

	end

end
