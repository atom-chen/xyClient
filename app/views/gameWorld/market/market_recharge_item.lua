--
-- Author: Wu Hengmin
-- Date: 2015-07-08 20:00:59
--

local market_recharge_item = class("market_recharge_item", cc.load("mvc").ViewBase)

market_recharge_item.RESOURCE_FILENAME = "ui_instance/market/market_recharge_item_node.csb"


function market_recharge_item:onCreate()
	-- body
end


function market_recharge_item:update(data)
	-- body
	self.data = data
	if data.type_ == 1 then
		local name = self.resourceNode_:getChildByName("main_node"):getChildByName("title_node_1"):getChildByName("name")
		name:setString(data.name)
		self.resourceNode_:getChildByName("main_node"):getChildByName("title_node_1"):setVisible(true)
		self.resourceNode_:getChildByName("main_node"):getChildByName("title_node_2"):setVisible(false)
	elseif data.type_ == 0 then
		self.resourceNode_:getChildByName("main_node"):getChildByName("title_node_1"):setVisible(false)
		self.resourceNode_:getChildByName("main_node"):getChildByName("title_node_2"):setVisible(true)
	end
	
	local descrip = self.resourceNode_:getChildByName("main_node"):getChildByName("descrip")
	descrip:setString(data.descrip)
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

return market_recharge_item
