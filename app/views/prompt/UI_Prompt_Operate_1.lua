--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 通用提示操作界面


local UI_Prompt_Operate_1 = class("UI_Prompt_Operate_1", cc.load("mvc").ViewBase)

-- UI_Prompt_Operate_1.RESOURCE_FILENAME = "testlayer.csb"
function UI_Prompt_Operate_1:onCreate()

    local s = cc.Director:getInstance():getWinSize()
    local  layer1 = cc.LayerColor:create(cc.c4b(0, 0, 0, 128), s.width, s.height)
    layer1:setCascadeColorEnabled(false)
    layer1:setPosition( cc.p(-s.width /2 , -s.height / 2))
    self:addChild(layer1, 0)

    --关闭按键事件
    local function onTouchBegan(touch, event)
        if self.ShowData.islistenclick then
            dispatchGlobaleEvent( "prompt" ,"click" ,nil)
        end
        return false;
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

end

--设置开场动画 和 
function UI_Prompt_Operate_1:openAnimationEffect(  )
    --开场动画
    self.showView = cc.CSLoader:createNode("ui_instance/prompt/prompt_Operation_0.csb") --testlayer
    self:addChild(self.showView , 1)
    local action = cc.CSLoader:createTimeline("ui_instance/prompt/prompt_Operation_0.csb")
    self.showView:runAction(action)
    action:gotoFrameAndPlay(0,false);

    local s = cc.Director:getInstance():getWinSize()
    self.showView:setPosition( cc.p(-s.width /2 , -s.height / 2))

    self.shadowNode = self.showView:getChildByName("shadow_layout");
    self.rootNode = self.showView:getChildByName("main_layout");
    self.infoList = self.rootNode:getChildByName("infolist");
    --标题文字
    self.TitleText = self.rootNode:getChildByName("title");

    --提示文字
    self.PromptText = self.infoList:getChildByName("describe");

    --确定按键
    self.Button_Ok = self.infoList:getChildByName("ok");

    --取消按键
    self.Button_Cancel = self.infoList:getChildByName("cancel");
    
    self:upDateShow();
    self:registerEvent();

end

function UI_Prompt_Operate_1:upDateShow(  )
    if self.ShowData.title then
        self.TitleText:setString(self.ShowData.title);
        self.TitleText:setVisible(true);
    end
    if self.ShowData.content then
        self.PromptText:setString(self.ShowData.content);
        self.PromptText:setVisible(true);
    end
    --按键名称1改变
    if self.ShowData.buttonName1 then
        self.Button_Ok:setTitleText(self.ShowData.buttonName1);
    end
    --按键名称2改变
    if self.ShowData.buttonName2 then
        self.Button_Cancel:setTitleText(self.ShowData.buttonName2);
    end
end

--注册事件
function UI_Prompt_Operate_1:registerEvent(  )
    --按键1
    self.Button_Ok:addClickEventListener(function (  )
        self.ShowData.listenButton(1);
        self:removeFromParent();
    end);
    --按键2
    self.Button_Cancel:addClickEventListener(function (  )
        self.ShowData.listenButton(2);
        self:removeFromParent();
    end);

end

--[[
    params = {
        mark = "",界面类型标示
        title = "",标题
        content = "",描述文字
        eventlogic = "",--绑定逻辑
        eventlist = "",注册事件列表
        buttonName1 = "",--button名称
        buttonName2 = "",
        listenButton = nil;--完成回调函数
    }
]]
function UI_Prompt_Operate_1:setData( params )
    self.ShowData = params or {};
    self.markType = self.ShowData.mark or "promptopreate";
end


return UI_Prompt_Operate_1


