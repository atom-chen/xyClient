--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:20:26
--


local mission_item = class("mission_item")

function mission_item:ctor(node)
	-- body

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
	-- ccui.Helper:doLayout(self._rootNode)

	self:init()

	self:_registUIEvent()

end

function mission_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function mission_item:getResourceNode()
	-- body
	return self._rootNode
end

function mission_item:_registUIEvent()
	-- body

	local function button_1OnClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            print("发送完成任务")
	            dispatchGlobaleEvent("model_missionManager", "recordID", {recordID = self.data.rewardID})
	            gameTcp:SendMessage(MSG_C2MS_COMPLETE_MISSION, {self.data.rewardID})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	self._rootNode:setSwallowTouches(false)
	self._rootNode:addTouchEventListener(button_1OnClicked)

end

function mission_item:update(data)
	-- body
	self.data = data
	self._rootNode:getChildByName("Text_1"):setString(Mission_BaseInfoSetup[data.rewardID].Caption)
	self._rootNode:getChildByName("Text_1_0"):setString(Mission_BaseInfoSetup[data.rewardID].Caption)


	-- 是否完成
	if not data.isComplete then
		self._rootNode:getChildByName("Text_5_0_0"):setString(data.schedule.."/"..data.fixProperty.CPara1)
		self._rootNode:getChildByName("Text_5_0_0"):setVisible(true)
		self._rootNode:getChildByName("Text_5_0"):setVisible(true)
		self._rootNode:getChildByName("Text_5"):setVisible(false)
	else
		self._rootNode:getChildByName("Text_5"):setVisible(true)
		self._rootNode:getChildByName("Text_5_0_0"):setVisible(false)
		self._rootNode:getChildByName("Text_5_0"):setVisible(false)
	end

	-- 奖励图标
	local iconNode = self._rootNode:getChildByName("Panel_2")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)

	local icon = UIManager:CreateDropOutFrame(
		Mission_BaseInfoSetup[data.rewardID].RewardsPara.obj_type,
		Mission_BaseInfoSetup[data.rewardID].RewardsPara.obj_id
	):getResourceNode()
	if icon then
		icon:setSwallowTouches(false)
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(43, 43)
		iconNode:addChild(icon)
	end


end


return mission_item
