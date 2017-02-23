--
-- Author: Wu Hengmin
-- Date: 2015-07-01 14:18:07
-- 导航按钮

local heros_navigation_item_node = class("heros_navigation_item_node", cc.load("mvc").ViewBase)

heros_navigation_item_node.RESOURCE_FILENAME = "ui_instance/heros/heros_navigation_item_node.csb"

function heros_navigation_item_node:onCreate()
	-- body
end

function heros_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return heros_navigation_item_node
