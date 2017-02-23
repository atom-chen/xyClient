--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local mail_item = class("mail_item", cc.load("mvc").ViewBase)

mail_item.RESOURCE_FILENAME = "ui_instance/mail/mail_item_node.csb"

function mail_item:onCreate()
	-- body
end

function mail_item:update(data)
	-- body

	self.data = data
	self.resourceNode_:getChildByName("main_node"):getChildByName("name"):setString(data.SendName)
	self.resourceNode_:getChildByName("main_node"):getChildByName("descrip"):setString(data.Content)

	-- 判定未读
	if data.Read_Time > 0 then
		self.resourceNode_:getChildByName("main_node"):getChildByName("unread"):setVisible(false)
	else
		self.resourceNode_:getChildByName("main_node"):getChildByName("unread"):setVisible(true)
	end


	
end

return mail_item
