--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 黄月英技能1

local skilleffect_hyy_1 = class("skilleffect_hyy_1")

function skilleffect_hyy_1:ctor()
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
function skilleffect_hyy_1:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	
	self:CreateAttackEffect();
end

--创建攻击动作
function skilleffect_hyy_1:CreateAttackEffect(  )
	-- local actor = control_Combat:getActorByPos(self.Release.);
	--张角执行技能动作2
	self.Release:doEvent("event_cast_1",{Callback = handler(self, self.setAttackEffectListen)});

end

--创建打击效果
function skilleffect_hyy_1:CreateAttackBlowEffect(  )
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
				name = "herores/huangyueying/f_hyy_s_1_1.ExportJson",--效果名称
				x = x,
				y = y + 90,
				zorder = aim.Map_x + aim.Map_y,
				isfinishdestroy = true,--是否完成销毁
			} );
			--设置标示
			effect.mark = v.aimpos;
			if self.ReleaseCamp ~= Data_Battle.CONST_CAMP_PLAYER then
				effect:setScaleX(-1);
			end
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
function skilleffect_hyy_1:CreateHurtEffect( pos )
	
	--得到攻击的目标
	-- local attackAim = Data_Battle_Msg:analysisAttackAimBy( self.AimData ,pos )
	-- attackAim:doEvent("event_behit");
end

function skilleffect_hyy_1:CreateHurtEffect_1( pos )
	--震动
	local attackAim = Data_Battle_Msg:analysisAttackAimBy( self.AimData ,pos )
	EffectManager.CreateShakeEffect({
		view = attackAim.showObject,
		offset = 10,--偏移量
		runtime = 0.8,
		finishCallBack = nil,
	})
end

--创建伤害逻辑
function skilleffect_hyy_1:CreateHurtLogic( pos )
	print("CreateHurtLogic",pos)
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_hyy_1:executeFinishLogic(  )
	self.Release:doEvent("event_castover_1");
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function skilleffect_hyy_1:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------
--攻击效果回调监听
function skilleffect_hyy_1:setAttackEffectListen( listenerType,armatureName,movementType ,object )
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

function skilleffect_hyy_1:setHurtCreateListen( listenerType,armatureName,movementType ,object  )
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
		elseif movementType == "blow_10000" then
			self:CreateHurtEffect_1( object.mark );
		end
	end
end
return skilleffect_hyy_1;
