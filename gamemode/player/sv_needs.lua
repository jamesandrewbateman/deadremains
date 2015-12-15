--! @module	So that the values can be loaded in from an sql result string.

function player_meta:setNeed(need_unique, value)
	-- get a reference to a function pointer
	local setNeedFunc = self["set" .. string.capitalize(need_unique)]

	if (setNeedFunc ~= nil) then

		--print(need_unique)
		--print("char val", self:getChar(need_unique))
		--print("need val", self:getNeed(need_unique))

		-- call the funciton pointer
		if self:getNeed(need_unique) == nil or self:getChar(need_unique) == nil then

			setNeedFunc(self, value)

		else

			setNeedFunc(self, math.Clamp(value, 0, self:getChar(need_unique)))

		end
	else
		-- function pointer fail catch
		if (need_unique == "health") then

			self:SetHealth(value or 666)

		else

			print("Could not set " .. self:Nick() .. "'s need " .. need_unique)

		end
	end
end

function player_meta:getNeed(need_unique)

	local getNeedFunc = self["get" .. string.capitalize(need_unique)]

	if (getNeedFunc ~= nil) then

		return getNeedFunc(self)

	else
		-- health function catch
		if (need_unique == "health") then

			return self:Health()

		else

			print("Could not get " .. self:Nick() .. "'s need " .. need_unique)

			return 0
		end
	end
end

function player_meta:getHunger()
	return self.dr_character.needs.hunger
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:setHunger(hunger)
	self.dr_character.needs.hunger = hunger

	self:SetNWInt("dr_hunger", self.dr_character.needs.hunger)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:increaseHunger(amount)
	self.dr_character.needs.hunger = math.max(100, self.dr_character.needs.hunger + amount)

	self:SetNWInt("dr_hunger", self.dr_character.needs.hunger)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:decreaseHunger(amount)
	self.dr_character.needs.hunger = math.max(0, self.dr_character.needs.hunger - amount)

	self:SetNWInt("dr_hunger", self.dr_character.needs.hunger)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:getThirst()
	return self.dr_character.needs.thirst
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:setThirst(thirst)
	self.dr_character.needs.thirst = thirst

	self:SetNWInt("dr_thirst", self.dr_character.needs.thirst)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:increaseThirst(amount)
	self.dr_character.needs.thirst = math.max(100, self.dr_character.needs.thirst +amount)

	self:SetNWInt("dr_thirst", self.dr_character.needs.thirst)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function player_meta:decreaseThirst(amount)
	self.dr_character.needs.thirst = math.max(0, self.dr_character.needs.thirst -amount)

	self:SetNWInt("dr_thirst", self.dr_character.needs.thirst)
end