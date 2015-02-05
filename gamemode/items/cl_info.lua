/*
 * Weapon Information System
 * Created by Zignd (http://steamcommunity.com/id/zignd/)
 * Inspired by TTT Weapon Info created by Wolf Halez and available as paid stuff :(.
 * The Weapon Information System is not a source code copy of the TTT Weapon Info, I analysed how it works an built my own version from scratch.
 * The Weapon Information System is an open-source Garry's Mod addon and is available on Garry's Mod Workshop on Steam.
 * 
 * Add me on Steam for contact.
 */

surface.CreateFont( "WpnInfoHead", {
	font = "Bebas Neue",
	size = 130,
	weight = 0,
	antialias = true
} )

surface.CreateFont( "WpnInfoBody", {
	font = "Bebas Neue",
	size = 100,
	weight = 0,
	antialias = true
} )

local wpninfo = {}

wpninfo.tttweaponnames =
{
	
	[ "pistol_name" ] = "Pistol",
	[ "knife_name" ] = "Knife",
	[ "rifle_name" ] = "Rifle",
	[ "shotgun_name" ] = "Shotgun",
	[ "sipistol_name" ] = "Silenced Pistol",
	[ "flare_name" ] = "Flare Gun",
	[ "newton_name" ] = "Newton Launcher",
	[ "grenade_smoke" ] = "Smoke Grenade",
	[ "grenade_fire" ] = "Incendiary Grenade",
	[ "c4" ] = "C4 Explosive",
	[ "tele_name" ] = "Teleporter"

}

wpninfo.fonts =
{

	head = "WpnInfoHead",
	body = "WpnInfoBody"

}

wpninfo.colors =
{

	background = Color( 25, 25, 25, 100 ),
	text = Color( 255, 255, 255, 255 )

}

wpninfo.infos =
{

	name = "N/A",
	damage = "N/A",
	clipsize = "N/A",
	automatic = "NO",
	spread = "0.00",
	recoil = "0",
	ammo = "N/A",
	rare = "Unknown"
}

local function drawwpninfo()

	local x, y, width, height, panelwidth, panelheight, desc, padding, position, angle, scale
	local ply = LocalPlayer()
	local wpn = ply:GetActiveWeapon()
	local ent = util.TraceLine(
	{

		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ( ply:GetAimVector() * 200 ),
		filter = ply,
		mask = MASK_SHOT_HULL

	} ).Entity

	local function getnewy( text )

		width, height = surface.GetTextSize( text )
		return y + height

	end

	if IsValid( ent ) then
		
		padding = 50
		
		angle = Angle( 0, ply:EyeAngles().y - 90, 90 )
		scale = 0.04

		// Display informations about weapons
		if (ent:IsWeapon() and ent:IsScripted()) or ent:IsItem() then
			if ent:IsItem() then
				wpninfo.infos.name = dr.Items.Data.MItems[ent:GetItemID()].Name
			else
			// Name
			if wpninfo.tttweaponnames[ ent:GetPrintName() ] then

				wpninfo.infos.name = wpninfo.tttweaponnames[ ent:GetPrintName() ]

			else

				wpninfo.infos.name = ent:GetPrintName()

			end

			// Damage
			if ent.Primary.Damage > 1 then

				wpninfo.infos.damage = ent.Primary.Damage

			elseif ent.Damage != nil then
				
				wpninfo.infos.damage = ent.Damage
				
			end

			// Clip Size
			if ent.Primary.ClipSize > 0 then
				wpninfo.infos.clipsize = ent.Primary.ClipSize

			end

			// Automatic
			if ent.Primary.Automatic then

				wpninfo.infos.automatic = "YES"
				
			end

			// Spread
			wpninfo.infos.spread = ent.Primary.Cone

			// Recoil
			wpninfo.infos.recoil = ent.Primary.Recoil

			// Ammo
			wpninfo.infos.ammo = ent.Primary.Ammo
			if ent.Primary.OldAmmo != nil then
				wpninfo.infos.ammo = ent.Primary.OldAmmo
			end
			
			end
			
			if string.len(wpninfo.infos.name) > 14 then
				panelwidth = 600 + string.len(wpninfo.infos.ammo) * 10
			else
				panelwidth = 600
			end
						
			panelheight = 575//950
			x = -panelwidth / 2
			y = 0

			position = ent:GetPos() + Vector( 0, 0, 50 )	

			// Draw the informations about the weapon
			cam.Start3D2D( position, angle, scale )
				local bg = wpninfo.colors.background
				local bolt = Color(255,255,255,255)
				if ent.Rare != nil then
					bolt = mods.tiercolours[ent.Rare] 
					wpninfo.infos.rare = mods.names[ent.Rare]
				else
					//bolt = mods.tiercolours[4] 
				end
				draw.RoundedBox( 30, x, y, panelwidth, panelheight, bg )
				desc = wpninfo.infos.name
				draw.DrawText( desc, wpninfo.fonts.head, 0, y + 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
				y = getnewy( desc )
				desc = "Damage: "
				draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
				draw.DrawText( wpninfo.infos.damage, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				y = getnewy( desc )
				desc = "Rarity: "
				draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
				draw.DrawText( wpninfo.infos.rare, wpninfo.fonts.body, x + panelwidth - padding, y, bolt, TEXT_ALIGN_RIGHT )
				y = getnewy( desc )
				desc = "Mag. Size: "
				draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
				draw.DrawText( wpninfo.infos.clipsize, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				-- y = getnewy( desc )
				-- desc = "Automatic: "
				-- draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
				-- draw.DrawText( wpninfo.infos.automatic, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				-- y = getnewy( desc )
				-- desc = "Spread: "
				-- draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
				-- draw.DrawText( wpninfo.infos.spread, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				-- y = getnewy( desc )
				-- desc = "Recoil: "
				-- draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
				-- draw.DrawText( wpninfo.infos.recoil, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
				y = getnewy( desc )
				desc = "Ammo: "
				draw.DrawText( desc, wpninfo.fonts.body, x + padding, y, wpninfo.colors.text, TEXT_ALIGN_LEFT )
				draw.DrawText( wpninfo.infos.ammo, wpninfo.fonts.body, x + panelwidth - padding, y, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
			cam.End3D2D()

		// Display information about ammunitions
		elseif ent.Type and ent.AmmoType and ent.Type == "anim" then
			
			width, height = surface.GetTextSize(ent.AmmoType)

			panelwidth = width + padding > 500 and width + padding * 4 or 500
			panelheight = 200
			panelwidth = panelwidth + 60
			//Add a quick ammount
			x = -panelwidth / 2
			y = 0

			position = ent:GetPos() + Vector( 0, 0, 30 )
			
			cam.Start3D2D( position, angle, scale )

				// If the player current weapon uses the ammo the player is looking at the RoundedBox you be green
				draw.RoundedBox( 30, x, y, panelwidth, panelheight, (wpn:IsWeapon() and wpn.Primary and (wpn.Primary.Ammo == ent.AmmoType) and Color( 41, 163, 92, 100 ) or wpninfo.colors.background) )
				draw.DrawText( ent.AmmoType .. " Ammo" or "FATAL ERROR", wpninfo.fonts.body, 0, y + padding, wpninfo.colors.text, TEXT_ALIGN_CENTER )

			cam.End3D2D()

		end

	end

end

hook.Add( "PostDrawOpaqueRenderables", "drawwpn", drawwpninfo )