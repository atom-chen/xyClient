--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 初始化英雄


local UI_InviHero = class("UI_InviHero", cc.load("mvc").ViewBase)

local hero_item = require("app.views.inithero.UI_hero_item");

UI_InviHero.RESOURCE_FILENAME = "ui_instance/login/choose_initialrole.csb"

function UI_InviHero:onCreate()
    -- self.shadowNode = self.resourceNode_:getChildByName("shadow_layout");
    --战役列表
    self.rootNode = self.resourceNode_:getChildByName("main_layout");
    --结果效果 
    self.button_ok = self.rootNode:getChildByName("ok");

    self.namedes = self.rootNode:getChildByName("nameinfo"):getChildByName("name");
    --英雄节点
    self.heroNode = self.rootNode:getChildByName("heronode");

    -- self:refreshView();
    self:registerEvent();

    local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode();
    rootNode:setContentSize(size);
    -- ccui.Helper:doLayout(rootNode);
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360));

    -- local shadow_layout = rootNode:getChildByName("shadow_layout");
    -- shadow_layout:setContentSize(size);
    -- ccui.Helper:doLayout(shadow_layout);
end

--设置开场动画 和 
function UI_InviHero:openAnimationEffect(  )
    
end

--注册事件
function UI_InviHero:registerEvent(  )
    --退出事件
    local buttonok = self.rootNode:getChildByName("ok")
    local function okClicked(sender)
        --确定事件
        print("确定事件")
        dispatchGlobaleEvent( "models_inithero" ,"queding",{self.namedes:getString()});
    end
    buttonok:addClickEventListener(okClicked)

    --请求名字消息
    local request_b =  self.rootNode:getChildByName("nameinfo"):getChildByName("b_request")
    local function requestClicked(sender)
        dispatchGlobaleEvent( "models_inithero" ,"random_name");
    end
    request_b:addClickEventListener(requestClicked)

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
    -- self.namedes:addEventListener(textFieldEvent);
end

--[[初始化英雄列表
]]
function UI_InviHero:InviHeroList(  )
    --添加数据
    -- local x = hero_item.new();
    self.invipos_x = -450;
    for i,v in ipairs(heroShowInitialize) do
        local view = hero_item.new();
        view:setPosition(cc.p(self.invipos_x + (i - 1) * 300 - 128 ,0));
        view:setData(v);
        self.heroNode:addChild(view)
        if not self.chooseMarkView then
            self.chooseMarkView = view;
            self.chooseMarkView:setChooseDisplay( true );
        end
    end
end

function UI_InviHero:updata_choose( view )
    view:setChooseDisplay(true);
    self.chooseMarkView:setChooseDisplay(false);
    self.chooseMarkView = view;
end

function UI_InviHero:updata_name( name )
    self.namedes:setString(name);
end

function UI_InviHero:exit()
    self:removeFromParent();
end

return UI_InviHero


