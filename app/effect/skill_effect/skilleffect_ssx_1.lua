--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 孙尚香技能效果1

local skilleffect_ssx_1 = class("skilleffect_ssx_1")

function skilleffect_ssx_1:ctor()
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
		executeMark -- 执行标示
	}
]]
function skilleffect_ssx_1:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self.executeMark = parame.executeMark;
	self:analysisData();
	-- self:CreateMoveAcion();
	self:CreateAttackEffect(  );
end

--解析数据
function skilleffect_ssx_1:analysisData(  )
	--攻击的目标
	local  aiminfo = Data_Battle_Msg:analysisAttackAimProtagonistFirst(self.AimData,self.executeMark);
	local aimCamp = Data_Battle_Msg:ConvertCampData( aiminfo.aimcamp );
	self.FirstAim = control_Combat:getActorByPos( aiminfo.aimpos , aimCamp);
	self.ReleasePos_x = self.Release.Map_x;
	self.ReleasePos_y = self.Release.Map_y;

	self.endPoint_x , self.endPoint_y = Data_Battle.mapData:getMapToWorldTransform(self.FirstAim.Map_x ,self.FirstAim.Map_y);
	self.startPoint_x ,self.startPoint_y = Data_Battle.mapData:getMapToWorldTransform( self.Release.Map_x ,self.Release.Map_y);
	self.endPoint_y = self.endPoint_y + 50;
	self.startPoint_y = self.startPoint_y + 100;
	
	--两点距离 得到速度 和角度
	local ccpsubValuse = cc.p(self.endPoint_x - self.startPoint_x,self.endPoint_y - self.startPoint_y);
	self.dist = cc.pGetLength(ccpsubValuse) ;
	self.angle = -cc.pToAngleSelf(ccpsubValuse)*180/math.pi;--两点间角度
	
	print("analysisData",self.angle,self.dist,self.endPoint_y,self.startPoint_y)
end

--创建攻击动作
function skilleffect_ssx_1:CreateAttackEffect(  )
	
	self.Release:setActorLocalZOrder( self.FirstAim.Map_x + self.FirstAim.Map_y + 1 )
	--张角执行技能动作2
	self.Release:doEvent("event_cast_1",{Callback = handler(self, self.setAttackEffectListen)});

end

--创建飞行效果
function skilleffect_ssx_1:CreateFlyingEffect(  )
	local moveLength = self.dist;
	local playereactoin = "Animation1";
	local play_x = self.startPoint_x;
	local play_y = self.startPoint_y;
	local angle = self.angle;
	
	local effect = EffectManager:CreateArmature( {
		name = "herores/sunshangxiang/f_ssx_s_1_1.ExportJson",--效果名称
		x = play_x,
		y = play_y,
		zorder = self.FirstAim.Map_x + self.FirstAim.Map_y + 1,
		isfinishdestroy = true,--是否完成销毁
	} );
	if self.ReleaseCamp ~= Data_Battle.CONST_CAMP_PLAYER then
		effect:setScaleX(-1);
		angle = angle + 180;
	end
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,2 ,nil})
	effect:setRotation(angle);
	effect:playAnimationByID( playereactoin ,nil ,-1);
	effect:setCallback(handler(self, self.setFlayingListen));--飞行监听
	
	if moveLength > 0 then
		local moveaction = cc.MoveTo:create(0.4,cc.p(self.endPoint_x , self.endPoint_y))
		local callfun = cc.CallFunc:create(function (  )
			self:CreateAttackBlowEffect(  );
		end)
		effect:runAction(cc.Sequence:create(moveaction,callfun));
	end
	
end

--创建打击效果
function skilleffect_ssx_1:CreateAttackBlowEffect(  )
	--震动
	dispatchGlobaleEvent( "battlefield" ,"shake" ,{0.2});
	EffectManager:CreatePiece_Shake_1( 0.2 );
	
end

--创建伤害效果
function skilleffect_ssx_1:CreateHurtEffect( pos )
	
	-- self.FirstAim:doEvent("event_behit");
end

--创建伤害逻辑
function skilleffect_ssx_1:CreateHurtLogic( pos )
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_ssx_1:executeFinishLogic(  )
	self.Release:doEvent("event_castover_1");
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--设置完成回调函数
function skilleffect_ssx_1:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------


--攻击效果回调监听
function skilleffect_ssx_1:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			-- self:executeFinishLogic(  );
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
		if movementType == "hurt_" then
			
		elseif movementType == "blow_" then
			self:CreateFlyingEffect(  );
		end
	end
end

function skilleffect_ssx_1:setHurtCreateListen( listenerType,armatureName,movementType ,object  )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:CreateHurtEffect();
			self:CreateHurtLogic();
			self:executeFinishLogic(  );
		end
	elseif listenerType == "FrameEvent" then
		if movementType == "hurt_" then
			-- self:CreateHurtLogic( object.mark );
		end
	end
end

function skilleffect_ssx_1:setFlayingListen( listenerType,armatureName,movementType ,object )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:executeFinishLogic(  );
		end
	elseif listenerType == "FrameEvent" then
		if movementType == "hurt_" then
			self:CreateHurtEffect();
			self:CreateHurtLogic();
		end
	end
end

return skilleffect_ssx_1;
