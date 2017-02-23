--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战役关卡


local UI_zhanyilevel = class("UI_zhanyilevel", cc.load("mvc").ViewBase)

UI_zhanyilevel.RESOURCE_FILENAME = "ui_instance/zhanyi/zhanyilevel.csb"
function UI_zhanyilevel:onCreate()

    --战役列表
    self.rootNode = self.resourceNode_:getChildByName("main_layout");

    self.mapNode = self.rootNode:getChildByName("node_map");

    --元宝值
    self.yuanbaoValuse = self.rootNode:getChildByName("yuanbao"):getChildByName("valuse");

    --金币值
    self.goldValuse = self.rootNode:getChildByName("gold"):getChildByName("valuse");

    --将魂值
    self.jianghunValuse = self.rootNode:getChildByName("jianghun"):getChildByName("valuse");

    self:refreshView();
    self:registerEvent();

    local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode();
    rootNode:setContentSize(size);
    ccui.Helper:doLayout(rootNode);
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360));

    local shadow_layout = rootNode:getChildByName("shadow_layout");
    shadow_layout:setContentSize(size);
    ccui.Helper:doLayout(shadow_layout);
end

--设置开场动画 和 
function UI_zhanyilevel:openAnimationEffect(  )
    
end

--注册事件
function UI_zhanyilevel:registerEvent(  )
    --退出事件
    local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
    local function exitClicked(sender)
        self:exit()
    end
    button:addClickEventListener(exitClicked)


    --注册界面更新
    createGlobalEventListener( "zhanyilevel_ctrl", "refresh", handler(self, self.refreshView), 1 )
end

function UI_zhanyilevel:refreshView( event )
    self.yuanbaoValuse:setString(MAIN_PLAYER:getBaseAttr()._yuanBao);
    self.goldValuse:setString(MAIN_PLAYER:getBaseAttr()._gold);
    self.jianghunValuse:setString(MAIN_PLAYER:getBaseAttr()._jianghun);
end

function UI_zhanyilevel:exit()
    self:removeFromParent();
end

return UI_zhanyilevel


