--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战役


local UI_zhanyi = class("UI_zhanyi", cc.load("mvc").ViewBase)

UI_zhanyi.RESOURCE_FILENAME = "ui_instance/zhanyi/ui_zhanyi.csb"
function UI_zhanyi:onCreate()

    --战役列表
    self.rootNode = self.resourceNode_:getChildByName("zhanyilist");
    --地图数据
    self.zhanyiMap = self.rootNode:getChildByName("zhanyimap");
    
    -- self.ccsfile_serverItem = "ui_instance/login/Layer_serverItem.csb"
    -- self.event_logic = require("app.views.gameWorld.zhanyi.zhanyi_event.lua").new(self);

    -- self.event_logic:event_invidata( nil );
    self:registerEvent(  );
end

--设置开场动画 和 
function UI_zhanyi:openAnimationEffect(  )
    
end

--注册事件
function UI_zhanyi:registerEvent(  )
    --注册退出事件
    local butten_exit = self.resourceNode_:getChildByName("exit"); 
    local function exitClicked(sender)
    	 dispatchGlobaleEvent( "zhanyi_ctrl" ,"exit" ,{sender = self})
    end
    butten_exit:addClickEventListener(exitClicked)
end




return UI_zhanyi


