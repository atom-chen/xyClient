--
-- Author: Wu Hengmin
-- Date: 2015-07-06 17:22:51
-- 武将碎片列表item

local heros_fragments_item_node = class("heros_fragments_item_node")


function heros_fragments_item_node:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()
end

function heros_fragments_item_node:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function heros_fragments_item_node:getResourceNode()
	-- body
	return self._rootNode
end



function heros_fragments_item_node:_registUIEvent()
	-- body

	local function htouchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/heros_button_hc_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/heros_button_hc_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/heros_button_hc_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	        	-- dispatchGlobaleEvent("goods_ctrl", "clickSubTitleList", {sender=sender, eventType=eventType})
	        	print("合成"..self.data.id)
	        	gameTcp:SendMessage(MSG_C2MS_PIECE_HERO_MERGE, {
							self.data.id,
						})
		    end
    	end
    end
	-- 合成按钮
	local button_h = self._rootNode:getChildByName("button_hecheng")
	button_h:setSwallowTouches(false)
	button_h:addTouchEventListener(htouchEvent)

	local function ftouchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/heros_button_fj_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/heros_button_fj_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/heros_button_fj_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	        	-- dispatchGlobaleEvent("goods_ctrl", "clickSubTitleList", {sender=sender, eventType=eventType})
	        	print("分解"..self.data.id)
	        	gameTcp:SendMessage(MSG_C2MS_PIECE_TO_SOUL, {
							self.data.id,
						})
	        	-- 分解比例 PIECE_TO_SOUL = 10
		    end
    	end
    end
	-- 分解按钮
	local button_f = self._rootNode:getChildByName("button_fenjie")
	button_f:setSwallowTouches(false)
	button_f:addTouchEventListener(ftouchEvent)

	self.have = self._rootNode:getChildByName("have")
end


function heros_fragments_item_node:update(data)
	-- body
	self.data = data
	if heroConfig[data.id] then
		self._rootNode:getChildByName("name"):setString(heroConfig[data.id].name)
	else
		self._rootNode:getChildByName("name"):setString("未知目标")
	end
	self._rootNode:getChildByName("name"):setColor(cc.c3b(200, 150, 50))

	-- 更新数量
	self._rootNode:getChildByName("count"):setString(data.count.."/"..heroConfig[data.id].unite)
	self._rootNode:getChildByName("count"):setColor(cc.c3b(190, 50, 30))

	-- 更新头像
	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)

	local icon = UIManager:CreateDropOutFrame(
			"卡片",
			data.id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end

	-- 是否拥有

	if MAIN_PLAYER.heroManager:isHave(data.id) then
		self.have:setVisible(true)
		self._rootNode:getChildByName("button_hecheng"):setVisible(false)
	else
		self.have:setVisible(false)
		self._rootNode:getChildByName("button_hecheng"):setVisible(true)
	end

end

return heros_fragments_item_node
