--
-- Author: Wu Hengmin
-- Date: 2015-08-18 11:26:15
--

local wujiangup_listitem = class("wujiangup_listitem")

function wujiangup_listitem:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

end

function wujiangup_listitem:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function wujiangup_listitem:getResourceNode()
	-- body
	return self._rootNode
end


function wujiangup_listitem:_registUIEvent()
	-- body
	local bg = self._rootNode:getChildByName("bg")
	local function clickEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				dispatchGlobaleEvent("wujiang_ctrl", "updatePanel", {data = self.data})
				dispatchGlobaleEvent("wujiangup_ctrl", "updateChoose", {data = self.data})
			end
		elseif eventType == ccui.TouchEventType.canceled then

		end
	end
	bg:addTouchEventListener(clickEvent)
end


function wujiangup_listitem:update(data)
	-- body
	self.data = data
	
	self._rootNode:getChildByName("name"):setString(heroConfig[data.id].name)
	

	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"卡片",
			data.id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(43, 43)
		iconNode:addChild(icon)
	end

	-- 战力
	local zhanli = self._rootNode:getChildByName("name_0_0")
	zhanli:setString(data:getZhanli())

	-- 是否上阵
	
	self:isInTeam(data:isInTeam())

end

function wujiangup_listitem:isChoose(bool)
	-- body
	if bool then
		self._rootNode:getChildByName("bg2"):setVisible(true)
	else
		self._rootNode:getChildByName("bg2"):setVisible(false)
	end
end

function wujiangup_listitem:isInTeam(bool)
	-- body
	if bool then
		self._rootNode:getChildByName("Panel_1"):setVisible(true)
	else
		self._rootNode:getChildByName("Panel_1"):setVisible(false)
	end
end

return wujiangup_listitem
