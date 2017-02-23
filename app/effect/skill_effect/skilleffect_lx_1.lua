--
-- Author: LiYang
-- Date: 2015-07-22 14:49:32
-- 陆逊技能效果1

local skilleffect_lx_1 = class("skilleffect_lx_1")

function skilleffect_lx_1:ctor()
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
function skilleffect_lx_1:setData( parame )
	self.Release = parame.release;
	self.ReleaseCamp = parame.releaseCamp;
	self.AimCamp = parame.aimCamp;
	self.AimData = parame.aimData;
	self.HurtData = parame.hurtData;
	self:analysisData();
	-- self:CastFocus(  );
	self:CreateMoveAcion();
end

--解析数据
function skilleffect_lx_1:analysisData(  )
	--[[技能说明
		次技能为一个攻打横排的技能
		攻打位置为对应横排的中间
	]]
	local  aiminfo = Data_Battle_Msg:analysisAttackAimProtagonistFirst(self.AimData);
	local aimCamp = Data_Battle_Msg:ConvertCampData( aiminfo.aimcamp );
	self.FirstAim = control_Combat:getActorByPos( aiminfo.aimpos , aimCamp);
	self.ReleasePos_x = self.Release.Map_x;
	self.ReleasePos_y = self.Release.Map_y;
	--得到施法目标的位置
	local horizontalpos = aiminfo.aimpos % 3;
	if horizontalpos == 0 then
		horizontalpos = 3;
	end
	self.castpos = EffectManager:getEffectHorizontalCasetPos( horizontalpos ,aiminfo.aimcamp );
	local direction = 1;
	if aiminfo.aimcamp == Data_Battle.CONST_CAMP_PLAYER then
		direction = -1;
	end

	self.endPoint_x , self.endPoint_y = Data_Battle.mapData:getMapToWorldTransform(self.castpos[1] ,self.castpos[2]);
	self.endPoint_x  = self.endPoint_x - 300 * direction;
	self.startPoint_x ,self.startPoint_y = Data_Battle.mapData:getMapToWorldTransform( self.Release.Map_x ,self.Release.Map_y );

	-- self.Release:setActorLocalZOrder(ManagerBattle.CONST_COMBAT_ORDER + 1);

	-- local aimlist ,aimcount = Data_Battle_Msg:analysisAttackAimProtagonist( self.AimData );
	-- for i,v in ipairs(aimlist) do
	-- 	--解析目标
	-- 	local aimCamp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
	-- 	local aim = control_Combat:getActorByPos( v.aimpos , aimCamp);
	-- 	aim:setActorLocalZOrder(ManagerBattle.CONST_COMBAT_ORDER);
	-- end
end

--施法聚焦
function skilleffect_lx_1:CastFocus(  )
	--目标进入攻击层
	self.FocusEffect = EffectManager.CreateCastFocusEffect({
		dataType = 1,
		camp = self.ReleaseCamp,
		cast_x = self.endPoint_x,
		cast_y = self.endPoint_y,
		rect_w = 20,
		rect_h = 20,
		isshowTemplate = 1,
	} ,function (  )
		-- 运行攻击动作
		-- self:CreateAttackEffect();
	end);
	self.FocusEffect:isShowTemplate( true );
end

--创建移动动作
function skilleffect_lx_1:CreateMoveAcion(  )
	self.Release:doEvent("event_move",{Callback = handler(self, self.MoveFinishListen),x = self.endPoint_x, y = self.endPoint_y});
end

function skilleffect_lx_1:GoBackAction(  )
	local x , y = Data_Battle.mapData:getMapToWorldTransform( self.ReleasePos_x ,self.ReleasePos_y )
	-- getWorldToNodeLayerSpace( display.cx ,display.cy );
	--还原z位置
	self.Release:setActorLocalZOrder( self.ReleasePos_x + self.ReleasePos_y );
	self.Release:doEvent("event_move",{Callback = handler(self, self.MoveFinishListen_1),x = x, y = y});
end

--创建攻击动作
function skilleffect_lx_1:CreateAttackEffect(  )
	--震动
	dispatchGlobaleEvent( "battlefield" ,"shake" ,{1});
	EffectManager:CreatePiece_Shake_1( 1);
	self.Release:setActorLocalZOrder( self.FirstAim.Map_x + self.FirstAim.Map_y + 1 )
	--张角执行技能动作2
	self.Release:doEvent("event_cast_1",{Callback = handler(self, self.setAttackEffectListen)});

end

--创建打击效果
function skilleffect_lx_1:CreateAttackBlowEffect(  )
	
end

--创建伤害效果
function skilleffect_lx_1:CreateHurtEffect(  )
	
	for i,v in ipairs(self.HurtData) do
		--解析目标
		local Camp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
		local hurtAim = control_Combat:getActorByPos( v.aimpos , Camp);
		if hurtAim then
			local x ,y = Data_Battle.mapData:getMapToWorldTransform( hurtAim.Map_x ,hurtAim.Map_y);
			local effect = EffectManager:CreateArmature( {
				name = "animation/skilleffect/f_lx_s_2_1.ExportJson",--效果名称
				x = x ,
				y = y + 60 ,
				zorder = hurtAim.Map_x + hurtAim.Map_y + 1,
				isfinishdestroy = true,--是否完成销毁
			} );
			--添加到显示界面
			dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{effect,1 ,nil})
			effect:playAnimationByID( "Animation1" ,nil ,-1);
			effect:setCallback(handler(self, self.setHurtCreateListen));
		end
		
	end
end

--创建伤害逻辑
function skilleffect_lx_1:CreateHurtLogic(  )
	Data_Battle_Msg:analysisSkillHurtDataExecuteLogic( self.HurtData , nil );
end

--执行完成逻辑
function skilleffect_lx_1:executeFinishLogic(  )
	self.Release:doEvent("event_castover_1");
	self:GoBackAction(  );
end

--设置完成回调函数
function skilleffect_lx_1:setFinishCallback( callfun )
	self.FinishCallback = callfun;
end

---------------------------------------------------

--移动结束监听
function skilleffect_lx_1:MoveFinishListen(  )
	self:CreateAttackEffect(  );
end

function skilleffect_lx_1:MoveFinishListen_1(  )
	if self.FinishCallback then
		self.FinishCallback();
	end
end

--攻击效果回调监听
function skilleffect_lx_1:setAttackEffectListen( listenerType,armatureName,movementType ,object )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			self:executeFinishLogic(  );
		end
	elseif listenerType == "FrameEvent" then
		--帧事件监听
		if movementType == "hurt_" then
			
			
		elseif movementType == "blow_10054" then
			self:CreateHurtEffect();
		end
	end
end

function skilleffect_lx_1:setHurtCreateListen( listenerType,armatureName,movementType ,object  )
	if listenerType == "AnimationEvent" then
		if movementType == ccs.MovementEventType.complete then
			
		end
	elseif listenerType == "FrameEvent" then
		if  movementType == "hurt_" then
			self:CreateHurtLogic();
		end
	end
end
return skilleffect_lx_1;
