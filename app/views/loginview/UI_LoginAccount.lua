--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 登录账户


local UI_LoginAccount = class("UI_LoginAccount", cc.load("mvc").ViewBase)

-- UI_LoginAccount.RESOURCE_FILENAME = "testlayer.csb"
function UI_LoginAccount:onCreate()
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

    self.rootnode = cc.CSLoader:createNode("ui_instance/login/loginview.csb") --testlayer
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
function UI_LoginAccount:openAnimationEffect(  )
    --账户输入
    self.inputAccount = self.rootnode:getChildByName("TextField_1");
    -- local function textFieldEvent(sender, eventType)
    --     if eventType == ccui.TextFiledEventType.attach_with_ime then
    --         print("attach with IME")
    --     elseif eventType == ccui.TextFiledEventType.detach_with_ime then
    --         print("detach with IME")
    --     elseif eventType == ccui.TextFiledEventType.insert_text then
    --         print("insert words")
    --     elseif eventType == ccui.TextFiledEventType.delete_backward then
    --         print("delete word")
    --     end
    -- end
    -- self.inputAccount:addEventListener(textFieldEvent);
    --密码输入
    self.inputPassword = self.rootnode:getChildByName("TextField_1_0");

    self:registerEvent();
    
end

--注册事件
function UI_LoginAccount:registerEvent(  )
    --登录按钮
    self.button_login = self.rootnode:getChildByName("Button_1");
    local function clickevent_login( sender )
        print("loginass",self.inputAccount:getString())
        self:executeLogin();
    end
    self.button_login:addClickEventListener(clickevent_login);
    

    --注册按钮
    self.button_Register = self.rootnode:getChildByName("Button_2");
    local function clickevent_Register( sender )
       self:executeRegister();
    end
    self.button_Register:addClickEventListener(clickevent_Register);
end

--[[
    执行登录
]]
function UI_LoginAccount:executeLogin()
    self.account = self.inputAccount:getString();
    self.Password = self.inputPassword:getString();
    print(self.account,self.Password)
    dispatchGlobaleEvent( "login" ,"event_loginAccount" ,{self.account,self.Password})
    print("self.account,self.Password")
end

--[[
    开启注册
]]
function UI_LoginAccount:executeRegister()
    --创建注册界面
    self:removeFromParent();
    dispatchGlobaleEvent( "login" ,"event_createregister" ,{target = self} )
end




return UI_LoginAccount


