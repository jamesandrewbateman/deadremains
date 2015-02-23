loader = {}

dr.extensions = {}

local function handleFunctionTable(tbl)
	for index, func in pairs(tbl) do
		if extension.shouldOverride and extension.shouldOverride(index) then
			GAMEMODE[index] = func
		else
			hook.Add(index,index..' for extension '.. extension.name.. ' (' .. #dr.extensions[extension.name].. ')',func)
			table.insert(dr.extensions[extension.name].hooks,index)
		end
	end
end

function loader.recursiveLoad(folder,callback)
	local files,folders = helper.findInFolder(folder,'LUA')
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

	local _,extensions = helper.findInFolder('deadremains/gamemode/extensions','LUA')

	extension = {}
	client = {}
	server = {}
	shared = {}

	local callback = function()

		dr.extensions[extension.name] = {}
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

end