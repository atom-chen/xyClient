--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:08:37
--

local friends_navigation_item_node = class("friends_navigation_item_node", cc.load("mvc").ViewBase)

friends_navigation_item_node.RESOURCE_FILENAME = "ui_instance/friends/friends_navigation_item.csb"

function friends_navigation_item_node:onCreate()
	-- body

end

function friends_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return friends_navigation_item_node
