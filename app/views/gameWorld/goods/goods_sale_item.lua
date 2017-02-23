--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:53:10
--

local goods_sale_item = class("goods_sale_item")

function goods_sale_item:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

end

function goods_sale_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self._rootNode:getChildByName("bg"):setSwallowTouches(false)
end

function goods_sale_item:getResourceNode()
	-- body
	return self._rootNode
end

function goods_sale_item:_registUIEvent()
	-- body
	------------------------ 出售按钮 ------------------------
	local button_sale = self._rootNode:getChildByName("button_sale")
	local function clickEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/goods/goods_button_sale_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/goods/goods_button_sale_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/goods/goods_button_sale_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
				gameTcp:SendMessage(MSG_C2MS_ITEMS_SELL, {1, self.data.id, self.count})
			end
		elseif eventType == ccui.TouchEventType.canceled then
			sender:loadTexture("ui_image/goods/goods_button_sale_0.png", ccui.TextureResType.plistType)
		end
	end
	button_sale:setSwallowTouches(false)
	button_sale:addTouchEventListener(clickEvent)

	------------------------ 减按钮 ------------------------
	self.reduc = self._rootNode:getChildByName("reduc")
	local function touchreduc(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			self:run(sender)
			sender.Record_pos = sender:convertToWorldSpace(cc.p(0, 0))
        elseif eventType == ccui.TouchEventType.moved then
        	if not sender.MarkIsMove then
		    	local pos = sender:convertToWorldSpace(cc.p(0, 0))
		    	if cc.pGetLength(cc.p(pos.x - sender.Record_pos.x, pos.y - sender.Record_pos.y)) > 5 then
		    		sender:stopAllActions()
		    	end
		    end
        elseif eventType == ccui.TouchEventType.ended then
            sender:stopAllActions()
            self.count = self.count - 1
            if self.count < 0 then
            	self.count = 0
            end
            self:check()
        end
	end
	self.reduc:setSwallowTouches(false)
	self.reduc:addTouchEventListener(touchreduc)

	------------------------ 加按钮 ------------------------
	self.plus = self._rootNode:getChildByName("plus")
	local function touchreduc(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			self:run(sender)
			sender.Record_pos = sender:convertToWorldSpace(cc.p(0, 0))
        elseif eventType == ccui.TouchEventType.moved then
        	if not sender.MarkIsMove then
		    	local pos = sender:convertToWorldSpace(cc.p(0, 0))
		    	if cc.pGetLength(cc.p(pos.x - sender.Record_pos.x, pos.y - sender.Record_pos.y)) > 5 then
		    		sender:stopAllActions()
		    	end
		    end
        elseif eventType == ccui.TouchEventType.ended then
            sender:stopAllActions()
            self.count = self.count + 1
            if self.count > self.data.count then
            	self.count = self.data.count
            end
            self:check()
        end
	end
	self.plus:setSwallowTouches(false)
	self.plus:addTouchEventListener(touchreduc)

	-- 更新卖出数量
	self.count = 0
	self:check()

end

function goods_sale_item:update(data)
	-- body
	self.data = data
	self._rootNode:getChildByName("name"):setString(ItemsConfig[data.id].name)
	self._rootNode:getChildByName("count"):setString("数量:"..data.count)

	self._rootNode:getChildByName("price"):setString("单价:"..ItemsConfig[data.id].price)


	local iconNode = self._rootNode:getChildByName("icon_node")
	iconNode:removeAllChildren()
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			data.id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end
end


function goods_sale_item:run(obj, delay)
	-- body
	local time = delay or 0.5
	local delay = cc.DelayTime:create(time)
	local runc = cc.CallFunc:create(function ()
		-- body
		local tmp = 1
		if time < 0.01 then
			tmp = 20
		elseif time < 0.05 then
			tmp = 5
		elseif time < 0.1 then
			tmp = 4
		elseif time < 0.5 then
			tmp = 2
		end
		if obj == self.reduc then
			if self.count - tmp >= 0 then
				self.count = self.count - tmp
			elseif self.count == 0 then
				return
			else
				self.count = 0
			end
			self:check()
		elseif obj == self.plus then
			if self.count + tmp <= self.data.count then
				self.count = self.count + tmp
			elseif self.count == self.max then
				return
			else
				self.count = self.data.count
			end
			self:check()
		end
		self:run(obj, time*0.8)
	end)
	obj:runAction(cc.Sequence:create(delay, runc))
end

function goods_sale_item:check()
	-- body
	self._rootNode:getChildByName("sale_count"):setString(self.count)
end

return goods_sale_item
