deadremains.settings = {}

local stored = {}

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.settings.new(unique, data)
	stored[unique] = data
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.settings.get(unique)
	return stored[unique]
end