--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:08:37
--

local market_navigation_item_node = class("market_navigation_item_node", cc.load("mvc").ViewBase)

market_navigation_item_node.RESOURCE_FILENAME = "ui_instance/market/market_navigation_item_node.csb"

function market_navigation_item_node:onCreate()
	-- body

end

function market_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return market_navigation_item_node
