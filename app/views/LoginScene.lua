--
-- Author: lipeng
-- Date: 2015-06-11 15:45:49
-- 登陆场景


local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)

local _classloginaccount = require("app.views.loginview.UI_LoginAccount");

LoginScene.RESOURCE_FILENAME = "common_scene.csb"
function LoginScene:onCreate()
    cc.bind(self, "layerManager")
    
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
    self.resourceNode_:registerScriptHandler(onNodeEvent)

    self.eventLogic = require("app.views.loginview.login_event").new(self);

end


--开场动画效果
function LoginScene:openAnimationEffect(  )
    self.loginSceneView = cc.CSLoader:createNode("ui_instance/login/LoginScene.csb")
    self:addChildToLayer(LAYER_ID_UI, self.loginSceneView)
    -- self.resourceNode_:addChild(self.rootnode)
    self.loginSceneView:setPosition(cc.p(display.cx - 640 ,display.cy - 360))

    --开始游戏按钮
    local screenSize = cc.Director:getInstance():getWinSize()
    -- local rootSize = self.backNode_:getSize()
    print("screenSize:",screenSize.width,screenSize.height)
    self.rootnode = self.loginSceneView:getChildByName("main_layout");
    self.rootnode:setScaleY(screenSize.height / 720);
    -- local rootNode = self:getResourceNode();
    -- rootNode:setContentSize(screenSize);
    -- ccui.Helper:doLayout(rootNode);

    -- self.rootnode:setContentSize(screenSize);
    -- ccui.Helper:doLayout(self.rootnode);

    --背景
    self.node_back = self.rootnode:getChildByName("layer_back");

    --标题
    self.node_title = self.rootnode:getChildByName("login_title");
    self.node_title:getAnimation():play("Animation1",-1,0)

    local function animationEvent( armatureBack,movementType,movementID )
        local id = movementID
        if movementType == ccs.MovementEventType.loopComplete then

        elseif movementType == ccs.MovementEventType.complete then
            --执行背景显示
            -- self:execute_uishow();
        elseif movementType == ccs.MovementEventType.start then
            
        end
    end

    self.node_title:getAnimation():setMovementEventCallFunc(animationEvent) --finish

    local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
        print(bone,evt,originFrameIndex,currentFrameIndex)
        if evt == "finish" then
            self:execute_uishow();
            -- self:registerEvent();
        end
    end
    self.node_title:getAnimation():setFrameEventCallFunc(onFrameEvent)

    --新服务器展示
    self.node_NewServerShow = self.rootnode:getChildByName("node_newServer");
    local chooseserverNode = self.node_NewServerShow:getChildByName("newserverlist");
    self.chooserverList = chooseserverNode:getChildByName("Panel_choose_1_3");


    --登录按钮
    self.node_ButtonStartGame = self.rootnode:getChildByName("node_startButton");

    ----标题armature
    -- self.node_title_artitle = self.node_title:getChildByName("ArmatureNode_title");

    --开场动画
    -- self.armaturenode_start = self.rootnode:getChildByName("ArmatureNode_start");
    -- self.armaturenode_start:getAnimation():play("Animation1",-1,0)

    -- local function animationEvent(armatureBack,movementType,movementID)
    --     local id = movementID
    --     print(armatureBack,movementType,movementID,ccs.MovementEventType.loopComplete)
    --     if movementType == ccs.MovementEventType.loopComplete then
    --         print("ccs.MovementEventType.loopComplete");
    --     elseif movementType == ccs.MovementEventType.complete then
    --         print("ccs.MovementEventType.complete");
    --         self.armaturenode_start:removeFromParent();
    --         release_ccs_animation("ui_image/logineffect_0/logineffect_0.ExportJson")
    --     elseif movementType == ccs.MovementEventType.start then
    --         print("ccs.MovementEventType.start");
    --     end
    -- end
    -- self.armaturenode_start:getAnimation():setMovementEventCallFunc(animationEvent)

    -- local function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
    --     if evt == "nextevent" then
    --         self:execute_uishow();
    --         self:registerEvent();
    --     end
    -- end
    -- self.armaturenode_start:getAnimation():setFrameEventCallFunc(onFrameEvent)


end

