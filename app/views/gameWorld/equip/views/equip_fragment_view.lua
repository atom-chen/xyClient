--
-- Author: Wu Hengmin
-- Date: 2015-07-09 17:42:21
--

local equip_fragment_view = class("equip_fragment_view")

local class_fragment_item = import("..equip_fragment_item")

function equip_fragment_view:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
    self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
    self.itemModel = cc.CSLoader:createNode("ui_instance/equip/equip_fragment_item.csb")
    self.itemModel:retain()
    self:initScrollView()
end

--初始化数据
function equip_fragment_view:_initData()
	-- body
end

function equip_fragment_view:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
    self:initScroll()
end

function equip_fragment_view:initScroll()
    -- body
    local defaultCount = 10
    local offy = math.ceil(defaultCount/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.075 then
        offy2 = 4.075
    end

    self.viewitems = {}
    for i=1,defaultCount do
        self.viewitems[i] = self:createItems(i)
        self.scrollview:addChild(self.viewitems[i]:getResourceNode())
    end
    local size = cc.size(0, 130*offy+50)
    self.scrollview:setInnerContainerSize(size)

end

--注册节点事件
function equip_fragment_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function equip_fragment_view:_registUIEvent()
	-- body

end

--注册全局事件监听器
function equip_fragment_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_equipManager", eventName = "refreshfenjie", callBack=handler(self, self.updateScrollview)},
        {modelName = "equip_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
        {modelName = "model_equipManager", eventName = "removeEquip", callBack=handler(self, self.updateScrollview)},
        {modelName = "model_equipManager", eventName = "addEquip", callBack=handler(self, self.updateScrollview)},
        {modelName = "model_equipManager", eventName = "equiphecheng", callBack=handler(self, self.updateScrollview)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function equip_fragment_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function equip_fragment_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function equip_fragment_view:display(target)
	-- body
	self._rootNode:setVisible(true)
	self:updateScrollview(true)
end

function equip_fragment_view:updateScrollview(jumpToTop)
    -- body
    self:updateData()
    -- self.scrollview:removeAllChildren()
    
    local offy = math.ceil(#self.displayData/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.1 then
        offy2 = 4.1
    end

    if #self.displayData == 0 then
        for i=1,#self.viewitems do
            self.viewitems[i]:getResourceNode():setVisible(false)
        end
    elseif #self.displayData > #self.viewitems then
        for i=#self.viewitems+1,#self.displayData do
            self.viewitems[i] = self:createItems(i)
            self.scrollview:addChild(self.viewitems[i]:getResourceNode())
        end
    else
        for i=#self.displayData,#self.viewitems do
            self.viewitems[i]:getResourceNode():setVisible(false)
        end
    end

     -- 重置位置,加入数据
    for i=1,#self.displayData do
        self.viewitems[i]:getResourceNode():setPosition(cc.p(16+445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))
        self.viewitems[i]:update(self.displayData[i])
        self.viewitems[i]:getResourceNode():setVisible(true)
    end

    local size = cc.size(12, 130*offy)
    self.scrollview:setInnerContainerSize(size)

    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)

    if jumpToTop then
        self.scrollview:jumpToTop()
    end

end

function equip_fragment_view:createItems(dex)
    -- body
    local item = class_fragment_item.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )
    local function touchEvent(sender,eventType)
        -- body
        if eventType == ccui.TouchEventType.began then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.moved then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.ended then
            if globalTouchEvent(sender,eventType) then
                -- 点击待分解装备
            end
        end
    end
    item.modelNode:addTouchEventListener(touchEvent)
    return item
end

function equip_fragment_view:updateData()
	-- body
	self.displayData = {}
    for i=1,#MAIN_PLAYER.equipManager.fragment do
    	self.displayData[i] = MAIN_PLAYER.equipManager.fragment[i]
    end

end

return equip_fragment_view
