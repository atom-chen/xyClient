--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 邮件界面

local UI_Mail = class("UI_Mail", cc.load("mvc").ViewBase)

local class_mail_view = import("app.views.gameWorld.mail2.mail_view.lua")

UI_Mail.RESOURCE_FILENAME = "ui_instance/mail2/mail_layer.csb"

UI_Mail.list = {
	{
		name = "全部",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "好友",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "系统",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Mail:onCreate()
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

	self:updateDisplay(1)
    
end

--注册节点事件
function UI_Mail:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Mail:_createControlerForUI()
	self._controlerMap = {}

	self.mail_view = class_mail_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_1")
		)


end

function UI_Mail:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	-- 一键收取
	local get = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_12")
	local function getClicked(sender)
		print("一键收取")
	end
	get:addClickEventListener(getClicked)

	-- 一键删除
	local del = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_12_0")
	local function delClicked(sender)
		print("一键删除")
	end
	del:addClickEventListener(delClicked)

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
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_quanbu")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_haoyou")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)
	
	self.tabs[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_xitong")
	self.tabs[3].index = 3
	self.tabs[3]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Mail:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_mailManager", eventName = "refreshlist", callBack=handler(self, self.updateDisplay)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function UI_Mail:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Mail:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Mail:close(res)
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


function UI_Mail:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Mail:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Mail:updateData()
	-- body

end

function UI_Mail:updateDisplay(index)
	-- body
	if type(index) == "number" then
		self.index = index
	end
	self.displayData = {}
	if self.index == 1 then -- 全部
		local tmp = 1
        for k,v in pairs(MAIN_PLAYER.mailManager.data) do
            self.displayData[tmp] = v
            tmp = tmp + 1
        end
	elseif self.index == 2 then -- 好友
		local tmp = 1
        for k,v in pairs(MAIN_PLAYER.mailManager.data) do
            if v.Type == 2 then
                self.displayData[tmp] = v
                tmp = tmp + 1
            end
        end
	elseif self.index == 3 then -- 系统
		local tmp = 1
        for k,v in pairs(MAIN_PLAYER.mailManager.data) do
            if v.Type == 1 then
                self.displayData[tmp] = v
                tmp = tmp + 1
            end
        end
	end


	self.mail_view:update(self.displayData)

end

return UI_Mail
