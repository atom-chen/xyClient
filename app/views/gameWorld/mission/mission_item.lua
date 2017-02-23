--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local mission_item = class("mission_item", cc.load("mvc").ViewBase)

mission_item.RESOURCE_FILENAME = "ui_instance/mission/mission_item_node.csb"

function mission_item:onCreate()
	-- body

end

function mission_item:update(data)
	-- body
	self.data = data

	self.resourceNode_:getChildByName("main_layout"):getChildByName("name"):setString(Mission_BaseInfoSetup[data.rewardID].Caption)
	-- self.resourceNode_:getChildByName("main_layout"):getChildByName("count"):setString("数量:"..data.count)

	local iconNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("icon_node")
	iconNode:removeAllChildren()
	local icon = UIManager:CreateDropOutFrame(
			Mission_BaseInfoSetup[data.rewardID].RewardsPara.obj_type,
			Mission_BaseInfoSetup[data.rewardID].RewardsPara.obj_id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)

		iconNode:setSwallowTouches(false)
		local function touchEvent(sender,eventType)
			if eventType == ccui.TouchEventType.began then
				globalTouchEvent(sender,eventType)
			elseif eventType == ccui.TouchEventType.moved then
				globalTouchEvent(sender,eventType)
			elseif eventType == ccui.TouchEventType.ended then
				if globalTouchEvent(sender,eventType) then
					-- 显示信息界面
					print("显示信息界面")
				end
			end
		end
		iconNode:addTouchEventListener(touchEvent)
	end
	

	-- 是否完成
	if not data.isComplete then
		self.resourceNode_:getChildByName("main_layout"):getChildByName("jindu"):getChildByName("count"):setString(data.schedule.."/"..data.fixProperty.CPara1)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("jindu"):setVisible(true)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("yiwancheng"):setVisible(false)
	else
		self.resourceNode_:getChildByName("main_layout"):getChildByName("yiwancheng"):setVisible(true)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("jindu"):setVisible(false)
	end
	
end

return mission_item
