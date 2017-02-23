--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:48:30
--

local mission_scrollview = class("mission_scrollview")

local class_mission_item = import(".mission_item")

function mission_scrollview:ctor(node)
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
function mission_scrollview:_initData()
	-- body
    self:sort()
end

function mission_scrollview:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
    self:initScroll()
end

--注册节点事件
function mission_scrollview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function mission_scrollview:_registUIEvent()
	-- body
end

--注册全局事件监听器
function mission_scrollview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
        {modelName = "model_missionManager", eventName = "complete_mission", callBack=handler(self, self.receivedMission)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function mission_scrollview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function mission_scrollview:initScroll()
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
        self.viewitems[i] = self:createItems(i, offy2)
        self.scrollview:addChild(self.viewitems[i])
    end
    local size = cc.size(0, 130*offy+50)
    self.scrollview:setInnerContainerSize(size)

end

function mission_scrollview:createItems(dex, offy2)
    -- body
    local item = class_mission_item:new()
    item:setCascadeOpacityEnabled(true)
    item.resourceNode_:getChildByName("main_layout"):setSwallowTouches(false)
    -- item:setPosition(cc.p(445*((dex-1)%2), 10+130* (offy2 - math.ceil(dex/2))))
    local function touchEvent(sender,eventType)
        -- body
        if eventType == ccui.TouchEventType.began then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.moved then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.ended then
            if globalTouchEvent(sender,eventType) then
                self.forwardDex = dex
                -- self:receivedMission(nil)
                -- 发送完成任务消息
                print("发送完成任务消息")
                gameTcp:SendMessage(MSG_C2MS_COMPLETE_MISSION, {self.displayData[self.forwardDex].rewardID})
            end
        end
    end
    item.resourceNode_:getChildByName("main_layout"):addTouchEventListener(touchEvent)
    return item
end

function mission_scrollview:updateScrollview(mode)
    -- body
    if self.displaymode == mode then
        return
    end
    if type(mode) == "userdata" then
        mode = nil
    end
    self.displaymode = mode or self.displaymode

    self:refreshScroll(true)

end

function mission_scrollview:receivedMission(params)
    -- body
    local nextAdds = nil
    if params then
        local nextAdds = params._usedata.nextAdds
    end

    if self.displaymode == 1 then -- 普通任务
        table.remove(MAIN_PLAYER.missionManager.missions, self.forwardDex)
        -- 加入新的
        if nextAdds then
            for i=1,#nextAdds do
                MAIN_PLAYER.missionManager:addMission(nextAdds[i])
            end
        end
    elseif self.displaymode == 2 then -- 日常任务
        table.remove(MAIN_PLAYER.missionManager.dailys, self.forwardDex)
        -- 加入新的
        if nextAdds then
            for i=1,#nextAdds do
                MAIN_PLAYER.missionManager:addDaily(nextAdds[i])
            end
        end
    elseif self.displaymode == 3 then -- 成就任务
        table.remove(MAIN_PLAYER.missionManager.achieves, self.forwardDex)
        -- 加入新的
        if nextAdds then
            for i=1,#nextAdds do
                MAIN_PLAYER.missionManager:addMission(nextAdds[i])
            end
        end
    end
    self:sort()
    self:refreshScroll()
end

function mission_scrollview:sort()
    -- body
    for i=1,#MAIN_PLAYER.missionManager.missions do
        if MAIN_PLAYER.missionManager.missions[i].isComplete then
            table.insert(MAIN_PLAYER.missionManager.missions, 1, MAIN_PLAYER.missionManager.missions[i])
            table.remove(MAIN_PLAYER.missionManager.missions, i+1)
        end
    end
    for i=1,#MAIN_PLAYER.missionManager.dailys do
        if MAIN_PLAYER.missionManager.dailys[i].isComplete then
            table.insert(MAIN_PLAYER.missionManager.dailys, 1, MAIN_PLAYER.missionManager.dailys[i])
            table.remove(MAIN_PLAYER.missionManager.dailys, i+1)
        end
    end
    for i=1,#MAIN_PLAYER.missionManager.achieves do
        if MAIN_PLAYER.missionManager.achieves[i].isComplete then
            table.insert(MAIN_PLAYER.missionManager.achieves, 1, MAIN_PLAYER.missionManager.achieves[i])
            table.remove(MAIN_PLAYER.missionManager.achieves, i+1)
        end
    end
end

function mission_scrollview:refreshScroll(jumpToTop)
    -- body
    if self.displaymode == 1 then -- 普通任务
        self.displayData = MAIN_PLAYER.missionManager.missions
    elseif self.displaymode == 2 then -- 日常任务
        self.displayData = MAIN_PLAYER.missionManager.dailys
    elseif self.displaymode == 3 then -- 成就任务
        self.displayData = MAIN_PLAYER.missionManager.achieves
    end
    local offy = math.ceil(#self.displayData/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.075 then
        offy2 = 4.075
    end

    if #self.displayData == 0 then
        for i=1,#self.viewitems do
            self.viewitems[i]:setVisible(false)
        end
    elseif #self.displayData > #self.viewitems then
        for i=#self.viewitems+1,#self.displayData do
            self.viewitems[i] = self:createItems(i, offy2)
            self.scrollview:addChild(self.viewitems[i])
        end
    else
        for i=#self.displayData,#self.viewitems do
            self.viewitems[i]:setVisible(false)
        end
    end

    -- 重置位置,加入数据
    for i=1,#self.displayData do
        self.viewitems[i]:setPosition(cc.p(445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))
        self.viewitems[i]:update(self.displayData[i])
        self.viewitems[i]:setVisible(true)
    end
    
    local size = cc.size(0, 130*offy+50)
    self.scrollview:setInnerContainerSize(size)

    if jumpToTop then
        self.scrollview:jumpToTop()
    end
end

return mission_scrollview
