--
-- Author: Wu Hengmin
-- Date: 2015-07-09 17:48:18
--

local equip_fenjie_item = class("equip_fenjie_item")


function equip_fenjie_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function equip_fenjie_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function equip_fenjie_item:getResourceNode()
	-- body
	return self._rootNode
end


function equip_fenjie_item:_registUIEvent()
	-- body

	-- local function touchEvent(sender,eventType)
	-- 	if eventType == ccui.TouchEventType.ended then
 --        	-- dispatchGlobaleEvent("goods_ctrl", "clickSubTitleList", {sender=sender, eventType=eventType})
 --        	print("点击装备")
 --    	end
 --    end
	-- self._rootNode:addTouchEventListener(touchEvent)
end


function equip_fenjie_item:update(equip)
	-- body
	self.equip = equip
	self._rootNode:getChildByName("name"):setString(EquipConfig[equip.id].name)
	self._rootNode:getChildByName("name"):setColor(cc.c3b(200, 150, 50))
	-- self._rootNode:getChildByName("lv"):setString(equip.curLv)

	-- 等级
	self._rootNode:getChildByName("lv"):setString(equip.mainlevel)
	self._rootNode:getChildByName("lv"):setColor(cc.c3b(120, 180, 90))
	self._rootNode:getChildByName("Text_10_18_6"):setColor(cc.c3b(120, 180, 90))
	
	-- 更新属性
	self._rootNode:getChildByName("main_attr"):setString(MAIN_PLAYER.equipManager:getMainType(equip.id)..":")
	self._rootNode:getChildByName("main_attr"):setColor(cc.c3b(120, 180, 90))
	self._rootNode:getChildByName("off_attr"):setString(MAIN_PLAYER.equipManager:getOffType(equip.id)..":")
	self._rootNode:getChildByName("off_attr"):setColor(cc.c3b(120, 180, 90))
	self._rootNode:getChildByName("count1"):setString(MAIN_PLAYER.equipManager:getMainAttr(equip.guid))
	self._rootNode:getChildByName("count1"):setColor(cc.c3b(120, 180, 90))
	self._rootNode:getChildByName("count2"):setString(MAIN_PLAYER.equipManager:getOffAttr(equip.guid))
	self._rootNode:getChildByName("count2"):setColor(cc.c3b(120, 180, 90))

	-- 更新头像
	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"装备",
			equip.id
		):getResourceNode()
	if icon then
		-- icon:setSwallowTouches(false)
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end


end

return equip_fenjie_item
