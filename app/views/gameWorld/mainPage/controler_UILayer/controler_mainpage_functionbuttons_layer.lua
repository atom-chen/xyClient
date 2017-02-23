--
-- Author: lipeng
-- Date: 2015-06-29 09:37:00
-- 控制器: 功能按钮组

local class_controler_mainpage_plus_node = import(".controler_mainpage_plus_node")
--local class_controler_mainpage_popup_buttons1 = import(".controler_mainpage_popup_buttons1")
--local class_controler_mainpage_popup_buttons2 = import(".controler_mainpage_popup_buttons2")


local controler_mainpage_functionbuttons_layer = class("controler_mainpage_functionbuttons_layer")

--[[发送全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName: 
    duiwu_touched --队伍按钮touched
    daoju_touched --道具按钮touched
    wujiang_touched --武将按钮touched
    juntuan_touched --军团按钮touched
    zhuangbei_touched --装备按钮touched
    ronglian_touched --熔炼按钮touched
    guyong_touched --雇佣按钮touched
    shangcheng_touched --商城按钮touched
    zhuxian_touched --主线按钮touched
    meirifuli_touched --每日福利按钮touched
    huodong_touched --活动按钮touched
    juewei_touched --爵位按钮touched
]]


--[[监听全局事件名预览
eventModleName: controler_mainpage_plus_node
eventName: 
    plus_touched --加号按钮touched
]]



function controler_mainpage_functionbuttons_layer:ctor(function_buttons)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._function_buttons = function_buttons
    self._function_buttons:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._function_buttons)

    self._UIContainer = self._function_buttons:getChildByName("UIContainer")

    --右边位置的UI容器
    self._rightUIContainer = self._UIContainer:getChildByName("img_mfb_bg1_47")


    self:_createControlerForUI()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()
    --self:_runAllAction()
end


--初始化数据
function controler_mainpage_functionbuttons_layer:_initModels()
	self._controlerMap = {}
	self._popupButtonsState = "pop"
end

--注册节点事件
function controler_mainpage_functionbuttons_layer:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._function_buttons:registerScriptHandler(onNodeEvent)
end

--创建控制器: UI
function controler_mainpage_functionbuttons_layer:_createControlerForUI()
	local UIContainer = self._UIContainer

    -- self._controlerMap.popup_buttons1 = class_controler_mainpage_popup_buttons1.new(
    -- 	UIContainer:getChildByName("popup_buttons1")
    -- )
    -- self._controlerMap.popup_buttons2 = class_controler_mainpage_popup_buttons2.new(
    -- 	UIContainer:getChildByName("popup_buttons2")
    -- )
    -- self._controlerMap.plus_node = class_controler_mainpage_plus_node.new(
    --     UIContainer:getChildByName("node_plus")
    -- )
    
end


