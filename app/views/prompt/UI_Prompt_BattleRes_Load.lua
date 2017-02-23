--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战场资源加载


local UI_Prompt_BattleRes_Load = class("UI_Prompt_BattleRes_Load", cc.load("mvc").ViewBase)

UI_Prompt_BattleRes_Load.RESOURCE_FILENAME = "ui_instance/prompt/prompt_wait.csb"
function UI_Prompt_BattleRes_Load:onCreate()
    self.rootNode = self.resourceNode_:getChildByName("main_layout");
    --连接状态
    self.loadStateNode = self.rootNode:getChildByName("loadstate");
    --提示文字
    self.PromptText = self.loadStateNode:getChildByName("Text_1_0");
    self.PromptText:setVisible(false);

    --连接状态
    self.errorStateNode = self.rootNode:getChildByName("errorstate");
    self.errorStateNode:setVisible(false);
    --错误提示文字
    self.errorText = self.errorStateNode:getChildByName("Text_1");
    
    -- self.eventLogic = require("app.views.prompt.event_logic").new(self);
end

function UI_Prompt_BattleRes_Load:upDateShow(  )
    if self.ShowData.content then
        self.PromptText:setString(self.ShowData.content);
        self.PromptText:setVisible(true);
    end
    
end

--注册事件
function UI_Prompt_BattleRes_Load:registerEvent(  )
    
end

function UI_Prompt_BattleRes_Load:setData( params )
    self.ShowData = params or {};
    if not self.ShowData.eventlogic then
        self.ShowData.eventlogic = "app.views.prompt.PromptEvent_logic.lua"
    end
    self.markType = self.ShowData.mark or "prompt";

    self:upDateShow(  );
    self:registerEvent();
end

function UI_Prompt_BattleRes_Load:ShowErrorInfo( params )
    self.loadStateNode:setVisible(false);
    self.errorStateNode:setVisible(true);
    self.errorText:setString(params);
end




return UI_Prompt_BattleRes_Load


