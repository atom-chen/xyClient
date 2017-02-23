--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:08:37
--

local goods_navigation_item_node = class("goods_navigation_item_node", cc.load("mvc").ViewBase)

goods_navigation_item_node.RESOURCE_FILENAME = "ui_instance/goods/goods_navigation_item_node.csb"

function goods_navigation_item_node:onCreate()
	-- body

end

function goods_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return goods_navigation_item_node