--注册UI事件
function controler_mainpage_functionbuttons_layer:_registUIEvent()
	local UIContainer = self._UIContainer

    --队伍
    local btn_duiwu = UIContainer:getChildByName("btn_duiwu")
    local function btn_duiwuCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("队伍")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "duiwu_touched", {sender=sender, eventType=eventType})
            --end)
        end
        
    end
    btn_duiwu:addTouchEventListener(btn_duiwuCallback)
    
	
    --道具
    -- local function btn_daojuCallback( sender, eventType )
    --     if eventType == ccui.TouchEventType.ended then
    --         dispatchGlobaleEvent("mainpage_popup_buttons2", "daoju_touched", {sender=sender, eventType=eventType})
    --     end
        
    -- end
    -- local btn_daoju = UIContainer:getChildByName("btn_daoju")
    -- btn_daoju:addTouchEventListener(btn_daojuCallback)

    --武将
    local btn_wujiang = UIContainer:getChildByName("btn_wujiang")
    local function btn_wujiangCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("武将")
            --self:delayCallback(sender, 1, function ()
                -- dispatchGlobaleEvent("mainpage_popup_buttons2", "wujiang_touched", {sender=sender, eventType=eventType})
                -- print("MSG_C2MS_PIECE_HERO_GET"..MSG_C2MS_PIECE_HERO_GET)
                gameTcp:SendMessage(MSG_C2MS_PIECE_HERO_GET)
            --end)
        end
    end
    btn_wujiang:addTouchEventListener(btn_wujiangCallback)


    --军团
    local btn_juntuan = UIContainer:getChildByName("btn_juntuan")
    local function btn_juntuanCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("军团")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "juntuan_touched", {sender=sender, eventType=eventType})
            --end)
            
        end
    end
    btn_juntuan:addTouchEventListener(btn_juntuanCallback)


    --背包
    local btn_beibao = UIContainer:getChildByName("btn_beibao")
    local function btn_beibaoCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("背包")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "zhuangbei_touched", {sender=sender, eventType=eventType})
            --end)
            
            -- gameTcp:SendMessage(MSG_C2MS_EQUIPS_GETLIST)
        end
    end
    btn_beibao:addTouchEventListener(btn_beibaoCallback)

    --熔炼
    local btn_ronglian = UIContainer:getChildByName("btn_ronglian")
    local function btn_ronglianCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("熔炼")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "ronglian_touched", {sender=sender, eventType=eventType})
            --end)
        end
    end
    btn_ronglian:addTouchEventListener(btn_ronglianCallback)
    
    --雇佣
    local btn_guyong = UIContainer:getChildByName("btn_guyong")
    local function btn_guyongCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("雇佣")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "guyong_touched", {sender=sender, eventType=eventType})
            --end)

        end
    end
    btn_guyong:addTouchEventListener(btn_guyongCallback)


    --商城
    local btn_shangcheng = UIContainer:getChildByName("btn_shangcheng")
    local function btn_shangchengCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("商店")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "shangcheng_touched", {sender=sender, eventType=eventType})
            --end)
        end
    end
    btn_shangcheng:addTouchEventListener(btn_shangchengCallback)

    --主线
    local btn_zhuXian = UIContainer:getChildByName("btn_zhuXian")
    local function btn_zhuXianCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("奇遇")
            -- dispatchGlobaleEvent("mainpage_popup_buttons2", "zhuxian_touched", {sender=sender, eventType=eventType})
            -- dispatchGlobaleEvent("model_qiyuManager", "open_qiyu")
            print("发送奇遇")
            gameTcp:SendMessage(MSG_C2MS_OPEN_QIYU_LIST)


        end
    end
    btn_zhuXian:addTouchEventListener(btn_zhuXianCallback)


    --每日福利
    local function btn_meirifuliCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("福利")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "meirifuli_touched", {sender=sender, eventType=eventType})
            --end)
        end
    end
    local btn_meirifuli = self._rightUIContainer:getChildByName("btn_fuli")
    btn_meirifuli:addTouchEventListener(btn_meirifuliCallback)

    --爵位
    local function btn_jueweiCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "juewei_touched", {sender=sender, eventType=eventType})
            --end)
        end
    end
    local btn_juewei = self._rightUIContainer:getChildByName("btn_juewei")
    btn_juewei:addTouchEventListener(btn_jueweiCallback)


    --活动
    local function btn_huodongCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("活动")
            --self:delayCallback(sender, 1, function ()
                -- dispatchGlobaleEvent("mainpage_popup_buttons2", "huodong_touched", {sender=sender, eventType=eventType})
                gameTcp:SendMessage(MSG_C2MS_START_QIANDAO)
                print("***********************************")
            --end)
            
        end
    end
    local btn_huodong = self._rightUIContainer:getChildByName("btn_huodong")
    btn_huodong:addTouchEventListener(btn_huodongCallback)

    --任务
    local function btn_renwuCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("任务")
            --self:delayCallback(sender, 1, function ()
                -- dispatchGlobaleEvent("mainpage_popup_buttons2", "renwu_touched", {sender=sender, eventType=eventType})
                gameTcp:SendMessage(MSG_C2MS_GET_MISSION_DATA)
            --end)
        end
    end
    local btn_renwu = self._rightUIContainer:getChildByName("btn_renwu")
    btn_renwu:addTouchEventListener(btn_renwuCallback)

    --好友
    local function btn_haoyouCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("好友")
            --self:delayCallback(sender, 1, function ()
                -- dispatchGlobaleEvent("mainpage_popup_buttons2", "haoyou_touched", {sender=sender, eventType=eventType})
                -- 好友验证数据
                gameTcp:SendMessage(MSG_C2MS_GET_APPLICANT_DATA)
            --end)

        end
    end
    local btn_haoyou = self._rightUIContainer:getChildByName("btn_haoyou")
    btn_haoyou:addTouchEventListener(btn_haoyouCallback)

    --邮件
    local function btn_youjianCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("邮件")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons2", "youjian_touched", {sender=sender, eventType=eventType})
            --end)

        end
    end
    local btn_youjian = self._rightUIContainer:getChildByName("btn_youjian")
    btn_youjian:addTouchEventListener(btn_youjianCallback)

    --设置
    local function btn_shezhiCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_runBtnAction("设置")
            --self:delayCallback(sender, 1, function ()
                dispatchGlobaleEvent("mainpage_popup_buttons1", "shezhi_touched", {sender=sender, eventType=eventType})
            --end)
        end
    end
    local btn_shezhi = self._rightUIContainer:getChildByName("btn_shezhi")
    btn_shezhi:addTouchEventListener(btn_shezhiCallback)

    --箭头按钮
    local function btn_arrowCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            if self._popupButtonsState == "pop" then
                self:_runAction_back()
                self._popupButtonsState = "back"
            else
                self:_runAction_pop()
                self._popupButtonsState = "pop"
            end
            
        end
    end
    local btn_arrow = self._rightUIContainer:getChildByName("btn_arrow")
    btn_arrow:addTouchEventListener(btn_arrowCallback)
