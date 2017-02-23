--
-- Author: Wu Hengmin
-- Date: 2015-07-01 14:40:01
-- 武将列表item

local heros_item_node = class("heros_item_node")

function heros_item_node:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()

    self:_registUIEvent()

end

function heros_item_node:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function heros_item_node:getResourceNode()
	-- body
	return self._rootNode
end

function heros_item_node:_registUIEvent()
	-- body

	-- local function touchEvent(sender,eventType)
	-- 	if eventType == ccui.TouchEventType.ended then
 --        	-- dispatchGlobaleEvent("goods_ctrl", "clickSubTitleList", {sender=sender, eventType=eventType})
 --        	print("点击武将")
 --    	end
 --    end
	-- self._rootNode:addTouchEventListener(touchEvent)
end

function heros_item_node:update(hero)
	-- body
	self.hero = hero
	self._rootNode:getChildByName("name"):setString(heroConfig[hero.id].name)
	self._rootNode:getChildByName("lv"):setString(hero.curLv)

	-- 更新属性
	self._rootNode:getChildByName("attr1"):setString(hero:getAttackTotal())
	self._rootNode:getChildByName("attr2"):setString(hero:getHPTotal())
	self._rootNode:getChildByName("attr3"):setString(hero:getWuFangTotal())
	self._rootNode:getChildByName("attr4"):setString(hero:getMoFangTotal())

	-- 更新头像
	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"卡片",
			hero.id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end

	-- 是否上阵
	local yishangzhen = self._rootNode:getChildByName("yishangzhen")
	-- if xxx then
	-- 	yishangzhen:setVisible(false)
	-- else
	-- 	yishangzhen:setVisible(true)
	-- end

end

return heros_item_node
