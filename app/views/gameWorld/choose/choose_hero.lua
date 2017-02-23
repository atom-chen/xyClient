--
-- Author: Wu Hengmin
-- Date: 2015-08-22 14:53:56
--

local choose_hero = class("choose_hero")

local class_choose_hero_item = import("app.views.gameWorld.choose.hero_item.lua")

function choose_hero:ctor(node, max)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
    self.max = max
end

function choose_hero:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function choose_hero:getResourceNode()
	-- body
	return self._rootNode
end


function choose_hero:_registUIEvent()
	-- body

end


function choose_hero:update(data, page)
	-- body
	self._rootNode:removeAllChildren()
	local index = 1 + (page-1)*4
	self.items = {}
	local x = 120
	local y = 210
	for i=index,index + 3 do
		self.items[i] = class_choose_hero_item:new()
		self.items[i]:setCascadeOpacityEnabled(true)
		self.items[i]:update(data[i], i, self.max)
		self.items[i]:setPosition(x, y)
		self._rootNode:addChild(self.items[i])

		x = x + 260
	end

end

return choose_hero
