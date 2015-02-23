local construct = function(self,name)
	self.__name = name
end

local setBase = function(self,base)
	self.__base = base
end

local register = function(self)
	vgui.Register(self.__name,self,self.__base)
end

define 'ui' {
	__constructor = construct,
	setBase = setBase,
	register = register
}