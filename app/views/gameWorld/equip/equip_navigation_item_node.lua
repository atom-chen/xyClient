--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:08:37
--

local equip_navigation_item_node = class("equip_navigation_item_node", cc.load("mvc").ViewBase)

equip_navigation_item_node.RESOURCE_FILENAME = "ui_instance/equip/equip_navigation_item_node.csb"

function equip_navigation_item_node:onCreate()
	-- body

end

function equip_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return equip_navigation_item_node
