--
-- Author: LiYang
-- Date: 2015-07-08 11:12:28
-- 控制战斗数据执行

local control_combat = class("control_combat")


-- 战场状态值
control_combat.CONST_STATE_INVI = "CONST_STATE_INVI";   -- 初始化
control_combat.CONST_STATE_ENTRANCE = "CONST_STATE_ENTRANCE"; -- 入场
control_combat.CONST_STATE_OPEN_STORY = "CONST_STATE_OPEN_STORY"; --开场剧情
control_combat.CONST_STATE_ROUND_TIP = "CONST_STATE_ROUND_TIP"; -- 回合提示 -- round tip
control_combat.CONST_STATE_PREWAR_BUF = "CONST_STATE_PREWAR_BUF"; --执行战前buf 
control_combat.CONST_STATE_ROUND_ACTOR_EXCHANGE = "CONST_STATE_ROUND_ACTOR_EXCHANGE"; --角色互换
control_combat.CONST_STATE_ROUND_PREPARE = "CONST_STATE_ROUND_PREPARE"; --回合前准备状态
control_combat.CONST_STATE_ROUND_FINISH = "CONST_STATE_ROUND_FINISH"; --回合完成
control_combat.CONST_STATE_ATTACK_PREPARE = "CONST_STATE_ATTACK_PREPARE"; -- 攻击数据准备
control_combat.CONST_STATE_ATTACK_RUN = "CONST_STATE_ATTACK_RUN";  --攻击执行
control_combat.CONST_STATE_ATTACK_FINISH = "CONST_STATE_ATTACK_FINISH"; -- 攻击完成
control_combat.CONST_STATE_ATTACKRESULT_EFFECT = "CONST_STATE_ATTACKRESULT_EFFECT"; -- 攻击结果效果 
control_combat.CONST_STATE_ATTACKRESULT_SHOW = "CONST_STATE_ATTACKRESULT_SHOW"; -- 攻击结果显示 attackresult
control_combat.CONST_STATE_OVER_STORY = "CONST_STATE_OVER_STORY"; -- 结束剧情
control_combat.CONST_STATE_END = "CONST_STATE_END";--战斗执行完成
-- control_combat.CONST_STATE_PAUSE = "CONST_STATE_PAUSE";--暂停游戏

--注册的事件列表
control_combat.GlobaleEventList = {
    
}

