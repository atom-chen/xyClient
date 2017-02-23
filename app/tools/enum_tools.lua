
--[[****************************************************************************
									类
****************************************************************************]]--
local _class={}
 
function __class(super)
	local class_type={}
	class_type.ctor=false

	class_type.super=super
	
	class_type.new=function(...) 
		local obj={}
		do
			local create
			create = function(c,...)
				if c.super then
					create(c.super,...)
				end
				if c.ctor then
					c.ctor(obj,...)
				end
			end

			create(class_type,...)
		end
		setmetatable(obj,{ __index=_class[class_type] })
		return obj
	end

	local vtbl={}
	_class[class_type]=vtbl
 
	setmetatable(class_type,{__newindex=
		function(t,k,v)
			vtbl[k]=v
		end
	})
 
	if super then
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				vtbl[k]=ret
				return ret
			end
		})
	end
 
	return class_type
end


--枚举类
--****************************************************************************
CEnumCreator = __class();
print("CEnumCreator")
--构造函数
function CEnumCreator:ctor()
	self.seed = 0;
end


--添加一个会话
function CEnumCreator:GetEnumVale()
	self.seed = self.seed + 1;
	return self.seed;
end

