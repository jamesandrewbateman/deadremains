extension = {}
EXTENSIONS = {}

function extension.addFunction(funcName,func,ext)

	local GAMEMODE = GAMEMODE or GM

	if type(func) == "function" and GAMEMODE[funcName] then
		if ext.shouldOverride then
			GAMEMODE[funcName] = func
		else
			hook.Add(funcName,funcName..'-'..tostring(func),func)
		end
		EXTENSIONS[ext.name][funcName] = func
	end
end

function extension.handleExtension(ext)

	local GAMEMODE = GAMEMODE or GM

	EXTENSIONS[ext.name] = {name = ext.name,override = ext.shouldOverride}

	if CLIENT then
		for funcName, func in pairs(ext.client) do
			extension.addFunction(funcName,func,ext)
		end
	else
		for funcName,func in pairs(ext.server) do
			extension.addFunction(funcName,func,ext)
		end
	end
	for funcName,func in pairs(ext.shared) do
		extension.addFunction(funcName,func,ext)
	end
	print("Loaded extension: "..ext.name)
end

function extension.loadExtensions()
	local f,d = file.Find('deadremains/gamemode/ext/*','LUA')

	for _, extFolder in pairs(d) do
		local path = 'deadremains/gamemode/ext/'..extFolder..'/'

		EXTENSION = {}
		CLIENT_EXT = {}
		SERVER_EXT = {}
		SHARED_EXT = {}
		if SERVER then AddCSLuaFile(path..'main.lua') end
		include(path..'main.lua')
		EXTENSION['client'] = CLIENT_EXT
		EXTENSION['server'] = SERVER_EXT
		EXTENSION['shared'] = SHARED_EXT
		extension.handleExtension(EXTENSION)
	end
	EXTENSION = nil
end