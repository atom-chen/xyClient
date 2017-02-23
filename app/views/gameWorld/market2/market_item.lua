--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:20:26
--


local market_item = class("market_item")

function market_item:ctor(node)
	-- body

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
	-- ccui.Helper:doLayout(self._rootNode)

	self:init()

	self:_registUIEvent()

end

function market_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function market_item:getResourceNode()
	-- body
	return self._rootNode
end

function market_item:_registUIEvent()
	-- body

	local button = self._rootNode:getChildByName("Image_1")
	local function Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			button:loadTexture("ui_image/market2/wujiang005.png", ccui.TextureResType.plistType)
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
			button:loadTexture("ui_image/market2/wujiang005.png", ccui.TextureResType.plistType)
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
			button:loadTexture("ui_image/market2/wujiang005.png", ccui.TextureResType.plistType)
	        if globalTouchEvent(sender,eventType) then
	            print("发送购买")
	            gameTcp:SendMessage(MSG_C2MS_BUY_GOODS, {table.indexof(stoneConfig, self.data)})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button:setSwallowTouches(false)
	button:addTouchEventListener(Clicked)

end

function market_item:update(data)
	-- body
	self.data = data
	self._rootNode:getChildByName("Text_1"):setString(data.name)
	self._rootNode:getChildByName("Text_1_0"):setString(data.subscription)
	self._rootNode:getChildByName("Text_1_1"):setString(data.price)

	local iconNode = self._rootNode:getChildByName("Panel_2")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			data.icon
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(43, 43)
		iconNode:addChild(icon)
	end

end


return market_item
