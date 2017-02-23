--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:48:30
--

local friends_scrollview = class("friends_scrollview")

local class_friends_item = import("app.views.gameWorld.friends.friends_item.lua")
local class_friends_recommend_item = import("app.views.gameWorld.friends.friends_recommend_item.lua")

function friends_scrollview:ctor(node)

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
    self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initScrollView()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
    self.itemModel = cc.CSLoader:createNode("ui_instance/friends/friends_item.csb")
    self.itemModel:retain()
    self.itemRecommendModel = cc.CSLoader:createNode("ui_instance/friends/friends_recommend_item.csb")
    self.itemRecommendModel:retain()
end


function friends_scrollview:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
    -- 输入框
    self.textfield = self._rootNode:getChildByName("ctrl_node"):getChildByName("TextField_1")


    local invite = self._rootNode:getChildByName("ctrl_node"):getChildByName("button_invite")
    local function inviteclickEvent(sender, eventType)
        -- body
        if eventType == ccui.TouchEventType.began then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_1.png", ccui.TextureResType.plistType)
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.moved then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.ended then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
            if globalTouchEvent(sender,eventType) then
                print("发送好友邀请:"..self.textfield:getString())
                gameTcp:SendMessage(MSG_C2MS_FRIEND_APPLY_NAME, {self.textfield:getString()})
            end
        elseif eventType == ccui.TouchEventType.canceled then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
        end
    end
    invite:addTouchEventListener(inviteclickEvent)


    local allow = self._rootNode:getChildByName("ctrl_node"):getChildByName("button_allow")
    local function alloweclickEvent(sender, eventType)
        -- body
        if eventType == ccui.TouchEventType.began then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_1.png", ccui.TextureResType.plistType)
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.moved then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.ended then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
            if globalTouchEvent(sender,eventType) then
                print("全部通过")
                for k,v in pairs(MAIN_PLAYER.friendsManager.verifyPool) do
                    gameTcp:SendMessage(MSG_C2MS_FRIEND_AGREE, {k, 1})
                end
                
            end
        elseif eventType == ccui.TouchEventType.canceled then
            -- sender:loadTexture("ui_image/friends/friends_button_invite_0.png", ccui.TextureResType.plistType)
        end
    end
    allow:addTouchEventListener(alloweclickEvent)

end

--注册节点事件
function friends_scrollview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function friends_scrollview:_registUIEvent()
	-- body
end

--注册全局事件监听器
function friends_scrollview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_friendsManager", eventName = "refreshinvite", callBack=handler(self, self.updateScrollview)},
        {modelName = "model_friendsManager", eventName = "refreshfriends", callBack=handler(self, self.updateScrollview)},
        
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function friends_scrollview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function friends_scrollview:updateScrollview(mode)
    -- body
    if self.displaymode == mode then
        return
    end
    if type(mode) == "userdata" then
        mode = nil
    end
    self.displaymode = mode or self.displaymode

    self.scrollview:removeAllChildren()
    if self.displaymode == 1 then -- 好友列表
        self.displayData = {}
        local index = 1
        for k,v in pairs(MAIN_PLAYER.friendsManager.friendsPool) do
            self.displayData[index] = v
            self.displayData[index].guid = k
            index = index + 1
        end
    elseif self.displaymode == 2 then -- 好友邀请
        self.displayData = {}
        local index = 1
        for k,v in pairs(MAIN_PLAYER.friendsManager.verifyPool) do
            self.displayData[index] = v
            self.displayData[index].guid = k
            index = index + 1
        end
    elseif self.displaymode == 3 then -- 推荐好友
        self.displayData = {}
        local index = 1
        -- ******************************有援军后再测试***********************************
        for k,v in pairs(MAIN_PLAYER.helperManager.RecordHelperPool) do
            -- 过滤掉好友和已经推荐过的
            local current = false
            for k1,v1 in pairs(MAIN_PLAYER.friendsManager.friendsPool) do
                if k == k1 then
                    current = true
                end
            end
            for k1,v1 in pairs(MAIN_PLAYER.friendsManager.recordPool) do
                if k == k1 then
                    current = true
                end
            end
            if not current then
                self.displayData[index] = v
                self.displayData[index].guid = k
                index = index + 1
            end
        end


    end
    local offy = math.ceil(#self.displayData/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.17 then
        offy2 = 4.17
    end

    

    self.viewitems = {}

    print("#self.displayData="..#self.displayData)
    for i=1,#self.displayData do
        local viewitem = nil
        if self.displaymode == 1 then
            self.viewitems[i] = class_friends_item.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )
        elseif self.displaymode == 2 then
            self.viewitems[i] = class_friends_item.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )
        elseif self.displaymode == 3 then
            self.viewitems[i] = class_friends_recommend_item.new(
                    self.itemRecommendModel:getChildByName("main_layout"):clone()
                )
        end
        self.viewitems[i]:getResourceNode():setPosition(cc.p(8+445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))

        local function touchEvent(sender,eventType)
            -- body
            if eventType == ccui.TouchEventType.began then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.moved then
                globalTouchEvent(sender,eventType)
            elseif eventType == ccui.TouchEventType.ended then
                if globalTouchEvent(sender,eventType) then
                    -- self:updateScrollview()
                    self:click(i)
                end
            end
        end
        self.viewitems[i]:getResourceNode():getChildByName("bg"):addTouchEventListener(touchEvent)
        self.viewitems[i]:update(self.displayData[i])
        self.scrollview:addChild(self.viewitems[i]:getResourceNode())
    end
    if self.displaymode == 2 then
        local size = cc.size(0, 130*offy2+110)
        self.scrollview:setInnerContainerSize(size)
        self._rootNode:getChildByName("ctrl_node"):setVisible(true)
    else
        local size = cc.size(0, 130*offy+40)
        self.scrollview:setInnerContainerSize(size)
        self._rootNode:getChildByName("ctrl_node"):setVisible(false)
    end

    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)

    if mode then
        self.scrollview:jumpToTop()
    end

end

function friends_scrollview:click(index)
    -- body
    if self.displaymode == 1 then
        print("点击:"..index)
        UIManager:createFriendsDialog(self.displayData[index])
    elseif self.displaymode == 2 then
        print("点击:"..index)
        UIManager:createFriendsInviteDialog(self.displayData[index])
    end
    
end


return friends_scrollview
