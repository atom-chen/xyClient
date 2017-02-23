--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 注册


local UI_Register = class("UI_Register", cc.load("mvc").ViewBase)

-- UI_Register.RESOURCE_FILENAME = "testlayer.csb"
function UI_Register:onCreate()
    -- self:registerScriptHandler(
    -- 	handler(self, self.onNodeEvent)
    -- )
    local s = cc.Director:getInstance():getWinSize()
    local  layer1 = cc.LayerColor:create(cc.c4b(0, 0, 0, 128), s.width, s.height)
    layer1:setCascadeColorEnabled(false)
    layer1:setPosition( cc.p(0, 0))
    self:addChild(layer1, 0)

    local function onTouchBegan(touch, event)
        return true;
    end
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    -- listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    -- listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer1:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, layer1)

    self.rootnode = cc.CSLoader:createNode("ui_instance/login/registerview.csb") --testlayer
    self:addChild(self.rootnode , 1)

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
    
end

--设置开场动画 和 
function UI_Register:openAnimationEffect(  )
    --账户输入
    self.inputAccount = self.rootnode:getChildByName("TextField_1");
    --密码输入
    self.inputPassword = self.rootnode:getChildByName("TextField_1_0");

    --再次密码输入
    self.inputPasswordAgain = self.rootnode:getChildByName("TextField_1_1");

    self:registerEvent(  );
end

--注册事件
function UI_Register:registerEvent(  )
    --注册按钮
    self.button_login = self.rootnode:getChildByName("Button_1");
    local function clickevent_login( sender )
        -- print("loginass",self.inputAccount:getString())
        self:executeLogin();
    end
    self.button_login:addClickEventListener(clickevent_login);
    

    --取消按钮
    self.button_Register = self.rootnode:getChildByName("Button_2");
    local function clickevent_cancel( sender )
        -- print("loginass",self.inputAccount:getString())
        self:executeCancel();
    end
    self.button_Register:addClickEventListener(clickevent_cancel);
end

--[[
    执行登录
]]
function UI_Register:executeLogin()
    self.account = self.inputAccount:getString();
    self.Password = self.inputPassword:getString();
    self.PasswordAgain = self.inputPasswordAgain:getString();
    dispatchGlobaleEvent( "login" ,"event_registeraccount" ,{self.account,self.Password,self.PasswordAgain})
end

--[[
    执行取消
]]
function UI_Register:executeCancel()
    self:removeFromParent();
    dispatchGlobaleEvent( "login" ,"event_registercancel")
end




return UI_Register


