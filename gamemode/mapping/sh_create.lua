

if SERVER then


else
	net.Receive( "dr.Create", function( len )
		if CREATEMODE == nil then CREATEMODE = true else CREATEMODE = !CREATEMODE end
		print("Create mode: ", CREATEMODE)
	end )
end