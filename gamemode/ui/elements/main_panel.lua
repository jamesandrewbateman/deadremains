local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")
local matFort = Material("deadremains/skills/CraftingSkill_Fortification.png", "noclamp smooth")
local matMech = Material("deadremains/skills/CraftingSkill_Mechanics.png", "noclamp smooth")
local matFire = Material("deadremains/skills/SurvivalSkill_Fire.png", "noclamp smooth")
local matHunting = Material("deadremains/skills/SurvivalSkill_Hunting.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.titleBar = vgui.Create("deadremains.panel_title_bar", self)
	self.titleBar:SetSize(640, 100)
	self.titleBar:SetPos(0, 0)

	self.tabList = vgui.Create("deadremains.category_tab_list", self)
	self.tabList:SetPos(0, 0)
	self.tabList:SetSize(100, 761)

	self.catSkills = vgui.Create("deadremains.skills_panel", self)
	self.catSkills:SetPos(101, 102)
	self.catSkills:SetSize(539, 659)

	local skillTypes = deadremains.settings.get("skill_types")
	for _, name in pairs(skillTypes) do

		self.catSkills:addCategory(name)

	end

	local skills = deadremains.settings.get("skills")

	for unique, data in pairs(skills) do

		self.catSkills:addSkill(unique, data.name, data.icon, data.type)

	end

	// local chars = deadremains.settings.get("char")

	local chars = {speed = {name = "Speed", default = 0, icon = "materials/deadremains/characteristics/sprintspeed.png"}, thirst = {name = "Thirst", default = 1, icon = "materials/deadremains/characteristics/thirst.png"}, health = {name = "Health", default = 2, icon = "materials/deadremains/characteristics/health.png"}, hunger = {name = "Hunger", default = 5, icon = "materials/deadremains/characteristics/hunger.png"}, strength = {name = "Strength", default = 9, icon = "materials/deadremains/characteristics/strength.png"}}
	
	--PrintTable(characteristics)
	for id, data in pairs(chars) do

		self.catSkills:addCharacteristic(id, data.name, data.default, data.icon)

	end
	
	self.catSkills:updateLayout()
	self.tabList:addCategory(matHunting, self.catSkills, 2, "SKILLS", function() local main = deadremains.ui.getMenu() main.sec:Hide() end)

	self.catMap = vgui.Create("deadremains.map_panel", self)
	self.catMap:SetPos(101, 102)
	self.catMap:SetSize(539, 659)
	self.tabList:addCategory(matMech, self.catMap, 3, "MAP", function() local main = deadremains.ui.getMenu() main.sec:Hide() end)

	self.catEquipment = vgui.Create("deadremains.equipment_panel", self)
	self.catEquipment:SetPos(101, 102)
	self.catEquipment:SetSize(539, 659)
	self.tabList:addCategory(matFire, self.catEquipment, 1, "EQUIPMENT", function() local main = deadremains.ui.getMenu() main.sec:Show() end)

	self.catCrafting = vgui.Create("deadremains.crafting_panel", self)
	self.catCrafting:SetPos(101, 102)
	self.catCrafting:SetSize(539, 659)
	self.tabList:addCategory(matFort, self.catCrafting, 4, "CRAFTING", function() local main = deadremains.ui.getMenu() main.sec:Hide() end)

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

end

function ELEMENT:Rebuild()

	print("rebuilding main panel")

	self.catCrafting:Rebuild()

end
vgui.Register("deadremains.main_panel", ELEMENT, "Panel")