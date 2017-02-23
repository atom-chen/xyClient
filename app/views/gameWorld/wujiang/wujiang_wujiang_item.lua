--
-- Author: Wu Hengmin
-- Date: 2015-08-13 10:48:19
--

local wujiang_wujiang_item = class("wujiang_wujiang_item", cc.load("mvc").ViewBase)

wujiang_wujiang_item.RESOURCE_FILENAME = "ui_instance/wujiang/wujiang_wujiang_item.csb"

function wujiang_wujiang_item:onCreate()
	-- body

	self._rootNode = self.resourceNode_:getChildByName("main_layout")

	-- 查看按钮
	local upgrade = self._rootNode:getChildByName("Image_1")
	local function Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 调到强化界面
	            print("调到强化界面")
	            dispatchGlobaleEvent("wujiangup_ctrl", "open", {data = self.data})
	            
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	upgrade:setSwallowTouches(false)
	upgrade:addTouchEventListener(Clicked)


end

function wujiang_wujiang_item:update(data)
	-- body
	self.data = data
	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	if data == nil then
		local icon = UIManager:CreateDropOutFrame(
			"大卡片"
		):getResourceNode()
		if icon then
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(79, 115)
			iconNode:addChild(icon)
		end
	else
		local icon = UIManager:CreateDropOutFrame(
			"大卡片",
			data.id
		):getResourceNode()
		if icon then
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(79, 115)
			iconNode:addChild(icon)
		end
	end

	-- 名字
	if data ~= nil then
		local name = self._rootNode:getChildByName("Text_3")
		local zhanli = self._rootNode:getChildByName("Text_3_0_0")
		name:setString(heroConfig[data.id].name)
		zhanli:setString(data:getZhanli())
		self._rootNode:getChildByName("Text_3"):setVisible(true)
		self._rootNode:getChildByName("Text_3_0"):setVisible(true)
		self._rootNode:getChildByName("Text_3_0_0"):setVisible(true)
		self._rootNode:getChildByName("Image_1"):setVisible(true)
		iconNode:setVisible(true)
	else
		self._rootNode:getChildByName("Text_3"):setVisible(false)
		self._rootNode:getChildByName("Text_3_0"):setVisible(false)
		self._rootNode:getChildByName("Text_3_0_0"):setVisible(false)
		self._rootNode:getChildByName("Image_1"):setVisible(false)
		iconNode:setVisible(false)
	end
	
end

return wujiang_wujiang_item
