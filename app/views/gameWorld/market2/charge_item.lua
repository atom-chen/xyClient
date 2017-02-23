--
-- Author: Wu Hengmin
-- Date: 2015-08-27 11:28:15
--

local charge_item = class("charge_item")

function charge_item:ctor(node)
	-- body

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
	-- ccui.Helper:doLayout(self._rootNode)

	self:init()

	self:_registUIEvent()

end

function charge_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function charge_item:getResourceNode()
	-- body
	return self._rootNode
end

function charge_item:_registUIEvent()
	-- body

	local button = self._rootNode:getChildByName("Image_1")
	local function Clicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			button:loadTexture("ui_image/market2/007.png", ccui.TextureResType.plistType)
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
			button:loadTexture("ui_image/market2/007.png", ccui.TextureResType.plistType)
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
			button:loadTexture("ui_image/market2/007.png", ccui.TextureResType.plistType)
	        if globalTouchEvent(sender,eventType) then
	            gameTcp:SendMessage(MSG_C2MS_BUY_YUANBAO, {table.indexof(saleConfig, self.data)})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	button:setSwallowTouches(false)
	button:addTouchEventListener(Clicked)

end

function charge_item:update(data)
	-- body
	self.data = data

	self._rootNode:getChildByName("Text_1"):setString(data.price.."元")
	self._rootNode:getChildByName("Text_1_0"):setString(data.name)

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


return charge_item
