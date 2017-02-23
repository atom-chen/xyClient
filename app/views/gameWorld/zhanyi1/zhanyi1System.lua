--
-- Author: lipeng
-- Date: 2015-07-02 10:59:57
-- 队伍

--UI层
--local class_controler_team_ui_layer = import(".controler_UILayer.controler_team_ui_layer")

local zhanYi1System = class("zhanYi1System")


--[[发送全局事件名预览
eventModleName: controler_mainPage_ui_layer
eventName: 
    doHideUI --执行隐藏首页的UI层
]]

--[[监听全局事件名预览
eventModleName: controler_mainpage_zhanyi1_layer
eventName: 
    zhanyi_touched     --战役1按钮touched
]]


function zhanYi1System:ctor()
    self:_initModels()
    -- body
    self:_registGlobalEventListeners()
end

function zhanYi1System:_initModels()
    self._controlerMap = {}
end


function zhanYi1System:_registGlobalEventListeners()
    -- body
    self._globalEventListeners = {}
    local configs = {
        {modelName = "controler_mainpage_zhanyi1_layer", eventName = "zhanyi_touched", callBack=handler(self, self._onZhanyi_touched)}
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function zhanYi1System:_createUILayer()
    return cc.CSLoader:createNode("ui_instance/team/team_ui_layer.csb")
end

function zhanYi1System:_onZhanyi_touched()
    self.scene = APP:getCurScene()
    dispatchGlobaleEvent("controler_mainPage_ui_layer", "setUIVisible", {visibleType="hideAll"})
    dispatchGlobaleEvent("controler_mainpage_uitop_layer", "setUIVisible", {visibleType="showAll"})
    dispatchGlobaleEvent("controler_mainpage_top_layer", "setUIVisible", {visibleType="showAll"})
    
    --self._controlerMap.team = class_controler_team_ui_layer.new(self:_createUILayer())
    --self.scene:addChildToLayer(LAYER_ID_UI, self._controlerMap.team:getView())
end



function zhanYi1System.getInstance()
    if zhanYi1System.instance == nil then
        zhanYi1System.instance = zhanYi1System.new()
    end

    return zhanYi1System.instance
end


zhanYi1SystemInstance = zhanYi1System.getInstance()


return zhanYi1System
