--
-- Author: lipeng
-- Date: 2015-07-02 13:40:11
-- 控制器: 选择战役

local class_controler_mainpage_zhanyi1_layer = import(".controler_mainpage_zhanyi1_layer")
local class_controler_mainpage_zhanyi2_layer = import(".controler_mainpage_zhanyi2_layer")
local class_controler_mainpage_zhanyi3_layer = import(".controler_mainpage_zhanyi3_layer")
local class_controler_mainpage_zhanyi4_layer = import(".controler_mainpage_zhanyi4_layer")
local class_controler_mainpage_zhanyi5_layer = import(".controler_mainpage_zhanyi5_layer")


local controler_mainpage_select_zhanyi_node = class("controler_mainpage_select_zhanyi_node")

function controler_mainpage_select_zhanyi_node:ctor(mainpage_select_zhanyi_node)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._select_zhanyi_node = mainpage_select_zhanyi_node
	self._select_zhanyi_node:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._select_zhanyi_node)

    self._scrollViewContainer = self._select_zhanyi_node:getChildByName("scrollViewContainer")
    --self._scrollViewContainer:setContentSize(visibleSize)
    --ccui.Helper:doLayout(self._scrollViewContainer)

    self:_createControlerForUI()
    self:_registUIEvent()
end


--初始化数据
function controler_mainpage_select_zhanyi_node:_initModels()
	self._controlerMap = {}
end


--创建控制器: UI
function controler_mainpage_select_zhanyi_node:_createControlerForUI()
	local scrollViewContainer = self._scrollViewContainer

    self._controlerMap.zhanyi1_layer = class_controler_mainpage_zhanyi1_layer.new(
    	scrollViewContainer:getChildByName("layer_zhanyi1")
    )

    self._controlerMap.zhanyi2_layer = class_controler_mainpage_zhanyi2_layer.new(
    	scrollViewContainer:getChildByName("layer_zhanyi2")
    )

    self._controlerMap.zhanyi3_layer = class_controler_mainpage_zhanyi3_layer.new(
    	scrollViewContainer:getChildByName("layer_zhanyi3")
    )
    
    self._controlerMap.zhanyi4_layer = class_controler_mainpage_zhanyi4_layer.new(
    	scrollViewContainer:getChildByName("layer_zhanyi4")
    )

    self._controlerMap.zhanyi5_layer = class_controler_mainpage_zhanyi5_layer.new(
    	scrollViewContainer:getChildByName("layer_zhanyi5")
    )
end


function controler_mainpage_select_zhanyi_node:_registGlobalEventListeners()
    -- body
    self._globalEventListeners = {}
    local configs = {
        {modelName = "zhanYi1System", eventName = "openZhanYi1", callBack=handler(self, self._onOpenZhanYi1)},
        {modelName = "zhanYi1System", eventName = "openZhanYi1", callBack=handler(self, self._onOpenZhanYi1)}
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--注册UI事件
function controler_mainpage_select_zhanyi_node:_registUIEvent()
	
end


function controler_mainpage_select_zhanyi_node:_onOpenZhanYi1( event )
    self:setVisible(false)
end



return controler_mainpage_select_zhanyi_node
