--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 法正技能2

local skilleffect_fz_2 = class("skilleffect_fz_2")

function skilleffect_fz_2:ctor()
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
function skilleffect_fz_2:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	
	self:CreateAttackEffect();
end

--创建攻击动作
function skilleffect_fz_2:CreateAttackEffect(  )
	-- local actor = control_Combat:getActorByPos(self.Release.);
	--张角执行技能动作2
	self.Release:doEvent("event_cast_2",{Callback = handler(self, self.setAttackEffectListen)});

end

--创建打击效果
function skilleffect_fz_2:CreateAttackBlowEffect(  )
	--解析目标数据
	--解析目标计数
	local aimlist ,aimcount = Data_Battle_Msg:analysisAttackAimProtagonist( self.AimData )
	self.EffectCount = aimcount;
	for i,v in ipairs(aimlist) do
		--解析目标
		local aimCamp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
		local aim = control_Combat:getActorByPos( v.aimpos , aimCamp);
		if aim then
			--得到坐标位置
			--得到坐标位置
			local x ,y= Data_Battle.mapData:getMapToWorldTransform( aim.Map_x ,aim.Map_y );
			local effect = EffectManager:CreateArmature( {
				name = "herores/fazheng/f_fz_s_2_1.ExportJson",--效果名称
				x = x,
				y = y,
				zorder = aim.Map_x + aim.Map_y,
				isfinishdestroy = true,--是否完成销毁
			} );
			--设置标示
			effect.mark = v.aimpos;
			--添加到显示界面
			dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,1 ,nil})
			effect:playAnimationByID( "Animation1" ,nil ,-1);
			effect:setCallback(handler(self, self.setHurtCreateListen));

		else
			print("施法：" , "目标为nil")
		end
	end 
end

--创建伤害效果
function skilleffect_fz_2:CreateHurtEffect( pos )
	--震动
	dispatchGlobaleEvent( "battlefield" ,"shake" ,{0.2});
	EffectManager:CreatePiece_Shake_1( 0.2 );
	--得到攻击的目标
	-- local attackAim = Data_Battle_Msg:analysisAttackAimBy( self.AimData ,pos )
	-- attackAim:doEvent("event_behit");
end

--创建伤害逻辑
function skilleffect_fz_2:CreateHurtLogic( pos )
	print("CreateHurtLogic",pos)
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_fz_2:executeFinishLogic(  )
	self.Release:doEvent("event_castover_2");
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function skilleffect_fz_2:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------
--攻击效果回调监听
function skilleffect_fz_2:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	print(listenerType,armatureName,movementType ,object)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
		if movementType == "blow_10026" then
			self:CreateAttackBlowEffect();
		end
	end
end

function skilleffect_fz_2:setHurtCreateListen( listenerType,armatureName,movementType ,object  )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self.EffectCount = self.EffectCount - 1;
			if self.EffectCount < 1 then
				self:executeFinishLogic(  );
			end
		end
	elseif listenerType == "FrameEvent" then
		if movementType == "hurt_" then
			self:CreateHurtEffect( object.mark );
			self:CreateHurtLogic( object.mark );
		end
	end
end
return skilleffect_fz_2;
