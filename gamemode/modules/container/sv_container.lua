local containers = containers or {}

function deadremains.containers.create(pName, pSlotX, pSlotY, pWorldPosition)

	--deadremains.log.write("general", "Creating container " .. pName .. " with size " .. pSlotX .. ", " .. pSlotY)

	local netId = util.AddNetworkString("deadremains.networkcontainers")	-- does nothing if net str exists.

	table.insert(containers, {
		Name = pName,
		SlotX = pSlotX,
		SlotY = pSlotY,
		Items = {
			
		}
	})

	local entity = ents.Create("deadremains_container")
	entity:SetPos(pWorldPosition)
	entity:SetModel("models/fallout3/backpack_1.mdl")
	entity:Spawn()

	entity:SetContainerIndex(#containers)

	return #containers

end
concommand.Add("dr_container_new", function(ply, cmd, args)

	if ply:IsAdmin() then

		deadremains.log.write("general", "Container index: " .. deadremains.containers.create(args[1], 4,4, ply:GetPos() + Vector(50, 0, 0)))

	end

end)


function deadremains.containers.addItem(pContainerIndex, pItemName)

	table.insert(containers[pContainerIndex].Items, pItemName)

	deadremains.containers.networkItemChanges(pContainerIndex)


end
concommand.Add("dr_container_insertitem", function(ply, cmd, args)

	deadremains.containers.addItem(tonumber(args[1]), tostring(args[2]))

end)

function deadremains.containers.hasItem(pContainerIndex, pItemName)

	if containers[pContainerIndex] == nil then return false end

	if containers[pContainerIndex].Items == nil then return false end

	if table.Count(containers[pContainerIndex].Items) == 0 then return false end

	local found = false
	local index = 0

	for k,v in pairs(containers[pContainerIndex].Items) do

		if v == pItemName then

			found = true

			index = k

		end

	end

	return found, index

end

function deadremains.containers.removeItem(pContainerIndex, pItemName)

	local found, index = deadremains.containers.hasItem(pContainerIndex, pItemName)

	if found then

		table.remove(containers[pContainerIndex].Items, index)

	end

end

function deadremains.containers.networkItemChanges(pContainerIndex)

	--deadremains.log.write("general", "Networking item changes for container " .. pContainerIndex)


	local containerTbl = containers[pContainerIndex]

	if containerTbl == nil then return end

	local itemCount = table.Count(containerTbl.Items)


	net.Start("deadremains.networkcontainers")

	net.WriteUInt(pContainerIndex, 16)

	net.WriteString(containerTbl.Name)

	net.WriteUInt(containerTbl.SlotX, 8)

	net.WriteUInt(containerTbl.SlotY, 8)

	net.WriteUInt(itemCount, 8)


	for i = 1, itemCount do

		--deadremains.log.write("general", "Sending item info for container " .. containers[pContainerIndex].Items[i])
		
		net.WriteString(containers[pContainerIndex].Items[i])
	
	end


	net.Broadcast()

end

function deadremains.containers.delete(pContainerIndex)

	table.remove(containers, pIndex)

end

deadremains.netrequest.create("deadremains.updatecontainerui", function (ply, data)

	if data then

		local container_index = data.container_id

		local item_action = data.item_action

		local item_name = data.item_name

		if item_action == "take" then

			deadremains.containers.removeItem(container_index, item_name)

			ply:AddItemToInventory("feet", item_name)

		end

		deadremains.containers.networkItemChanges(container_index)

		return { ContainerIndex = container_index }

	end

end)