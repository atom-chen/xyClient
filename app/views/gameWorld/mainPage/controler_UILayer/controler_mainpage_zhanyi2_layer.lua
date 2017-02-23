--
-- Author: lipeng
-- Date: 2015-07-02 15:39:31
-- 控制器: 战役2

local controler_mainpage_zhanyi2_layer = class("controler_mainpage_zhanyi2_layer")

function controler_mainpage_zhanyi2_layer:ctor(mainpage_zhanyi2_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._mainpage_zhanyi2_layer = mainpage_zhanyi2_layer

    self:_registUIEvent()
    --self:_runAllAction()
end


--初始化数据
function controler_mainpage_zhanyi2_layer:_initModels()
	
end


--注册UI事件
function controler_mainpage_zhanyi2_layer:_registUIEvent()
	local function btn_zhanyiCallback( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			dispatchGlobaleEvent("controler_mainpage_zhanyi2_layer", "zhanyi_touched", {sender=sender, eventType=eventType})
		end
	end

	local btn_zhanyi = self._mainpage_zhanyi2_layer:getChildByName("Button_1")
    btn_zhanyi:addTouchEventListener(btn_zhanyiCallback)
    btn_zhanyi:setSwallowTouches(false)
end


function controler_mainpage_zhanyi2_layer:_runAllAction()
 	local animNode = self._mainpage_zhanyi2_layer:getChildByName("Sprite_17")
    local action = cc.CSLoader:createTimeline("ui_instance/mainPage/mainpage_zhanyi2_layer.csb")
    animNode:runAction(action)
    action:play("animation0", true)
end


return controler_mainpage_zhanyi2_layer
