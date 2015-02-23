--Metatable for "define"
 
local defineMeta = {}
 
local DEFAULT_CONSTRUCTOR = function() return {} end
 
--
local merge = table.Merge
 
local function changeVar(oldTbl,newTbl,key)
	newTbl[key] = oldTbl[key]
end
 
defineMeta.__index = defineMeta
defineMeta.__call = function(self,metaName)
	return function(metaTbl)
		_G[metaName] = function(...)
			local construct = metaTbl.__constructor or DEFAULT_CONSTRUCTOR
 
			metaTbl.__index = metaTbl
 
			local structTbl = {}
 
			construct(structTbl,...)
 
			if metaTbl.__varChanged or metaTbl.__varRemoved or metaTbl.__varAdded then
				structTbl.__oldVars = {}
				for k, v in pairs(structTbl) do
					if not metaTbl[k] and k ~= '__oldVars' then
						structTbl.__oldVars[k] = v
					end
				end
 
				hook.Add('Think','__varChanged for '..tostring(structTbl), function()
 
					for k, v in pairs(structTbl.__oldVars) do
						if structTbl.__varChanged and structTbl[k] ~= nil and structTbl[k] ~= v then
							local shouldChange = structTbl.__varChanged(k,structTbl[k],v)
 
							if shouldChange == false then
								changeVar(structTbl,structTbl.__oldVars,k)
							else
								changeVar(structTbl.__oldVars,structTbl,k)
							end
						elseif structTbl.__varRemoved and structTbl[k] == nil then
							local shouldRestore = structTbl.__varRemoved(k)
 
							if shouldRestore == true then
								changeVar(structTbl.__oldVars,structTbl,k)
							else
								changeVar(structTbl,structTbl.__oldVars,k)
							end
						end
					end
 
					if not structTbl.__varAdded then return end
					
					for k, v in pairs(structTbl) do
						if k ~= '__oldVars' and structTbl.__oldVars[k] == nil then
							local shouldAdd = structTbl.__varAdded(k,v)
 
							if shouldAdd == false then
								changeVar(structTbl.__oldVars,structTbl,k)
							else
								changeVar(structTbl,structTbl.__oldVars,k)
							end
						end
					end
				end)
			end
 
			return setmetatable(structTbl,metaTbl)
		end
	end
end
 
define = {}
setmetatable(define,defineMeta)