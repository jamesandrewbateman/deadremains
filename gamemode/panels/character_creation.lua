local color_line = Color(255, 255, 255, 30)
local color_label = Color(70, 70, 70, 255)

local panel = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Init()
	self:showButtons()
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:showButtons()
	if (!IsValid(self.buttons_base)) then
		self.buttons_base = self:Add("Panel")

		function self.buttons_base:Paint(w,h)
			--draw.simpleOutlined(0,0,w,h,color_red)
		end

		local header = self.buttons_base:Add("deadremains.button")
		header:setDisabled(true)
		header:Dock(TOP)
		header:SetTall(48 +20 *2)

		function header:Paint(w, h)
			draw.simpleRect(0, 0, w, h, panel_color_background)

			local nick = LocalPlayer():Nick()
			local width = util.getTextSize("deadremains.button", "Welcome back")

			draw.SimpleText("Welcome back", "deadremains.button", w *0.5 -8, h *0.5, panel_color_text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(nick, "deadremains.button", w *0.5 +8, h *0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
		local button_play = self.buttons_base:Add("deadremains.button")
		button_play:setName("Play")
		button_play:Dock(TOP)
		button_play:DockMargin(128, 48, 128, 48)
		button_play:SetTall(48 +20 *2)

		local line = self.buttons_base:Add("Panel")
		line:Dock(TOP)
		line:DockMargin(256, 0, 256, 0)
		line:SetTall(1)

		function line:Paint(w, h)
			draw.simpleRect(0, 0, w, h, color_line)
		end
		
		local button_character = self.buttons_base:Add("deadremains.button")
		button_character:setName("Character")
		button_character:Dock(TOP)
		button_character:DockMargin(128, 48, 128, 48)
		button_character:SetTall(48 +20 *2)

		function button_character.doClick()
			self.buttons_base:AlphaTo(0, 0.3, 0, function(_, panel)
				panel:SetVisible(false)

				self:showCharacterCreation()
				--self:showCharacter()
			end)
		end
		
		local line = self.buttons_base:Add("Panel")
		line:Dock(TOP)
		line:DockMargin(256, 0, 256, 0)
		line:SetTall(1)

		function line:Paint(w, h)
			draw.simpleRect(0, 0, w, h, color_line)
		end
		
		local button_settings = self.buttons_base:Add("deadremains.button")
		button_settings:setName("Settings")
		button_settings:Dock(TOP)
		button_settings:DockMargin(128, 48, 128, 0)
		button_settings:SetTall(48 +20 *2)
	end

	self.buttons_base:SetVisible(true)
	self.buttons_base:SetAlpha(0)
	self.buttons_base:AlphaTo(255, 0.3, 0)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:showCharacterCreation()
	if (!IsValid(self.character_creation_base)) then
		self.character_creation_base = self:Add("Panel")

		self.character_creation_base:SetSize(1024, 756)
		self.character_creation_base:Center()

		function self.character_creation_base:Paint(w,h)
		--	draw.simpleOutlined(0,0,w,h,color_red)
		end

		local top_base =  self.character_creation_base:Add("Panel")
		top_base:Dock(TOP)
		top_base:DockMargin(256, 0, 256, 0)
		top_base:SetTall(80)

		function top_base:Paint(w, h)
			draw.RoundedBox(2, 0, 0, w, h, panel_color_background_light)

			draw.SimpleText(LocalPlayer():Nick(), "deadremains.button", w *0.5, h *0.5, color_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local model = self.character_creation_base:Add("DModelPanel")
		model:DockMargin(0, 32, 0, 0)
		model:Dock(FILL)
		model:SetModel("models/humans/group01/male_07.mdl")
		model:SetCamPos(Vector(68, -5, 46))
		model:SetLookAt(Vector(0, 0, 35))
		model:SetFOV(60)

		function model:LayoutEntity(entity)
		end

		local left_base = self.character_creation_base:Add("Panel")
		left_base:Dock(LEFT)
		left_base:DockMargin(0, 128, 0, 0)
		left_base:SetWide(256)

		local face_option = left_base:Add("deadremains.combobox")
		face_option:Dock(TOP)
		face_option:DockMargin(0, 0, 0, 0)
		face_option:SetTall(48 +20 *1.5)
		face_option:setName("Face")

		local skin_color_option = left_base:Add("deadremains.combobox")
		skin_color_option:Dock(TOP)
		skin_color_option:DockMargin(0, 32, 0, 0)
		skin_color_option:SetTall(48 +20 *1.5)
		skin_color_option:setName("Skin Color")

		skin_color_option:addOption("Light")
		skin_color_option:addOption("Darker")
		skin_color_option:addOption("Darker")

		local right_base = self.character_creation_base:Add("Panel")
		right_base:Dock(RIGHT)
		right_base:DockMargin(0, 128, 0, 0)
		right_base:SetWide(256)

		local gender_option = right_base:Add("deadremains.combobox")
		gender_option:Dock(TOP)
		gender_option:DockMargin(0, 0, 0, 0)
		gender_option:SetTall(48 +20 *1.5)
		gender_option:setName("Gender")
		gender_option:addOption("Male", function()
			local models = deadremains.settings.get("male_models")

			model:SetModel(models[1])
		end)

		gender_option:addOption("Female", function()
			local models = deadremains.settings.get("female_models")

			model:SetModel(models[1])
		end)

		local bottom_base = self.character_creation_base:Add("Panel")
		bottom_base:Dock(BOTTOM)
		--bottom_base:DockMargin(0, 128, 0, 0)
		bottom_base:SetTall(60)

		local button_cancel = bottom_base:Add("deadremains.button")
		button_cancel:Dock(LEFT)
		button_cancel:DockMargin(0, 0, 32, 0)
		button_cancel:SetWide(1024 *0.5 -(256 +16))
		button_cancel:setName("Cancel")

		function button_cancel.doClick()
			self.character_creation_base:AlphaTo(0, 0.3, 0, function(_, panel)
				panel:SetVisible(false)

				self:showButtons()
			end)
		end
		
		local button_create = bottom_base:Add("deadremains.button")
		button_create:Dock(FILL)
		button_create:setName("Create")
	end
	
	self.character_creation_base:SetVisible(true)
	self.character_creation_base:SetAlpha(0)
	self.character_creation_base:AlphaTo(255, 0.3, 0)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:showCharacter()
	if (!IsValid(self.character_base)) then
		self.character_base = self:Add("Panel")

		self.character_base:SetSize(1024, 756)
		self.character_base:Center()


		local top_base =  self.character_base:Add("Panel")
		top_base:Dock(TOP)
		top_base:SetTall(80)

		function top_base:Paint(w, h)
			draw.RoundedBox(3, 0, 0, w, h, panel_color_background)
		end

		local back_button = top_base:Add("DLabel")
		back_button:Dock(LEFT)
		back_button:DockMargin(20, 0, 0, 0)
		back_button:SetText("<    Back to menu")
		back_button:SetFont("deadremains.button")
		back_button:SetColor(panel_color_text)
		back_button:SetCursor("hand")
		back_button:SetMouseInputEnabled(true)
		back_button:SizeToContents()

		function back_button.OnMousePressed()
			self.character_base:AlphaTo(0, 0.3, 0, function(_, panel)
				panel:SetVisible(false)

				self:showButtons()
			end)
		end
		
		local new_button = top_base:Add("DLabel")
		new_button:Dock(RIGHT)
		new_button:DockMargin(0, 0, 20, 0)
		new_button:SetText("New character    >")
		new_button:SetFont("deadremains.button")
		new_button:SetColor(panel_color_text)
		new_button:SizeToContents()

	end

	self.character_base:SetVisible(true)
	self.character_base:SetAlpha(0)
	self.character_base:AlphaTo(255, 0.3, 0)
end


----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:PerformLayout()
	local w, h = self:GetSize()

	if (IsValid(self.buttons_base)) then
		self.buttons_base:SetSize(700, (48 +20 *2) *4 +81 *3)
		self.buttons_base:Center()
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	Derma_DrawBackgroundBlur(self)
end

vgui.Register("deadremains.character.creation", panel, "EditablePanel")

if (IsValid(testmenu)) then testmenu:Remove() end

--[[
timer.Simple(0.1, function()

testmenu = vgui.Create("deadremains.character.creation")
testmenu:SetSize(ScrW(), ScrH())

gui.EnableScreenClicker(true)

end)
]]