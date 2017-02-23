--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:10
--

local friends_recommend_item = class("friends_recommend_item")


function friends_recommend_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
	

end

function friends_recommend_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)

	------------------------ 邀请按钮 ------------------------
	local button = self._rootNode:getChildByName("button_invite")
	local function clickEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/friends/friends_button_invite_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
				print("点击邀请")
				-- gameTcp:SendMessage(MSG_C2MS_ITEMS_SELL, {1, self.data.id, self.count})
			end
		elseif eventType == ccui.TouchEventType.canceled then
			sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
		end
	end
	-- button:setSwallowTouches(false)
	button:addTouchEventListener(clickEvent)
end

function friends_recommend_item:getResourceNode()
	-- body
	return self._rootNode
end

function friends_recommend_item:update(data)
	-- body
	self.data = data
	-- self.resourceNode_:getChildByName("main_layout"):getChildByName("name"):setString(ItemsConfig[data.id].name)
	-- self.resourceNode_:getChildByName("main_layout"):getChildByName("count"):setString("数量:"..data.count)

	-- self.resourceNode_:getChildByName("main_layout"):getChildByName("price"):setString("单价:"..ItemsConfig[data.id].price)


	-- local iconNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("icon_node")
	-- iconNode:removeAllChildren()
	-- local icon = UIManager:CreateDropOutFrame(
	-- 		"道具",
	-- 		data.id
	-- 	):getResourceNode()
	-- if icon then
	-- 	icon:setCascadeOpacityEnabled(true)
	-- 	icon:setPosition(50, 50)
	-- 	iconNode:addChild(icon)
	-- end
end

return friends_recommend_item
