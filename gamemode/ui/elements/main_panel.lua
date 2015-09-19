local matCircle = Material("deadremains/skills/circle.png", "noclamp smooth")
local matFort = Material("deadremains/skills/CraftingSkill_Fortification.png", "noclamp smooth")
local matMech = Material("deadremains/skills/CraftingSkill_Mechanics.png", "noclamp smooth")
local matFire = Material("deadremains/skills/SurvivalSkill_Fire.png", "noclamp smooth")
local matHunting = Material("deadremains/skills/SurvivalSkill_Hunting.png", "noclamp smooth")

local ELEMENT = {}
function ELEMENT:Init()

	self.title_bar = vgui.Create("deadremains.panel_title_bar", self)
	self.title_bar:SetSize(640, 100)
	self.title_bar:SetPos(0, 0)

	self.tab_list = vgui.Create("deadremains.category_tab_list", self)
	self.tab_list:SetPos(0, 0)
	self.tab_list:SetSize(100, 760)

	self.cat_skills = vgui.Create("deadremains.skills_panel", self)
	self.cat_skills:SetPos(101, 102)
	self.cat_skills:SetSize(539, 660)
	self.tab_list:addCategory(matHunting, self.cat_skills, 2)

	self.cat_map = vgui.Create("deadremains.map_panel", self)
	self.cat_map:SetPos(101, 102)
	self.cat_map:SetSize(539, 660)
	self.tab_list:addCategory(matMech, self.cat_map, 3)

	self.cat_character = vgui.Create("deadremains.character_panel", self)
	self.cat_character:SetPos(101, 102)
	self.cat_character:SetSize(539, 660)
	self.tab_list:addCategory(matFire, self.cat_character, 1)

	self.cat_crafting = vgui.Create("deadremains.crafting_panel", self)
	self.cat_crafting:SetPos(101, 102)
	self.cat_crafting:SetSize(539, 660)
	self.tab_list:addCategory(matFort, self.cat_crafting, 4)

end

function ELEMENT:Think()

end

function ELEMENT:Paint(w, h)

end
vgui.Register("deadremains.main_panel", ELEMENT, "Panel")