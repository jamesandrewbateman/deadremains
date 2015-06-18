deadremains.item = {}

local stored = {}

local meta_table = {}
meta_table.__index = meta_table

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.item.register(data)
	data.__index = data
	
	setmetatable(data, meta_table)

	stored[data.unique] = data
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function deadremains.item.get(unique)
	return stored[unique]
end

----------------------------------------------------------------------
-- Purpose:
--		
----------------------------------------------------------------------

function meta_table:use()
end