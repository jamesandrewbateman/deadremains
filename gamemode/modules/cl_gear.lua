---------------------------------------------------------
-- Player gear/apparel system.
---------------------------------------------------------

deadremains.gear = {}

local cache = {}

function deadremains.gear.get(player, slot)
	local steamID = player:SteamID()
	
	return cache[steamID] and cache[steamID][slot]
end

function deadremains.gear.getCache()
	return cache
end

function deadremains.gear.getCacheByPlayer(player)
	local steamID = player:SteamID()
	
	return cache[steamID]
end

function deadremains.gear.shouldDraw()
	if (GetViewEntity() == LocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer() and !LocalPlayer():GetObserverTarget()) then return false end
	
	return true
end

---------------------------------------------------------
-- Full gear update.
---------------------------------------------------------

net.Receive("deadremains.gear.gtgrfull", function(bits)
	local steamID = net.ReadString()

	for i = 1, inventory_equip_maximum do
		cache[steamID][i] = {}

		local unique = net.ReadString()

		if (unique != "") then
			local item = deadremains.store.items[unique]
			local player = util.FindPlayer(steamID)
			
			if (item) then
				local previous = cache[steamID][item.slot].unique
				
				if (previous and previous != "") then
					previous = deadremains.store.items[previous]
					
					-- Update inventory preview.
					if (steamID == LocalPlayer():SteamID() and IsValid(store) --[[ <----- TODO: CHANGE TO REAL PANEL ]]) then
						local inventory = store:getPanel("inventory")
					
						if (IsValid(inventory)) then
							inventory:RemoveEntity(previous.slot)
						end
					end
					
					-- Unequip the previous one.
					if (IsValid(player) and previous and previous.unEquip) then
						previous:unEquip(player)
					end
		
					-- Make the menu stuff call unEquip.
					local panel = store:getPanel("inventory")
					
					if (IsValid(panel)) then
						local entity = panel:getModelEntity()
						
						if (IsValid(entity)) then
							deadremains.store.callItemHookMenu(entity, previous.unique, "unEquip")
						end
					end
				end
				
				cache[steamID][item.slot].unique = item.unique
				
				if (item.bone) then
					if (IsValid(cache[steamID][i].entity)) then
						cache[steamID][i].entity:Remove()
					end
	
					local entity = ClientsideModel(item.model)
					
					-- Set rendermode for alpha/color support.
					entity:SetRenderMode(RENDERMODE_TRANSALPHA)
					
					local skin = net.ReadUInt(8)
					local color = net.ReadVector()
		
					color = Color(color.x, color.y, color.z)
			
					entity:SetSkin(skin)
					entity:SetColor(color)
					
					local bodygroups = net.ReadUInt(8)

					for i = 1, bodygroups do
						local group = net.ReadUInt(8)
						local value = net.ReadUInt(8)
						
						entity:SetBodygroup(group, value)
					end

					cache[steamID][i].entity = entity
					
				-- Updates the model in the player inventory.
				elseif (item.model and !item.bone and store --[[ <----- TODO: CHANGE TO REAL PANEL ]] and steamID == LocalPlayer():SteamID()) then
					local panel = store:getPanel("inventory")
					
					if (IsValid(panel)) then
						local entity = panel:getModelEntity()
						
						if (IsValid(entity)) then
							local skin = net.ReadUInt(8)
							local color = net.ReadVector()
							
							color = Color(color.x, color.y, color.z)
						
							entity:SetSkin(skin)
							entity:SetColor(color)
							
							local bodygroups = net.ReadUInt(8)
							
							for i = 1, bodygroups do
								local group = net.ReadUInt(8)
								local value = net.ReadUInt(8)
								
								entity:SetBodygroup(group, value)
							end
						end
					end
				end
			
				-- Update inventory preview.
				if (steamID == LocalPlayer():SteamID() and IsValid(store) --[[ <----- TODO: CHANGE TO REAL PANEL ]]) then
					local inventory = store:getPanel("inventory")
				
					if (IsValid(inventory)) then
						inventory:AddEntity(item)
					end
				end
				
				if (IsValid(player) and item.equip) then
					item:equip(player)
				end
			end
		end
		
		if (steamID == LocalPlayer():SteamID() and IsValid(store)) then
			local inventory = store:getPanel("inventory")
			
			if (IsValid(inventory)) then
				inventory:rebuild()
			end
		end
	end
end)
 
