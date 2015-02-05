//Main Tables
dr.Chars = {}
dr.Chars.Functions = {}
dr.Chars.Data = {}

net.Receive( "dr.Characters", function( len )
	print("Receiving Data: Characters", len)
	local data = net.ReadTable()
	if data != nil then
		LocalPlayer().Characters = data
		PrintTable(data)
	end
end )