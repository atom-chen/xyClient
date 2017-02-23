--
-- Author: Wu Hengmin
-- Date: 2015-08-22 13:57:11
--

local hero_item = class("hero_item", cc.load("mvc").ViewBase)

hero_item.RESOURCE_FILENAME = "ui_instance/choose/hero_item.csb"

function hero_item:onCreate()
	-- body

	self._rootNode = self.resourceNode_:getChildByName("main_layout")


	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				if self.resourceNode_:getChildByName("main_layout"):getChildByName("CheckBox_1"):isSelected() then
					self.resourceNode_:getChildByName("main_layout"):getChildByName("CheckBox_1"):setSelected(false)
					dispatchGlobaleEvent("chooseup_ctrl", "updateCheck", {index = self.index, value = 0})
				elseif chooseSystemInstance.choose:getCountWithChoose() < self.max then
					self.resourceNode_:getChildByName("main_layout"):getChildByName("CheckBox_1"):setSelected(true)
					dispatchGlobaleEvent("chooseup_ctrl", "updateCheck", {index = self.index, value = 1})
				end

			end
		end
	end
	self._rootNode:setSwallowTouches(false)
	self._rootNode:addTouchEventListener(touchEvent)


end

function hero_item:update(data, index, max)
	-- body
	if data == nil then
		self._rootNode:setVisible(false)
		return
	end
	self.data = data
	self.index = index
	self.max = max
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
			icon:setPosition(50, 50)
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
			icon:setPosition(50, 50)
			iconNode:addChild(icon)
		end
	end

	-- 名字
	if data ~= nil then
		local name = self._rootNode:getChildByName("Text_3_1")
		local zhanli = self._rootNode:getChildByName("Text_3_0_0")
		name:setString(heroConfig[data.id].name)
		zhanli:setString(data:getZhanli())
		self._rootNode:getChildByName("Text_3_1"):setVisible(true)
		self._rootNode:getChildByName("Text_3_0_0"):setVisible(true)
		self._rootNode:getChildByName("Text_3_0"):setVisible(true)
	else
		self._rootNode:getChildByName("Text_3_1"):setVisible(false)
		self._rootNode:getChildByName("Text_3_0_0"):setVisible(false)
		self._rootNode:getChildByName("Text_3_0"):setVisible(false)
	end
	
end

return hero_item

