--
-- Author: Wu Hengmin
-- Date: 2015-08-11 17:08:28
--

local backpack_goods = class("backpack_goods")

local class_backpack_goods_item = import("app.views.gameWorld.backpack.backpack_goods_item.lua")

function backpack_goods:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function backpack_goods:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function backpack_goods:getResourceNode()
	-- body
	return self._rootNode
end


function backpack_goods:_registUIEvent()
	-- body

end


function backpack_goods:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*21
	self.items = {}
	local x = 80
	local y = 340
	for i=index,index + 20 do
		self.items[i] = class_backpack_goods_item:new()
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(data[i])
		self.items[i]:setPosition(x, y)
		self._rootNode:addChild(self.items[i])

		if x == 950 then
			x = 80
			y = y - 140
		else
			x = x + 145
		end
	end

end

return backpack_goods
