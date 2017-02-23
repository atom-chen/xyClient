--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 严颜技能效果2

local skilleffect_yy_2 = class("skilleffect_yy_2")

function skilleffect_yy_2:ctor()
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
function skilleffect_yy_2:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self:analysisData();
	self:CreateMoveAcion();
	-- self:CreateAttackEffect(  );
end

--解析数据
function skilleffect_yy_2:analysisData(  )
	--攻击的目标
	local  aiminfo = Data_Battle_Msg:analysisAttackAimProtagonistFirst(self.AimData);
	local aimCamp = Data_Battle_Msg:ConvertCampData( aiminfo.aimcamp );
	self.FirstAim = control_Combat:getActorByPos( aiminfo.aimpos , aimCamp);
	self.ReleasePos_x = self.Release.Map_x;
	self.ReleasePos_y = self.Release.Map_y;
	
end


--创建移动动作
function skilleffect_yy_2:CreateMoveAcion(  )
	local map_x = self.FirstAim.Map_x;
	local map_y = self.FirstAim.Map_y;
	
	local x , y = Data_Battle.mapData:getMapToWorldTransform( map_x ,map_y )
	if self.ReleaseCamp == Data_Battle.CONST_CAMP_PLAYER then
		x = x - 150
	else
		x = x + 150
	end

	self.Release:doEvent("event_move",{Callback = handler(self, self.MoveFinishListen),x = x, y = y});
end

function skilleffect_yy_2:GoBackAction(  )
	local x , y = Data_Battle.mapData:getMapToWorldTransform( self.ReleasePos_x ,self.ReleasePos_y )
	--还原z位置
	self.Release:setActorLocalZOrder( self.ReleasePos_x + self.ReleasePos_y );
	self.Release:doEvent("event_move",{Callback = handler(self, self.MoveFinishListen_1),x = x, y = y});
end

--创建攻击动作
function skilleffect_yy_2:CreateAttackEffect(  )
	-- local actor = control_Combat:getActorByPos(self.Release.);
	
	--重置施法者z位置
	self.Release:setActorLocalZOrder( self.FirstAim.Map_x + self.FirstAim.Map_y + 1 )
	
	--张角执行技能动作2
	self.Release:doEvent("event_cast_2",{Callback = handler(self, self.setAttackEffectListen)});

end

--创建打击效果
function skilleffect_yy_2:CreateAttackBlowEffect(  )
	
end

--创建伤害效果
function skilleffect_yy_2:CreateHurtEffect(  )
	-- self.FirstAim:doEvent("event_behit");
	dispatchGlobaleEvent( "battlefield" ,"shake" ,{0.3});
end

--创建伤害逻辑
function skilleffect_yy_2:CreateHurtLogic( pos )
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , pos );
end

--执行完成逻辑
function skilleffect_yy_2:executeFinishLogic(  )
	self.Release:doEvent("event_castover_2");
	self:GoBackAction(  );
end

--设置完成回调函数
function skilleffect_yy_2:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------

--移动结束监听
function skilleffect_yy_2:MoveFinishListen(  )
	self:CreateAttackEffect(  );
end

function skilleffect_yy_2:MoveFinishListen_1(  )
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--攻击效果回调监听
function skilleffect_yy_2:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	print(listenerType,armatureName,movementType ,object)
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:executeFinishLogic(  );
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
		print("setAttackEffectListen",movementType)
		if movementType == "hurt_" then
			self:CreateHurtEffect(  );
			self:CreateHurtLogic();
		end
	end
end

return skilleffect_yy_2;
