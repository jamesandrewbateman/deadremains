//Main Tables
dr.Vitals = {}
dr.Vitals.Functions = {}
dr.Vitals.Data = {}
dr.Vitals.Data.Hunger = {}

function dr.Vitals.Functions.SetData( ply, data)
	ply.Vitals = data
	dr.Vitals.Functions.SyncClient( )
end

function dr.Vitals.Functions.GetData( ply )
	return ply.Vitals
end

local c = 0
function dr.Vitals.Functions.VitalsHandler()
	dr.Vitals.Functions.HungerHandler()
	dr.Vitals.Functions.ThirstHandler()
	if c == 10 then
		dr.Vitals.Functions.SyncClient()
		c = 0
	else
		c = c + 1
	end
end

function dr.Vitals.Functions.HungerHandler()
	for k,v in pairs(player.GetAll()) do
		if v.Vitals != nil then
			v.Vitals.Hunger.Value = math.Clamp(v.Vitals.Hunger.Value - v.Vitals.Hunger.TickRate, 0, v.Vitals.Hunger.Max)
			
			if v.Vitals.Hunger.Value == 0 then
				//Do something
			end
		end
	end
	
end

function dr.Vitals.Functions.ThirstHandler()
	for k,v in pairs(player.GetAll()) do
		if v.Vitals != nil then
			v.Vitals.Thirst.Value = math.Clamp(v.Vitals.Thirst.Value - v.Vitals.Thirst.TickRate, 0, v.Vitals.Thirst.Max)
			
			if v.Vitals.Thirst.Value == 0 then
				//Do something
			end
		end
	end
	
end

util.AddNetworkString( "dr.Vitals" )
function dr.Vitals.Functions.SyncClient( )
	
	for k,v in pairs(player.GetAll()) do
		if v.Vitals != nil then
			net.Start( "dr.Vitals" )
				net.WriteTable( v.Vitals )
			net.Send( v )
			print("Syncing: " .. v:Nick() .. "'s " .. "Vitals")
		end
	end
	
end

timer.Create( "dr.Vitals.HungerHandler", 1, 0, dr.Vitals.Functions.VitalsHandler )