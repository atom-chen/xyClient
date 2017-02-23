--
-- Author: Wu Hengmin
-- Date: 2015-08-13 13:58:34
--

local wujiang_fragment = class("wujiang_fragment")

local class_wujiang_fragment_item = import("app.views.gameWorld.wujiang.wujiang_fragment_item.lua")

function wujiang_fragment:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function wujiang_fragment:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function wujiang_fragment:getResourceNode()
	-- body
	return self._rootNode
end


function wujiang_fragment:_registUIEvent()
	-- body

end


function wujiang_fragment:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*8
	self.items = {}
	local x = 125
	local y = 300
	for i=index,index + 7 do
		self.items[i] = class_wujiang_fragment_item:new()
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(data[i])
		self.items[i]:setPosition(x, y)
		self._rootNode:addChild(self.items[i])
		
		if x == 905 then
			x = 125
			y = y - 200
		else
			x = x + 260
		end
	end


end

return wujiang_fragment
