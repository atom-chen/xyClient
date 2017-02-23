--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 服务器选择列表


local UI_serverList = class("UI_serverList", cc.load("mvc").ViewBase)

-- UI_serverList.RESOURCE_FILENAME = "testlayer.csb"
function UI_serverList:onCreate()
    -- self:registerScriptHandler(
    -- 	handler(self, self.onNodeEvent)
    -- )
    local s = cc.Director:getInstance():getWinSize()
    local  layer1 = cc.LayerColor:create(cc.c4b(0, 0, 0, 128), s.width, s.height)
    layer1:setCascadeColorEnabled(false)
    layer1:setPosition( cc.p(0 ,0))
    self:addChild(layer1, 0)

    -- local screenSize = cc.Director:getInstance():getWinSize()
    -- layer1:setScaleY(screenSize.height / 720);

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

    self.rootnode = cc.CSLoader:createNode("ui_instance/login/layer_serverList.csb") --testlayer
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
    
    self.ccsfile_serverItem = "ui_instance/login/layer_serverItem.csb" --
    --login_serverItem
end

--设置开场动画 和 
function UI_serverList:openAnimationEffect(  )
    --得到服务器列表显示容器
    self.showList = self.rootnode:getChildByName("ScrollView_2");
    self.showList:setTouchEnabled(true)
    local innerWidth = self.showList:getContentSize().width
    local innerHeight = self.showList:getContentSize().height
    -- local InnerContainerSize_w = self.showList:getInnerContainerSize().width
    -- local InnerContainerSize_h = self.showList:getInnerContainerSize().height
    print("ScrollView_2",innerWidth,innerHeight)
    --setInnerContainerSize
    --添加对象
    local count = 1;
    local unit_w = innerWidth / 4;
    local unit_h = 60;
    local Container_h = 0;
    for i,v in ipairs(Data_Login.ServerList) do
        local item = self:CreateServerItem( v ,i);
        local item_w = item:getContentSize().width;
        local item_h = item:getContentSize().height
        local x = (i - 1) % 4 * unit_w + unit_w / 2 - item_w / 2;
        -- local y = innerHeight - math.modf((i - 1) / 4) * unit_h - unit_h / 2 + item_h / 2;
        local y = innerHeight - unit_h / 2 - item_h / 2 - math.modf((i - 1) / 4) * unit_h;
        Container_h = y + 30;
        item:setPosition(cc.p(x , y));
        self.showList:addChild(item);
        
        -- local button = ccui.Button:create()
        -- button:setTouchEnabled(true)
        -- button:loadTextures("animationbuttonnormal.png", "animationbuttonpressed.png", "")
        -- button:setPosition(cc.p(x, y))
        -- self.showList:addChild(button)
        --  print("=======",button:isSwallowTouches())
        -- local function clickevent( sender )
        --     print("clickevent",sender.logicId)
        -- end
        -- button:addClickEventListener(clickevent);
    end
    if Container_h < innerHeight then
        Container_h = innerHeight;
    end
    print("Container_h:",Container_h)
    self.showList:setInnerContainerSize(cc.size(innerWidth, Container_h))
    self.showList:jumpToBottom()
    
    --更新上次选择的服务器
    self.beforeChooseList = self.rootnode:getChildByName("shangci_choose");
    local beforename = nil;
end

--注册事件
function UI_serverList:registerEvent(  )
    -- body
end

--创建数据
function UI_serverList:CreateServerItem( itemData ,logicID)
    local serverItem = cc.CSLoader:createNode(self.ccsfile_serverItem)
    --注册按键事件
    local button = serverItem:getChildByName("Panel_1");
    button:setSwallowTouches(false)
    button.logicId = logicID;
    local function touchEvent(sender,eventType)
        print("local function touchEvent(sender,eventType)")
        if eventType == ccui.TouchEventType.began then
            sender.MarkIsMove = false;
            sender.Record_pos = sender:convertToWorldSpace(cc.p(0,0));
        elseif eventType == ccui.TouchEventType.moved then
            if not sender.MarkIsMove then
                local pos = sender:convertToWorldSpace(cc.p(0,0))
                if cc.pGetLength(cc.p(pos.x - sender.Record_pos.x,pos.y - sender.Record_pos.y)) > 5 then
                    sender.MarkIsMove = true;
                end
            end
            
            
        elseif eventType == ccui.TouchEventType.ended then
            if not sender.MarkIsMove then
                --执行选择服务器逻辑
                self:executeChooseServerLogic(sender.logicId);
            end
        elseif eventType == ccui.TouchEventType.canceled then
            -- self._displayValueLabel:setString("Touch Cancelled")
            -- print("Touch Cancelled")
        end
    end
    button:addTouchEventListener(touchEvent);
    --服务器名称
    local servername = button:getChildByName("name");
    servername:setTextColor(Data_Login:getServerStateColour(itemData.state));
    servername:setString(itemData.name);
    --服务器状态信息
    local serverstate = button:getChildByName("serverstate");
    serverstate:loadTexture("server_state_"..itemData.state..".png",ccui.TextureResType.plistType );
    return serverItem;
end

--设置服务器列表
function UI_serverList:executeChooseServerLogic(id)
    dispatchGlobaleEvent( "login" ,"event_chooseserver" ,id)
    self:removeFromParent();
end



return UI_serverList


