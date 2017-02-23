--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 通用提示条


local UI_Prompt_Bar = class("UI_Prompt_Bar", cc.load("mvc").ViewBase)

-- UI_Prompt_Bar.RESOURCE_FILENAME = "testlayer.csb"
function UI_Prompt_Bar:onCreate()


    local function onNodeEvent(event)
            if "enter" == event then
                print("onNodeEvent:","enter");
                
            elseif "exit" == event then
                print("onNodeEvent:","exit");
            elseif "enterTransitionFinish" == event then
                print("enterTransitionFinish:","enterTransitionFinish");
                
                self:openAnimationEffect(  );
            end
        end
    self:registerScriptHandler(onNodeEvent)
    
    -- self.eventLogic = require("app.views.prompt.event_logic").new(self);
end

--设置开场动画 和 
function UI_Prompt_Bar:openAnimationEffect(  )
    --开场动画
    self.rootnode = cc.CSLoader:createNode("ui_instance/prompt/prompt_Bar.csb") --testlayer
    self:addChild(self.rootnode , 1)
    local action = cc.CSLoader:createTimeline("ui_instance/prompt/prompt_Bar.csb")
    self.rootnode:runAction(action)
    action:gotoFrameAndPlay(0,false);

    --提示文字
    self.PromptText = self.rootnode:getChildByName("Text_1");

    --动画完成
    local function onFrameEvent(frame)
        
        if nil == frame then
            return
        end
        print(frame:getEvent())
        local str = frame:getEvent()
        if str == "Finish" then
           
            self:registerEvent(  );
        end
    end
    action:setFrameEventCallFunc(onFrameEvent)
    self:upDateShow();
end

function UI_Prompt_Bar:upDateShow(  )
    if self.ShowData.content then
        self.PromptText:setString(self.ShowData.content);
        self.PromptText:setVisible(true);
    end
    
end

--注册事件
function UI_Prompt_Bar:registerEvent(  )
    print("UI_Prompt_Bar:registerEvent ===================")
    --创建计时器
    self.scheduleClose = GLOBAL_SCHEDULER:scheduleScriptFunc(
        handler(self, self.registerScheduleListen),
        1, false
    )
end

function UI_Prompt_Bar:setData( params )
    self.ShowData = params or {};
    
end

function UI_Prompt_Bar:registerScheduleListen()
    GLOBAL_SCHEDULER:unscheduleScriptEntry(self.scheduleClose)
    self:removeFromParent();
end


return UI_Prompt_Bar


