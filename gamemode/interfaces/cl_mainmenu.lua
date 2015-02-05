//Main Menu
//Main Tables
dr.Interfaces = dr.Interfaces or {}
dr.Interfaces.Functions = dr.Interfaces.Functions or {}
dr.Interfaces.Data = dr.Interfaces.Data or {}

dr.Interfaces.Functions.MainMenu = {}
dr.Interfaces.Data.MainMenu = {}

//Text
dr.Interfaces.Data.MainMenu.WelcomeText = "Welcome to Dark Remains!"
dr.Interfaces.Data.MainMenu.Butt1 = "Play"
dr.Interfaces.Data.MainMenu.Butt2 = "Character"
dr.Interfaces.Data.MainMenu.Butt3 = "Credits"

//Functions
function dr.Interfaces.Functions.MainMenu.Play()
	//Send request to server
	
end


//Display
function dr.Interfaces.Functions.MainMenu.Create()
	local background_panel = vgui.Create("DFrame")
	background_panel:SetSize(ScrW(), ScrH())
	background_panel:SetPos(0,0)
	//background_panel:MakePopup()
	background_panel:SetDraggable(false)
	background_panel:SetTitle("")
	background_panel:ShowCloseButton(false)
	background_panel.Paint = function(pnl, w, h)
		local renderview = {}
		renderview.x = 0
		renderview.y = 0
		renderview.w = ScrW()
		renderview.h = ScrH()

		renderview.origin = Vector(-3945.548584, 678.207581, 1084.502686)
		renderview.angles = Angle(24.771990, -0.928006, 0.000000)
		renderview.drawhud = false
		renderview.drawviewmodel = false
		render.RenderView(renderview)
	end
	
	local main_panel = vgui.Create("DPanel", background_panel)
	main_panel:SetSize(500, 300)
	main_panel:SetPos(ScrW()/2 - 250, ScrH()/2 - 150)
	main_panel:MakePopup()
	main_panel.Paint = function(pnl, w, h)
		Derma_DrawBackgroundBlur( pnl, pnl.startTime )
		//draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0 ) )
		
	end
	
	local title = vgui.Create("DPanel", main_panel)
	title:SetPos( 30, 20 )
	title:SetSize( 400, 60 )
	title.Paint = function(pnl, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		draw.DrawText( dr.Interfaces.Data.MainMenu.WelcomeText, "dr.interfaces.maintext", w/2, h/2 - 16, Color( 248, 153, 36, 255 ), TEXT_ALIGN_CENTER )
	end
	
	local butt1 = vgui.Create( "DButton", main_panel )	
	butt1:SetSize( 260, 60 )
	butt1:SetPos( 100, 100 )
	butt1:SetText( "" )

	butt1:SetDisabled(true)
	butt1.Paint = function(pnl, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		draw.DrawText( dr.Interfaces.Data.MainMenu.Butt1, "dr.interfaces.maintext", w/2, h/2 - 16, Color( 248, 153, 36, 255 ), TEXT_ALIGN_CENTER )
	end
	butt1.DoClick = function()
		dr.Interfaces.Functions.MainMenu.Play()
		background_panel:Visible(false)
	end
	
	local butt2 = vgui.Create( "DButton", main_panel )	
	butt2:SetSize( 260, 60 )
	butt2:SetPos( 100, 180 )
	butt2:SetText( "" )

	butt2:SetDisabled(true)
	butt2.Paint = function(pnl, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		draw.DrawText( dr.Interfaces.Data.MainMenu.Butt2, "dr.interfaces.maintext", w/2, h/2 - 16, Color( 248, 153, 36, 255 ), TEXT_ALIGN_CENTER )
	end
	butt2.DoClick = function()
		if background_panel != nil then background_panel:Close() end
	end
	
		
	timer.Simple(30, function() if background_panel != nil then background_panel:Close() end end)
end

concommand.Add( "123", dr.Interfaces.Functions.MainMenu.Create() )