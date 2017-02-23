--
-- Author: Wu Hengmin
-- Date: 2015-08-22 14:54:01
--

local choose_equip = class("choose_equip")

local class_choose_equip_item = import("app.views.gameWorld.choose.equip_item.lua")

function choose_equip:ctor(node, max)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
    self.max = max
end

function choose_equip:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function choose_equip:getResourceNode()
	-- body
	return self._rootNode
end


function choose_equip:_registUIEvent()
	-- body

end

function choose_equip:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*3
	self.items = {}
	local x = 175
	local y = 205
	for i=index,index + 2 do
		self.items[i] = class_choose_equip_item:new()
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(data[i], i, self.max)
		self.items[i]:setPosition(x, y)
		self._rootNode:addChild(self.items[i])

		x = x + 340
	end

end

return choose_equip
