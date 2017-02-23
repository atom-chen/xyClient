--
-- Author: Wu Hengmin
-- Date: 2015-08-13 13:58:41
--


local wujiang_fragment_item = class("wujiang_fragment_item", cc.load("mvc").ViewBase)

wujiang_fragment_item.RESOURCE_FILENAME = "ui_instance/wujiang/wujiang_fragment_item.csb"

function wujiang_fragment_item:onCreate()
	-- body
	self._rootNode = self.resourceNode_:getChildByName("main_layout")

	-- 合成
	self.button_1 = self._rootNode:getChildByName("Image_1")
	local function button_1OnClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            print("合成")
	            gameTcp:SendMessage(MSG_C2MS_PIECE_HERO_MERGE, {self.data.id})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	self.button_1:setSwallowTouches(false)
	self.button_1:addTouchEventListener(button_1OnClicked)

	-- 分解
	self.button_2 = self._rootNode:getChildByName("Image_1_0")
	local function button_1OnClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            print("分解")
	            gameTcp:SendMessage(MSG_C2MS_PIECE_TO_SOUL, {self.data.id})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	self.button_2:setSwallowTouches(false)
	self.button_2:addTouchEventListener(button_1OnClicked)

end

function wujiang_fragment_item:update(data)
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
			"卡片",
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

		local name = self._rootNode:getChildByName("Text_3")
		name:setString(heroConfig[data.id].name)
		local num = self._rootNode:getChildByName("Text_3_0")
		num:setString(data.count.."/"..heroConfig[data.id].unite)
		self._rootNode:getChildByName("Text_3"):setVisible(true)
		self._rootNode:getChildByName("Text_3_0"):setVisible(true)
	else
		self._rootNode:getChildByName("Text_3"):setVisible(false)
		self._rootNode:getChildByName("Text_3_0"):setVisible(false)
	end


	-- 是否已经拥有该武将
	if data == nil then
		self.button_1:setVisible(false)
		self.button_2:setVisible(false)
		self._rootNode:getChildByName("Image_2"):setVisible(false)
	elseif MAIN_PLAYER.heroManager:isHave(data.id) then
		self.button_1:setVisible(false)
		self.button_2:setVisible(true)
		self.button_2:setPositionX(118)
		self._rootNode:getChildByName("Image_2"):setVisible(true)
	else
		self.button_1:setVisible(true)
		self.button_2:setVisible(true)
		self.button_2:setPositionX(178)
		self._rootNode:getChildByName("Image_2"):setVisible(false)
	end
	
end

return wujiang_fragment_item
