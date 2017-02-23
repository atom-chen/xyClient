--
-- Author: Wu Hengmin
-- Date: 2015-08-10 19:28:49
--

local backpack_equip = class("backpack_equip")

local class_backpack_equip_item = import("app.views.gameWorld.backpack.backpack_equip_item.lua")

function backpack_equip:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function backpack_equip:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function backpack_equip:getResourceNode()
	-- body
	return self._rootNode
end


function backpack_equip:_registUIEvent()
	-- body
	

end

function backpack_equip:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*21
	self.items = {}
	local x = 80
	local y = 340
	for i=index,index + 20 do
		self.items[i] = class_backpack_equip_item:new()
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

return backpack_equip
