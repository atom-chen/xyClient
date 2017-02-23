--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:08:49
--

local friends_view = class("friends_view")

local class_item = import("app.views.gameWorld.friends2.friends_item.lua")

function friends_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

    self.itemModel = cc.CSLoader:createNode("ui_instance/friends2/friends_item.csb")
    self.itemModel:retain()

end

function friends_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self.items = {}
end

function friends_view:getResourceNode()
	-- body
	return self._rootNode
end

function friends_view:_registUIEvent()
	-- body

end

function friends_view:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*8
	self.items = {}
	local x = 140
	local y = 305
	for i=index,index + 7 do
		self.items[i] = class_item:new()
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(data[i])
		self.items[i]:setMode(1)
		self.items[i]:setPosition(x, y)
		self._rootNode:addChild(self.items[i])

		if x == 890 then
			x = 140
			y = y - 200
		else
			x = x + 250
		end
	end

end

return friends_view