function LoginScene:registerEvent(  )
    
    --新服务器展示列表 
    local startgame_button = self.node_ButtonStartGame:getChildByName("Panel_loginbutton");
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            -- self._displayValueLabel:setString("Touch Down")
            print("Touch Down")
            sender:setScale(1.1);
        elseif eventType == ccui.TouchEventType.moved then
            -- self._displayValueLabel:setString("Touch Move")
            print("Touch Move")
        elseif eventType == ccui.TouchEventType.ended then
            -- self._displayValueLabel:setString("Touch Up")
            print("Touch Up")
            sender:setScale(1);
            -- TounchContrlScheduler(10);
            --发送事件
            -- local eventDispatcher = self:getEventDispatcher()
            -- local event = cc.EventCustom:new("prompt_wait_close")
            -- event._usedata = string.format("%d",10)
            -- eventDispatcher:dispatchEvent(event)
            dispatchGlobaleEvent( "login" ,"event_start" ,nil)
        elseif eventType == ccui.TouchEventType.canceled then
            -- self._displayValueLabel:setString("Touch Cancelled")
            print("Touch Cancelled")
        end
    end

    startgame_button:addTouchEventListener(touchEvent);
    -- startgame_button:setPressedActionEnabled(true);

    local NewServerList= self.node_NewServerShow:getChildByName("newserverlist");
    local function clickevent( sender )
        print("clickevent")
        self:execute_ServerShow(  );
    end
    NewServerList:addClickEventListener(clickevent);

    --登录账户按钮
    self.loginass = self.rootnode:getChildByName("loginass");
    local function clickevent_1( sender )
        print("loginass")
        dispatchGlobaleEvent( "login" ,"event_createloginview" ,nil)
    end
    self.loginass:addClickEventListener(clickevent_1);


    self.eventLogic:register_event();
    dispatchGlobaleEvent( "login" ,"event_invidata" ,nil)
end

--执行UI显示
function LoginScene:execute_uishow(  )
    --执行背景显示
    local action = cc.CSLoader:createTimeline("ui_instance/login/layer_login_back.csb")
    self.node_back:runAction(action)
    action:gotoFrameAndPlay(0,false);

    local function onFrameEvent(frame)
        
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "Finish" then
            --新服务器展示
            action = cc.CSLoader:createTimeline("ui_instance/login/Node_newserverFrame.csb")
            self.node_NewServerShow:runAction(action)
            action:gotoFrameAndPlay(0,false);

            --按钮显示
            action = cc.CSLoader:createTimeline("ui_instance/login/Node_startgameButton.csb")
            self.node_ButtonStartGame:runAction(action)
            action:gotoFrameAndPlay(0,false);
            self:registerEvent();
        end
    end
    action:setFrameEventCallFunc(onFrameEvent)

    -- --新服务器展示
    -- action = cc.CSLoader:createTimeline("ui_instance/login/Node_newserverFrame.csb")
    -- self.node_NewServerShow:runAction(action)
    -- action:gotoFrameAndPlay(0,false);

    -- --按钮显示
    -- action = cc.CSLoader:createTimeline("ui_instance/login/Node_startgameButton.csb")
    -- self.node_ButtonStartGame:runAction(action)
    -- action:gotoFrameAndPlay(0,false);

    --初始化数据
    self:execute_UpdateChooseServer();
end

--执行服务器列表显示
function LoginScene:execute_ServerShow(  )
    -- self.rootnode_server = cc.CSLoader:createNode("layer_serverList.csb")
    self.rootnode_server = require("app.views.loginview.UI_serverList").new();
    self:addChildToLayer(LAYER_ID_POPUP, self.rootnode_server)
    self.rootnode_server:setPosition(cc.p(display.cx - 640,display.cy - 360))
end

function LoginScene:execute_LoginAccountShow(  ) 
    self.rootnode_loginaccount =_classloginaccount.new();
    self:addChildToLayer(LAYER_ID_POPUP, self.rootnode_loginaccount)
    self.rootnode_loginaccount:setPosition(cc.p(display.cx - 640,display.cy - 360))
end

--执行更新选择的服务器
function LoginScene:execute_UpdateChooseServer()
    local namenode = self.chooserverList:getChildByName("bf_name_2");
    local statenode = self.chooserverList:getChildByName("bf_state_2");
    local showData = Data_Login:getChooseServerDescribe();
    print("====================================",showData.state)
    statenode:loadTexture("server_state_"..showData.state..".png",ccui.TextureResType.plistType );
    namenode:setTextColor(Data_Login:getServerStateColour(showData.state));
    namenode:setString(showData.name);
end

--释放逻辑
function LoginScene:releaselogic(  )
    --释放使用资源
    release_textureAndplist("ui_image/login.jpg",nil);
    release_textureAndplist("ui_image/login_res_0.png","ui_image/login_res_0.plist");
    release_ccs_animation("ui_image/ui_effect/effect_login_title.plist")
    release_ccs_animation("ui_image/ui_effect/logineffect_button.plist")
end



return LoginScene

