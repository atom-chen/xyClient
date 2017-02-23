--
-- Author: lipeng
-- Date: 2015-06-29 09:37:00
-- 控制器: 功能按钮组1


local controler_mainpage_popup_buttons1 = class("controler_mainpage_popup_buttons1")


--[[发送全局事件名预览
eventModleName: mainpage_popup_buttons1
eventName: 
	shezhi_touched --设置按钮touched
]]


function controler_mainpage_popup_buttons1:ctor(popup_buttons1)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._popup_buttons1 = popup_buttons1
	self._popup_buttons1:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._popup_buttons1)

    self:_registUIEvent()
end


--parmas.nameID
function controler_mainpage_popup_buttons1:runAction(parmas)
	if parmas.nameID == "animation_toTop" then
		self:_runCCSAction_animation_toTop(parmas)

	elseif parmas.nameID == "animation_toBottom" then
		self:_runCCSAction_animation_toBottom(parmas)
	end
end


--初始化数据
function controler_mainpage_popup_buttons1:_initModels()
	-- body
end


--注册UI事件
function controler_mainpage_popup_buttons1:_registUIEvent()
	--设置
	local function btn_shezhiCallback( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			--todo
			dispatchGlobaleEvent("mainpage_popup_buttons1", "shezhi_touched", {sender=sender, eventType=eventType})
		end
	end
	local btn_shezhi = self._popup_buttons1:getChildByName("btn_shezhi")
    btn_shezhi:addTouchEventListener(btn_shezhiCallback)
end


function controler_mainpage_popup_buttons1:_createTimeline()
	return cc.CSLoader:createTimeline("ui_instance/mainPage/mainpage_popup_buttons1.csb")
end

--
function controler_mainpage_popup_buttons1:_runCCSAction_animation_toTop(parmas)
	self._popup_buttons1:stopAllActions()
	self._popup_buttons1:setVisible(true)

	local action = self:_createTimeline()
	self._popup_buttons1:runAction(action)
    action:play("animation_toTop", false)
end


--
function controler_mainpage_popup_buttons1:_runCCSAction_animation_toBottom(parmas)
	self._popup_buttons1:stopAllActions()

	local action = self:_createTimeline()
	self._popup_buttons1:runAction(action)
    action:play("animation_toBottom", false)
    action:setFrameEventCallFunc(function ( frame )
    	if frame:getEvent() == "playFinish" then
    		self._popup_buttons1:setVisible(false)
    	end
    end)
end


return controler_mainpage_popup_buttons1

