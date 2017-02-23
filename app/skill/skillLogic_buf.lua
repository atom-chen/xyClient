--
-- Author: Li Yang
-- Date: 2014-05-26 09:29:49
-- 技能 执行buf逻辑
local skillbase = import(".Skill_Base")

local SkillLogic_buf = class("SkillLogic_buf", skillbase);


function SkillLogic_buf:ctor()
	SkillLogic_buf.super.ctor(self)
	--初始化
	self:addEventListener(self.INIT_EVENT, handler(self, self.Initialize));
	self:addEventListener(self.EVENT_STARTBUF, handler(self, self.ExecuteStartBuf));
	-- self:addEventListener(self.EVENT_OPEN_STORY, handler(self, self.Create_OpenStory));
	self:addEventListener(self.EVENT_SKILL_PROMPT, handler(self, self.CreateSkillPrompt));
	self:addEventListener(self.EVENT_CASTING_EFFECT, handler(self, self.CreateSkillEffect));
	self:addEventListener(self.EVENT_HURT, handler(self, self.CreateSkillHurt));
	self:addEventListener(self.EVENT_ATTACK_FINISH, handler(self, self.CreateAttackFinish));
end

--[[ 设置技能数据和解析技能数据
	params = {
		config = nil;-- 施法参数
		callback = nil; --完成回调
	}
]]
function SkillLogic_buf:setData( params )
	-- if BattleManager.BattleState < BattleManager.CONST_STATE_ATTACK then
	-- 	-- 去除所有
	-- 	self:getComponent("components.behavior.EventProtocol"):removeAllEventListeners();
	-- 	return;
	-- end
	self.AttackConfig = params.config;
	--得到类型
	self.Type = self.AttackConfig.bufID;
	self.SkillCongfig = GetBuff(self.Type);
	print("buf技能ID:",self.AttackConfig.bufID,self.SkillCongfig)

	self.releaseCamp = Data_Battle_Msg:ConvertCampData( self.AttackConfig.releasecamp );
	self.releaseData = control_Combat:getActorByPos( self.AttackConfig.releasepos , self.releaseCamp);
	assert(self.releaseData,"技能施法：施法者为nil 值");

	--运行施法动作
	self.FinishCallBack = params.callback;

	--直接产生伤害
	if self.SkillCongfig.CastingType == -1 then
		self:doEvent("event_hurt") ;
		return;
	end
	--处理消失的buf
	self:doEvent("event_buf") ;
	
end

function SkillLogic_buf:ExecuteStartBuf( event )
	--判断buff是否找到
	if self.SkillCongfig then
		self:doEvent("event_skillprompt") ;
	else
		printError("skill is  nil")
		self:doEvent("event_attackfinish") ;
	end
end


--技能提示
function SkillLogic_buf:CreateSkillPrompt( event )
	--创建技能提示
	--施法者技能t提示效果ID 为0 则进行技能动作
	if (not self.SkillCongfig.CastingNameShow) or self.SkillCongfig.CastingNameShow == 0 then
		self:doEvent("event_casting") ;
		return;
	end
	EffectManager.CreateBattleSkillPrompt({
		target = self.releaseData, 
		name = self.SkillCongfig.name,
	},function (  )
		self:doEvent("event_casting") ;
	end);

end

-- 技能效果
function SkillLogic_buf:CreateSkillEffect(  )

	-- 释放技能效果
	if self.SkillCongfig.CastingEffectID == 0 then
		self:doEvent("event_hurt") ;
		return;
	end
	--[[分三种
		1.单体攻击
		2.施法效果 1 对多
		3.施法效果 多 对多
	]]
	--解析目标计数
	self.EffectCount = self.AttackConfig.aimcount;
	--创建施法效果
	local effect = EffectManager.CreateEffect[self.SkillCongfig.CastingEffectID]({
			name = self.SkillCongfig.name,
			release = self.releaseData, --释放者
			releaseCamp = self.releaseData:getCamp(),--释放者阵营
			aimData = self.AttackConfig.affectAim, -- 目标
			aimCamp = nil, --目标阵营
			hurtData = self.AttackConfig.affectAim,
			executeMark = self.AttackConfig.executeMark,
			
			-- release = self.releaseData, --释放者
			-- releaseCamp = self.releaseData:getCamp(),--释放者阵营
			-- aimData = self.AttackConfig.AimData,-- 目标数据
			-- aimCamp = aimdata:getCamp(), --目标阵营
			-- hurtData = self.AttackConfig.HurtData,--伤害数据
		});
	effect:setFinishCallback(function ( event )
		print("技能1 施法完成 --- >进入伤害逻辑阶段")
		self:doEvent("event_hurt") ;
	end)
end

--[[只处理被动技能情况
]]
function SkillLogic_buf:CreateSkillHurt(  )
	print("SkillLogic_buf:CreateSkillHurt")
	for i,v in ipairs(self.AttackConfig.affectAim) do
		--解析目标
		local Camp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
		local hurtdata =  control_Combat:getActorByPos( v.aimpos , Camp);
		if hurtdata and (not hurtdata:isDead()) then
			--执行伤害
			if v.hurtvaluse ~= 0 then
				--逻辑3方式 为被动技能形式
				if self.AttackConfig.executeMark == 3 then
					--如果是角色自己不检查(在角色整个buf执行完成后检查)
					if hurtdata ~= self.releaseData then
						hurtdata:DeadCheck(  );
					end
				end
			end
		end
	end
	--执行 
	self:doEvent("event_attackfinish") ;
end


--攻击完成
function SkillLogic_buf:CreateAttackFinish( event )
	if self.FinishCallBack then
		self.FinishCallBack(  );
	end
	-- 去除所有
	self:removeAllEventListeners();
end

-- 技能完成监听
function SkillLogic_buf:SetSkillFinishCallBak( )
	-- body
end

return SkillLogic_buf;
