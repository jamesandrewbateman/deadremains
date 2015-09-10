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
		header:SetTall(STORE_SCALE_Y * (48 +20) * 2)

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
		button_play:DockMargin(STORE_SCALE_X * 128, STORE_SCALE_Y * 48, STORE_SCALE_X * 128, STORE_SCALE_Y * 24)
		button_play:SetTall(STORE_SCALE_Y * 48 +20 *2)

		function button_play.doClick()
			self.buttons_base:AlphaTo(0, 0.3, 0, function(_, panel)
				if LocalPlayer():GetNWInt("dr_character_created") == 0 then
					ShowNotification("Error", "You must create a character!",
						function()
							self.buttons_base:AlphaTo(255, 0.3, 0, function(_, panel) end)
						end,
						function()
						end,
						1,
						{x = ScrW()/2, y = ScrH()/2})
				else
					self:Close()
				end
			end)
		end

		local line = self.buttons_base:Add("Panel")
		line:Dock(TOP)
		line:DockMargin(STORE_SCALE_X * 256, 0, STORE_SCALE_X * 256, 0)
		line:SetTall(1)

		function line:Paint(w, h)
			draw.simpleRect(0, 0, w, h, color_line)
		end
		
		local button_character = self.buttons_base:Add("deadremains.button")
		button_character:setName("Character")
		button_character:Dock(TOP)
		button_character:DockMargin(STORE_SCALE_X * 128, STORE_SCALE_Y * 24, STORE_SCALE_X * 128, STORE_SCALE_Y * 24)
		button_character:SetTall(STORE_SCALE_Y * 48 +20 *2)

		function button_character.doClick()
			self.buttons_base:AlphaTo(0, 0.3, 0, function(_, panel)
				panel:SetVisible(false)

				self:showCharacterCreation()
				--self:showCharacter()
			end)
		end
	end

	self.buttons_base:SetVisible(true)
	self.buttons_base:SetAlpha(0)
	self.buttons_base:AlphaTo(255, 0.3, 0)
end

function panel:Close()
	self:Remove()
	gui.EnableScreenClicker(false)
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:showCharacterCreation()
	if (!IsValid(self.character_creation_base)) then
		self.character_creation_base = self:Add("Panel")

		self.character_creation_base:SetSize(1024 * STORE_SCALE_X, 756 * STORE_SCALE_Y)
		self.character_creation_base:Center()

		function self.character_creation_base:Paint(w,h)
		--	draw.simpleOutlined(0,0,w,h,color_red)
		end

		local top_base =  self.character_creation_base:Add("Panel")
		top_base:Dock(TOP)
		top_base:DockMargin(256 * STORE_SCALE_X, 0, 256 * STORE_SCALE_X, 0)
		top_base:SetTall(80 * STORE_SCALE_Y)

		function top_base:Paint(w, h)
			draw.RoundedBox(2, 0, 0, w, h, panel_color_background_light)

			draw.SimpleText(LocalPlayer():Nick(), "deadremains.button", w *0.5, h *0.5, color_label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local model = self.character_creation_base:Add("DModelPanel")
		model:DockMargin(0, STORE_SCALE_Y * 32, 0, 0)
		model:Dock(FILL)
		model:SetModel("models/humans/group01/male_01.mdl")
		model:SetCamPos(Vector(68, -5, 46))
		model:SetLookAt(Vector(0, 0, 35))
		model:SetFOV(60)

		function model:LayoutEntity(entity)
		end

		local left_base = self.character_creation_base:Add("Panel")
		left_base:Dock(LEFT)
		left_base:DockMargin(0, STORE_SCALE_Y * 128, 0, 0)
		left_base:SetWide(STORE_SCALE_X * 256)

		local model_option = left_base:Add("deadremains.combobox")
		model_option:Dock(TOP)
		model_option:DockMargin(0, 0, 0, 0)
		model_option:SetTall(STORE_SCALE_Y * 48 +20 *1.5)
		model_option:setName("Model")

		local models = deadremains.settings.get("male_models")
		for k,v in pairs(models) do
			model_option:addOption(tostring(k), function()
				model:SetModel(v)
				self.modelstring = v
			end)
		end

		-- default variables
		self.modelstring = models[1]
		self.genderstring = "m"

		local right_base = self.character_creation_base:Add("Panel")
		right_base:Dock(RIGHT)
		right_base:DockMargin(0, STORE_SCALE_Y * 128, 0, 0)
		right_base:SetWide(STORE_SCALE_X * 256)

		local gender_option = right_base:Add("deadremains.combobox")
		gender_option:Dock(TOP)
		gender_option:DockMargin(0, 0, 0, 0)
		gender_option:SetTall(STORE_SCALE_Y * 48 +20 *1.5)
		gender_option:setName("Gender")
		gender_option:addOption("Male", function()
			local models = deadremains.settings.get("male_models")
			self.genderstring = "m"

			model:SetModel(models[1])

			model_option:clearOptions()
			for k,v in pairs(models) do
				model_option:addOption(tostring(k), function()
					model:SetModel(v)
					self.modelstring = v
				end)
			end
		end)

		gender_option:addOption("Female", function()
			local models = deadremains.settings.get("female_models")
			self.genderstring = "f"

			model:SetModel(models[1])

			model_option:clearOptions()
			for k,v in pairs(models) do
				model_option:addOption(tostring(k), function()
					model:SetModel(v)
					self.modelstring = v
				end)
			end
		end)

		local bottom_base = self.character_creation_base:Add("Panel")
		bottom_base:Dock(BOTTOM)
		--bottom_base:DockMargin(0, 128, 0, 0)
		bottom_base:SetTall(STORE_SCALE_Y*60)

		local button_create = bottom_base:Add("deadremains.button")
		button_create:Dock(FILL)
		button_create:setName("Save")

		function button_create.doClick()
			LocalPlayer():newCharacter(self.modelstring, self.genderstring)

			self.character_creation_base:AlphaTo(0, 0.3, 0, function(_, panel)
				panel:SetVisible(false)

				self:showButtons()
			end)
		end
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

		self.character_base:SetSize(1024 * STORE_SCALE_X, 756 * STORE_SCALE_Y)
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
		self.buttons_base:SetSize(STORE_SCALE_X * 700, STORE_SCALE_Y * (48 +20 *2) *4 +81 *3)
		self.buttons_base:Center()
	end
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function panel:Paint(w, h)
	if (IsValid(self)) then
		Derma_DrawBackgroundBlur(self)
	end
end

vgui.Register("deadremains.character.creation", panel, "EditablePanel")

--if (IsValid(testmenu)) then testmenu:Remove() end


timer.Simple(0.1, function()
	if (IsValid(testmenu)) then return end

	testmenu = vgui.Create("deadremains.character.creation")
	testmenu:SetSize(ScrW(), ScrH())

	gui.EnableScreenClicker(true)
end)