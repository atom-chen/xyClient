--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local shiji_item = class("shiji_item", cc.load("mvc").ViewBase)

shiji_item.RESOURCE_FILENAME = "ui_instance/shiji/shiji_item_node.csb"

function shiji_item:onCreate()
	-- body

end


function shiji_item:update(data)
	-- body
	self.data = data
	self.resourceNode_:getChildByName("main_node"):getChildByName("name"):setString(data.name)
	self.resourceNode_:getChildByName("main_node"):getChildByName("count"):setString(data.count2.."/"..data.count1)
	self.resourceNode_:getChildByName("main_node"):getChildByName("price1"):setString(data.price1)
	self.resourceNode_:getChildByName("main_node"):getChildByName("price2"):setString(data.price2)

	local iconNode = self.resourceNode_:getChildByName("main_node"):getChildByName("icon_node")
	iconNode:removeAllChildren()
	local icon = UIManager:CreateDropOutFrame(
			data.itemTypeForIcon,
			data.itemIDForIcon
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

	
end

return shiji_item
