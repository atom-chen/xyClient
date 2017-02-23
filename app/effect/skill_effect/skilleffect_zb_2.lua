--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 张宝技能2

local skilleffect_zb_2 = class("skilleffect_zb_2")

function skilleffect_zb_2:ctor()
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
function skilleffect_zb_2:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self:CastFocus(  );
end

--施法聚焦
function skilleffect_zb_2:CastFocus(  )
	--目标进入攻击层
	-- self.Aim:setZOrder(BattleManager.CONST_COMBAT_ORDER);
	self.FocusEffect = EffectManager.CreateCastFocusEffect({
		-- actionType = self.SkillCongfig.CastingactionID, -- 动作类型
		target = self.Release,
		-- attackAim = self.Aim,--- 攻击目标
		camp = self.ReleaseCamp,
		isshowTemplate = 1,
	} ,function (  )
		-- 运行攻击动作
		self:CreateAttackEffect();
	end);
	self.FocusEffect:isShowTemplate( true );
end


--创建攻击动作
function skilleffect_zb_2:CreateAttackEffect(  )
	-- local actor = control_Combat:getActorByPos(self.Release.);
	
	--张角执行技能动作2
	self.Release:doEvent("event_cast_2",{Callback = handler(self, self.setAttackEffectListen)});

end

--创建打击效果
function skilleffect_zb_2:CreateAttackBlowEffect(  )
	
	self.FocusEffect:restoreAction(  );
	--震动
	dispatchGlobaleEvent( "battlefield" ,"shake" ,{1.5});
	EffectManager:CreatePiece_Shake_1( 1.5 );
	
	local x,y = Data_Battle.mapData:getMapToWorldTransform(24,14);
	--得到施法位置
	local castpos = EffectManager:getEffectCasetPos( "campscope" ,self.AimCamp );
	local effect = EffectManager:CreateArmature( {
		name = "animation/skilleffect/zb_se_0.ExportJson",--效果名称
		x = castpos.x,
		y = castpos.y,
		zorder = 0,
		isfinishdestroy = true,--是否完成销毁
	} );
	-- print("CreateAttackBlowEffect",castpos.x,castpos.y,x,y)
	--设置标示
	-- effect.mark = v.aimpos;
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,2 ,nil})
	effect:playAnimationByID( "more" ,nil ,0);
	effect:setCallback(handler(self, self.setHurtCreateListen));
end

--创建伤害效果
function skilleffect_zb_2:CreateHurtEffect(  )
	-- for i,v in ipairs(self.HurtData) do
	-- 	--解析目标
	-- 	local Camp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
	-- 	local hurtAim = control_Combat:getActorByPos( v.aimpos , Camp);
	-- 	hurtAim:doEvent("event_behit");
	-- end
end

--创建伤害逻辑
function skilleffect_zb_2:CreateHurtLogic( pos )
	-- print("CreateHurtLogic",pos)
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_zb_2:executeFinishLogic(  )
	-- print("executeFinishLogic")
	self.Release:doEvent("event_castover_2");
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function skilleffect_zb_2:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------
--攻击效果回调监听
function skilleffect_zb_2:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	-- print(listenerType,armatureName,movementType ,object)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听 
		if movementType == "blow_" then
			self:CreateAttackBlowEffect();
		end
	end
end

function skilleffect_zb_2:setHurtCreateListen( listenerType,armatureName,movementType ,object  )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:executeFinishLogic(  );
		end
	elseif listenerType == "FrameEvent" then
		if movementType == "hurt_" then
			self:CreateHurtEffect(  );
			self:CreateHurtLogic(nil);
		end
	end
end
return skilleffect_zb_2;
