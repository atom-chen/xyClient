--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 奇遇界面

local UI_Qiyu = class("UI_Qiyu", cc.load("mvc").ViewBase)

local class_qiyu_view = import("app.views.gameWorld.qiyu.qiyu_view.lua")

UI_Qiyu.RESOURCE_FILENAME = "ui_instance/qiyu/qiyu_layer.csb"

UI_Qiyu.list = {
	{
		name = "奇遇",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "复仇",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Qiyu:onCreate()
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
function UI_Qiyu:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Qiyu:_createControlerForUI()
	self._controlerMap = {}

	self.qiyu_view = class_qiyu_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_1")
		)


end

function UI_Qiyu:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	local refresh = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_2")
	
	local function refreshClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_ADD_QIYU)
	end
	refresh:addClickEventListener(refreshClicked)

	local function onClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 改变按钮状态
	            if sender.index == 2 then
	            	gameTcp:SendMessage(MSG_C2MS_OPEN_FUCHOU_LIST)
	            	-- self:openFuchou()
	        	else
		            self:updateButton(sender.index)
		            self:updateDisplay(sender.index)
		        end
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

	self:updateButton(1)
	
end

function UI_Qiyu:openFuchou()
	-- body
	self:updateButton(2)
	self:updateDisplay(2)
end

function UI_Qiyu:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "qiyu_ctrl", eventName = "refreshlist", callBack=handler(self, self.updateDisplay)},
		{modelName = "qiyu_ctrl", eventName = "close", callBack=handler(self, self.close)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_OPEN_FUCHOU_LIST), callBack=handler(self, self.openFuchou)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Qiyu:recordID(params)
	-- body
	self.recordID = params._usedata.recordID
end

function UI_Qiyu:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end


function UI_Qiyu:close(res)
	-- body
	if res == nil then
		res = self._dynamicResConfigIDs
	end
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


function UI_Qiyu:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Qiyu:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Qiyu:updateData()
	-- body

end

function UI_Qiyu:updateDisplay(index)
	-- body
	if index and type(index) == "number" then
		self.index = index
	end


	if self.index == 1 then -- 奇遇
		self.qiyu_view:update(MAIN_PLAYER.marketManager.qiyu, 1)
	elseif self.index == 2 then -- 复仇
		self.qiyu_view:update(MAIN_PLAYER.marketManager.fuchou, 2)
	end


	self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Text_4_1_0"):setString(#MAIN_PLAYER.marketManager.qiyu)


end

return UI_Qiyu
