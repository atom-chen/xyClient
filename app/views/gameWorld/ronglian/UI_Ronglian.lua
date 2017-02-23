--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 道具界面

local UI_Ronglian = class("UI_Ronglian", cc.load("mvc").ViewBase)

-- local class_wujiang_pageview = import("app.views.gameWorld.wujiang.wujiang_pageview.lua")
-- local class_wujiang_wujiang = import("app.views.gameWorld.wujiang.wujiang_wujiang.lua")
-- local class_wujiang_fragment = import("app.views.gameWorld.wujiang.wujiang_fragment.lua")
-- local class_wujiang_atlas = import("app.views.gameWorld.wujiang.wujiang_atlas.lua")
local class_ronglian_view = import("app.views.gameWorld.ronglian.ronglian_view.lua")
local class_chongsheng_view = import("app.views.gameWorld.ronglian.chongsheng_view.lua")
local class_chongzhu_view = import("app.views.gameWorld.ronglian.chongzhu_view.lua")

UI_Ronglian.RESOURCE_FILENAME = "ui_instance/ronglian/ronglian_layer.csb"

UI_Ronglian.list = {
	{
		name = "熔炼",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "重生",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "重铸",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Ronglian:onCreate()
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
function UI_Ronglian:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Ronglian:_createControlerForUI()
	self._controlerMap = {}

	-- self._controlerMap.pageview = class_wujiang_pageview.new(
	-- 	self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("pageview")
	-- )

	-- local function pageViewEvent(sender, eventType)
	-- 	if eventType == ccui.PageViewEventType.turning then
	-- 		self:updatePage(sender:getCurPageIndex()+1)
	-- 	end
	-- end
	-- self._controlerMap.pageview:getResourceNode():addEventListener(pageViewEvent)


	-- 熔炼
	self.ronglian = class_ronglian_view.new(
		self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ronglian_view")
		)

	-- 重生
	self.chongsheng = class_chongsheng_view.new(
		self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("chongsheng_view")
		)

	-- 重铸
	self.chongzhu = class_chongzhu_view.new(
		self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("chongzhu_view")
		)


end

function UI_Ronglian:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	local function onClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 改变按钮状态
	            if sender.index == 3 then -- 发送熔炼商店消息
	           		print("发送熔炼商店消息")
	            	gameTcp:SendMessage(MSG_C2MS_OPEN_RONGLIAN_SHOP)
		        else
		            self:updateButton(sender.index)
		            self:updateDisplay(sender.index)
		        end

	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end

	self.tabs = {}
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_ronglian")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_chongsheng")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)
	
	self.tabs[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_chongzhu")
	self.tabs[3].index = 3
	self.tabs[3]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Ronglian:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_OPEN_RONGLIAN_SHOP), callBack=handler(self, self.openronglianshop)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_RUSH_RONGLIAN_SHOP), callBack=handler(self, self.openronglianshop)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_BUY_RONGLIANSHOP_ITEM), callBack=handler(self, self.openronglianshop)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Ronglian:openronglianshop()
	-- body
	self:updateButton(3)
	self:updateDisplay(3)
end


function UI_Ronglian:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Ronglian:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Ronglian:close(res)
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


function UI_Ronglian:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Ronglian:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Ronglian:updateData()
	-- body
	
end

function UI_Ronglian:updateDisplay(index)
	-- body
	self.chongzhu:stop()
	if index == 1 then -- 熔炼
		self.ronglian:getResourceNode():setVisible(true)
		self.chongsheng:getResourceNode():setVisible(false)
		self.chongzhu:getResourceNode():setVisible(false)
	elseif index == 2 then -- 重生
		self.ronglian:getResourceNode():setVisible(false)
		self.chongsheng:getResourceNode():setVisible(true)
		self.chongzhu:getResourceNode():setVisible(false)
	elseif index == 3 then -- 重铸
		self.ronglian:getResourceNode():setVisible(false)
		self.chongsheng:getResourceNode():setVisible(false)
		self.chongzhu:getResourceNode():setVisible(true)
		if self.chongzhu:update() then
			self.chongzhu:start()
		end
	end

end

return UI_Ronglian
