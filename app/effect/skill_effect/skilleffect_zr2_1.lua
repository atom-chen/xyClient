--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 祝融2技能1

local skilleffect_zr2_1 = class("skilleffect_zr2_1")

function skilleffect_zr2_1:ctor()
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
function skilleffect_zr2_1:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self:analysisData(  );
	self:CreateAttackEffect();
end

--解析数据
function skilleffect_zr2_1:analysisData(  )
	
	self.startPoint_x = 0;
	self.startPoint_y = 0;
	if self.ReleaseCamp == Data_Battle.CONST_CAMP_ENEMY then
		self.startPoint_x = 1280; 
	end

	self.castIndex = 1;
end

--创建攻击动作
function skilleffect_zr2_1:CreateAttackEffect(  )
	-- local actor = control_Combat:getActorByPos(self.Release.);
	self.Release:doEvent("event_cast_1",{Callback = handler(self, self.setAttackEffectListen)});

end

--创建打击效果
function skilleffect_zr2_1:CreateAttackBlowEffect(  )
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
			local effect = self:CreateFlyingEffect( self.startPoint_x ,  y + 50 , x , y + 50 ,aim.Map_x + aim.Map_y);
			
			--设置标示
			effect.mark = v.aimpos;
		else
			print("施法：" , "目标为nil")
		end
	end 
end

--创建飞行效果
function skilleffect_zr2_1:CreateFlyingEffect( start_x , start_y , end_x ,end_y ,zorder)
	local playereactoin = "Animation1";
	local flyingEffect = EffectManager:CreateArmature( {
		name = "herores/zhurong/f_zr_s_1_1.ExportJson",--效果名称
		x = start_x,
		y = start_y,
		zorder = zorder,
		isfinishdestroy = true,--是否完成销毁
	} );
	if self.ReleaseCamp ~= Data_Battle.CONST_CAMP_PLAYER then
		flyingEffect:setScaleX(-1);
	end
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{flyingEffect,2 ,nil})
	flyingEffect:playAnimationByID( playereactoin ,nil ,-1);
	flyingEffect:setCallback(handler(self, self.setFlayingListen));--飞行监听
	
	local moveaction = cc.MoveTo:create(0.4,cc.p(end_x,end_y))
	local callfun = cc.CallFunc:create(function (  )
		-- self:CreateAttackBlowEffect(  );
	end)
	flyingEffect:runAction(cc.Sequence:create(moveaction,callfun));
	return flyingEffect;
end

--创建伤害效果
function skilleffect_zr2_1:CreateHurtEffect( pos )
	
	--得到攻击的目标
	-- local attackAim = Data_Battle_Msg:analysisAttackAimBy( self.AimData ,pos )
	-- attackAim:doEvent("event_behit");
end


--创建伤害逻辑
function skilleffect_zr2_1:CreateHurtLogic( pos )
	print("CreateHurtLogic",pos)
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_zr2_1:executeFinishLogic(  )
	self.Release:doEvent("event_castover_1");
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function skilleffect_zr2_1:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------
--攻击效果回调监听
function skilleffect_zr2_1:setAttackEffectListen( listenerType,armatureName,movementType ,object )
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


function skilleffect_zr2_1:setFlayingListen( listenerType,armatureName,movementType ,object )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self.EffectCount = self.EffectCount - 1;
			if self.EffectCount < 1 then
				self:executeFinishLogic(  );
			end
		end
	elseif listenerType == "FrameEvent" then
		if movementType == "hurt_" then
			self:CreateHurtLogic( object.mark );
		end
	end
end

return skilleffect_zr2_1;
