--
-- Author: Wu Hengmin
-- Date: 2015-07-30 15:34:44
--

local arena_view_2 = class("arena_view_2", cc.load("mvc").ViewBase)

local class_super_item = import(".arena_super_item_node")

arena_view_2.RESOURCE_FILENAME = "ui_instance/arena/arena_view_2.csb"

function arena_view_2:onCreate()
	-- body
	-- ArenaGoodses
	self.scrollview = self.resourceNode_:getChildByName("scrollview")
	for i=1,#ArenaGoodses do
		local item = class_super_item:new()
		item:setCascadeOpacityEnabled(true)
		item:setPosition(-120 + i * 240, 320)
		item:updateDisplay(ArenaGoodses[i])
		self.scrollview:addChild(item)
	end
end

function arena_view_2:updateDisplay()
	-- body

	self.resourceNode_:setVisible(true)
end

function arena_view_2:disable()
	-- body
	self.resourceNode_:setVisible(false)
end

return arena_view_2