---------------------------------------------------------
-- Single slot update.
---------------------------------------------------------

net.Receive("deadremains.gear.gtgrslot", function(bits)
	local item = deadremains.store.items[net.ReadString()]
	local steamID = net.ReadString()
	local remove = net.ReadBit()
	local player = util.FindPlayer(steamID)
	
	if (remove == 1) then
		if (IsValid(cache[steamID][item.slot].entity)) then
			cache[steamID][item.slot].entity:Remove()
		end
		
		cache[steamID][item.slot].dirty = nil
		cache[steamID][item.slot].unique = nil
		
		-- Update inventory preview.
		if (steamID == LocalPlayer():SteamID() and IsValid(store) --[[ <----- TODO: CHANGE TO REAL PANEL ]]) then
			local inventory = store:getPanel("inventory")
			
			if (IsValid(inventory)) then
				inventory:RemoveEntity(item.slot)
			end
		end
		
		if (IsValid(player) and item.unEquip) then
			item:unEquip(player)
		end
		
		-- Make the menu stuff call unEquip.
		local panel = store:getPanel("inventory")
		
		if (IsValid(panel)) then
			local entity = panel:getModelEntity()
			
			if (IsValid(entity)) then
				deadremains.store.callItemHookMenu(entity, item.unique, "unEquip")
			end
		end
	else
		if (item) then
			local previous = cache[steamID][item.slot].unique
			
			if (previous and previous != "") then
				previous = deadremains.store.items[previous]
				
				-- Update inventory preview.
				if (steamID == LocalPlayer():SteamID() and IsValid(store) --[[ <----- TODO: CHANGE TO REAL PANEL ]]) then
					local inventory = store:getPanel("inventory")
				
					if (IsValid(inventory)) then
						inventory:RemoveEntity(previous.slot)
					end
				end
				
				-- Unequip the previous one.
				if (IsValid(player) and previous and previous.unEquip) then
					previous:unEquip(player)
				end
		
				-- Make the menu stuff call unEquip.
				local panel = store:getPanel("inventory")
				
				if (IsValid(panel)) then
					local entity = panel:getModelEntity()
					
					if (IsValid(entity)) then
						deadremains.store.callItemHookMenu(entity, previous.unique, "unEquip")
					end
				end
			end
			
			cache[steamID][item.slot].dirty = nil
			cache[steamID][item.slot].unique = item.unique
			
			if (item.bone) then
				if (IsValid(cache[steamID][item.slot].entity)) then
					cache[steamID][item.slot].entity:Remove()
				end
				
				local entity = ClientsideModel(item.model)
				
				-- Set rendermode for alpha support.
				entity:SetRenderMode(RENDERMODE_TRANSALPHA)
				
				local skin = net.ReadUInt(8)
				local color = net.ReadVector()
				
				color = Color(color.x, color.y, color.z)
			
				entity:SetSkin(skin)
				entity:SetColor(color)
				
				local bodygroups = net.ReadUInt(8)
				
				for i = 1, bodygroups do
					local group = net.ReadUInt(8)
					local value = net.ReadUInt(8)
					
					entity:SetBodygroup(group, value)
				end
				
				cache[steamID][item.slot].entity = entity

			-- Updates the model in the player inventory.
			elseif (item.model and !item.bone and store --[[ <----- TODO: CHANGE TO REAL PANEL ]] and steamID == LocalPlayer():SteamID()) then
				local panel = store:getPanel("inventory")
				
				if (IsValid(panel)) then
					local entity = panel:getModelEntity()
					
					if (IsValid(entity)) then
						local skin = net.ReadUInt(8)
						local color = net.ReadVector()
						
						color = Color(color.x, color.y, color.z)
						
						entity:SetSkin(skin)
						entity:SetColor(color)
						
						local bodygroups = net.ReadUInt(8)
						
						for i = 1, bodygroups do
							local group = net.ReadUInt(8)
							local value = net.ReadUInt(8)
							
							entity:SetBodygroup(group, value)
						end
					end
				end
			end
		
			-- Update inventory preview.
			if (steamID == LocalPlayer():SteamID() and IsValid(store) --[[ <----- TODO: CHANGE TO REAL PANEL ]]) then
				local inventory = store:getPanel("inventory")
		
				if (IsValid(inventory)) then
					inventory:AddEntity(item)
				end
			end
			
			if (IsValid(player) and item.equip) then
				item:equip(player)
			end
		end
	end

	if (steamID == LocalPlayer():SteamID() and IsValid(store) ) then
		local inventory = store:getPanel("inventory")
		
		if (IsValid(inventory)) then
			inventory:rebuild()
		end
	end
end)

