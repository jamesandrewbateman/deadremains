if SERVER then
	AddCSLuaFile('libs/util.lua')
end
include('libs/util.lua')

dr = dr or {}

helper.include('libs/meta.lua')
helper.include('libs/ui.lua')
helper.include('libs/loader.lua')

loader.loadExtensions()

if CLIENT then
	loader.loadVGUI()
end