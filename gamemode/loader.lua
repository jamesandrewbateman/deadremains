//Main Tables
dr = {}
Q = {}

//End Tables

include 'extension.lua'

function hook.RemoveExtension(extName,extHook)
	local ext = EXTENSIONS[extName]
	if not ext then return end

	local func = ext[extHook]
	if not func then return end

	hook.Remove(extHook,extHook..'-'..tostring(func))
end

function GM:Initialize()
	extension.loadExtensions()
end