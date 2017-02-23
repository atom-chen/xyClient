--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战场切换逻辑


local controller_battlefieldCut = class("controller_battlefieldCut")

function controller_battlefieldCut:ctor()
    self.registerConfig = {
        --初始化数据
        {"battlefieldcut","create",1},--战场提示等待
        {"loadbattleres","loadbattleres_finish",1},--战场资源加载完成
    }
    self:register_event();

    --[[战场逻辑流程
        1.请求数据
        2.关闭当前战斗(包括销毁资源)
        3.初始化新战斗
        4.开始新的战斗
    ]]
end

--注册事件
function controller_battlefieldCut:register_event(  )
    local defaultCallbacks = {
        battlefieldcut_create = handler(self, self.register_event_create),
        loadbattleres_loadbattleres_finish = handler(self, self.register_event_loadbattleres_finish),
    }
    self.eventlisen = {};
    for i,v in ipairs(self.registerConfig) do
        local eventname = createGlobaleEventName( v[1], v[2] )
        print("注册事件",eventname);
        if defaultCallbacks[eventname] then
            createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
        end
    end
end

function controller_battlefieldCut:register_event_create( event )
    local params = event._usedata;
    self:battlefieldCutLogic( params );
end

--资源加载完成
function controller_battlefieldCut:register_event_loadbattleres_finish( event )
    self:CreateBattlefieldByType(  );
end

--[[战场切换逻辑
    params = {
        battledata = "",--战斗类型
    }
]]
function controller_battlefieldCut:battlefieldCutLogic( params )
    print("controller_battlefieldCut:setData")
    self.cutBattleData = params.battledata
    self.CurrentBattleType = Data_Battle.BattleType;
    local delayTime = 2;
    local isshow = true;
    --是否资源刷新
    self.IsResRefresh = false;
    --挂机系统
    if self.CurrentBattleType == Data_Battle.CONST_BATTLE_TYPE_ONHOOK then
        --[[
            1.直接显示结果界面
        ]]
        if self.cutBattleData.fightType == Data_Battle.CONST_BATTLE_TYPE_ONHOOK then
            delayTime = 1;
            -- return;
        else
            --战场类型切换(关闭挂机战场的执行)
            dispatchGlobaleEvent( "battlefield" ,"cut" ,{""});
            delayTime = 1;
        end
    else
        delayTime = 1;
    end
    --等待 时间
    local delay_1 = cc.DelayTime:create(delayTime);
    local callfun = cc.CallFunc:create(function (  )
        self:clearLastTimeBattlefield(  );
    end)
    APP:getCurScene():runAction(cc.Sequence:create(delay_1,callfun));
end

--清除上一次战斗 加载下一次战斗
function controller_battlefieldCut:clearLastTimeBattlefield(  )
    print("controller_battlefieldCut:clearLastTimeBattlefield")
    --清理战场
    control_Combat:doEvent("event_exit_battle")
    --创建加载等待界面(加载资源)
    ManagerBattle:createLoadBattleRes( self.cutBattleData );

    --进行加载资源
    -- dispatchGlobaleEvent( "loadbattleres" ,"loadbattleres_start",{self.cutBattleData})
    -- ManagerBattleRes:InitBattleUseRes( self.cutBattleData , 1);
    --进入游戏
    -- self:CreateBattlefieldByType(  );
    -- UIManager:CreateSamplePrompt("pppppppppppp")
end

--创建战场通过战斗类型
function controller_battlefieldCut:CreateBattlefieldByType(  )
    print("controller_battlefieldCut:CreateBattlefieldByType",self.cutBattleData.fightType)
    if self.cutBattleData.fightType == Data_Battle.CONST_BATTLE_TYPE_ONHOOK then
        --执行挂机数据
        dispatchGlobaleEvent( "onhook" ,"create");
    elseif self.cutBattleData.fightType == Data_Battle.CONST_BATTLE_TYPE_BOSS then
        --boss挑战类型
        --必须马上执行
        dispatchGlobaleEvent( "challengeboss" ,"initialize");
    elseif self.cutBattleData.fightType == Data_Battle.CONST_BATTLE_TYPE_test then
        dispatchGlobaleEvent( "testbattlefield" ,"create");
    elseif self.cutBattleData.fightType == Data_Battle.CONST_BATTLE_TYPE_QIYU then
        dispatchGlobaleEvent( "qiyu" ,"initialize");
    else
        --测试战场
    end
end


return controller_battlefieldCut


