--
-- Author: Wu Hengmin
-- Date: 2015-08-11 10:17:51
--

local backpack_equip_item = class("backpack_equip_item", cc.load("mvc").ViewBase)

backpack_equip_item.RESOURCE_FILENAME = "ui_instance/backpack/backpack_equip_item.csb"

function backpack_equip_item:onCreate()
	-- body

	self._rootNode = self.resourceNode_:getChildByName("main_layout")

	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
		        print("弹出装备信息")
		        if self.data then
			        UIManager:createEquipDialog(self.data)
			    end
		    end
	    end
    end
    self._rootNode:setSwallowTouches(false)
    self._rootNode:setCascadeOpacityEnabled(true)
    self._rootNode:addTouchEventListener(touchEvent)

end

function backpack_equip_item:update(data)
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
			"装备",
			data.id
		):getResourceNode()
		if icon then
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(43, 43)
			iconNode:addChild(icon)
		end
	end

	-- 等级
	if data ~= nil then
		self._rootNode:getChildByName("Text_7_0"):setVisible(true)
		self._rootNode:getChildByName("Text_7"):setVisible(true)
		local lv = self._rootNode:getChildByName("Text_7_0")
		lv:setString(data.mainlevel)
	else
		self._rootNode:getChildByName("Text_7_0"):setVisible(false)
		self._rootNode:getChildByName("Text_7"):setVisible(false)
	end
	
end

return backpack_equip_item
