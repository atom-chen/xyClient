--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:08:37
--

local mail_navigation_item_node = class("mail_navigation_item_node", cc.load("mvc").ViewBase)

mail_navigation_item_node.RESOURCE_FILENAME = "ui_instance/mail/mail_navigation_item_node.csb"

function mail_navigation_item_node:onCreate()
	-- body

end

function mail_navigation_item_node:getModelNode()
	-- body
	return self.resourceNode_:getChildByName("image")
end

return mail_navigation_item_node
