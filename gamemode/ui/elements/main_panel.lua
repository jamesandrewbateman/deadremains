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
	self.tabList:SetSize(100, 760)

	self.catSkills = vgui.Create("deadremains.skills_panel", self)
	self.catSkills:SetPos(101, 102)
	self.catSkills:SetSize(539, 660)
	self.tabList:addCategory(matHunting, self.catSkills, 2, "SKILLS")

	self.catMap = vgui.Create("deadremains.map_panel", self)
	self.catMap:SetPos(101, 102)
	self.catMap:SetSize(539, 660)
	self.tabList:addCategory(matMech, self.catMap, 3, "MAP")

	self.catCharacter = vgui.Create("deadremains.character_panel", self)
	self.catCharacter:SetPos(101, 102)
	self.catCharacter:SetSize(539, 660)
	self.tabList:addCategory(matFire, self.catCharacter, 1, "CHARACTER")

	self.catCrafting = vgui.Create("deadremains.crafting_panel", self)
	self.catCrafting:SetPos(101, 102)
	self.catCrafting:SetSize(539, 660)
	self.tabList:addCategory(matFort, self.catCrafting, 4, "CRAFTING")

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

end
vgui.Register("deadremains.main_panel", ELEMENT, "Panel")