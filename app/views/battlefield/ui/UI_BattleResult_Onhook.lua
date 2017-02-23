--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 挂机战斗结果


local UI_BattleResult_Onhook = class("UI_BattleResult_Onhook", cc.load("mvc").ViewBase)

UI_BattleResult_Onhook.RESOURCE_FILENAME = "ui_instance/battlefield/battle_result_onhook.csb"
function UI_BattleResult_Onhook:onCreate()
    self.shadowNode = self.resourceNode_:getChildByName("shadow_layout");
    --战役列表
    self.rootNode = self.resourceNode_:getChildByName("main_layout");

    self.resultNode = self.rootNode:getChildByName("effectnode");

    --结果效果 
    self.resulteffect = self.rootNode:getChildByName("resulteffect");

    -- self.boutValuse = self.resulteffect:getChildByName("Text_1_1_0");

    --下一场战斗提示
    self.nextprompt =  self.resulteffect:getChildByName("Text_1");

    self.node_timer = self.resulteffect:getChildByName("timer");


    -- self:refreshView();
    -- self:registerEvent();

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
function UI_BattleResult_Onhook:openAnimationEffect(  )
    
end

--注册事件
function UI_BattleResult_Onhook:registerEvent(  )
    --退出事件
    -- local buttonexit = self.rootNode:getChildByName("exit")
    -- local function exitClicked(sender)
    --     -- self:exit()
    --     print("退出战斗")
        
    --     control_Combat:doEvent("event_exit_battle");
    -- end
    -- buttonexit:addClickEventListener(exitClicked)

    --在站一次
    -- local buttonagain = self.rootNode:getChildByName("buttonagain")
    -- local function againClicked(sender)
    --     print("在战一次")
    -- end
    -- buttonagain:addClickEventListener(againClicked)

    -- --注册界面更新
    -- createGlobalEventListener( "zhanyilevel_ctrl", "refresh", handler(self, self.refreshView), 1 )
end

--[[
    data = {
        boutCount = 18, --回合数
        nextprompt = "", --下一场战斗提示
        countdown = 10,--倒计时
    }
]]
function UI_BattleResult_Onhook:refreshView( data )
    -- self.boutValuse:setString(data.boutCount.."/"..data.sumBout);
    self.nextprompt:setString(data.nextprompt);
    --创建倒计时

    if data.countdown then
        self.timeNode = EffectManager.CreatePiece_Timer( data.countdown );
        self.node_timer:addChild(self.timeNode,10);
        self.timeNode:setFinishCallback( function (  )
            print("倒计时完成 挂机执行完成一个");
            dispatchGlobaleEvent( "onhook" ,"executeover");
            -- control_Combat:doEvent("event_exit_battle");
        end );
    end

    --结果 self.resultNode
    local resultInfo = "ui_instance/battlefield/battleresult_win.csb"
    if data.result == 0 then
        resultInfo = "ui_instance/battlefield/battleresult_lose.csb"
    end
    local effect = cc.CSLoader:createNode(resultInfo);

    self.resultNode:addChild(effect);
end

function UI_BattleResult_Onhook:exit()
    self:removeFromParent();
end

return UI_BattleResult_Onhook


