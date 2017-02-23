--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:08:37
--

local mission_navigation_item_node = class("mission_navigation_item_node", cc.load("mvc").ViewBase)

mission_navigation_item_node.RESOURCE_FILENAME = "ui_instance/mission/mission_navigation_item_node.csb"

function mission_navigation_item_node:onCreate()
	-- body

end

function mission_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return mission_navigation_item_node
