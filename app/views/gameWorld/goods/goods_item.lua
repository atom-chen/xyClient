--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:03
--

local goods_item = class("goods_item")

function goods_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

end

function goods_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function goods_item:getResourceNode()
	-- body
	return self._rootNode
end


function goods_item:_registUIEvent()
	-- body
	local button_use = self._rootNode:getChildByName("button_use")
	local function clickEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/goods/goods_button_use_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/goods/goods_button_use_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/goods/goods_button_use_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
				print("使用")
				gameTcp:SendMessage(MSG_C2MS_ITEMS_USE, {self.data.id, 10})
			end
		elseif eventType == ccui.TouchEventType.canceled then
			sender:loadTexture("ui_image/goods/goods_button_use_0.png", ccui.TextureResType.plistType)
		end
	end
	button_use:addTouchEventListener(clickEvent)

	self._rootNode:getChildByName("descrip"):setColor(cc.c3b(120, 180, 90))
end


function goods_item:update(data)
	-- body
	self.data = data
	
	self._rootNode:getChildByName("name"):setString(ItemsConfig[data.id].name)
	self._rootNode:getChildByName("count"):setString("数量:"..data.count)
	self._rootNode:getChildByName("descrip"):setString(ItemsConfig[data.id].info)
	

	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			data.id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end

	if ItemsConfig[data.id].use_fun then
		self._rootNode:getChildByName("button_use"):setVisible(true)
	else
		self._rootNode:getChildByName("button_use"):setVisible(false)
	end
end

return goods_item
