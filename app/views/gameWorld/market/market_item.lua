--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local market_item = class("market_item", cc.load("mvc").ViewBase)

market_item.RESOURCE_FILENAME = "ui_instance/market/market_item_node.csb"

function market_item:onCreate()
	-- body
end


function market_item:update(data)
	-- body

	self.data = data
	self.resourceNode_:getChildByName("main_node"):getChildByName("name"):setString(data.name)
	self.resourceNode_:getChildByName("main_node"):getChildByName("descrip"):setString(data.subscription)
	self.resourceNode_:getChildByName("main_node"):getChildByName("price"):setString(data.price)


	local iconNode = self.resourceNode_:getChildByName("main_node"):getChildByName("icon_node")
	iconNode:removeAllChildren()
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			data.icon
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end


	
end

return market_item
