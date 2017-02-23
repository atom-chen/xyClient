--
-- Author: Li Yang
-- Date: 2014-03-21 11:26:14
-- 技能控制基类

local Skill_Base = class("Skill_Base");

Skill_Base.Type = nil

--技能数据
Skill_Base.SkillCongfig = nil;

-- 释放者
Skill_Base.releaseData = nil;

--目标角色
Skill_Base.targetData = nil;

--[[伤害数据
    hurtType = 伤害方式
    hurtValuse = 伤害值
    dropgoods = 掉落物品
    boutCount = 1,持续回合数
    HPValuse = 10,-- 目标HP
]]
Skill_Base.HurtConfig = {};


-- 技能攻击参数
Skill_Base.AttackConfig = {};

-- 技能完成回调
Skill_Base.FinishCallBack = nil;

-- 技能状态
Skill_Base.state = nil;

Skill_Base.CONST_STATE_NORMAL = "normal";-- 初始化

Skill_Base.CONST_STATE_BUF = "startbuf";

Skill_Base.CONST_STATE_OPEN_STORY = "openstory";--开场剧情

Skill_Base.CONST_STATE_SKILL_PROMPT = "skillprompt"; --技能提示

Skill_Base.CONST_STATE_CASTING = "casting"; -- 施法

Skill_Base.CONST_STATE_HURT = "hurt"; -- 伤害

-- Skill_Base.CONST_STATE_CASTING_OVER = "castingover"; -- 施法结束

Skill_Base.CONST_STATE_OVER_STORY = "overstory";--结束剧情

Skill_Base.CONST_STATE_ATTACKFINISH = "attackover"; -- 攻击完成完成

-- 定义事件
Skill_Base.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
Skill_Base.INIT_EVENT         = "INIT_EVENT"
Skill_Base.EVENT_STARTBUF     = "EVENT_STARTBUF"
Skill_Base.EVENT_SKILL_PROMPT = "EVENT_SKILL_PROMPT"
Skill_Base.EVENT_CASTING_EFFECT  = "EVENT_CASTING_EFFECT"
Skill_Base.EVENT_HURT = "EVENT_HURT";
Skill_Base.EVENT_OPEN_STORY  = "EVENT_OPEN_STORY"
Skill_Base.EVENT_OVER_STORY  = "EVENT_OVER_STORY"
Skill_Base.EVENT_ATTACK_FINISH  = "EVENT_ATTACK_FINISH"

--[[ 技能分类(通过效果表现)
    1.单体 ->单体
    2.单体 ->范围群攻(作用地为地图某个位置)
    3.单体 ->群体攻击(作用所有角色)
    4.特殊类(传递所有数据)
    5.
]]

function Skill_Base:ctor()
	--绑定事件
    cc.bind(self, "event")
    --绑定状态机
    cc.bind(self, "stateMachine")

    -- 设定状态机的默认事件
    local defaultEvents = {
        -- 初始化后
        {name = "initialize",  from = "none",    to = self.CONST_STATE_NORMAL },
        --执行buf事件
        {name = "event_buf",  from = self.CONST_STATE_NORMAL,    to = self.CONST_STATE_BUF },
        --开始剧情
        {name = "event_openstory",  from = self.CONST_STATE_BUF,    to = self.CONST_STATE_OPEN_STORY },
        --技能提示
        {name = "event_skillprompt",   from = {self.CONST_STATE_BUF,self.CONST_STATE_NORMAL,self.CONST_STATE_OPEN_STORY},    to = self.CONST_STATE_SKILL_PROMPT},
        -- 施法
        {name = "event_casting",   from = self.CONST_STATE_SKILL_PROMPT,    to = self.CONST_STATE_CASTING},
        -- 伤害逻辑处理
        {name = "event_hurt",   from = "*",    to = self.CONST_STATE_HURT},
        --结束剧情
        {name = "event_overstory",  from = self.CONST_STATE_CASTING,    to = self.CONST_STATE_OVER_STORY },
        -- 技能攻击完成
        {name = "event_attackfinish",  from = "*",  to = self.CONST_STATE_ATTACKFINISH},
    }
    -- 设定状态机的默认回调
    local defaultCallbacks = {
        oninitialize  = handler(self, self.onInitialize_),
        onevent_buf = handler(self, self.onStartBuf_),
        onevent_openstory = handler(self, self.onOpenStory_),--开场剧情
        onevent_skillprompt = handler(self, self.onSkillPrompt_),
        onevent_casting        = handler(self, self.onCasting_),
        onevent_hurt        = handler(self, self.onHurt_),
        onevent_overstory     = handler(self, self.onOverStory_),
        onevent_attackfinish   = handler(self, self.onAttackfinish_),
    }
    -- 如果继承类提供了其他回调，则合并
    -- table.merge(defaultCallbacks, totable(callbacks))

    self:setupState({
        events = defaultEvents,
        callbacks = defaultCallbacks
    })
    self:doEvent("initialize") ;
end


function Skill_Base:getId()
    return self;
end

-- 技能初始化
function Skill_Base:onInitialize_(event)
    self:dispatchEvent({name = self.INIT_EVENT,data = event.args})
end

function Skill_Base:onStartBuf_( event )
    self:dispatchEvent({name = self.EVENT_STARTBUF,data = event.args})
end

function Skill_Base:onSkillPrompt_(event)
    self:dispatchEvent({name = self.EVENT_SKILL_PROMPT,data = event.args})
end

function Skill_Base:onCasting_(event)
    self:dispatchEvent({name = self.EVENT_CASTING_EFFECT,data = event.args})
end

function Skill_Base:onHurt_( event )
    self:dispatchEvent({name = self.EVENT_HURT,data = event.args})
end

function Skill_Base:onOpenStory_(event)
    self:dispatchEvent({name = self.EVENT_OPEN_STORY,data = event.args})
end

function Skill_Base:onOverStory_(event)
    self:dispatchEvent({name = self.EVENT_OVER_STORY,data = event.args})
end

function Skill_Base:onAttackfinish_(event)
    self:dispatchEvent({name = self.EVENT_ATTACK_FINISH,data = event.args})
end

return Skill_Base;
