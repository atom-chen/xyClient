--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 黄祖2效果1

local skilleffect_hz2_1 = class("skilleffect_hz2_1")

function skilleffect_hz2_1:ctor()
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
function skilleffect_hz2_1:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self:analysisData();
	self:CreateMoveAcion();
	self:CastFocus(  );
	-- self:CreateAttackEffect(  );
end

--解析数据
function skilleffect_hz2_1:analysisData(  )
	--攻击的目标
	local  aiminfo = Data_Battle_Msg:analysisAttackAimProtagonistFirst(self.AimData);
	local aimCamp = Data_Battle_Msg:ConvertCampData( aiminfo.aimcamp );
	self.FirstAim = control_Combat:getActorByPos( aiminfo.aimpos , aimCamp);
	self.ReleasePos_x = self.Release.Map_x;
	self.ReleasePos_y = self.Release.Map_y;

	self.endPoint_x , self.endPoint_y = Data_Battle.mapData:getMapToWorldTransform(self.FirstAim.Map_x ,self.FirstAim.Map_y);
	if self.ReleaseCamp == Data_Battle.CONST_CAMP_PLAYER then
		self.startPoint_x = self.endPoint_x - 320
	else
		self.startPoint_x = self.endPoint_x + 320
	end
	self.startPoint_y = self.endPoint_y;
	--创建黑屏效果
	--重置施法者zorad
	self.Release:setActorLocalZOrder(ManagerBattle.CONST_COMBAT_ORDER + 1);
	self.FirstAim:setActorLocalZOrder(ManagerBattle.CONST_COMBAT_ORDER);
end

--施法聚焦
function skilleffect_hz2_1:CastFocus(  )
	--目标进入攻击层
	local x,y = Data_Battle.mapData:getNodeLayerToWordSpace( self.startPoint_x , self.startPoint_y )
	self.FocusEffect = EffectManager.CreateCastFocusEffect({
		dataType = 1,
		camp = self.ReleaseCamp,
		cast_x = x,
		cast_y = y,
		rect_w = 20,
		rect_h = 20,
		isshowTemplate = 1,
	} ,function (  )
		-- 运行攻击动作
		self:CreateAttackEffect();
	end);
	self.FocusEffect:isShowTemplate( true );
end

--创建移动动作
function skilleffect_hz2_1:CreateMoveAcion(  )

	self.Release:doEvent("event_move",{Callback = handler(self, self.MoveFinishListen),x = self.startPoint_x, y = self.startPoint_y});
end

function skilleffect_hz2_1:GoBackAction(  )
	local x , y = Data_Battle.mapData:getMapToWorldTransform( self.ReleasePos_x ,self.ReleasePos_y )
	-- getWorldToNodeLayerSpace( display.cx ,display.cy );
	--还原z位置
	self.Release:setActorLocalZOrder( self.ReleasePos_x + self.ReleasePos_y );
	self.Release:doEvent("event_move",{Callback = handler(self, self.MoveFinishListen_1),x = x, y = y});
end


--创建攻击动作
function skilleffect_hz2_1:CreateAttackEffect(  )
	
	--张角执行技能动作2
	self.Release:doEvent("event_cast_1",{Callback = handler(self, self.setAttackEffectListen)});

end


--创建打击效果
function skilleffect_hz2_1:CreateAttackBlowEffect(  )
	--震动
	dispatchGlobaleEvent( "battlefield" ,"shake" ,{0.5});
	EffectManager:CreatePiece_Shake_1( 0.5 );
	
	--目标震动
	EffectManager.CreateShakeEffect({
		view = self.FirstAim.showObject,
		offset = 6,--偏移量
		runtime = 0.5,
		finishCallBack = nil,
	})

	--解析目标数据
	--创建爆炸效果
	local effect = EffectManager:CreateArmature( {
		name = "animation/skilleffect/f_hz_s_1_1.ExportJson",--效果名称
		x = self.endPoint_x,
		y = self.endPoint_y + 80,
		zorder = ManagerBattle.CONST_COMBAT_ORDER + 10,
		isfinishdestroy = true,--是否完成销毁
	} );
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,1 ,nil})
	effect:playAnimationByID( "Animation1" ,nil ,-1);
	effect:setCallback(handler(self, self.setHurtCreateListen));
end

--创建伤害效果
function skilleffect_hz2_1:CreateHurtEffect( pos )
	
	-- self.FirstAim:doEvent("event_behit");
end

--创建伤害逻辑
function skilleffect_hz2_1:CreateHurtLogic( pos )
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_hz2_1:executeFinishLogic(  )

	self.Release:doEvent("event_castover_1");
	self.FocusEffect:restoreAction(  );
	--关闭
	self:GoBackAction(  );
	self.FirstAim:resetActorLocalZOrder(  );
end

--设置完成回调函数
function skilleffect_hz2_1:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------

--移动结束监听
function skilleffect_hz2_1:MoveFinishListen(  )
	-- self:CreateAttackEffect(  );
end

function skilleffect_hz2_1:MoveFinishListen_1(  )
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--攻击效果回调监听
function skilleffect_hz2_1:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:executeFinishLogic(  );
			
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
		if movementType == "hurt_" then
			-- self:CreateHurtEffect();
			self:CreateHurtLogic();
		elseif movementType == "blow_10051" then
			--创建打击效果
			self:CreateAttackBlowEffect(  );
		end
	end
end

function skilleffect_hz2_1:setHurtCreateListen( listenerType,armatureName,movementType ,object  )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			-- self.EffectCount = self.EffectCount - 1;
			-- -- print("setHurtCreateListen",self.EffectCount)
			-- if self.EffectCount < 1 then
			-- 	self:executeFinishLogic(  );
			-- end
		end
	elseif listenerType == "FrameEvent" then
		-- if movementType == "hurt_" then
		-- 	self:CreateHurtLogic( object.mark );
		-- end
	end
end


return skilleffect_hz2_1;