function control_combat:ctor()
	--绑定状态机
	cc.bind(self, "stateMachine")

	self:setupState({
        initial = "none",
		events = {
			--初始化战场数据
            {name = "event_initialize", from = "none", to = self.CONST_STATE_INVI },
            --入场效果
            {name = "event_entrance", from = "*", to = self.CONST_STATE_ENTRANCE },
            --开始剧情
            {name = "event_open_story", from = self.CONST_STATE_ENTRANCE, to = self.CONST_STATE_OPEN_STORY},
            --回合提示
            {name = "event_round_tip", from = {self.CONST_STATE_ENTRANCE,self.CONST_STATE_OPEN_STORY}, to = self.CONST_STATE_ROUND_TIP},
            --执行战前buf
            {name = "event_prewar_buf", from = {self.CONST_STATE_ENTRANCE,self.CONST_STATE_OPEN_STORY}, to = self.CONST_STATE_PREWAR_BUF},
            --回合前buf执行
            {name = "event_round_prepare", from = {self.CONST_STATE_ROUND_TIP,self.CONST_STATE_ROUND_FINISH,self.CONST_STATE_PREWAR_BUF}, to = self.CONST_STATE_ROUND_PREPARE},
            --回合前角色交换
            {name = "event_round_actor_exchange", from = {self.CONST_STATE_ROUND_PREPARE}, to = self.CONST_STATE_ROUND_ACTOR_EXCHANGE},
            --回合执行完成
            {name = "event_round_finish", from = {self.CONST_STATE_ATTACK_FINISH,self.event_attack_prepare}, to = self.CONST_STATE_ROUND_FINISH},
            --攻击数据准备
            {name = "event_attack_prepare", from = {self.CONST_STATE_ROUND_ACTOR_EXCHANGE}, to = self.CONST_STATE_ATTACK_PREPARE},
            --攻击
            {name = "event_attack", from = {self.CONST_STATE_ATTACK_PREPARE,self.CONST_STATE_ATTACK_FINISH}, to = self.CONST_STATE_ATTACK_RUN},
            --攻击完成(回合攻击完成后 任何状态都能切入)
            {name = "event_attack_finish", from = "*", to = self.CONST_STATE_ATTACK_FINISH},
            --战斗结束
            {name = "event_fight_over", from = "*", to = self.CONST_STATE_END},
            --结束剧情
            {name = "event_over_story", from = self.CONST_STATE_END, to = self.CONST_STATE_OVER_STORY},
            --结果效果
            {name = "event_result_effect", from = {self.CONST_STATE_END ,self.CONST_STATE_OVER_STORY }, to = self.CONST_STATE_ATTACKRESULT_EFFECT},
            --结果信息显示
            {name = "event_result_info", from = self.CONST_STATE_ATTACKRESULT_EFFECT, to = self.CONST_STATE_ATTACKRESULT_SHOW},
            --暂停游戏
            -- {name = "event_pause", from = self.CONST_STATE_ATTACKRESULT_EFFECT, to = self.CONST_STATE_ATTACKRESULT_SHOW},
            {name = "event_exit_battle", from = "*", to = "none"},
		},
		callbacks = {
			onevent_initialize = handler(self, self.onEvent_initialize),
            onevent_entrance = handler(self, self.onEvent_entrance),
            onevent_open_story = handler(self, self.onEvent_open_story),
            onevent_round_tip = handler(self, self.onEvent_round_tip), 
            onevent_prewar_buf = handler(self, self.onEvent_prewar_buf),
            onevent_round_prepare = handler(self, self.onEvent_round_prepare),
            onevent_round_actor_exchange = handler(self, self.onEvent_round_actor_exchange),
            onevent_round_finish = handler(self, self.onEvent_round_finish),
            onevent_attack_prepare = handler(self, self.onEvent_attack_prepare),

            onevent_attack = handler(self, self.onEvent_attack),
            onevent_attack_finish = handler(self, self.onEvent_attack_finish),
            onevent_fight_over = handler(self, self.onEvent_fight_over),
            onevent_over_story = handler(self, self.onEvent_over_story),
            onevent_result_effect = handler(self, self.onEvent_result_effect),
            onevent_result_info = handler(self, self.onEvent_result_info),
            onevent_exit_battle = handler(self, self.onEvent_exit_battle),
		}
	});

    self.registerConfig = {
        {"controler_mainpage_zhanyi1_layer","zhanyi_touched",1},--观看挂机
        {"battlefield","create_boss",1},--创建boss 挑战战场
    }
    self:register_event(  );
	-- self:doEvent("event_initialize")
    self.actorPool = {};
    --执行的数据
    self.executeData = nil;
    --是否暂停状态
    self.IsPause = false;

    --当前战场信息
    self.CurrentCombatInfo = nil;
end

function control_combat:getInstance(  )
    if control_combat.instance == nil then
        control_combat.instance = control_combat.new()
    end
    return control_combat.instance
end

