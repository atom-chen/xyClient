--
-- Author: lipeng
-- Date: 2015-06-29 09:37:00
-- 控制器: 功能按钮组1


local controler_mainpage_popup_buttons2 = class("controler_mainpage_popup_buttons2")

--[[发送全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName: 
	qian_dao_touched --签到按钮touched
	shiji_touched --市集按钮touched
	renwu_touched --任务按钮touched
	youjian_touched --邮件按钮touched
	haoyou_touched --好友按钮touched
]]


function controler_mainpage_popup_buttons2:ctor(popup_buttons2)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._popup_buttons2 = popup_buttons2
	self._popup_buttons2:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._popup_buttons2)

    self:_registUIEvent()
end


--parmas.nameID
function controler_mainpage_popup_buttons2:runAction(parmas)
	if parmas.nameID == "animation_toLeft" then
		self:_runCCSAction_animation_toLeft(parmas)

	elseif parmas.nameID == "animation_toRight" then
		self:_runCCSAction_animation_toRight(parmas)
	end
end


--初始化数据
function controler_mainpage_popup_buttons2:_initModels()
	-- body
end


--注册UI事件
function controler_mainpage_popup_buttons2:_registUIEvent()
	--签到
	local function btn_qiandaoCallback( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			-- dispatchGlobaleEvent("mainpage_popup_buttons2", "qian_dao_touched", {sender=sender, eventType=eventType})
			print("MSG_C2MS_PVP_GET_INFO")
			gameTcp:SendMessage(MSG_C2MS_PVP_GET_INFO)
			-- equipSystemInstance:open({
			-- 		target = "装备强化",
			-- 		guid = "{811B31A6-60A9-46AD-9C28-52843EB158CF}"
			-- 	})
		end
	end
	local btn_qiandao = self._popup_buttons2:getChildByName("btn_qiandao")
    btn_qiandao:addTouchEventListener(btn_qiandaoCallback)

    --市集
    local function btn_shijiCallback( sender, eventType )
    	if eventType == ccui.TouchEventType.ended then
    		-- dispatchGlobaleEvent("mainpage_popup_buttons2", "shiji_touched", {sender=sender, eventType=eventType})
    		gameTcp:SendMessage(MSG_C2MS_OPEN_XIANGOU_SHOPLIST)
    	end
	end
	local btn_shiji = self._popup_buttons2:getChildByName("btn_shiji")
    btn_shiji:addTouchEventListener(btn_shijiCallback)

    --任务
    local function btn_renwuCallback( sender, eventType )
    	if eventType == ccui.TouchEventType.ended then
    		-- dispatchGlobaleEvent("mainpage_popup_buttons2", "renwu_touched", {sender=sender, eventType=eventType})
    		gameTcp:SendMessage(MSG_C2MS_GET_MISSION_DATA)
    	end
	end
	local btn_renwu = self._popup_buttons2:getChildByName("btn_renwu")
    btn_renwu:addTouchEventListener(btn_renwuCallback)

    --邮件
    local function btn_youjianCallback( sender, eventType )
    	if eventType == ccui.TouchEventType.ended then
    		dispatchGlobaleEvent("mainpage_popup_buttons2", "youjian_touched", {sender=sender, eventType=eventType})
    	end
	end
	local btn_youjian = self._popup_buttons2:getChildByName("btn_youjian")
    btn_youjian:addTouchEventListener(btn_youjianCallback)

    --好友
    local function btn_haoyouCallback( sender, eventType )
    	if eventType == ccui.TouchEventType.ended then
    		-- dispatchGlobaleEvent("mainpage_popup_buttons2", "haoyou_touched", {sender=sender, eventType=eventType})
    		-- 好友验证数据
			gameTcp:SendMessage(MSG_C2MS_GET_APPLICANT_DATA)
    	end
	end
	local btn_haoyou = self._popup_buttons2:getChildByName("btn_haoyou")
    btn_haoyou:addTouchEventListener(btn_haoyouCallback)
end


function controler_mainpage_popup_buttons2:_createTimeline()
	return cc.CSLoader:createTimeline("ui_instance/mainPage/mainpage_popup_buttons2.csb")
end

--
function controler_mainpage_popup_buttons2:_runCCSAction_animation_toLeft(parmas)
	self._popup_buttons2:stopAllActions()

	self._popup_buttons2:setVisible(true)

	local action = self:_createTimeline()
	self._popup_buttons2:runAction(action)
    action:play("animation_toLeft", false)
end


--
function controler_mainpage_popup_buttons2:_runCCSAction_animation_toRight(parmas)
	self._popup_buttons2:stopAllActions()
	
	local action = self:_createTimeline()
	self._popup_buttons2:runAction(action)
    action:play("animation_toRight", false)
    action:setFrameEventCallFunc(function ( frame )
    	if frame:getEvent() == "playFinish" then
    		self._popup_buttons2:setVisible(false)
    	end
    end)
end



return controler_mainpage_popup_buttons2

