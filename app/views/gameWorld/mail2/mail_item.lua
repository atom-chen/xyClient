--
-- Author: Wu Hengmin
-- Date: 2015-08-26 11:20:26
--


local mail_item = class("mail_item")

function mail_item:ctor(node)
	-- body

	-- local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
	-- ccui.Helper:doLayout(self._rootNode)

	self:init()

	self:_registUIEvent()

end

function mail_item:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function mail_item:getResourceNode()
	-- body
	return self._rootNode
end

function mail_item:_registUIEvent()
	-- body

	local function button_1OnClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 获取附件/删除
	            if self.data.adjunctNum > 0 then
	            	gameTcp:SendMessage(MSG_C2MS_MAIL_TAKE_ATTACHMENT ,{self.data.guid})
	            else
	            	gameTcp:SendMessage(MSG_C2MS_MAIL_DEL ,{1, self.data.guid})
	            end
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end
	local button = self._rootNode:getChildByName("Image_1")
	-- button:setSwallowTouches(false)
	button:addTouchEventListener(button_1OnClicked)

end

function mail_item:update(data)
	-- body
	self.data = data
	self._rootNode:getChildByName("Text_1"):setString(data.SendName)
	self._rootNode:getChildByName("Text_1_0"):setString(data.Content)

	if data.adjunctNum > 0 then
		-- print("有附件")
		self._rootNode:getChildByName("Image_1"):loadTexture("ui_image/mail2/011.png", ccui.TextureResType.plistType)
	else
		-- print("无附件")
		self._rootNode:getChildByName("Image_1"):loadTexture("ui_image/mail2/001.png", ccui.TextureResType.plistType)
	end

end


return mail_item
