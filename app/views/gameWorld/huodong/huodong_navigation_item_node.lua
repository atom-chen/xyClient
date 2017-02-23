--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:08:37
--

local huodong_navigation_item_node = class("huodong_navigation_item_node", cc.load("mvc").ViewBase)

huodong_navigation_item_node.RESOURCE_FILENAME = "ui_instance/huodong/huodong_navigation_item_node.csb"

function huodong_navigation_item_node:onCreate()
	-- body

end

function huodong_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return huodong_navigation_item_node
