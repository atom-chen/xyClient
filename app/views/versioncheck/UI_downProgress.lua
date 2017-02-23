--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 下载进度提示


local UI_downProgress = class("UI_downProgress", cc.load("mvc").ViewBase)

-- UI_downProgress.RESOURCE_FILENAME = "testlayer.csb"
function UI_downProgress:onCreate()

    -- local s = cc.Director:getInstance():getWinSize()
    -- local  layer1 = cc.LayerColor:create(cc.c4b(0, 0, 0, 128), s.width, s.height)
    -- layer1:setCascadeColorEnabled(false)
    -- layer1:setPosition( cc.p(-s.width /2 , -s.height / 2))
    -- self:addChild(layer1, 0)

    -- --关闭按键事件
    -- local function onTouchBegan(touch, event)
    --     if self.ShowData.islistenclick then
    --         dispatchGlobaleEvent( "prompt" ,"click" ,nil)
    --     end
    --     return false;
    -- end
    -- local listener1 = cc.EventListenerTouchOneByOne:create()
    -- listener1:setSwallowTouches(true)
    -- listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    -- local eventDispatcher = layer1:getEventDispatcher()
    -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, layer1)

    

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
function UI_downProgress:openAnimationEffect(  )
    --开场动画
    self.rootnode = cc.CSLoader:createNode("ui_instance/prompt/prompt_schedule.csb") --testlayer
    self:addChild(self.rootnode , 1)
    -- local action = cc.CSLoader:createTimeline("ui_instance/prompt/prompt_schedule.csb")
    -- self.rootnode:runAction(action)
    -- action:gotoFrameAndPlay(0,false);

    self.rootnode:setPositionY(-360 + 100);
    --进度节点
    self.progressNode = self.rootnode:getChildByName("loadschedule");
    self.progress = self.progressNode:getChildByName("LoadingBar_2");
    --提示文字
    self.PromptText = self.rootnode:getChildByName("Text_1");--loadstate
    self.PromptText:setVisible(true);

    --加载完成
    -- local function onNodeEvent(event)
    --         if "enter" == event then

    --         elseif "exit" == event then

    --         elseif "enterTransitionFinish" == event then
    --             self:upDateShow( self.ShowData.content );
    --             self:registerEvent(  );
    --             print("==================================")
    --         end
    --     end
    -- self.progressNode:registerScriptHandler(onNodeEvent)
    -- self:upDateShow();
end

function UI_downProgress:upDateShow( prompttest ,progress )

    if prompttest then
        self.PromptText:setString(prompttest)
    end

    if progress then
        self.progress:setPercent(progress);
    end
end

--注册事件
function UI_downProgress:registerEvent(  )
    if self.ShowData.eventlogic then
        self.eventLogic = require(self.ShowData.eventlogic).new(self);
        self.eventLogic:addExecuteEvent( self.ShowData.eventlist );
        self.eventLogic:register_event(  );
    end
end

--[[
   params = {
        mark = "",界面类型标示
        content = "",描述文字
        eventlogic = "",--绑定逻辑
        eventlist = "",注册事件列表
        islistenclick = ,--是否监听按键事件
        timer = ,--计时器
        fininshCallBack = nil;--完成回调函数
    }
]]
function UI_downProgress:setData( params )
    self.ShowData = params or {};
    if not self.ShowData.eventlogic then
        self.ShowData.eventlogic = "app.views.versioncheck.downEvent_logic.lua"
    end
    self.markType = self.ShowData.mark or "downprogress";
    self:registerEvent();
end





return UI_downProgress