end


--注册全局事件监听器
function controler_mainpage_functionbuttons_layer:_registGlobalEventListeners()

end


--移除全局事件监听器
function controler_mainpage_functionbuttons_layer:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end


function controler_mainpage_functionbuttons_layer:_runBtnAction(name)
    
    -- local UIContainer = self._UIContainer
    -- if name == "背包" then
    --     --背包
    --     local anim_beibao = UIContainer:getChildByName("anim_beibao")
    --     local action_baobei = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_beibao.csb")
    --     anim_beibao:runAction(action_baobei)
    --     action_baobei:play("animation0", false)

    -- elseif name == "武将" then 
    --     --武将
    --     local anim_wujiang = UIContainer:getChildByName("anim_wujiang")
    --     local action_wujiang = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_wujiang.csb")
    --     anim_wujiang:runAction(action_wujiang)
    --     action_wujiang:play("animation0", false)

    -- elseif name == "队伍" then 
    --     --队伍
    --     local anim_duiwu = UIContainer:getChildByName("anim_duiwu")
    --     local action_duiwu = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_duiwu.csb")
    --     anim_duiwu:runAction(action_duiwu)
    --     action_duiwu:play("animation0", false)

    -- elseif name == "军团" then 
    --     --军团
    --     local anim_juntuan = UIContainer:getChildByName("anim_juntuan")
    --     local action_juntuan = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_juntuan.csb")
    --     anim_juntuan:runAction(action_juntuan)
    --     action_juntuan:play("animation0", false)

    -- elseif name == "商店" then 
    --     --商店
    --     local anim_shangcheng = UIContainer:getChildByName("anim_shangcheng")
    --     local action_shangcheng = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_shangdian.csb")
    --     anim_shangcheng:runAction(action_shangcheng)
    --     action_shangcheng:play("animation0", false)

    -- elseif name == "奇遇" then 
    --     --奇遇
    --     local anim_qiyu = UIContainer:getChildByName("anim_qiyu")
    --     local action_qiyu = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_qiyu.csb")
    --     anim_qiyu:runAction(action_qiyu)
    --     action_qiyu:play("animation0", false)

    -- elseif name == "雇佣" then 
    --     --雇佣
    --     local anim_guyong = UIContainer:getChildByName("anim_guyong")
    --     local action_guyong = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_guyong.csb")
    --     anim_guyong:runAction(action_guyong)
    --     action_guyong:play("animation0", false)

    -- elseif name == "熔炼" then 
    --     --熔炼
    --     local anim_ronglian = UIContainer:getChildByName("anim_ronglian")
    --     local action_ronglian = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_ronglian.csb")
    --     anim_ronglian:runAction(action_ronglian)
    --     action_ronglian:play("animation0", false)

    -- elseif name == "福利" then 
    --     --福利
    --     local anim_fuli = self._rightUIContainer:getChildByName("anim_fuli")
    --     local action_fuli = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_fuli.csb")
    --     anim_fuli:runAction(action_fuli)
    --     action_fuli:play("animation0", false)

    -- elseif name == "活动" then 
    --     --活动
    --     local anim_huodong = self._rightUIContainer:getChildByName("anim_huodong")
    --     local action_huodong = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_huodong.csb")
    --     anim_huodong:runAction(action_huodong)
    --     action_huodong:play("animation0", false)

    -- elseif name == "任务" then 
    --     --任务
    --     local anim_renwu = self._rightUIContainer:getChildByName("anim_renwu")
    --     local action_renwu = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_renwu.csb")
    --     anim_renwu:runAction(action_renwu)
    --     action_renwu:play("animation0", false)

    -- elseif name == "好友" then 
    --     --好友
    --     local anim_haoyou = self._rightUIContainer:getChildByName("anim_haoyou")
    --     local action_haoyou = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_haoyou.csb")
    --     anim_haoyou:runAction(action_haoyou)
    --     action_haoyou:play("animation0", false)

    -- elseif name == "邮件" then 
    --     --邮件
    --     local anim_youjian = self._rightUIContainer:getChildByName("anim_youjian")
    --     local action_youjian = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_youjian.csb")
    --     anim_youjian:runAction(action_youjian)
    --     action_youjian:play("animation0", false)

    -- elseif name == "设置" then 
    --     --设置
    --     local anim_shezhi = self._rightUIContainer:getChildByName("anim_shezhi")
    --     local action_shezhi = cc.CSLoader:createTimeline("ui_instance/mainPage/anim/mainpage_anim_shezhi.csb")
    --     anim_shezhi:runAction(action_shezhi)
    --     action_shezhi:play("animation0", false)
    -- end

end

function controler_mainpage_functionbuttons_layer:_createTimeline()
    return cc.CSLoader:createTimeline("ui_instance/mainPage/mainpage_functionbuttons_layer.csb")
end


function controler_mainpage_functionbuttons_layer:_runAction_pop()
    self._rightUIContainer:stopAllActions()

    local action = self:_createTimeline()
    self._rightUIContainer:runAction(action)
    action:play("animation_open", false)

    self._rightUIContainer:getChildByName("btn_arrow_1"):setFlippedX(false)
end

function controler_mainpage_functionbuttons_layer:_runAction_back()
    self._rightUIContainer:stopAllActions()

    local action = self:_createTimeline()
    self._rightUIContainer:runAction(action)
    action:play("animation_close", false)

    self._rightUIContainer:getChildByName("btn_arrow_1"):setFlippedX(true)
end


function controler_mainpage_functionbuttons_layer:delayCallback( node, time, callback )
    local delay_1 = cc.DelayTime:create(time)
    local callfun = cc.CallFunc:create(function (  )
        callback()
    end)
    local action = cc.Sequence:create(delay_1,callfun)
    node:stopAllActions()
    node:runAction(action)
end

return controler_mainpage_functionbuttons_layer

