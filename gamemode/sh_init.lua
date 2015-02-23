if SERVER then
	AddCSLuaFile('libs/util.lua')
end
include('libs/util.lua')

dr = dr or {}

helper.include('libs/loader.lua')

loader.loadExtensions()