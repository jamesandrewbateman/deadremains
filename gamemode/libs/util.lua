helper = helper or {}

function helper.include(file)

	if SERVER then
		include(file)
		AddCSLuaFile(file)
	else
		include(file)
	end
end

function helper.findInFolder(folder,tag)

	return file.Find(folder .. '/*',tag or 'GAME')
end

