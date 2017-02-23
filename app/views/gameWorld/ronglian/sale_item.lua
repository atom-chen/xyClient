--
-- Author: Wu Hengmin
-- Date: 2015-08-24 14:10:21
--


local sale_item = class("sale_item", cc.load("mvc").ViewBase)

sale_item.RESOURCE_FILENAME = "ui_instance/ronglian/sale_item.csb"

function sale_item:onCreate()
	-- body
	self._rootNode = self.resourceNode_:getChildByName("main_layout")

	-- 购买
	self.button_1 = self._rootNode:getChildByName("Button_1")
	local function button_1OnClicked(sender, eventType)
		-- body
		print("购买")
		print(UIManager:createDropName(self.data.type_, self.data.id))
		gameTcp:SendMessage(MSG_C2MS_BUY_RONGLIANSHOP_ITEM, {table.indexof(MAIN_PLAYER.marketManager.ronglianShop, self.data)})
	end
	self.button_1:setSwallowTouches(false)
	self.button_1:addClickEventListener(button_1OnClicked)


end

function sale_item:update(data)
	-- body
	self.data = data
	if data then
		local iconNode = self._rootNode:getChildByName("icon_node")
		iconNode:removeAllChildren()
		iconNode:setCascadeOpacityEnabled(true)
		local icon = UIManager:CreateDropOutFrame(
			data.type_,
			data.id
		):getResourceNode()
		if icon then
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(50, 50)
			iconNode:addChild(icon)
		end

		-- 名字
		if data ~= nil then
			local name = self._rootNode:getChildByName("Text_3")
			name:setString(UIManager:createDropName(data.type_, data.id))
			self._rootNode:getChildByName("Text_3"):setVisible(true)
		else
			self._rootNode:getChildByName("Text_3"):setVisible(false)
		end

		-- 价格
		local price = self._rootNode:getChildByName("Text_3_0")
		if data.pricetype == eDT_YuanBao then
			price:setString("元宝:"..math.ceil(data.price*data.discount/10))
		elseif data.pricetype == eDT_SmeltValue then
			price:setString("熔炼值:"..math.ceil(data.price*data.discount/10))
		end
		self._rootNode:setVisible(true)
	else
		self._rootNode:setVisible(false)
	end
	
end

return sale_item
