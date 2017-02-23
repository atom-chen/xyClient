--
-- Author: Wu Hengmin
-- Date: 2015-07-09 10:04:49
--

local market_vip_item = class("market_vip_item")

function market_vip_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()

end

function market_vip_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function market_vip_item:getResourceNode()
	-- body
	return self._rootNode
end

function market_vip_item:update(data, dex)
	-- body
	self.data = data
	self._rootNode:getChildByName("title"):setString("VIP"..dex)
	self._rootNode:getChildByName("descrip"):setString(data.info)
end

return market_vip_item