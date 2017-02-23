--
-- Author: lipeng
-- Date: 2015-07-13 19:37:14
-- 主页顶层


local class_controler_mainpage_chat_node = import(".controler_mainpage_chat_node")


local controler_mainpage_top_layer = class("controler_mainpage_top_layer")


--[[监听全局事件名预览
eventModleName: controler_mainpage_top_layer
eventName: 
	setUIVisible 	--设置UI显示状态
]]


function controler_mainpage_top_layer:ctor(mainPage_top_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._mainPage_top_layer = mainPage_top_layer
    self._mainPage_top_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._mainPage_top_layer)

    self._baseContainer = self._mainPage_top_layer:getChildByName("baseContainer")
    self._baseContainer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._baseContainer)
    

    self:_createControlerForUI()
    self:_registGlobalEventListeners()

    self:_registUIEvent()
end


function controler_mainpage_top_layer:getView()
    return self._mainPage_top_layer
end


function controler_mainpage_top_layer:_initModels()
    self._controlerMap = {}
end

--创建控制器: UI
function controler_mainpage_top_layer:_createControlerForUI()
    --聊天
    self._controlerMap.chat = class_controler_mainpage_chat_node.new(
        self._baseContainer:getChildByName("chat")
    )
    
end


function controler_mainpage_top_layer:_registGlobalEventListeners()
	self._globalEventListeners = {}
    local configs = {
        {modelName = "controler_mainpage_top_layer", eventName = "setUIVisible", callBack=handler(self, self._onSetUIVisible)},
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function controler_mainpage_top_layer:_registUIEvent()
    -- body
end


function controler_mainpage_top_layer:_onSetUIVisible( event )
	local eventUseData = event._usedata
	local visibleType = eventUseData.visibleType

	--隐藏所有
	if visibleType == "hideAll" then
		self._controlerMap.chat:getView():setVisible(false)
		self._mainPage_top_layer:setVisible(false)

	--显示所有
	elseif visibleType == "showAll" then
		self._controlerMap.chat:getView():setVisible(true)
		self._mainPage_top_layer:setVisible(true)

	--仅显示聊天框
	elseif visibleType == "onlyShowChat" then
		self._controlerMap.chat:getView():setVisible(true)
		self._mainPage_top_layer:setVisible(true)

	--显示聊天和公告
	elseif visibleType == "showChatAndMsg" or
			visibleType == "showMsgAndChat" then
		self._controlerMap.chat:getView():setVisible(true)
		self._mainPage_top_layer:setVisible(true)

	--仅显示公告
	elseif visibleType == "onlyShowMsg" then
		self._controlerMap.chat:getView():setVisible(false)
		self._mainPage_top_layer:setVisible(true)
	end

end


return controler_mainpage_top_layer


