--
-- Author: Wu Hengmin
-- Date: 2015-08-22 14:05:04
--


local equip_item = class("equip_item", cc.load("mvc").ViewBase)

equip_item.RESOURCE_FILENAME = "ui_instance/choose/equip_item.csb"

function equip_item:onCreate()
	-- body

	self._rootNode = self.resourceNode_:getChildByName("Panel_1")

	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				if self.resourceNode_:getChildByName("Panel_1"):getChildByName("CheckBox_1"):isSelected() then
					self.resourceNode_:getChildByName("Panel_1"):getChildByName("CheckBox_1"):setSelected(false)
					dispatchGlobaleEvent("chooseup_ctrl", "updateCheck", {index = self.index, value = 0})
				elseif chooseSystemInstance.choose:getCountWithChoose() < self.max then
					self.resourceNode_:getChildByName("Panel_1"):getChildByName("CheckBox_1"):setSelected(true)
					dispatchGlobaleEvent("chooseup_ctrl", "updateCheck", {index = self.index, value = 1})
				end
	        	
		    end
    	end
    end
    self._rootNode:setSwallowTouches(false)
	self._rootNode:addTouchEventListener(touchEvent)

end

function equip_item:update(data, index, max)
	-- body
	if data == nil then
		self._rootNode:setVisible(false)
		return
	end
	print("最大:"..max)
	self.max = max
	self.data = data
	self.index = index
	local iconNode = self._rootNode:getChildByName("Panel_2")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	
	local icon = UIManager:CreateDropOutFrame(
		"装备",
		data.id
	):getResourceNode()
	if icon then
		icon:setSwallowTouches(false)
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end

	-- 名字
	local name = self._rootNode:getChildByName("Text_1_3_0")
	name:setString(EquipConfig[data.id].name)
	self._rootNode:getChildByName("Text_1_3_0"):setVisible(true)

	-- 等级
	local level = self._rootNode:getChildByName("Text_3")
	level:setString("Lv."..data.mainlevel)

	-- 评分
	local score1 = self._rootNode:getChildByName("Text_1_1_0")
	score1:setString(data:getZhanDouLiMain())
	local score2 = self._rootNode:getChildByName("Text_1_1_0_0")
	score2:setString("("..data:getZhanDouLiOff()..")")

	-- 主属性
	local mainattr_type = self._rootNode:getChildByName("Text_1_2_6")
	mainattr_type:setString(data:getMainTypeName()..":")

	local mainattr = self._rootNode:getChildByName("Text_1_2_4_5")
	mainattr:setString(data:getMainAttr())

	-- 属性
	local attr1 = self._rootNode:getChildByName("Text_1_2_4")
	attr1:setString(data.off_attr_1)
	
	local attr2 = self._rootNode:getChildByName("Text_1_2_4_0")
	attr2:setString(data.off_attr_2)
	
	local attr3 = self._rootNode:getChildByName("Text_1_2_4_1")
	attr3:setString(data.off_attr_3)
	
	local attr4 = self._rootNode:getChildByName("Text_1_2_4_2")
	attr4:setString(data.off_attr_4)
	
	local attr5 = self._rootNode:getChildByName("Text_1_2_4_3")
	attr5:setString(data.off_attr_5)

	-- 附加属性
	for i=1,#data.other_attr do
		print(i)
	end

	
end

return equip_item

