loader = {}

dr.extensions = {}

local function handleFunctionTable(tbl)
	for index, func in pairs(tbl) do
		if extension.shouldOverride and extension.shouldOverride(index) then
			GAMEMODE[index] = func
		else
			local name = index..' for extension '.. extension.name.. ' (' .. #dr.extensions[extension.name].. ')'
			hook.Add(index,name,func)
			table.insert(dr.extensions[extension.name].hooks,{name=name,func=func,index=index})
		end
	end
end

function loader.recursiveLoad(folder,callback)
	local files,folders = helper.findInFolder('gamemodes/'..folder)
	local callback = callback or function() end
	
	local path = folder..'/'

	for _, file in pairs(files) do
		helper.include(path..file)
		callback()
	end

	for _, folder in pairs(folders) do
		loader.recursiveLoad(path..folder)
	end
end

function loader.loadExtensions()

	local _, extensions = helper.findInFolder('gamemodes/deadremains/gamemode/extensions')

	extension = {}
	client = {}
	server = {}
	shared = {}

	local callback = function()

		dr.extensions[extension.name] = {__ext = extension}
		dr.extensions[extension.name].hooks = {}

		local GAMEMODE = GM or GAMEMODE

		if CLIENT then
			handleFunctionTable(client)
		else
			handleFunctionTable(server)
		end
		
		handleFunctionTable(shared)
	end

	for n, ext in pairs(extensions) do
		loader.recursiveLoad('deadremains/gamemode/extensions/'..ext,callback)
	end

	extension = nil
	client = nil
	server = nil
	shared = nil
end

function loader.disableExtension(name)

	local ext = dr.extensions[name]

	if not ext or ext.__isDisabled then return end

	for _, hookTbl in pairs(ext.hooks) do
		hook.Remove(hookTbl.index,hookTbl.name)
	end

	dr.extensions[name].__isDisabled = true
end

function loader.enableExtension(name)

	local ext = dr.extensions[name]

	if not ext or not ext.__isDisabled then return end

	for _, hookTbl in pairs(ext.hooks) do
		hook.Add(hookTbl.index,hookTbl.name,hookTbl.func)
	end

	dr.extensions[name].__isDisabled = false
end

function loader.loadVGUI()

	local _, uiElements = helper.findInFolder('gamemodes/deadremains/gamemode/vgui')

	for n, uiElement in pairs(uiElements) do
		loader.recursiveLoad('deadremains/gamemode/vgui/'..uiElement)
	end
end