--注册事件
function control_combat:register_event(  )

    local defaultCallbacks = {
        controler_mainpage_zhanyi1_layer_zhanyi_touched = handler(self, self.register_event_watchonhook),
        battlefield_create_boss = handler(self, self.register_event_create_boss),
        battlefield_close = handler(self, self.register_event_close),
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


--初始化游戏
function control_combat:onEvent_initialize( event )
	--更新地图
    -- dispatchGlobaleEvent( "battleshowlayer" ,"event_createmap" ,Data_Battle.mapData.ShowMapID)
    --创建伤害提示管理逻辑
    -- if not self.HurtPromptManager then
    --     self.HurtPromptManager = require("app.effect.hurtprompt.HurtPromptManager").new();
    --     dispatchGlobaleEvent( "battleshowlayer" ,"event_addlogicbject" ,self.HurtPromptManager);
    -- end
    
    self.CurrentInning = 1;--当前局数
    self.CurrentBout = 1;--当前回合数
    self.CurrentBoutAction = 1;--当前回合行动
    self.IsPause = false;

    --得到当前执行的数据
    self.executeData = Data_Battle_Msg:getCurrentFightData();
    --更新战斗描述
    dispatchGlobaleEvent( "battlefieldui" ,"updata_info" , {self.executeData.describe});
    --创建角色
    local excData = Data_Battle_Msg:getCurrentFightData(  );
    --创建防守方英雄
    local defendcamp = excData.defendcamp[1];
    local FormationID = defendcamp.formation;--阵型Id
    local formationInfo = formationConfig[FormationID];--阵型信息
    if not formationInfo then
        printInfo("创建角色出错:阵型信息为nil,阵型ID：", FormationID);
    end
    local fishtList = defendcamp.FirstList;--开始角色位置
    for i,v in ipairs(fishtList) do
        -- local pos = formationInfo.Openpos[v.pos];
        local map_pos = BattlefieldFormationPosInfo.defendCamp[v.pos]
        local actor = ManagerActor:CreateActor( {
            map_x = map_pos[1],
            map_y = map_pos[2],
            camp = -1,
            formationid = FormationID,
            frompos = v.pos,
            mark = 100 + v.pos;
            templateid = v.actorID
            } );
        actor.mark = i;
        --执行初始化
        actor:doEvent("event_initialize");
        self.actorPool[actor] = actor;

        if not self.attack then
            self.attack = actor;
        end
    end
    --攻击方
    local attackcamp = excData.attackcamp[1];
    local FormationID = attackcamp.formation;--阵型Id
    local formationInfo = formationConfig[FormationID];--阵型信息
    if not formationInfo then
        printInfo("创建角色出错:阵型信息为nil,阵型ID：", FormationID);
    end
    local fishtList = attackcamp.FirstList;--开始角色位置
    for i,v in ipairs(fishtList) do
        -- local pos = formationInfo.Openpos[v.pos];
        local map_pos = BattlefieldFormationPosInfo.attckCamp[v.pos]
        local actor = ManagerActor:CreateActor( {
            map_x = map_pos[1],
            map_y = map_pos[2],
            camp = 1,
            formationid = FormationID,
            frompos = v.pos,
            mark = 200 + v.pos;
            templateid = v.actorID
            } );
        actor.mark = i;
        --执行初始化
        actor:doEvent("event_initialize");
        self.actorPool[actor] = actor;
    end

    --执行入场动作
    -- self:doEvent("event_entrance");
end

--入场
function control_combat:onEvent_entrance( event )
    --执行入场动作
    -- for k,v in pairs(self.actorPool) do
    --    v:doEvent("event_entrance");
    --    v.target_:setVisible(true);
    -- end
    EffectManager.CreateHeroEntranceEffect(function (  )
        print("control_combat:start onEvent_open_story")
        --开始开场剧情 
        --直接执行战斗数据
        self:doEvent("event_prewar_buf");
        --执行技能释放效果
        -- local effect = EffectManager.CreateEffect["testskill"]({
        --     name = "test",--技能名称
        --     release = self.attack,--释放者
        --     releaseCamp = 1, --释放者阵营
        --     aimCamp = -1, --目标阵营
        --     aimData = self.aimData,-- 目标
        --     hurtData = self.hurtdata,--目标伤害数据
        --     })
        -- effect:setFinishCallback( function (  )
        --     print("====>完成")
        -- end )
    end)
end

--开场剧情
function control_combat:onEvent_open_story( event )
    -- body
end

--执行战前buf
function control_combat:onEvent_prewar_buf( event )
    --角色血量更新
    print("event:onEvent_prewar_buf")
    --得到当前战斗数据
    self.CurrentInningData = Data_Battle_Msg:getCombatInningData( self.CurrentInning );
    --执行被动技能
    ManagerBattle:CreatePrewarExecuteLogic( self.CurrentInning ,function (  )
        --执行技能释放 
        self:doEvent("event_round_prepare");
    end)
end

--回合提示
function control_combat:onEvent_round_tip( event )
    -- body
end

--回合前执行逻辑
function control_combat:onEvent_round_prepare( event )
    print("event:onEvent_round_prepare")
    --更新回合数
    dispatchGlobaleEvent( "battlefieldui" ,"updata_bout",{self.CurrentBout});
    --得到当前回合数据
    self.CurrentBoutData = self.CurrentInningData.boutData[self.CurrentBout];
    --执行回合前buf
    ManagerBattle:CreateBoutBufExecuteLogic( self.CurrentInning ,self.CurrentBout ,function (  )
        --执行角色上城 
        self:doEvent("event_round_actor_exchange");
    end );
end

--回合前角色换阵
function control_combat:onEvent_round_actor_exchange( event )
    print("event:onEvent_round_actor_exchange")
    self:doEvent("event_attack_prepare");
end

--回合执行完成
function control_combat:onEvent_round_finish( event )

    self.CurrentBout = self.CurrentBout + 1;
    self.CurrentBoutData = self.CurrentInningData.boutData[self.CurrentBout];
    print("control_combat:onEvent_round_finish",self.CurrentBoutData)
    if not self.CurrentBoutData then
        self:doEvent("event_fight_over");
    else
        self:doEvent("event_round_prepare");
    end
end

--攻击前数据准备
function control_combat:onEvent_attack_prepare( event )
    print("event:onEvent_attack_prepare")
    --攻击前数据准备
    self.CurrentBoutAction = 1;--当前回合行动执行数
    self.CurrentBoutActionData = self.CurrentBoutData.actionData;
    self.BoutActionCount =  self.CurrentBoutData.actionCount; --回合行动总数
    
    self.CurrentExecuteActionData = self.CurrentBoutActionData[self.CurrentBoutAction];--当前执行的行动数据
    print(self.BoutActionCount,self.CurrentExecuteActionData)
    --资源加载
    
    --执行攻击
    self:doEvent("event_attack");
end

--攻击
function control_combat:onEvent_attack( event )
    print("event:onEvent_attack",self.CurrentBoutAction)
    if not self.CurrentExecuteActionData then
        self:doEvent("event_attack_finish");
        return;
    end
    -- 创建技能施法
    local skill = SkillManager:CreateSkill( {
        config = self.CurrentExecuteActionData,
        callback = function (  )
            if self:checkIsPause( self.CurrentInning , self.CurrentBout ,self.CurrentBoutAction ) or self.IsPause then
                print(self.PauseInfo_Inning,self.PauseInfo_Bout,self.PauseInfo_Act,self.IsPause)
            else
                self:doEvent("event_attack_finish");
            end
        end
    } )
end

--攻击完成
function control_combat:onEvent_attack_finish( event )
    print("event:onEvent_attack_finish")
    self.CurrentBoutAction = self.CurrentBoutAction + 1;
    self.CurrentExecuteActionData = self.CurrentBoutActionData[self.CurrentBoutAction];--当前执行的行动数据
    if not self.CurrentExecuteActionData then
        self:doEvent("event_round_finish");
    else
        self:doEvent("event_attack");
    end
end

--战斗完成
function control_combat:onEvent_fight_over( event )
   
    --得到战斗结果数据
    local resultData = self.executeData.ResultData;
    print("event:onEvent_fight_over",resultData,Data_Battle.BattleType)
    --播放结果Ui
    dispatchGlobaleEvent( "battlefield" ,"create_result" ,{Data_Battle.BattleType , resultData});
end

--战斗结束剧情
function control_combat:onEvent_over_story( event )
    -- body
end

--战斗结果效果
function control_combat:onEvent_result_effect( event )
    -- body
end

--战斗结果信息显示
function control_combat:onEvent_result_info( event )
    -- body
end

--退出战斗
function control_combat:onEvent_exit_battle( event )
    self.actorPool = {};
    --清空战场
    dispatchGlobaleEvent( "battlefield" ,"exit" );

    -- dispatchGlobaleEvent("controler_mainPage_ui_layer", "setUIVisible", {visibleType="showAll"})
    -- dispatchGlobaleEvent("controler_mainpage_top_layer", "setUIVisible", {visibleType="showAll"})
    -- dispatchGlobaleEvent("model_playerBaseAttr", "setUIVisible", {visibleType="showAll"})
    -- APP:toScene(SCENE_ID_GAMEWORLD) ; --
end

function control_combat:testlogic(  )
    for k,v in pairs(self.actorPool) do
        print(k,v,v:getState())
    end
end

------------------------------------------监听的事件函数-------------------------------------------------
--观看挂机事件
function control_combat:register_event_watchonhook( event )
    if self.IsPause then
        self.IsPause = false;
        self:doEvent("event_attack_finish");
    end
end


--[[创建boss战场
]]
function control_combat:register_event_create_boss( event )
    --创建战场
    -- Data_Battle:setBattlefieldType( Data_Battle.CONST_BATTLE_TYPE_BOSS );--设置战斗类型
    -- --更新执行数据
    -- Data_Battle_Msg:updateExecuteData();
    -- --创建boss挑战ui
    -- Control_BattleUI:CreateBattleUI_Boss(  );
    -- --清理战场
    -- self:doEvent("event_exit_battle");
    -- --战场切换效果
    -- dispatchGlobaleEvent( "battleshowlayer" ,"event_cut" ,{2});
    -- --执行数据
    -- control_combat:doEvent("event_initialize","testcjcj");
    -- local delay_1 = cc.DelayTime:create(1);
    -- local callfun = cc.CallFunc:create(function (  )
    --     control_combat:doEvent("event_entrance");
    -- end)
    -- self.HurtPromptManager:runAction(cc.Sequence:create(delay_1,callfun));
end

----------------------------------一些接口函数--------------------------------------

--[[得到角色
    camp 阵营
    pos 位置
]]
function control_combat:getActorByPos( pos ,camp )
    for k,v in pairs(self.actorPool) do
        if v.attribute_camp == camp and v.attribute_frompos == pos then
            return v;
        end
    end
    return nil;
end

--设置暂停参数
function control_combat:setPauseInfo( inning , bout ,act )
    self.PauseInfo_Inning = inning;
    self.PauseInfo_Bout = bout;
    self.PauseInfo_Act = act;
end

function control_combat:checkIsPause( inning , bout ,act )
    if self.PauseInfo_Inning == inning and self.PauseInfo_Bout == bout and self.PauseInfo_Act == act then
        self.IsPause = true;
        return true;
    end
    return false;
end

function control_combat:setPause( ispause )
    self.IsPause = ispause;
end

--检查战斗是否结束
function control_combat:checkBattleOver(  )
    if self:getState() == self.CONST_STATE_END then
        return true;
    end
    return false;
end

--回复执行
function control_combat:recoverExecute(  )
    self:doEvent("event_attack_finish");
end

--挂机逻辑
function control_combat:OnhookLogic_next(  )
    --展示状态值(0 隐藏状态 1 显示状态)
    self.ShowState = 0;
end



control_Combat = control_combat.getInstance( );

return control_combat;
