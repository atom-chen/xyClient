--
-- Author: lipeng
-- Date: 2015-06-29 09:37:59
--

local class_controler_mainpage_select_zhanyi_node = import(".controler_mainpage_select_zhanyi_node")
local class_controler_mainpage_functionbuttons_layer = import(".controler_mainpage_functionbuttons_layer")


local controler_mainPage_ui_layer = class("controler_mainPage_ui_layer")

--[[监听全局事件名预览
eventModleName: controler_mainPage_ui_layer
eventName: 
    setUIVisible     --设置显示状态

]]


function controler_mainPage_ui_layer:ctor(mainPage_ui_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._mainPage_ui_layer = mainPage_ui_layer
    self._mainPage_ui_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._mainPage_ui_layer)

    --UI容器
    self._UIContainer = self._mainPage_ui_layer:getChildByName("UIContainer")
    self._UIContainer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._UIContainer)

    self:_createControlerForUI()
    self:_registGlobalEventListeners()

    self:_registUIEvent()
end


function controler_mainPage_ui_layer:getView()
    return self._mainPage_ui_layer
end


function controler_mainPage_ui_layer:_initModels()
    self._controlerMap = {}
end

--创建控制器: UI
function controler_mainPage_ui_layer:_createControlerForUI()
    --选择战役
    print("controler_mainPage_ui_layer 0")
    self._controlerMap.selecte_zhanyi = class_controler_mainpage_select_zhanyi_node.new(
        self._UIContainer:getChildByName("selecte_zhanyi")
    )
    print("controler_mainPage_ui_layer 1")
    --功能按钮组
    self._controlerMap.functionbuttons = class_controler_mainpage_functionbuttons_layer.new(
        self._UIContainer:getChildByName("function_buttons")
    )
    print("controler_mainPage_ui_layer 2")
end


function controler_mainPage_ui_layer:_registGlobalEventListeners()
    self._globalEventListeners = {}
    local configs = {
        {modelName = "controler_mainPage_ui_layer", eventName = "setUIVisible", callBack=handler(self, self._onSetUIVisible)},
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function controler_mainPage_ui_layer:_registUIEvent()
    -- body
end


function controler_mainPage_ui_layer:_onSetUIVisible( event )
    local eventUseData = event._usedata
    local visibleType = eventUseData.visibleType

    --隐藏所有
    if visibleType == "hideAll" then
        self._mainPage_ui_layer:setVisible(false)

    --显示所有
    elseif visibleType == "showAll" then
        self._mainPage_ui_layer:setVisible(true)
    end
    
end


return controler_mainPage_ui_layer
