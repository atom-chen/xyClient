--
-- Author: Wu Hengmin
-- Date: 2015-08-12 15:02:40
--


local backpack_fragment_item = class("backpack_fragment_item", cc.load("mvc").ViewBase)

backpack_fragment_item.RESOURCE_FILENAME = "ui_instance/backpack/backpack_fragment_item.csb"

function backpack_fragment_item:onCreate()
	-- body

	local get = self.resourceNode_:getChildByName("main_layout"):getChildByName("Image_1")

	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
		        print("获取或者合成")
		        -- if true then
			        gameTcp:SendMessage(MSG_C2MS_EQUIPS_UNITE, {self.data})
			    -- end
		    end
	    end
    end
    get:setSwallowTouches(false)
    get:addTouchEventListener(touchEvent)

end

function backpack_fragment_item:update(data)
	-- body
	self.data = data
	local iconNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("icon_node")
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

	-- 名字
	local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_3")
	-- 数量
	local count = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_3_0")
	if data then
		name:setString(EquipConfig[data.id].name)
		name:setVisible(true)
		count:setString("x"..data.count)
		count:setVisible(true)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Image_1"):setVisible(true)
	else
		name:setVisible(false)
		count:setVisible(false)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Image_1"):setVisible(false)
	end

end

return backpack_fragment_item
