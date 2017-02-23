--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:48:30
--

local mail_scrollview = class("mail_scrollview")

local class_mail_item = import("app.views.gameWorld.mail.mail_item.lua")


function mail_scrollview:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
    self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initScrollView()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
end

--初始化数据
function mail_scrollview:_initData()
	-- body
    
end

function mail_scrollview:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")


end

--注册节点事件
function mail_scrollview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function mail_scrollview:_registUIEvent()
	-- body
    local getall = self._rootNode:getChildByName("ctrl_node"):getChildByName("button_get")
    local function getClicked(sender)
        -- 获取所有附件
        for i=1,#self.displayData do
            if self.displayData[i].adjunctNum > 0 then
                gameTcp:SendMessage(MSG_C2MS_MAIL_TAKE_ATTACHMENT ,{self.displayData[i].guid})
            end
        end
    end
    getall:addClickEventListener(getClicked)

    local clean = self._rootNode:getChildByName("ctrl_node"):getChildByName("button_clean")
    local function cleanClicked(sender)
        -- 删除所有已读
        local msgdata = {}
        local tmp = 2
        for i=1,#self.displayData do
            if self.displayData[i].adjunctNum == 0 and self.displayData[i].Read_Time > 0 then
                msgdata[tmp] = self.displayData[i].guid
                tmp = tmp + 1
            end
        end
        msgdata[1] = tmp-2
        gameTcp:SendMessage(MSG_C2MS_MAIL_DEL ,msgdata)
    end
    clean:addClickEventListener(cleanClicked)

end

--注册全局事件监听器
function mail_scrollview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_mailManager", eventName = "refreshlist", callBack=handler(self, self.updateScrollview)}, 
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function mail_scrollview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function mail_scrollview:updateScrollview(mode, scroll)
    -- body
    if self.displaymode == mode then
        return
    end
    if type(mode) == "userdata" then
        mode = nil
    end
    self.displaymode = mode or self.displaymode

    self.scrollview:removeAllChildren()
    self.displayData = {}
    if self.displaymode == 1 then -- 所有邮件
        local tmp = 1
        for k,v in pairs(MAIN_PLAYER.mailManager.data) do
            self.displayData[tmp] = v
            tmp = tmp + 1
        end
    elseif self.displaymode == 2 then -- 玩家邮件
        local tmp = 1
        for k,v in pairs(MAIN_PLAYER.mailManager.data) do
            if v.Type == 1 then
                self.displayData[tmp] = v
                tmp = tmp + 1
            end
        end
    elseif self.displaymode == 3 then -- 系统邮件
        local tmp = 1
        for k,v in pairs(MAIN_PLAYER.mailManager.data) do
            if v.Type == 2 then
                self.displayData[tmp] = v
                tmp = tmp + 1
            end
        end
    end


    local offy = math.ceil(#self.displayData/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 3.50 then
        offy2 = 3.50
    end
    
    for i=1,#self.displayData do
        local viewitem = nil
        viewitem = class_mail_item:new()
        viewitem:setPosition(cc.p(445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))
        viewitem:setCascadeOpacityEnabled(true)
        viewitem.resourceNode_:getChildByName("main_node"):setSwallowTouches(false)

        local function touchEvent(sender,eventType)
            -- body
            if eventType == ccui.TouchEventType.began then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.moved then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.ended then
                if globalTouchEvent(sender,eventType) then
                    UIManager:createMailDialog(self.displayData[i])
                end
            end
        end
        viewitem.resourceNode_:getChildByName("main_node"):addTouchEventListener(touchEvent)
        
        viewitem:update(self.displayData[i])
        self.scrollview:addChild(viewitem)
    end

    local size = cc.size(0, 130*offy+120)
    self.scrollview:setInnerContainerSize(size)
    
    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)
    if scroll then
        self.scrollview:jumpToTop()
    end

end

return mail_scrollview
