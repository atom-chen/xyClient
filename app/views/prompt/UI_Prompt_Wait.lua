--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 提示等待界面


local UI_Prompt_Wait = class("UI_Prompt_Wait", cc.load("mvc").ViewBase)

-- UI_Prompt_Wait.RESOURCE_FILENAME = "testlayer.csb"
function UI_Prompt_Wait:onCreate()
    -- self:registerScriptHandler(
    -- 	handler(self, self.onNodeEvent)
    -- )
    local s = cc.Director:getInstance():getWinSize()
    local  layer1 = cc.LayerColor:create(cc.c4b(0, 0, 0, 128), s.width, s.height)
    layer1:setCascadeColorEnabled(false)
    layer1:setPosition( cc.p(-s.width /2 , -s.height / 2))
    self:addChild(layer1, 0)

    --关闭按键事件
    local function onTouchBegan(touch, event)
        if self.ShowData.islistenclick then
            -- dispatchGlobaleEvent( "prompt" ,"click" ,{sender = self})
            --执行点击逻辑
            if self.eventLogic and self.eventLogic.click_logic then
                self.eventLogic:click_logic(self.markType);
            end
        end
        return true;
    end
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer1:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, layer1)

    

    local function onNodeEvent(event)
            if "enter" == event then

            elseif "exit" == event then

            elseif "enterTransitionFinish" == event then
                print("enterTransitionFinish:","enterTransitionFinish");
                self:openAnimationEffect(  );
            end
        end
    self:registerScriptHandler(onNodeEvent)
    
    -- self.eventLogic = require("app.views.prompt.event_logic").new(self);
end

--设置开场动画 和 
function UI_Prompt_Wait:openAnimationEffect(  )
    --开场动画
    self.rootnode = cc.CSLoader:createNode("ui_instance/prompt/prompt_ResumeConnect.csb") --testlayer
    self:addChild(self.rootnode , 1)
    local action = cc.CSLoader:createTimeline("ui_instance/prompt/prompt_ResumeConnect.csb")
    self.rootnode:runAction(action)
    action:gotoFrameAndPlay(0,false);

    self.rootnode:setPositionY(-360 + 100);
    --连接状态
    self.loadStateNode = self.rootnode:getChildByName("loadstate");
    --提示文字
    self.PromptText = self.loadStateNode:getChildByName("Text_1_0");--loadstate
    self.PromptText:setVisible(false);

    --连接状态
    self.errorStateNode = self.rootnode:getChildByName("errorstate");
    self.errorStateNode:setVisible(false);
    --错误提示文字
    self.errorText = self.errorStateNode:getChildByName("Text_1");--errorstate
    -- self.errorText:setVisible(false);

    --动画完成
    local function onFrameEvent(frame)
        
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "Finish" then
            self:upDateShow();
            -- self:registerEvent();
        end
    end
    action:setFrameEventCallFunc(onFrameEvent)
end

function UI_Prompt_Wait:upDateShow(  )
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

--注册事件
function UI_Prompt_Wait:registerEvent(  )
    if self.ShowData.eventlogic then
        self.eventLogic = require(self.ShowData.eventlogic).new(self ,self.markType);
        self.eventLogic:addExecuteEvent( self.ShowData.eventlist );
        self.eventLogic:register_event(  );
    end
end

function UI_Prompt_Wait:setData( params )
    self.ShowData = params or {};
    if not self.ShowData.eventlogic then
        self.ShowData.eventlogic = "app.views.prompt.PromptEvent_logic.lua"
    end
    self.markType = self.ShowData.mark or "prompt";
    self:registerEvent();
end

function UI_Prompt_Wait:ShowErrorInfo( params )
    self.loadStateNode:setVisible(false);
    self.errorStateNode:setVisible(true);
    self.errorText:setString(params);
end

function UI_Prompt_Wait:registerScheduleListen(  )
    GLOBAL_SCHEDULER:unscheduleScriptEntry(self.scheduleClose);
    -- dispatchGlobaleEvent( "prompt" ,"wait_timeout" ,{sender = self ,markType = self.markType})
    --执行超时逻辑
    if self.eventLogic and self.eventLogic.wait_timeout_logic then
        self.eventLogic:wait_timeout_logic(self.markType);
    end
end




return UI_Prompt_Wait


