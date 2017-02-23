--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:20:26
--


local friends_item = class("friends_item", cc.load("mvc").ViewBase)

friends_item.RESOURCE_FILENAME = "ui_instance/friends2/friends_item.csb"

function friends_item:onCreate()
	-- body

	self._rootNode = self.resourceNode_:getChildByName("main_layout")

	local button1 = self._rootNode:getChildByName("Image_1")
	local function button_1Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            print("查看")
	            if self.data then
		            UIManager:createFriendsDialog(self.data)
		        end
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button1:addTouchEventListener(button_1Clicked)


	local button2 = self._rootNode:getChildByName("Image_1_0")
	local function button_2Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            print("申请")
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button2:addTouchEventListener(button_2Clicked)


	local button3 = self._rootNode:getChildByName("Image_1_1")
	local function button_3Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            print("拒绝")
	            gameTcp:SendMessage(MSG_C2MS_FRIEND_AGREE, {self.data.GUID, 0})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button3:addTouchEventListener(button_3Clicked)


	local button4 = self._rootNode:getChildByName("Image_1_2")
	local function button_4Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            print("同意")
	            gameTcp:SendMessage(MSG_C2MS_FRIEND_AGREE, {self.data.GUID, 1})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button4:addTouchEventListener(button_4Clicked)

end

function friends_item:setMode(mode)
	-- body
	self._rootNode:getChildByName("Image_1"):setVisible(false)
	self._rootNode:getChildByName("Image_1_0"):setVisible(false)
	self._rootNode:getChildByName("Image_1_1"):setVisible(false)
	self._rootNode:getChildByName("Image_1_2"):setVisible(false)
	if mode == 1 then -- 好友
		self._rootNode:getChildByName("Image_1"):setVisible(true)
	elseif mode == 2 then -- 推荐
		self._rootNode:getChildByName("Image_1_0"):setVisible(true)
	elseif mode == 3 then -- 申请
		self._rootNode:getChildByName("Image_1_1"):setVisible(true)
		self._rootNode:getChildByName("Image_1_2"):setVisible(true)
	end
end

function friends_item:update(data)
	-- body
	self.data = data
	if data then
		local name = self._rootNode:getChildByName("Text_3")
		name:setString(data.Name)
		local level = self._rootNode:getChildByName("Text_3_0_0")
		level:setString(data.grade)
		local zhanli = self._rootNode:getChildByName("Text_3_0")
		zhanli:setString(data.strength)
		local vipg = self._rootNode:getChildByName("Text_3_0_0_0")
		vipg:setString(data.vipgrade)

		if data.captainhero then
			local iconNode = self._rootNode:getChildByName("icon_node")
			iconNode:removeAllChildren()
			iconNode:setCascadeOpacityEnabled(true)
			
			local icon = UIManager:CreateDropOutFrame(
				"卡片",
				data.captainhero.templeateID
			):getResourceNode()
			if icon then
				icon:setSwallowTouches(false)
				icon:setCascadeOpacityEnabled(true)
				icon:setPosition(50, 50)
				iconNode:addChild(icon)
			end
		end

		self._rootNode:setVisible(true)
	else
		self._rootNode:setVisible(false)
	end

end

return friends_item
