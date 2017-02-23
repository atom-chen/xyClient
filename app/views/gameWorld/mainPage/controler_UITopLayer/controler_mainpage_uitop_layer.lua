--
-- Author: lipeng
-- Date: 2015-07-13 19:37:14
-- UI层的置顶层

--头像
local class_controler_mainpage_head_node = import(".controler_mainpage_head_node")


local controler_mainpage_uitop_layer = class("controler_mainpage_uitop_layer")


--[[监听全局事件名预览
eventModleName: controler_mainpage_uitop_layer
eventName: 
	setUIVisible 	--设置UI显示状态
]]


function controler_mainpage_uitop_layer:ctor(mainPage_uitop_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._mainPage_uitop_layer = mainPage_uitop_layer
    self._mainPage_uitop_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._mainPage_uitop_layer)

    self._baseContainer = self._mainPage_uitop_layer:getChildByName("baseContainer")
    self._baseContainer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._baseContainer)
    

    self:_createControlerForUI()
    self:_registGlobalEventListeners()

    self:_registUIEvent()
end


function controler_mainpage_uitop_layer:getView()
    return self._mainPage_uitop_layer
end


function controler_mainpage_uitop_layer:_initModels()
    self._controlerMap = {}
end

--创建控制器: UI
function controler_mainpage_uitop_layer:_createControlerForUI()
    --头像
    self._controlerMap.head = class_controler_mainpage_head_node.new(
        self._baseContainer:getChildByName("head")
    )
    self._controlerMap.head:updateAllView(MAIN_PLAYER)
end


function controler_mainpage_uitop_layer:_registGlobalEventListeners()
	self._globalEventListeners = {}
    local configs = {
        {modelName = "controler_mainpage_uitop_layer", eventName = "setUIVisible", callBack=handler(self, self._onSetUIVisible)},
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function controler_mainpage_uitop_layer:_registUIEvent()
    -- body
end


function controler_mainpage_uitop_layer:_onSetUIVisible( event )
	local eventUseData = event._usedata
	local visibleType = eventUseData.visibleType

	--隐藏所有
	if visibleType == "hideAll" then
		self._controlerMap.head:getView():setVisible(false)
		self._mainPage_uitop_layer:setVisible(false)

	--显示所有
	elseif visibleType == "showAll" then
		self._controlerMap.head:getView():setVisible(true)
		self._mainPage_uitop_layer:setVisible(true)
	end

end


return controler_mainpage_uitop_layer


