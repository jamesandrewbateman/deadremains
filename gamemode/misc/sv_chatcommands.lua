//Chat Commands
//Setup
dr.ChatCommands = {}

function dr.ChatCommands.NewChatCommand(text, func)
	table.insert(dr.ChatCommands, {text, func})
end

hook.Add( "PlayerSay", "chatCommand", function( ply, text, public )
	local text = string.lower(text)
	for k,v in pairs(dr.ChatCommands) do
		if k != "NewChatCommand" then
			if (string.sub(text, 1, string.len(v[1])) == v[1]) then
				v[2](ply, text)
				return false
			end
		end
	end
end )

Q.NewChatCommand = dr.ChatCommands.NewChatCommand

// Actual Chat Commands
util.AddNetworkString( "dr.Create" )

Q.NewChatCommand("/create", function(ply, text) 
	//if ply:IsSuperAdmin() then
		net.Start( "dr.Create" )
		net.Send( ply )
	//end
end)