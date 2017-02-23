--
-- Author: Wu Hengmin
-- Date: 2015-07-09 12:03:40
--
local UI_Setting = class("UI_Setting", cc.load("mvc").ViewBase)

UI_Setting.RESOURCE_FILENAME = "ui_instance/setting/setting_layer.csb"

function UI_Setting:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()

	self.rootNode = self.resourceNode_:getChildByName("main_layout")

	self:_createControlerForUI()

	self:_registButtonEvent()

	local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode()
    rootNode:setContentSize(size)
    ccui.Helper:doLayout(rootNode)
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360))

    local shadow_layout = rootNode:getChildByName("shadow_layout")
    shadow_layout:setContentSize(size)
    ccui.Helper:doLayout(shadow_layout)

end

--注册节点事件
function UI_Setting:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Setting:_createControlerForUI()


    -- 公告
    local gonggao = self.rootNode:getChildByName("gonggao")
	local function gtouchEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				print("公告")
			end
		elseif eventType == ccui.TouchEventType.canceled then
			
		end
	end
	gonggao:setSwallowTouches(false)
	gonggao:addTouchEventListener(gtouchEvent)


	-- 礼包
    local libao = self.rootNode:getChildByName("libao")
	local function lgtouchEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				print("礼包")
			end
		elseif eventType == ccui.TouchEventType.canceled then
			
		end
	end
	libao:setSwallowTouches(false)
	libao:addTouchEventListener(lgtouchEvent)


	-- 退出
    local tuichu = self.rootNode:getChildByName("tuichu")
	local function tgtouchEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				print("退出")
			end
		elseif eventType == ccui.TouchEventType.canceled then
			
		end
	end
	tuichu:setSwallowTouches(false)
	tuichu:addTouchEventListener(tgtouchEvent)


	-- 音效
    local yinxiao = self.rootNode:getChildByName("yinxiao"):getChildByName("Image_1_0")
	local function yxgtouchEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				print("音效")
			end
		elseif eventType == ccui.TouchEventType.canceled then
			
		end
	end
	yinxiao:setSwallowTouches(false)
	yinxiao:addTouchEventListener(yxgtouchEvent)


	-- 音乐
    local yinyue = self.rootNode:getChildByName("yinxiao"):getChildByName("Image_1")
	local function yygtouchEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
				print("音乐")
			end
		elseif eventType == ccui.TouchEventType.canceled then
			
		end
	end
	yinyue:setSwallowTouches(false)
	yinyue:addTouchEventListener(yygtouchEvent)


end

function UI_Setting:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("button_exit")
	local function exitClicked(sender)
		self:close()
	end
	button:addClickEventListener(exitClicked)
end

function UI_Setting:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "setting_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Setting:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function UI_Setting:close()
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				self:removeFromParent(true)
			end
		})
end

return UI_Setting
