--
-- Author: Wu Hengmin
-- Date: 2015-08-12 15:00:56
--


local backpack_fragment = class("backpack_fragment")

local class_backpack_fragment_item = import("app.views.gameWorld.backpack.backpack_fragment_item.lua")

function backpack_fragment:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function backpack_fragment:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function backpack_fragment:getResourceNode()
	-- body
	return self._rootNode
end


function backpack_fragment:_registUIEvent()
	-- body

end


function backpack_fragment:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*8
	self.items = {}
	local x = 120
	local y = 310
	for i=index,index + 7 do
		self.items[i] = class_backpack_fragment_item:new()
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(data[i])
		self.items[i]:setPosition(x, y)
		self._rootNode:addChild(self.items[i])

		if x == 900 then
			x = 120
			y = y - 210
		else
			x = x + 260
		end
	end

end

return backpack_fragment