---------------------------------------------------------
-- Sets a slot to dirty.
---------------------------------------------------------

net.Receive("deadremains.gear.gtgrslotd", function(bits)
	local steamID = net.ReadString()
	
	if (cache[steamID]) then
		local slot = net.ReadUInt(8)
	
		cache[steamID][slot].dirty = true
	end
end)

----------------------------------------------------------------------
-- Purpose:
--			Draws the gear.
----------------------------------------------------------------------

local validGear = setmetatable({}, {__mode = "k"})

hook.Add("PostPlayerDraw", "deadremains.gear.render", function(player)
	validGear[player] = true
end)

hook.Add("Think", "deadremains.gear.think", function()
	local players = player.GetAll()

	for k, player in pairs(players) do
		if (IsValid(player) and !player:Alive()) then
			local ragdoll = player:GetRagdollEntity()

			if (IsValid(ragdoll)) then
				validGear[ragdoll] = true
			end
		end
	end
end)

hook.Add("PreDrawOpaqueRenderables", "deadremains.gear.render", function()
	local players = player.GetAll()
	
	for k, player in pairs(players) do
		local steamID = player:SteamID()
		local entity = player

		if (!entity:Alive()) then
			entity = entity:GetRagdollEntity()
		elseif (validGear[entity]) then
			validGear[entity] = false

			-- Request full update.
			if (!cache[steamID]) then
				cache[steamID] = {}
			
				net.Start("deadremains.gear.rqgrfull")
					net.WriteString(steamID)
				net.SendToServer()
			else
				if (cache[steamID].hidden) then
					for i = 1, inventory_equip_maximum do
						local data = cache[steamID][i]
						
						if (data and IsValid(data.entity)) then
							data.entity:RemoveEffects(EF_NODRAW)
						end
					end
				end
				
				cache[steamID].hidden = false
				
				for i = 1, inventory_equip_maximum do
					local data = cache[steamID][i]
					
					if (data) then
					
						-- Request update for slot if it's dirty.
						if (data.dirty) then
							cache[steamID][i].dirty = false
							
							net.Start("deadremains.gear.rqgrslot")
								net.WriteString(steamID)
								net.WriteUInt(i, 8)
							net.SendToServer()
						end
						
						local item = deadremains.store.items[data.unique]
						
						if (item) then
							if (IsValid(data.entity)) then
							
								-- Maybe cache this?
								local index = entity:LookupBone(item.bone or "ValveBiped.Bip01_Head1")
								
								if (index and index > -1) then
									
									-- Using bone matrix fixes the hat from lagging behind when the player is getting shot. (lol)
									local boneMatrix = entity:GetBoneMatrix(index)
									
									if (boneMatrix) then
										local position, angles = boneMatrix:GetTranslation(), boneMatrix:GetAngles()
										
										local modelData = item.models[string.lower(entity:GetModel())]
										
										-- TODO: Get a better "backup" position/angle?
										if (!modelData) then
											modelData = item.models[deadremains.store.model.dante]
										end
										
										if (modelData) then
											local positionData = modelData[1]
											
											for i = 1, #modelData do
												local modelBodygroup = entity:GetBodygroup(modelData[i][1])
												local entityBodygroup = data.entity:GetBodygroup(modelData[i][2])
												
												if (bit.bor(modelBodygroup, entityBodygroup) == modelData[i][3]) then
													positionData = modelData[i]
												end
											end
											
											if (positionData) then
												if positionData.pos then
													local up, right, forward = angles:Up(), angles:Right(), angles:Forward()
													
													position = position + up*positionData.pos.z + right*positionData.pos.y + forward*positionData.pos.x -- NOTE: y and x could be wrong way round
												end 
							
												if positionData.ang then 
													angles:RotateAroundAxis(angles:Up(), positionData.ang.p) 
													angles:RotateAroundAxis(angles:Forward(), positionData.ang.y) 
													angles:RotateAroundAxis(angles:Right(), positionData.ang.r) 
												end
												
												if positionData.scale then data.entity:SetModelScale(positionData.scale, 0) end 
											end
										end
					
										data.entity:SetPos(position)
										data.entity:SetAngles(angles)
									end
								end
							end
						end
					end
				end
			end
			
			deadremains.store.callItemHook(entity, "preDrawOpaqueRenderables", false, entity)
		else
			if (cache[steamID] and !cache[steamID].hidden) then
				cache[steamID].hidden = true
				
				for i = 1, maximum_slots do
					local data = cache[steamID][i]
					
					if (data and IsValid(data.entity)) then
						data.entity:AddEffects(EF_NODRAW)
					end
				end
			end
		end
	end
end)

