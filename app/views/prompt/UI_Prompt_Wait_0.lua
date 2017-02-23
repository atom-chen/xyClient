--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 提示等待界面


local UI_Prompt_Wait_0 = class("UI_Prompt_Wait_0", cc.load("mvc").ViewBase)

UI_Prompt_Wait_0.RESOURCE_FILENAME = "ui_instance/prompt/prompt_ResumeConnect.csb"
function UI_Prompt_Wait_0:onCreate()
    -------------添加按键控制
    local s = cc.Director:getInstance():getWinSize()
    local  layer1 = cc.LayerColor:create(cc.c4b(0, 0, 0, 128), s.width, s.height)
    layer1:setCascadeColorEnabled(false)
    layer1:setPosition( cc.p(-s.width /2 , -s.height / 2))
    self:addChild(layer1, -1)

    --关闭按键事件
    local function onTouchBegan(touch, event)
        print("UI_Prompt_Wait_0 onTouchBegan",self.ShowData.event_click)
        if self.ShowData.event_click then
            --执行点击逻辑
            self.ShowData.event_click(self.markType);
        end
        return true;
    end
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer1:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, layer1)
    ----------------------得带控件
    --连接状态
    self.loadStateNode = self.resourceNode_:getChildByName("loadstate");
    --提示文字
    self.PromptText = self.loadStateNode:getChildByName("Text_1_0");--loadstate
    self.PromptText:setVisible(false);

    --连接状态
    self.errorStateNode = self.resourceNode_:getChildByName("errorstate");
    self.errorStateNode:setVisible(false);
    --错误提示文字
    self.errorText = self.errorStateNode:getChildByName("Text_1");

    --播放动画
    local function onNodeEvent(event)
        if "enter" == event then

        elseif "exit" == event then

        elseif "enterTransitionFinish" == event then
            self:openAnimationEffect(  );
        end
    end
    self:registerScriptHandler(onNodeEvent)
    
end

--设置开场动画 和 
function UI_Prompt_Wait_0:openAnimationEffect(  )
    --开场动画
    local action = cc.CSLoader:createTimeline("ui_instance/prompt/prompt_ResumeConnect.csb")
    self.resourceNode_:runAction(action)
    action:gotoFrameAndPlay(0,false);

    self.resourceNode_:setPositionY(-360 + 100);
    

    --动画完成
    local function onFrameEvent(frame)
        
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "Finish" then
           if self.ShowData.event_show then
               self.ShowData.event_show();
           end
        end
    end
    action:setFrameEventCallFunc(onFrameEvent)
end

function UI_Prompt_Wait_0:updateShow(  )
    if self.ShowData.content then
        self.PromptText:setString(self.ShowData.content);
        self.PromptText:setVisible(true);
    end
    print("self.ShowData.timer == >",self.ShowData.timer)
    if self.ShowData.timer then
        --创建计时器
       self.scheduleClose = GLOBAL_SCHEDULER:scheduleScriptFunc(
            handler(self, self.registerScheduleListen),
            self.ShowData.timer, false
        )
    end
end


--[[
params = {
        mark = "",界面类型标示 次为必填项 在全局关闭事件中 需要次参数
        content = "",描述文字
        event_click = "",点击逻辑事件监听
        event_timer = nil,计数器监听
        event_show = nil,等待界面展现完成监听
        timer = ,--计时器
        fininshCallBack = nil;--完成回调函数
    }
]]
function UI_Prompt_Wait_0:setData( params )
    self.ShowData = params or {};
    self.markType = self.ShowData.mark or "prompt";
    self:updateShow();
end

function UI_Prompt_Wait_0:ShowErrorInfo( params )
    self.loadStateNode:setVisible(false);
    self.errorStateNode:setVisible(true);
    self.errorText:setString(params);
end

function UI_Prompt_Wait_0:registerScheduleListen(  )
    GLOBAL_SCHEDULER:unscheduleScriptEntry(self.scheduleClose);
    -- dispatchGlobaleEvent( "prompt" ,"wait_timeout" ,{sender = self ,markType = self.markType})
    --执行超时逻辑
    if self.ShowData.event_timer then
        self.ShowData.event_timerc(self.markType);
    end
end

return UI_Prompt_Wait_0


