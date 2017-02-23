--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:06:51
--

local mail_navigation_node = class("mail_navigation_node")

local class_mail_navigation_item_node = import(".mail_navigation_item_node")

mail_navigation_node.list = {
	{
		name = "全部邮件",
		textures = {
			"ui_image/mail/mail_navigation_button_0_0.png",
			"ui_image/mail/mail_navigation_button_0_1.png",
			"ui_image/mail/mail_navigation_button_0_1.png",
		},
	},
	{
		name = "好友邮件",
		textures = {
			"ui_image/mail/mail_navigation_button_1_0.png",
			"ui_image/mail/mail_navigation_button_1_1.png",
			"ui_image/mail/mail_navigation_button_1_1.png",
		},
	},
	{
		name = "系统邮件",
		textures = {
			"ui_image/mail/mail_navigation_button_2_0.png",
			"ui_image/mail/mail_navigation_button_2_1.png",
			"ui_image/mail/mail_navigation_button_2_1.png",
		},
	},
}

function mail_navigation_node:ctor(node)
	-- body
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initNavigation()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self:updateButton(1)

end

function mail_navigation_node:initNavigation()
	-- body
	self.navigation = self._rootNode:getChildByName("navigation_node")

	local subTitleModel = class_mail_navigation_item_node:new()

	local itemModel = subTitleModel:getModelNode()

	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
        	-- dispatchGlobaleEvent("mail_ctrl", "clickSubTitleList", {sender=sender, eventType=eventType})
    		self:onClicked(sender, eventType)
    	end
    end
    itemModel:addTouchEventListener(touchEvent)

    self.navigation:setItemModel(itemModel)

    for i=1,#self.list do
		self.navigation:pushBackDefaultItem()
		print(self.list[i].textures[1])
		-- self.navigation:getItems()[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		self.navigation:getItems()[i].index = i
    end
    -- self.navigation:refreshView()
end

--初始化数据
function mail_navigation_node:_initData()
	-- body
end

--注册节点事件
function mail_navigation_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function mail_navigation_node:_registUIEvent()
	-- body
end

--注册全局事件监听器
function mail_navigation_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mail_ctrl", eventName = "clickSubTitleList", callBack=handler(self, self.onClicked)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function mail_navigation_node:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function mail_navigation_node:onClicked(sender, eventType)
	-- body
	-- local eventType = event._usedata.eventType
	-- local sender = event._usedata.sender

	if eventType == ccui.TouchEventType.began then
        globalTouchEvent(sender,eventType)
    elseif eventType == ccui.TouchEventType.moved then
        globalTouchEvent(sender,eventType)
    elseif eventType == ccui.TouchEventType.ended then
        if globalTouchEvent(sender,eventType) then
            print("点击"..sender.index)
            dispatchGlobaleEvent("mail_ctrl", "clickSubTitleButtom", {sender=sender})
            -- 改变按钮状态
            self:updateButton(sender.index)
        end
    elseif eventType == ccui.TouchEventType.canceled then

    end

end

function mail_navigation_node:updateButton(index)
	-- body
	local navigation_items = self.navigation:getItems()
	for i=1,#navigation_items do
		if index == i then
			navigation_items[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			navigation_items[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end

end

return mail_navigation_node
