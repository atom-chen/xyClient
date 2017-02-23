--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:48:30
--

local shiji_scrollview = class("shiji_scrollview")

local class_shiji_item = import(".shiji_item")

function shiji_scrollview:ctor(node)
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
function shiji_scrollview:_initData()
	-- body

    -- MAIN_PLAYER.marketManager.shijiData

    
end

function shiji_scrollview:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
end

--注册节点事件
function shiji_scrollview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function shiji_scrollview:_registUIEvent()
	-- body
end

--注册全局事件监听器
function shiji_scrollview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "shiji_ctrl", eventName = "refreshlist", callBack=handler(self, self.updateScrollview)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function shiji_scrollview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function shiji_scrollview:updateScrollview(mode)
    -- body
    if self.displaymode == mode then
        return
    end
    if type(mode) == "userdata" then
        mode = nil
    end
    self.displaymode = mode or self.displaymode

    self.scrollview:removeAllChildren()
    
    local offy = math.ceil(#MAIN_PLAYER.marketManager.shijiData/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4 then
        offy2 = 4
    end

    for i=1,#MAIN_PLAYER.marketManager.shijiData do
        local viewitem = class_shiji_item:new()
        viewitem.resourceNode_:getChildByName("main_node"):setSwallowTouches(false)
        viewitem:setPosition(cc.p(445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))

        local function touchEvent(sender,eventType)
            -- body
            if eventType == ccui.TouchEventType.began then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.moved then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.ended then
                if globalTouchEvent(sender,eventType) then
                    -- 发送购买
                    gameTcp:SendMessage(MSG_C2MS_BUY_XIANGOU_ITEM, {MAIN_PLAYER.marketManager.shijiData[i].index})
                end
            end
        end
        viewitem:setCascadeOpacityEnabled(true)
        viewitem.resourceNode_:getChildByName("main_node"):addTouchEventListener(touchEvent)
        viewitem:update(MAIN_PLAYER.marketManager.shijiData[i])
        self.scrollview:addChild(viewitem)
    end
    local size = cc.size(0, 130*offy+40)
    self.scrollview:setInnerContainerSize(size)

    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)

    if mode then
        self.scrollview:jumpToTop()
    end

end

return shiji_scrollview
