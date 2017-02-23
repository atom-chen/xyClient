--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local equip_item = class("equip_item")

function equip_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

end

function equip_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function equip_item:getResourceNode()
	-- body
	return self._rootNode
end



function equip_item:_registUIEvent()
	-- body

	-- local function touchEvent(sender,eventType)
	-- 	if eventType == ccui.TouchEventType.ended then
 --        	-- dispatchGlobaleEvent("goods_ctrl", "clickSubTitleList", {sender=sender, eventType=eventType})
 --        	print("点击装备")
 --    	end
 --    end
	-- self._rootNode:addTouchEventListener(touchEvent)
end



function equip_item:update(equip)
	-- body
	self.equip = equip
	self._rootNode:getChildByName("name"):setString(EquipConfig[equip.id].name)
	self._rootNode:getChildByName("lv"):setString(equip.mainlevel)

	-- 更新属性
	self._rootNode:getChildByName("main_attr"):setString(MAIN_PLAYER.equipManager:getMainType(equip.id)..":")
	self._rootNode:getChildByName("off_attr"):setString(MAIN_PLAYER.equipManager:getOffType(equip.id)..":")
	self._rootNode:getChildByName("main_attr_count"):setString(MAIN_PLAYER.equipManager:getMainAttr(equip.guid))
	self._rootNode:getChildByName("off_attr_count"):setString(MAIN_PLAYER.equipManager:getOffAttr(equip.guid))

	-- 更新头像
	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"装备",
			equip.id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		-- icon:setSwallowTouches(false)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end

	-- 是否上阵
	
end

return equip_item
