--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:48:30
--

local market_scrollview = class("market_scrollview")

local class_market_item = import("app.views.gameWorld.market.market_item.lua")
local class_market_recharge_item = import("app.views.gameWorld.market.market_recharge_item.lua")
local class_recharge = import("app.views.gameWorld.market.market_recharge.lua")
local class_vip_item = import("app.views.gameWorld.market.market_vip_item_node.lua")


function market_scrollview:ctor(node)
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
    self.itemModel = cc.CSLoader:createNode("ui_instance/market/market_vip_item_node.csb")
    self.itemModel:retain()
end

--初始化数据
function market_scrollview:_initData()
	-- body
end

function market_scrollview:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")

    self.rechargeNode = class_recharge:new()
    self.rechargeNode:setCascadeOpacityEnabled(true)
    self.rechargeNode:setPosition(0, 460)
    self._rootNode:addChild(self.rechargeNode)

end

--注册节点事件
function market_scrollview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function market_scrollview:_registUIEvent()
	-- body
end

--注册全局事件监听器
function market_scrollview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "market_ctrl", eventName = "refreshlist", callBack=handler(self, self.updateScrollview)}, 
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function market_scrollview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function market_scrollview:updateScrollview(mode)
    -- body
    if self.displaymode == mode then
        return
    end
    if type(mode) == "userdata" then
        mode = nil
    end
    self.displaymode = mode or self.displaymode

    self.scrollview:removeAllChildren()
    if self.displaymode == 1 then -- 商店
        print("商店")
        self.displayData = stoneConfig
        self.rechargeNode:setVisible(false)
    elseif self.displaymode == 2 then -- 充值
        print("充值")
        self.displayData = saleConfig
        self.rechargeNode:setVisible(true)
    elseif self.displaymode == 3 then -- VIP面板
        print("VIP面板")
        self.displayData = VipConfig
        self.rechargeNode:setVisible(true)
    end


    local offy = math.ceil(#self.displayData/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.15 then
        offy2 = 4.15
    end
    

    for i=1,#self.displayData do
        local viewitem = nil
        if self.displaymode == 1 then
            viewitem = class_market_item:new()
            viewitem:setPosition(cc.p(445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))
        elseif self.displaymode == 2 then
            viewitem = class_market_recharge_item:new()
            viewitem:setPosition(cc.p(445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))
        elseif self.displaymode == 3 then
            viewitem = class_vip_item.new(
                    self.itemModel:getChildByName("main_node"):clone()
                )
            viewitem:getResourceNode():setPosition(cc.p(16, 10+320*(#self.displayData-i)))
        end

        if self.displaymode == 3 then
            
            local function touchEvent(sender,eventType)
                -- body
                if eventType == ccui.TouchEventType.began then
                    globalTouchEvent(sender,eventType)
                elseif eventType == ccui.TouchEventType.moved then
                    globalTouchEvent(sender,eventType)
                elseif eventType == ccui.TouchEventType.ended then
                    if globalTouchEvent(sender,eventType) then
                        self:clicked(sender.index)
                    end
                end
            end
            viewitem:getResourceNode():getChildByName("bg"):addTouchEventListener(touchEvent)
            viewitem:getResourceNode():getChildByName("bg").index = i
            viewitem:update(self.displayData[i], i)
            self.scrollview:addChild(viewitem:getResourceNode())

        else
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
                        self:clicked(sender.index)
                    end
                end
            end
            viewitem.resourceNode_:getChildByName("main_node"):addTouchEventListener(touchEvent)
            viewitem.resourceNode_:getChildByName("main_node").index = i
            viewitem:update(self.displayData[i], i)
            self.scrollview:addChild(viewitem)
        end
    end

    if self.displaymode == 1 then -- 商店
        local size = cc.size(0, 130*offy+120)
        self.scrollview:setInnerContainerSize(size)
    elseif self.displaymode == 2 then -- 充值
        local size = cc.size(0, 130*offy+120)
        self.scrollview:setInnerContainerSize(size)
    elseif self.displaymode == 3 then -- vip
        local size = cc.size(0, 320*#self.displayData+120)
        self.scrollview:setInnerContainerSize(size)
    end
    
    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)
    self.scrollview:jumpToTop()

end

function market_scrollview:clicked(index)
    -- body
    if self.displaymode == 1 then

    elseif self.displaymode == 2 then
        gameTcp:SendMessage(MSG_C2MS_BUY_YUANBAO, {index})
    elseif self.displaymode == 3 then

    end
end

return market_scrollview
