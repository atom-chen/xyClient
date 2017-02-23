--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 大桥技能效果2

local skilleffect_dq_2 = class("skilleffect_dq_2")

function skilleffect_dq_2:ctor()
	-- body
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
function skilleffect_dq_2:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self:CreateAttackEffect();
end


--创建攻击动作
function skilleffect_dq_2:CreateAttackEffect(  )
	
	--张角执行技能动作2
	-- self.Release:doEvent("event_cast_2",{Callback = handler(self, self.setAttackEffectListen)});
	local x ,y= Data_Battle.mapData:getMapToWorldTransform( self.Release.Map_x ,self.Release.Map_y );
	local effect = EffectManager:CreateArmature( {
		name = "herores/daqiao/f_dq_s_2.ExportJson",--效果名称
		x = x,
		y = y,
		zorder = self.Release.Map_x + self.Release.Map_y + 1,
		isfinishdestroy = true,--是否完成销毁
	} );
	if self.ReleaseCamp ~= Data_Battle.CONST_CAMP_PLAYER then
		effect:setScaleX(-1);
	end
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,1 ,nil})
	effect:playAnimationByID( "skill_2" ,nil ,-1);
	effect:setCallback(handler(self, self.setAttackEffectListen));
end

--创建打击效果
function skilleffect_dq_2:CreateAttackBlowEffect(  )
end

--创建伤害效果
function skilleffect_dq_2:CreateHurtEffect(  )
	-- for i,v in ipairs(self.HurtData) do
	-- 	--解析目标
	-- 	local Camp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
	-- 	local hurtAim = control_Combat:getActorByPos( v.aimpos , Camp);
	-- 	hurtAim:doEvent("event_behit");
	-- end
end

--创建伤害逻辑
function skilleffect_dq_2:CreateHurtLogic(  )
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , nil );
end

--执行完成逻辑
function skilleffect_dq_2:executeFinishLogic(  )
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function skilleffect_dq_2:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------
--攻击效果回调监听
function skilleffect_dq_2:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	print(listenerType,armatureName,movementType ,object)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:executeFinishLogic(  );
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
		if movementType == "hurt_" then
			self:CreateHurtEffect();
			self:CreateHurtLogic();
		end
	end
end

function skilleffect_dq_2:setHurtCreateListen( listenerType,armatureName,movementType ,object  )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			
		end
	elseif listenerType == "FrameEvent" then
		if movementType == "hurt_" then
			
		end
	end
end
return skilleffect_dq_2;
