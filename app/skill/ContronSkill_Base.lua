--
-- Author: Li Yang
-- Date: 2014-03-21 11:26:14
-- 技能控制基类

local ContronSkill_Base = class("ContronSkill_Base");

ContronSkill_Base.Type = nil

--技能数据
ContronSkill_Base.SkillCongfig = nil;

-- 释放者
ContronSkill_Base.releaseData = nil;

--目标角色
ContronSkill_Base.targetData = nil;

--[[伤害数据
    hurtType = 伤害方式
    hurtValuse = 伤害值
    dropgoods = 掉落物品
    boutCount = 1,持续回合数
    HPValuse = 10,-- 目标HP
]]
ContronSkill_Base.HurtConfig = {};


-- 技能攻击参数
ContronSkill_Base.AttackConfig = {};

-- 技能完成回调
ContronSkill_Base.FinishCallBack = nil;

-- 技能状态
ContronSkill_Base.state = nil;

ContronSkill_Base.CONST_STATE_NORMAL = "normal";-- 初始化

ContronSkill_Base.CONST_STATE_OPEN_STORY = "openstory";--开场剧情

ContronSkill_Base.CONST_STATE_SKILL_PROMPT = "skillprompt"; --技能提示

ContronSkill_Base.CONST_STATE_CASTING = "casting"; -- 施法

-- ContronSkill_Base.CONST_STATE_CASTING_OVER = "castingover"; -- 施法结束

ContronSkill_Base.CONST_STATE_OVER_STORY = "overstory";--结束剧情

ContronSkill_Base.CONST_STATE_ATTACKFINISH = "attackover"; -- 攻击完成完成

-- 定义事件
ContronSkill_Base.CHANGE_STATE_EVENT = "CHANGE_STATE_EVENT"
ContronSkill_Base.INIT_EVENT         = "INIT_EVENT"
ContronSkill_Base.EVENT_SKILL_PROMPT = "EVENT_SKILL_PROMPT"
ContronSkill_Base.EVENT_CASTING_EFFECT  = "EVENT_CASTING_EFFECT"
ContronSkill_Base.EVENT_OPEN_STORY  = "EVENT_OPEN_STORY"
ContronSkill_Base.EVENT_OVER_STORY  = "EVENT_OVER_STORY"
ContronSkill_Base.EVENT_ATTACK_FINISH  = "EVENT_ATTACK_FINISH"


function ContronSkill_Base:ctor()
    -- cc.GameObject.extend(self)
    -- cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	--绑定事件
    cc.bind(self, "EventProtocol")
    --绑定状态机
    cc.bind(self, "stateMachine")

    -- 设定状态机的默认事件
    local defaultEvents = {
        -- 初始化后
        {name = "initialize",  from = "none",    to = self.CONST_STATE_NORMAL },
        --开始剧情
        {name = "event_openstory",  from = self.CONST_STATE_NORMAL,    to = self.CONST_STATE_OPEN_STORY },
        --技能提示
        {name = "event_skillprompt",   from = {self.CONST_STATE_NORMAL,self.CONST_STATE_OPEN_STORY},    to = self.CONST_STATE_SKILL_PROMPT},
        -- 施法
        {name = "event_casting",   from = self.CONST_STATE_SKILL_PROMPT,    to = self.CONST_STATE_CASTING},
        --结束剧情
        {name = "event_overstory",  from = self.CONST_STATE_CASTING,    to = self.CONST_STATE_OVER_STORY },
        -- 技能攻击完成
        {name = "event_attackfinish",  from = "*",  to = self.CONST_STATE_ATTACKFINISH},
       
    }
    -- 设定状态机的默认回调
    local defaultCallbacks = {
        onchangestate = handler(self, self.onChangeState_),
        oninitialize  = handler(self, self.onInitialize_),
        onevent_openstory = handler(self, self.onOpenStory_),--开场剧情
        onevent_skillprompt = handler(self, self.onSkillPrompt_),
        onevent_casting        = handler(self, self.onCasting_),
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


function ContronSkill_Base:getId()
    return self;
end

function ContronSkill_Base:onChangeState_(event)
    -- printf("skill %s: state change from %s to %s", tostring(self:getId()), event.from, event.to)
    -- event = {name = self.CHANGE_STATE_EVENT, from = event.from, to = event.to}
    -- self:dispatchEvent(event)
end

-- 技能初始化
function ContronSkill_Base:onInitialize_(event)
    self:dispatchEvent({name = self.INIT_EVENT,data = event.args})
end

function ContronSkill_Base:onSkillPrompt_(event)
    self:dispatchEvent({name = self.EVENT_SKILL_PROMPT,data = event.args})
end

function ContronSkill_Base:onCasting_(event)
    self:dispatchEvent({name = self.EVENT_CASTING_EFFECT,data = event.args})
end

function ContronSkill_Base:onOpenStory_(event)
    self:dispatchEvent({name = self.EVENT_OPEN_STORY,data = event.args})
end

function ContronSkill_Base:onOverStory_(event)
    self:dispatchEvent({name = self.EVENT_OVER_STORY,data = event.args})
end

function ContronSkill_Base:onAttackfinish_(event)
    self:dispatchEvent({name = self.EVENT_ATTACK_FINISH,data = event.args})
end

return ContronSkill_Base;
