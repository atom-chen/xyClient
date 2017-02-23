--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 邮件界面

local UI_Market = class("UI_Market", cc.load("mvc").ViewBase)

local class_market_view = import("app.views.gameWorld.market2.market_view.lua")
local class_vip_view = import("app.views.gameWorld.market2.vip_view.lua")
local class_zhaomu_view = import("app.views.gameWorld.market2.zhaomu_view.lua")
local class_charge_view = import("app.views.gameWorld.market2.charge_view.lua")

UI_Market.RESOURCE_FILENAME = "ui_instance/market2/market_layer.csb"

UI_Market.list = {
	{
		name = "招募",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "商店",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "充值",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "vip",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Market:onCreate()
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
    self:updateVIP()
end

--注册节点事件
function UI_Market:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Market:_createControlerForUI()
	self.views = {}
	self.views[2] = class_market_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_1")
		)

	self.views[1] = class_zhaomu_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_4")
		)

	self.views[3] = class_charge_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_5")
		)

	self.views[4] = class_vip_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_3")
		)

end

function UI_Market:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	local jumptopkg = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_1")
	local function jumptopkgClicked(sender)
		self:close()
		dispatchGlobaleEvent("mainpage_popup_buttons2", "meirifuli_touched")
	end
	jumptopkg:addClickEventListener(jumptopkgClicked)

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
	
	self.tabs[4] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_4")
	self.tabs[4].index = 4
	self.tabs[4]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Market:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_marketManager", eventName = "refreshlist", callBack=handler(self, self.updateDisplay)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_VIP_BASE_INFO_CHANGE), callBack=handler(self, self.updateVIP)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function UI_Market:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Market:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Market:close(res)
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


function UI_Market:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Market:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Market:updateData()
	-- body

end

function UI_Market:updateDisplay(index)
	-- body
	if type(index) == "number" then
		self.index = index
	end
	self.displayData = {}

	for i=1,#self.views do
		self.views[i]:getResourceNode():setVisible(false)
	end

	if self.index == 1 then -- 招募
		self.views[1]:getResourceNode():setVisible(true)
	elseif self.index == 2 then -- 商店
		self.views[2]:getResourceNode():setVisible(true)
		self.views[2]:update(stoneConfig)
	elseif self.index == 3 then -- 充值
		self.views[3]:getResourceNode():setVisible(true)
		self.views[3]:update(saleConfig)
	elseif self.index == 4 then -- vip
		self.views[4]:getResourceNode():setVisible(true)
		self.views[4]:update(VipConfig)
	end

end

function UI_Market:updateVIP()
	-- body
	local vip = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_1")
	vip:setString("VIP:"..MAIN_PLAYER.VIPManager.VipGrade)

	local loadingBar = self.resourceNode_:getChildByName("main_layout"):getChildByName("LoadingBar_1")
	local exp = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_1_0")
	if MAIN_PLAYER.VIPManager.VipGrade < #VipConfig then
		loadingBar:setPercent(MAIN_PLAYER.VIPManager.chongzhijine/VipConfig[MAIN_PLAYER.VIPManager.VipGrade+1].recharge_amount*100)
		exp:setString(MAIN_PLAYER.VIPManager.chongzhijine.."/"..VipConfig[MAIN_PLAYER.VIPManager.VipGrade+1].recharge_amount)
	else
		loadingBar:setPercent(100)
		exp:setString("0/0")
	end
	
end

return UI_Market
