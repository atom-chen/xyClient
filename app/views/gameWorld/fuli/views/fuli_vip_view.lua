--
-- Author: Wu Hengmin
-- Date: 2015-07-10 15:27:45
--


local fuli_vip_view = class("fuli_vip_view")

local class_fuli_item = import("..fuli_item")

function fuli_vip_view:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initScrollView()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
    self.itemModel = cc.CSLoader:createNode("ui_instance/fuli/fuli_item.csb")
    self.itemModel:retain()
end

--初始化数据
function fuli_vip_view:_initData()
	-- body
end

function fuli_vip_view:getResourceNode()
    -- body
    return self._rootNode
end

function fuli_vip_view:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
end

--注册节点事件
function fuli_vip_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function fuli_vip_view:_registUIEvent()
	-- body

end

--注册全局事件监听器
function fuli_vip_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "fuli_ctrl", eventName = "refreshlist", callBack=handler(self, self.updateScrollview)},
		{modelName = "fuli_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
        {modelName = "netMsg", eventName = tostring(MSG_MS2C_BUY_VIP_PACK), callBack=handler(self, self.updateScrollview)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function fuli_vip_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function fuli_vip_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function fuli_vip_view:display(target)
	-- body
    print("display")
	self._rootNode:setVisible(true)
	self:updateScrollview(true)
end

function fuli_vip_view:updateScrollview(jumptotop)
    -- body
    self.scrollview:removeAllChildren()
    print("updateScrollview")

    local offy = #VipConfig
    -- 不足一屏的时候列表置顶
    if offy < 4.5 then
        offy = 4.5
    end
    for i=1,#VipConfig do
        local viewitem = class_fuli_item.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )
        viewitem:getResourceNode():setPosition(cc.p(5, 10+110*(offy-i)))

        local function touchEvent(sender,eventType)
            -- body
            if eventType == ccui.TouchEventType.began then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.moved then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.ended then
                if globalTouchEvent(sender,eventType) then
                    -- 发送购买VIP礼包
                    print("发送购买VIP礼包")
                    gameTcp:SendMessage(MSG_C2MS_BUY_VIP_PACK, {i})
                end
            end
        end
        viewitem:getResourceNode():getChildByName("button_get"):addTouchEventListener(touchEvent)
        viewitem:getResourceNode():getChildByName("button_get"):setSwallowTouches(false)
        if MAIN_PLAYER.VIPManager.giftpackage[i] == 1 then
            viewitem:getResourceNode():getChildByName("icon_node_0"):setVisible(true)
        else
            viewitem:getResourceNode():getChildByName("icon_node_0"):setVisible(false)
        end
        viewitem:update(VipConfig[i])
        self.scrollview:addChild(viewitem:getResourceNode())
    end
    local size = cc.size(0, 110*offy+10)
    self.scrollview:setInnerContainerSize(size)

    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)

    if jumptotop == true then
        self.scrollview:jumpToTop()
    end

end

return fuli_vip_view
