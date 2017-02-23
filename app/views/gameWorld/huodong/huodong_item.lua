--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local huodong_item = class("huodong_item", cc.load("mvc").ViewBase)

huodong_item.RESOURCE_FILENAME = "ui_instance/huodong/huodong_item_node.csb"


function huodong_item:onCreate()
	-- body
end

function huodong_item:update(data)
	-- body
	self.data = data
	
	
	
end

return huodong_item
