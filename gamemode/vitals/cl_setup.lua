//Main Tables
dr.Vitals = {}
dr.Vitals.Functions = {}
dr.Vitals.Data = {}
dr.Vitals.Data.Hunger = {}

net.Receive( "dr.Vitals", function( len )
	local data = net.ReadTable()
	local ply = LocalPlayer()
	if data != nil and IsValid(ply) then
		print("Receiving Data: " .. ply:Nick() .. "'s " .. "Vitals", len)
		ply.Vitals = data
		PrintTable(data)
	end
end )