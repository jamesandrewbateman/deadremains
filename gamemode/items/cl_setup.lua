//Main Tables
dr.Items = {}
dr.Items.Functions = {}
dr.Items.Data = {}
dr.Items.Data.MItems = {}

net.Receive( "dr.Items", function( len )
	print("Receiving Data: Items", len)
	local data = net.ReadTable()
	if data != nil then
		dr.Items.Data.MItems = data
		PrintTable(data)
	end
end )