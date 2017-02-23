--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战役关卡


local UI_BattleResult = class("UI_BattleResult", cc.load("mvc").ViewBase)

UI_BattleResult.RESOURCE_FILENAME = "ui_instance/battlefield/battle_result.csb"
function UI_BattleResult:onCreate()
    self.shadowNode = self.resourceNode_:getChildByName("shadow_layout");
    --战役列表
    self.rootNode = self.resourceNode_:getChildByName("main_layout");

    -- self.InfoNode = self.rootNode:getChildByName("resultvaluse");

    -- --伤害值
    -- self.hurtValuse = self.InfoNode:getChildByName("hurtvaluse");

    -- --回合数
    -- self.boutValuse = self.InfoNode:getChildByName("boutvaluse");

    -- --将魂值
    -- self.gradeValuse = self.InfoNode:getChildByName("gradevaluse");
    -- --经验值
    -- self.expValuse = self.InfoNode:getChildByName("Slider_1");
    -- --掉落列表
    -- self.dropoutlist = self.InfoNode:getChildByName("diaoluo");
    -- --分数
    -- self.starLevel = self.rootNode:getChildByName("starlevel");

    -- --结果效果
    -- self.resulteffect = self.rootNode:getChildByName("resulteffect");


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
function UI_BattleResult:openAnimationEffect(  )
    
end

--注册事件
function UI_BattleResult:registerEvent(  )
    --退出事件
    local buttonexit = self.rootNode:getChildByName("exit")
    local function exitClicked(sender)
        -- self:exit()
        print("退出战斗")
        self:removeFromParent();
        -- control_Combat:doEvent("event_exit_battle");
    end
    buttonexit:addClickEventListener(exitClicked)

    --在站一次
    -- local buttonagain = self.rootNode:getChildByName("buttonagain")
    -- local function againClicked(sender)
    --     print("在战一次")
    -- end
    -- buttonagain:addClickEventListener(againClicked)

    -- --注册界面更新
    -- createGlobalEventListener( "zhanyilevel_ctrl", "refresh", handler(self, self.refreshView), 1 )
end

function UI_BattleResult:refreshView( event )
    --设置战斗结果显示
    -- local resulteffectinfo = "animation/zhandou/battleresult_1.ExportJson";
    -- if Data_Battle_Msg.ResultData.result == 0 then
    --     resulteffectinfo = "animation/zhandou/battleresult_0.ExportJson";
    -- end
    -- local resulteEffect = EffectManager:CreateArmature( {
    --         name = resulteffectinfo,
    --         x = 0 ,
    --         y = 0 ,
    --         zorder = 0,
    --         isfinishdestroy = false,
    --     } );
    -- print(resulteEffect,self.resulteffect)
    -- self.resulteffect:addChild(resulteEffect); --playWithNames
    -- resulteEffect:playAnimationByID( "Animation2" ,nil ,-1);

    -- --星级
    -- for i=1,3 do
    --     if Data_Battle_Msg.ResultData.score >= i then
    --         self.starLevel:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star1.png")
    --     else
    --         self.starLevel:getChildByName("star"..i):loadTexture("ui_image/zhanyi/heroitem_star2.png")
    --     end
    -- end

    -- --总伤害 
    -- self.hurtValuse:setString("总伤害:"..Data_Battle_Msg.ResultData.AttackSumHurt);
    -- --总回合数
    -- self.boutValuse:setString("回合数:"..Data_Battle_Msg.ResultData.boutCount.."/ 30");
    --等级
    
    --经验
end

function UI_BattleResult:exit()
    self:removeFromParent();
end

return UI_BattleResult


