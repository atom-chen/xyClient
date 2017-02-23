--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 活动界面

local UI_Huodong = class("UI_Huodong", cc.load("mvc").ViewBase)

local class_qiandao_view = import("app.views.gameWorld.huodong2.qiandao_view.lua")

UI_Huodong.RESOURCE_FILENAME = "ui_instance/huodong2/huodong_layer.csb"

UI_Huodong.list = {
	{
		name = "签到",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Huodong:onCreate()
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
function UI_Huodong:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Huodong:_createControlerForUI()
	self._controlerMap = {}

	self.qiandao_view = class_qiandao_view.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("ProjectNode_1")
		)


end

function UI_Huodong:_registButtonEvent()
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
	            self:updateButton(sender.index)
	            self:updateDisplay(sender.index)
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end

	self.tabs = {}
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Image_1")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Huodong:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "huodong_ctrl", eventName = "refreshlist", callBack=handler(self, self.updateDisplay)},
		-- {modelName = "model_missionManager", eventName = "recordID", callBack=handler(self, self.recordID)},
		-- {modelName = "model_missionManager", eventName = "complete_mission", callBack=handler(self, self.receivedMission)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Huodong:recordID(params)
	-- body
	self.recordID = params._usedata.recordID
end

function UI_Huodong:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end


function UI_Huodong:close(res)
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


function UI_Huodong:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Huodong:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Huodong:updateData()
	-- body

end

function UI_Huodong:updateDisplay(index)
	-- body
	if index and type(index) == "number" then
		self.index = index
	end


	if self.index == 1 then -- 签到
		self.qiandao_view:update()
	elseif self.index == 2 then

	end


	

end

return UI_Huodong
