--
-- Author: Wu Hengmin
-- Date: 2015-08-13 10:48:04
--


local wujiang_wujiang = class("wujiang_wujiang")

local class_wujiang_wujiang_item = import("app.views.gameWorld.wujiang.wujiang_wujiang_item.lua")

function wujiang_wujiang:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function wujiang_wujiang:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function wujiang_wujiang:getResourceNode()
	-- body
	return self._rootNode
end


function wujiang_wujiang:_registUIEvent()
	-- body

end


function wujiang_wujiang:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*4
	self.items = {}
	local x = 120
	local y = 200
	for i=index,index + 3 do
		self.items[i] = class_wujiang_wujiang_item:new()
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(data[i])
		self.items[i]:setPosition(x, y)
		self._rootNode:addChild(self.items[i])

		x = x + 260
	end

end

return wujiang_wujiang
