--
-- Author: lipeng
-- Date: 2015-07-02 15:39:31
-- 控制器: 寻宝

local controler_mainpage_zhanyi3_layer = class("controler_mainpage_zhanyi3_layer")

function controler_mainpage_zhanyi3_layer:ctor(mainpage_zhanyi3_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._mainpage_zhanyi3_layer = mainpage_zhanyi3_layer
    --self:_runAllAction()

    self:_registUIEvent()
end


--初始化数据
function controler_mainpage_zhanyi3_layer:_initModels()

end

--注册UI事件
function controler_mainpage_zhanyi3_layer:_registUIEvent()
	local function btn_zhanyiCallback( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			-- dispatchGlobaleEvent("controler_mainpage_zhanyi3_layer", "zhanyi_touched", {sender=sender, eventType=eventType})
			gameTcp:SendMessage(MSG_C2MS_PVP_GET_INFO)
			print("发送请求竞技场")
		end
	end

	local btn_zhanyi = self._mainpage_zhanyi3_layer:getChildByName("Button_1")
    btn_zhanyi:addTouchEventListener(btn_zhanyiCallback)
    btn_zhanyi:setSwallowTouches(false)
end


function controler_mainpage_zhanyi3_layer:_runAllAction()
 	local animNode = self._mainpage_zhanyi3_layer:getChildByName("Sprite_1")
    local action = cc.CSLoader:createTimeline("ui_instance/mainPage/mainpage_zhanyi3_layer.csb")
    animNode:runAction(action)
    action:play("animation0", true)
end


return controler_mainpage_zhanyi3_layer
