--
-- Author: Wu Hengmin
-- Date: 2015-08-11 17:10:41
--


local backpack_goods_item = class("backpack_goods_item", cc.load("mvc").ViewBase)

backpack_goods_item.RESOURCE_FILENAME = "ui_instance/backpack/backpack_goods_item.csb"

function backpack_goods_item:onCreate()
	-- body

	self._rootNode = self.resourceNode_:getChildByName("main_layout")

	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
		        print("弹出道具信息")
		        UIManager:createGoodsDialog(self.data)
		    end
	    end
    end
    self._rootNode:setSwallowTouches(false)
    self._rootNode:setCascadeOpacityEnabled(true)
    self._rootNode:addTouchEventListener(touchEvent)

end

function backpack_goods_item:update(data)
	-- body
	self.data = data
	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	if data == nil then
		local icon = UIManager:CreateDropOutFrame(
			"空白"
		):getResourceNode()
		if icon then
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(43, 43)
			iconNode:addChild(icon)
		end
	else
		local icon = UIManager:CreateDropOutFrame(
			"道具",
			data.id
		):getResourceNode()
		if icon then
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(43, 43)
			iconNode:addChild(icon)
		end
	end

	-- 名字
	if data ~= nil then
		self._rootNode:getChildByName("Text_1"):setVisible(true)
		local lv = self._rootNode:getChildByName("Text_1")
		lv:setString(ItemsConfig[data.id].name)
	else
		self._rootNode:getChildByName("Text_1"):setVisible(false)
	end

	-- 数量
	if data ~= nil then
		self._rootNode:getChildByName("Text_1_0"):setVisible(true)
		local lv = self._rootNode:getChildByName("Text_1_0")
		lv:setString("x"..data.count)
	else
		self._rootNode:getChildByName("Text_1_0"):setVisible(false)
	end
	
end

return backpack_goods_item
