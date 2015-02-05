local whitelist = {"STEAM_0:0:49657803", "STEAM_0:1:36031593", "STEAM_0:1:41377261"}

function GM:CheckPassword( steamID64, ipAddress, svPassword, clPassword, name )

	 for k,v in pairs(whitelist) do
		if util.SteamIDFrom64( steamID64 ) == v then
			print(name.." has been authorised!")
			return true
		end
	 end
	 
	 return false, "Unauthorised Player: Ask Aliiig96 for a white listing"
end