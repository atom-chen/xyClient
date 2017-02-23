--
-- Author: Wu Hengmin
-- Date: 2015-07-09 17:42:21
--

local equip_fenjie_view = class("equip_fenjie_view")

local class_fenjie_item = import("..equip_fenjie_item")

function equip_fenjie_view:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
    self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
    self.itemModel = cc.CSLoader:createNode("ui_instance/equip/equip_fenjie_item.csb")
    self.itemModel:retain()
    self:initScrollView()
end

--初始化数据
function equip_fenjie_view:_initData()
	-- body
end

function equip_fenjie_view:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
    self:initScroll()
end

function equip_fenjie_view:initScroll()
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
function equip_fenjie_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function equip_fenjie_view:_registUIEvent()
	-- body
	local button_screen = self._rootNode:getChildByName("ctrl_node"):getChildByName("button_screen")
	local function clicked_screen()
		-- body
		print("筛选")
	end
	button_screen:addClickEventListener(clicked_screen)

	local button_fenjie = self._rootNode:getChildByName("ctrl_node"):getChildByName("button_fenjie")
	local function clicked_fenjie()
		-- body
		print("分解")
		self:sendMsg()
	end
	button_fenjie:addClickEventListener(clicked_fenjie)
end

--注册全局事件监听器
function equip_fenjie_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_equipManager", eventName = "refreshfenjie", callBack=handler(self, self.updateScrollview)},
        {modelName = "equip_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
        {modelName = "model_equipManager", eventName = "removeEquip", callBack=handler(self, self.updateScrollview)},
        {modelName = "model_equipManager", eventName = "addEquip", callBack=handler(self, self.updateScrollview)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function equip_fenjie_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function equip_fenjie_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function equip_fenjie_view:display(target)
	-- body
	self._rootNode:setVisible(true)
	self:updateScrollview(true)
end

function equip_fenjie_view:updateScrollview(jumpToTop)
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
            self.viewitems[i]:setVisible(false)
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
        self.viewitems[i]:getResourceNode():setPosition(cc.p(12+445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))
        self.viewitems[i]:update(self.displayData[i])
        self.viewitems[i]:getResourceNode():setVisible(true)
    end

    local size = cc.size(12, 130*offy2+80)
    self.scrollview:setInnerContainerSize(size)

    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)

    if jumpToTop then
        print("刷新")
        self.scrollview:jumpToTop()
    else
        print("未刷新")
    end

    for i=1,#self.checkData do
        if self.checkData[i] == 0 then
            self.viewitems[i]._rootNode:getChildByName("checkbox"):setSelected(false)
        else
            self.viewitems[i]._rootNode:getChildByName("checkbox"):setSelected(true)
        end
    end

end

function equip_fenjie_view:createItems(dex)
    -- body
    local item = class_fenjie_item.new(
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
                if item._rootNode:getChildByName("checkbox"):isSelected() then
                    item._rootNode:getChildByName("checkbox"):setSelected(false)
                    self.checkData[dex] = 0
                else
                    item._rootNode:getChildByName("checkbox"):setSelected(true)
                    self.checkData[dex] = 1
                end
            end
        end
    end
    item._rootNode:getChildByName("bg"):addTouchEventListener(touchEvent)
    return item
end

function equip_fenjie_view:updateData()
	-- body
	self.displayData = {}
    self.checkData = {}
    for i=1,#MAIN_PLAYER.equipManager.data do
    	self.displayData[i] = MAIN_PLAYER.equipManager.data[i]
    	self.checkData[i] = 0
    end

end

function equip_fenjie_view:sendMsg()
	-- body
    local sendData = {}
    local k = 2
    printLog("网络日志","发送分解请求消息")
    for i=1,#self.checkData do
        if self.checkData[i] == 1 then
            sendData[k] = self.displayData[i].guid
            printLog("网络日志","装备guid:"..self.displayData[i].guid)
            k = k + 1
        end
    end
    sendData[1] = k - 2
    gameTcp:SendMessage(MSG_C2MS_EQUIPS_FENJIE, sendData)
end

function equip_fenjie_view:updateSelected()
	-- body

end

return equip_fenjie_view
