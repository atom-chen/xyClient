--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 邮件界面

local UI_Friends = class("UI_Friends", cc.load("mvc").ViewBase)

local class_friends_view = import("app.views.gameWorld.friends2.friends_view.lua")
local class_verify_view = import("app.views.gameWorld.friends2.verify_view.lua")
local class_record_view = import("app.views.gameWorld.friends2.record_view.lua")
local class_friends_pageview = import("app.views.gameWorld.friends2.friends_pageview.lua")

UI_Friends.RESOURCE_FILENAME = "ui_instance/friends2/friends_layer.csb"

UI_Friends.list = {
	{
		name = "好友",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "推荐",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "申请",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Friends:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()


	self:_createControlerForUI()
	self:_initDynamicResConfig()

	self:_registButtonEvent()

	local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode()
    rootNode:setContentSize(size)
    ccui.Helper:doLayout(rootNode)
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360))

    local shadow_layout = rootNode:getChildByName("shadow_layout")
    shadow_layout:setContentSize(size)
    ccui.Helper:doLayout(shadow_layout)

    self.itemModel = cc.CSLoader:createNode("ui_instance/friends2/friends_view.csb")
    self.itemModel:retain()

	self:updateDisplay(1)
end

--注册节点事件
function UI_Friends:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Friends:_createControlerForUI()
	self.views = class_friends_pageview.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("PageView_1")
		)

end

function UI_Friends:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	-- 输入框
    self.textfield = self.resourceNode_:getChildByName("main_layout"):getChildByName("TextField_1")

    -- 邀请按钮
    local invite = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_invite")
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


	local function onClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 改变按钮状态
	            self:updateButton(sender.index)
	            self:updateDisplay(sender.index)
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end

	self.tabs = {}
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_1")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_2")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)
	
	self.tabs[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_3")
	self.tabs[3].index = 3
	self.tabs[3]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Friends:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_friendsManager", eventName = "refreshfriends", callBack=handler(self, self.refreshfriends)},
		-- {modelName = "model_marketManager", eventName = "refreshlist", callBack=handler(self, self.updateDisplay)},
		{modelName = "model_friendsManager", eventName = "refreshinvite", callBack=handler(self, self.refreshinvite)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

-- 刷新邀请列表
function UI_Friends:refreshinvite()
	-- body
	self:updateDisplay(3)
end

-- 刷新好友列表
function UI_Friends:refreshfriends()
	-- body
	self:updateDisplay(1)
end

function UI_Friends:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Friends:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Friends:close(res)
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				self:removeFromParent(true)
				release_res(res)
			end
		})
end


function UI_Friends:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Friends:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Friends:updateData()
	-- body

end

function UI_Friends:updatePage(page)
	-- body
	if page == nil then
		page = 1
		self.page = page
	end
	self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Text_1"):setString("当前页:"..page.."/"..self.maxpage)

	local targetpage = page + 1
	if self.maxpage > page and #self.views:getResourceNode():getPages() < targetpage then
		if self.displayMode == 1 then
			self.pages[targetpage] = class_friends_view.new(
                    self.itemModel:getChildByName("Panel_1"):clone()
                )
			self.pages[targetpage]:update(targetpage)
			self.views:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		elseif self.displayMode == 2 then
			self.pages[targetpage] = class_record_view.new(
                    self.itemModel:getChildByName("Panel_1"):clone()
                )
			self.pages[targetpage]:update(targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		elseif self.displayMode == 3 then
			self.pages[targetpage] = class_verify_view.new(
                    self.itemModel:getChildByName("Panel_1"):clone()
                )
			self.pages[targetpage]:update(targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		end

	end

end

function UI_Friends:updateDisplay(index)
	-- body
	self.views:getResourceNode():removeAllPages()
	self.pages = {}
	self.displayMode = index


	self.displayData = {}
	if self.displayMode == 1 then -- 好友
		print("好友")
        local index = 1
        for k,v in pairs(MAIN_PLAYER.friendsManager.friendsPool) do
            self.displayData[index] = v
            self.displayData[index].guid = k
            index = index + 1
        end
		self.maxpage = math.ceil(#self.displayData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_friends_view.new(
                    self.itemModel:getChildByName("Panel_1"):clone()
                )
			self.pages[i]:update(self.displayData, i)
			self.views:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	elseif self.displayMode == 2 then -- 推荐
		print("推荐")
        local index = 1
        for k,v in pairs(MAIN_PLAYER.friendsManager.recordPool) do
            self.displayData[index] = v
            self.displayData[index].guid = k
            index = index + 1
            print("数量")
        end
		self.maxpage = math.ceil(#self.displayData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_record_view.new(
                    self.itemModel:getChildByName("Panel_1"):clone()
                )
			self.pages[i]:update(self.displayData, i)
			self.views:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	elseif self.displayMode == 3 then -- 申请
		print("申请")
        local index = 1
        for k,v in pairs(MAIN_PLAYER.friendsManager.verifyPool) do
            self.displayData[index] = v
            self.displayData[index].guid = k
            index = index + 1
            print("数量")
        end
		self.maxpage = math.ceil(#self.displayData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_verify_view.new(
                    self.itemModel:getChildByName("Panel_1"):clone()
                )
			self.pages[i]:update(self.displayData, i)
			self.views:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	end

end

return UI_Friends
