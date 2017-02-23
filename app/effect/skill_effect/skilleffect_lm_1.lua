--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 吕蒙技能1

local skilleffect_lm_1 = class("skilleffect_lm_1")

function skilleffect_lm_1:ctor()
	--[[技能说明
		自身添加buf
	]]
end

--[[设置技能数据
	parame = {
		name --技能名称
		release --释放者
		releaseCamp --释放者阵营
		aimCamp --目标阵营
		aimData -- 目标
		hurtData --目标伤害数据
	}
]]
function skilleffect_lm_1:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	
	self:CreateAttackEffect();
end

--创建攻击动作
function skilleffect_lm_1:CreateAttackEffect(  )
	-- local actor = control_Combat:getActorByPos(self.Release.);
	--张角执行技能动作2
	self.Release:doEvent("event_cast_1",{Callback = handler(self, self.setAttackEffectListen)});
end

--创建打击效果
function skilleffect_lm_1:CreateAttackBlowEffect(  )
	
end

--创建伤害效果
function skilleffect_lm_1:CreateHurtEffect( pos )
	
end

--创建伤害逻辑
function skilleffect_lm_1:CreateHurtLogic( pos )
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_lm_1:executeFinishLogic(  )
	self.Release:doEvent("event_castover_1");
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function skilleffect_lm_1:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------
--攻击效果回调监听
function skilleffect_lm_1:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	print(listenerType,armatureName,movementType ,object)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:CreateHurtLogic(  );
			self:executeFinishLogic();
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
	end
end

return skilleffect_lm_1;
