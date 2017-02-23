--
-- Author: Wu Hengmin
-- Date: 2015-08-27 11:27:49
--


local charge_view = class("charge_view")

local class_item = import("app.views.gameWorld.market2.charge_item.lua")

function charge_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

    self.itemModel = cc.CSLoader:createNode("ui_instance/market2/charge_item.csb")
    self.itemModel:retain()

end

function charge_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self.items = {}
end

function charge_view:getResourceNode()
	-- body
	return self._rootNode
end

function charge_view:_registUIEvent()
	-- body

end

function charge_view:update(data)
	-- body
	local scrollview = self._rootNode:getChildByName("ScrollView_1")


	for i=#self.items+1,#data do
		self.items[i] = class_item.new(
				self.itemModel:getChildByName("Panel_1"):clone()
			)
		scrollview:addChild(self.items[i]:getResourceNode())
	end



	local offy = math.ceil(#data/2)
    local offy2 = offy

    -- 不足一屏的时候列表置顶
    if offy2 < 3.6 then
        offy2 = 3.6
    end

	for i=#data+1,#self.items do
		self.items[i]:getResourceNode():setVisible(false)
	end

	for i=1,#self.items do
		-- 更新位置
		self.items[i]:getResourceNode():setPosition(cc.p(10+505*((i-1)%2), 10+110* (offy2 - math.ceil(i/2))))
		self.items[i]:update(data[i])
		self.items[i]:getResourceNode():setVisible(true)
	end

	local size = cc.size(0, 110*offy+10)
    scrollview:setInnerContainerSize(size)



end

return charge_view