----------------------------------------------------------------------
-- Purpose:
--			Remove the players gear entities.
----------------------------------------------------------------------

gameevent.Listen("player_disconnect")

hook.Add("player_disconnect", "deadremains.gear.player_disonnect", function(data)
	local steamID = data.networkid
	
	if (cache[steamID]) then
		for i = 1, maximum_slots do
			local data = cache[steamID][i]
			
			if (data and IsValid(data.entity)) then
				data.entity:Remove()
			end
		end
		
		cache[steamID] = nil
	end
end)

----------------------------------------------------------------------
-- Purpose:
--			Draws gear on a "ClientsideModel"
----------------------------------------------------------------------

function deadremains.gear.DrawPreview(data, entity)
	local item = deadremains.store.items[data.unique]

	if (item) then
		if (IsValid(data.entity)) then
		
			-- Maybe cache this?
			local index = entity:LookupBone(item.bone or "ValveBiped.Bip01_Head1")
		
			if (index and index > -1) then
				local position, angles = entity:GetBonePosition(index)
				local modelData = item.models[string.lower(entity:GetModel())]
				
				-- TODO: Get a better "backup" position/angle?
				if (!modelData) then
					modelData = item.models[deadremains.store.model.dante]
				end
				
				if (modelData) then
					local positionData = modelData[1]
					
					for i = 1, #modelData do
						local modelBodygroup = entity:GetBodygroup(modelData[i][1])
						local entityBodygroup = data.entity:GetBodygroup(modelData[i][2])
						
						if (bit.bor(modelBodygroup, entityBodygroup) == modelData[i][3]) then
							positionData = modelData[i]
						end
					end
					
					if (positionData) then
						if positionData.pos then
							local up, right, forward = angles:Up(), angles:Right(), angles:Forward()
							
							position = position + up*positionData.pos.z + right*positionData.pos.y + forward*positionData.pos.x -- NOTE: y and x could be wrong way round
						end 
		
						if positionData.ang then 
							angles:RotateAroundAxis(angles:Up(), positionData.ang.p) 
							angles:RotateAroundAxis(angles:Forward(), positionData.ang.y) 
							angles:RotateAroundAxis(angles:Right(), positionData.ang.r) 
						end
						
						if positionData.scale then data.entity:SetModelScale(positionData.scale, 0) end 
					end
				end
	
				data.entity:SetPos(position)
				data.entity:SetAngles(angles)
				
				local color = data.entity:GetColor()
				
				render.SetColorModulation(color.r /255, color.g /255, color.b /255)
				
				data.entity:DrawModel()
			end
		end
	end
end