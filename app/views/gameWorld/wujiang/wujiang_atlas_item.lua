--
-- Author: Wu Hengmin
-- Date: 2015-08-13 14:23:50
--


local wujiang_atlas_item = class("wujiang_atlas_item", cc.load("mvc").ViewBase)

wujiang_atlas_item.RESOURCE_FILENAME = "ui_instance/wujiang/wujiang_atlas_item.csb"

function wujiang_atlas_item:onCreate()
	-- body
	self._rootNode = self.resourceNode_:getChildByName("main_layout")

	-- 查看
	self.button_1 = self._rootNode:getChildByName("Image_1")
	local function button_1OnClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            UIManager:createAtlasDialog(self.data)
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	self.button_1:setSwallowTouches(false)
	self.button_1:addTouchEventListener(button_1OnClicked)

end

function wujiang_atlas_item:update(data)
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
		self._rootNode:getChildByName("Text_3"):setVisible(true)
		self.button_1:setVisible(true)
	else
		self._rootNode:getChildByName("Text_3"):setVisible(false)
		self.button_1:setVisible(false)
	end

end

return wujiang_atlas_item
