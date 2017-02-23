--
-- Author: Li Yang
-- Date: 2014-03-24 09:29:49
-- 技能 攻击逻辑
--[[ 攻击逻辑说明
	初步按照技能释放的方式划分
	1.对目标释放 2.对区域释放

	逻辑结构
	1.设置数据 2.开始前剧情 3.技能提示 4.施法 5.施法完成剧情 4.施法结束回调

	(注释：说明下角色攻击的流程 ：体现施法者动作 ---> 施法动作 --->显示施法的名称 --->施法效果 ---->伤害效果)

]]
local skillbase = import(".ContronSkill_Base")

local commonAttack = class("commonAttack", skillbase);

commonAttack.CONST_LOGICTYPE_POINTTO = 1;--技能施法逻辑 指向性
commonAttack.CONST_LOGICTYPE_SCOPE = 2;--技能施法逻辑 范围
commonAttack.CONST_LOGICTYPE_Special_1 = 3;--特殊逻辑1
commonAttack.CONST_LOGICTYPE_Special_2 = 4;--多关联逻辑

function commonAttack:ctor()
	commonAttack.super.ctor(self)
	--初始化
	self:addEventListener(self.INIT_EVENT, handler(self, self.Initialize));
	self:addEventListener(self.SKILL_PROMPT_EVENT, handler(self, self.CreateSkillPrompt));
	self:addEventListener(self.CASTING_ACTION_EVENT,  handler(self, self.CreateSkillReaseAction));
	self:addEventListener(self.CASTING_EFFECT_EVENT, handler(self, self.CreateSkillEffect));
	self:addEventListener(self.HURT_TARGET_EVENT, handler(self, self.CreateSkillHurt));
	self:addEventListener(self.CONST_STATE_ATTACKFINISH, handler(self, self.CreateAttackFinish));
end

--[[ 设置技能数据
	params = {
		config = nil;-- 施法参数
		callback = nil; --完成回调
	}
]]
function commonAttack:setData( params )
	--不在攻击状态 不执行
	-- if BattleManager.BattleState < BattleManager.CONST_STATE_ATTACK then
	-- 	return;
	-- end
	--攻击参数 和伤害数据
	self.AttackConfig = params.config;

	--技能解析
	self.skillID = self.AttackConfig.skillID;
	self.SkillCongfig = GetSkill( self.skillID );
	print("技能ID:",self.AttackConfig.skillID,self.SkillCongfig)

	--施法者解析
	self.releaseCamp = BattleManager.CONST_CAMP_ENEMY;
	if self.AttackConfig.attackcamp == 1 then
		self.releaseCamp = BattleManager.CONST_CAMP_PLAYER;
	end
	self.releaseData = BattleManager:getActorByPos( self.AttackConfig.pos , self.releaseCamp);
	
	assert(self.releaseData,"技能施法：施法者为nil 值"..self.AttackConfig.pos..","..self.releaseCamp);

	--处理消失的buf
	self:BuffLogicExecute(  );
	
	--运行施法动作
	self.FinishCallBack = params.callback;
	if self.SkillCongfig then
		self.fsm__:doEvent("skillpromptevent") ;
	else
		self:NoActionLogic(  );
	end
end

--处理buff逻辑
function commonAttack:BuffLogicExecute(  )
	-- 阵营方向
	-- buffData.camp = msg:ReadIntData();
	-- -- 位置
	-- buffData.pos = msg:ReadIntData();
	-- -- 消失的buffid
	-- buffData.buffId = msg:ReadIntData();
	-- buffList[m] = buffData;

	if self.AttackConfig.buffCount > 0 then
		for i,v in ipairs(self.AttackConfig.buffList) do
			if v then
				--解析buff消失的对象
				local aimCamp = BattleManager.CONST_CAMP_ENEMY;
				if v.camp == 1 then
					aimCamp = BattleManager.CONST_CAMP_PLAYER;
				end 

				local aim = BattleManager:getActorByPos( v.pos , aimCamp);
				print("施法者：消失的buff",v.buffId,v.pos);
				local aimview = BattleManager:getActorView( aim)
				if aimview then
					aimview:RemoveBuff( v.buffId );
				end
				-- EffectManager.CreateBuffEffect({
				-- 	aim = BattleManager:getActorView( aim),--buff作用目标
				-- 	skillID = v.buffId,--buffID
				-- 	});
			end
		end
	end
end

--技能数据为0 处理方式
function commonAttack:NoActionLogic(  )

	if self.FinishCallBack then
		self.FinishCallBack(  );
	end
	-- self.fsm__:doEvent("attackfinish") ;
	-- 去除所有
	self:getComponent("components.behavior.EventProtocol"):removeAllEventListeners();
end

--技能提示
function commonAttack:CreateSkillPrompt(  )
	if BattleManager.BattleState < BattleManager.CONST_STATE_ATTACK then
		-- 去除所有
		self:getComponent("components.behavior.EventProtocol"):removeAllEventListeners();
		return;
	end
	--创建技能提示
	--施法者技能t提示效果ID 为0 则进行技能动作 or self.releaseCamp == BattleManager.CONST_CAMP_ENEMY
	if (not self.SkillCongfig.CastingNameShow) or self.SkillCongfig.CastingNameShow == 0 then
		self.fsm__:doEvent("castingaction") ;
		return;
	end

	print("技能提示：",self.SkillCongfig.CastingactionID)

	EffectManager.CreateBattleSkillPrompt({
		target = BattleManager:getActorView( self.releaseData), 
		camp = self.releaseCamp, --阵营
		skillData = self.SkillCongfig,
		callback =function ()
			self.fsm__:doEvent("castingaction") ;
		end,
	});
end

--施法聚焦

-- 技能施法动作
function commonAttack:CreateSkillReaseAction( )
	if BattleManager.BattleState < BattleManager.CONST_STATE_ATTACK then
		-- 去除所有
		self:getComponent("components.behavior.EventProtocol"):removeAllEventListeners();
		return;
	end
	-- 创建技能释放动作
	--设置施法ZOrder
	BattleManager:getActorView( self.releaseData):setZOrder(BattleManager.CONST_COMBAT_ORDER);
	--施法者技能动作效果ID 为0 则进行技能效果
	if self.SkillCongfig.CastingactionID == 0 then
		self.fsm__:doEvent("castingeffect") ;
		BattleManager.ActorViewPool[self.releaseData]:SkillPromptEffect( self.SkillCongfig );
		return;
	end
	print("技能施法动作：",self.SkillCongfig.CastingactionID)

	-- self.FocusEffect = EffectManager.CreateCastFocusEffect({
	-- 	-- actionType = self.SkillCongfig.CastingactionID, -- 动作类型
	-- 	target = BattleManager:getActorView( self.releaseData),
	-- 	attackAim = self:getAttackAim( ),--- 攻击目标
	-- 	camp = self.releaseCamp,
	-- 	callback = nil,
	-- } , function (  )
	-- 	EffectManager.CreateSkillReleaseAction({
	-- 		actionType = self.SkillCongfig.CastingactionID, -- 动作类型
	-- 		target = BattleManager:getActorView( self.releaseData), -- 作用的目标(此目标必须是 actorview 类型)
	-- 		attackAim = self:getAttackAim( ),--- 攻击目标
	-- 		camp = self.releaseCamp,
	-- 		callback = function ()
	-- 			-- print("结束回调测试")
	-- 			BattleManager.ActorViewPool[self.releaseData]:SkillPromptEffect( self.SkillCongfig );
	-- 			-- self:CreateSkillEffect(  )
	-- 			if self.FocusEffect then
	-- 				self.FocusEffect:restoreAction(  );
	-- 			end
	-- 			self.fsm__:doEvent("castingeffect") ;
	-- 		end,
	-- 		}
	-- 	);
	-- 	--施法动作音效播放
	-- 	AudioManager.playSkillEffectSound(self.SkillCongfig.CastingactionID);
	-- end);
	
	EffectManager.CreateSkillReleaseAction({
		actionType = self.SkillCongfig.CastingactionID, -- 动作类型
		target = BattleManager:getActorView( self.releaseData), -- 作用的目标(此目标必须是 actorview 类型)
		attackAim = self:getAttackAim( ),--- 攻击目标
		camp = self.releaseCamp,
		callback = function ()
			-- print("结束回调测试")
			BattleManager.ActorViewPool[self.releaseData]:SkillPromptEffect( self.SkillCongfig );
			-- self:CreateSkillEffect(  )
			self.fsm__:doEvent("castingeffect") ;
		end,
		}
	);
	--施法动作音效播放
	AudioManager.playSkillEffectSound(self.SkillCongfig.CastingactionID);
end

--得到攻击的目标(次方法只适合单体攻击模式)
function commonAttack:getAttackAim( )
	for i,v in ipairs(self.AttackConfig.AimData) do
		--解析目标
		local Camp = BattleManager.CONST_CAMP_ENEMY;
		if v.aimcamp == 1 then
			Camp = BattleManager.CONST_CAMP_PLAYER;
		end
		local aimdata = BattleManager:getActorByPos( v.aimpos , Camp);
		if aimdata then
			return BattleManager:getActorView( aimdata);
		end
		return nil;
	end
end

--效果计数
commonAttack.EffectCount = 0;

-- 技能效果
function commonAttack:CreateSkillEffect(  )
	if BattleManager.BattleState < BattleManager.CONST_STATE_ATTACK then
		-- 去除所有
		self:getComponent("components.behavior.EventProtocol"):removeAllEventListeners();
		return;
	end
	-- 释放技能效果
	if self.SkillCongfig.CastingEffectID == 0 then
		self.fsm__:doEvent("hurttarget") ;
		return;
	end
	--单体和范围 划分
	if self.SkillCongfig.CastingType == self.CONST_LOGICTYPE_POINTTO then
		self:CastingLogic_PointTo(  );
	elseif self.SkillCongfig.CastingType == self.CONST_LOGICTYPE_SCOPE then
		self:CastingLogic_Scope(  );
	elseif self.SkillCongfig.CastingType == self.CONST_LOGICTYPE_Special_1 then
		--特殊逻辑1
	elseif self.SkillCongfig.CastingType == self.CONST_LOGICTYPE_Special_2 then
		--创建技能效果
		print("创建伤害效果--->",self.SkillCongfig.CastingType,self.SkillCongfig.CastingEffectID)
		local effect = EffectManager.CreateEffect[self.SkillCongfig.CastingEffectID]({
				name = self.SkillCongfig.name,
				release = BattleManager:getActorView( self.releaseData), --释放者
				releaseCamp = self.releaseData:getCamp(),--释放者阵营
				aimData = self.AttackConfig.AimData,--BattleManager:getActorView( aimdata), -- 目标
				aimHurtData = self.AttackConfig.HurtData,--目标伤害数据
				aimCamp = nil, --目标阵营
				speed = EffectManager.EFFECT_CONST_FLY_SPEED, -- 运行速度600
			});
		effect:setFinishCallBack(function ( ... )
				print("技能1 施法完成 --- >进入伤害逻辑阶段")
				self.fsm__:doEvent("hurttarget") ;
			end);
	end
	--施法效果音效播放
	AudioManager.playSkillEffectSound(self.SkillCongfig.CastingEffectID);
end


--指向性攻击逻辑
function commonAttack:CastingLogic_PointTo(  )
	--[[分三种
		1.单体攻击
		2.施法效果 1 对多
		3.施法效果 多 对多
	]]
	--解析目标计数
	self.EffectCount = self.AttackConfig.AimCount;
	for i,v in ipairs(self.AttackConfig.AimData) do
		--解析目标
		local Camp = BattleManager.CONST_CAMP_ENEMY;
		if v.aimcamp == 1 then
			Camp = BattleManager.CONST_CAMP_PLAYER;
		end
		local aimdata = BattleManager:getActorByPos( v.aimpos , Camp)
		if aimdata then
			local start_x , start_y = self.releaseData:getPosCoord( )
			local end_x , end_y = aimdata:getPosCoord( )
			-- print("start_x , start_y , end_x , end_y",start_x ,start_y ,end_x ,end_y,v.aimcamp,v.aimpos,v.hurtvaluse);
			--创建施法效果
			local effect = EffectManager.CreateEffect[self.SkillCongfig.CastingEffectID]({
					name = self.SkillCongfig.name,
					release = BattleManager:getActorView( self.releaseData), --释放者
					releaseCamp = self.releaseData:getCamp(),--释放者阵营
					aim = BattleManager:getActorView( aimdata), -- 目标
					aimCamp = aimdata:getCamp(), --目标阵营
					speed = EffectManager.EFFECT_CONST_FLY_SPEED , -- 运行速度600
				});
			effect:setFinishCallBack(function (  )
				
				self.EffectCount = self.EffectCount - 1;
				print("技能1 施法完成 --- >进入伤害逻辑阶段" ,self.EffectCount)
				if self.EffectCount <= 0 then
				 	self.fsm__:doEvent("hurttarget") ;
				end
			end)
			
			--判断目标是否死亡是否有物品爆出
			-- print("---------------------------->判断是否有掉落：" ,v.isdrop )
			-- if v.isdrop == 1 then
			-- 	aimdata:setDropType( v.dropData.droptype );
			-- 	-- print("---------------------------->设置掉落物品类型：" ,v.isdrop,v.dropData.droptype )
			-- end

		else
			print("施法：" , "目标为nil")
		end
		
	end 
end

--得到第一个目标数据
function commonAttack:getFirstAimData(  )
	for i,v in ipairs(self.AttackConfig.AimData) do
		if v then
			return v;
		end
	end
	return nil;
end

--范围攻击逻辑
function commonAttack:CastingLogic_Scope(  )
	--[[分三种
		1.单体攻击
		2.施法效果 1 对多
		3.施法效果 多 对多
	]]

	--创建施法效果
	--得到目标(范围攻击随便解析个目标)
	local data = self:getFirstAimData(  );
	if not data then
		print("error --->"..self.__cname..",223","data 为nil");
		return;
	end
	local Camp = BattleManager.CONST_CAMP_ENEMY;
	if data.aimcamp == 1 then
		Camp = BattleManager.CONST_CAMP_PLAYER;
	end
	local aimdata = BattleManager:getActorByPos( data.aimpos , Camp);
	if not aimdata then
		print("error --->"..self.__cname..",232","aimdata 为nil");
		return;
	end
	--创建技能效果
	local effect = EffectManager.CreateEffect[self.SkillCongfig.CastingEffectID]({
					name = self.SkillCongfig.name,
			release = BattleManager:getActorView( self.releaseData), --释放者
			releaseCamp = self.releaseData:getCamp(),--释放者阵营
			aim = self.AttackConfig.AimData,--BattleManager:getActorView( aimdata), -- 目标数据
			aimCamp = aimdata:getCamp(), --目标阵营
			speed = EffectManager.EFFECT_CONST_FLY_SPEED, -- 运行速度600
		});
	effect:setFinishCallBack(function ( ... )
			print("技能1 施法完成 --- >进入伤害逻辑阶段")
			self.fsm__:doEvent("hurttarget") ;
		end);
	
end

--特殊逻辑效果1
function commonAttack:CastingLogic_Special_1(  )
	--创建技能效果
	local effect = EffectManager.CreateEffect[self.SkillCongfig.CastingEffectID]({
					name = self.SkillCongfig.name,
			release = BattleManager:getActorView( self.releaseData), --释放者
			releaseCamp = self.releaseData:getCamp(),--释放者阵营
			aim = self.AttackConfig.AimData, -- 目标
			aimCamp = nil, --目标阵营()
			skillConfig = self.SkillCongfig,--技能参数
			speed = EffectManager.EFFECT_CONST_FLY_SPEED, -- 运行速度600
		});
	effect:setFinishCallBack(function ( ... )
			print("技能1 施法完成 --- >进入伤害逻辑阶段")
			self.fsm__:doEvent("hurttarget") ;
		end);
end

--[[创建技能伤害
	处理逻辑结构：
	目标伤害显示(伤害类型判断 ，创建伤害显示)
	被动buf处理(创建buf处理逻辑 ，死亡检查处理)
	buf伤害(添加buf)
	注意事项：
	1.死亡检查在各种buf执行完成后检查
	2.self.bufEffectCount 为整个伤害效果计算处理
		self.hurtBufCount 为单个伤害完成计算处理
]]
function commonAttack:CreateSkillHurt(  )
	if BattleManager.BattleState < BattleManager.CONST_STATE_ATTACK then
		-- 去除所有
		self:getComponent("components.behavior.EventProtocol"):removeAllEventListeners();
		return;
	end
	BattleManager:getActorView( self.releaseData):setZOrder(self.releaseData:getShowOrder());
	--执行伤害计数
	self.HurtCount = self.AttackConfig.HurtCount;
	print("执行伤害逻辑--->" ,self.HurtCount)
	--执行完成回调方式
	self.executeFinishType = 0;
	--buf效果总计数
	self.bufEffectCount = 0;
	--单个角色buf伤害完成计数
	self.hurtBufCount = {};
	--执行伤害逻辑
	for i,v in ipairs(self.AttackConfig.HurtData) do
		--解析目标
		local Camp = BattleManager.CONST_CAMP_ENEMY;
		if v.aimcamp == 1 then
			Camp = BattleManager.CONST_CAMP_PLAYER;
		end
		local hurtdata = BattleManager:getActorByPos( v.aimpos , Camp)

		if hurtdata and (not hurtdata:isDead()) then
			if v.IsHurt > 0 then
				---------------------伤害提示---------------------
				if v.hurtvaluse ~= 0 or v.miss > 0 then
					--解析伤害类型
					local hurttype = 1;
					if v.crit > 0 then
					 	--暴击
					 	hurttype = 2;
					end
					if v.miss > 0 then
					 	--miss
					 	hurttype = 3;
					end
					print("执行伤害逻辑--->" ,hurttype ,v.hurtvaluse);
					-- 伤害提示
					local effect = EffectManager.CreateSkillHurtEffect({
						hurtType = hurttype, --类型(比如暴击，普通伤害 ,miss)
						aim = hurtdata, -- 目标
						valuse = v.hurtvaluse, -- 值
					});
					--更新角色HP进度
					print("角色血量---------------------",v.Hp)
					hurtdata:setCurrentHp(v.Hp)
				end

				------------------目标被动buf执行处理-------------------------
				if v.bufcount > 0 then
					--执行被动buf效果 buffData
					self.executeFinishType = 1;
					self.hurtBufCount[i] = v.bufcount;

					self.bufEffectCount = self.bufEffectCount + 1;
					print("-----执行被动buf数量：",v.bufcount)
					local bufQueueManage = SkillManager:CreateSkillBufExecuteQueue(  );
					for index,bufdata in ipairs(v.buffData) do
						if bufdata then
							print("				执行被动buf信息：",bufdata.bufID,bufdata.aimcount);
							-- 创建buf效果执行
							bufQueueManage:addExecuteBuffData( bufdata );
							-- self.bufEffectCount = self.bufEffectCount + 1;
							-- local skill = SkillManager:CreateSkillBuf( {
						 --        config = bufdata,
						 --        callback = function ( ... )
						 --            self.bufEffectCount = self.bufEffectCount - 1;
						 --            self.hurtBufCount[i] = self.hurtBufCount[i] - 1;
						 --            print("			buf执行完毕--->330:",self.bufEffectCount,self.hurtBufCount[i]);
						 --            if self.hurtBufCount[i] < 1 then
						 --            	--更新角色HP进度
							-- 			print("角色死亡检查")
							-- 			hurtdata:DeadCheck(  );
						 --            end
						 --            if self.hurtBufCount[i] < 1 and self.bufEffectCount < 1 then

						 --            	if self.FinishCallBack then
							-- 				self.FinishCallBack(  );
							-- 			end
						 --            	--执行完成回调
						 --            	self.fsm__:doEvent("attackfinish") ;
							-- 			-- 去除所有
							-- 			self:getComponent("components.behavior.EventProtocol"):dumpAllEventListeners();
						 --            end
						 --         end
						 --    } )
							
						end
					end
					bufQueueManage:setFinishCallBack(function ( ... )
						--更新角色HP进度
						print("角色死亡检查")
						hurtdata:DeadCheck(  );
						self.bufEffectCount = self.bufEffectCount - 1;
						if self.bufEffectCount < 1 then
							if self.FinishCallBack then
								self.FinishCallBack();
							end
							self.fsm__:doEvent("attackfinish") ;
							-- 去除所有
							-- self:getComponent("components.behavior.EventProtocol"):dumpAllEventListeners();
						end
					end);
					bufQueueManage:ExecuteBuff( );--执行buf
				else
					--角色死亡检查
					hurtdata:DeadCheck(  );
				end
			end
			------------------目标添加buff-------------------------
			if v.bufID > 0 then
				--执行buf数据
				print("--LY--313:commonAttack-------------> 添加buff:",v.bufID);
				EffectManager.CreateBuffEffect({
					aim = BattleManager:getActorView( hurtdata),--buff作用目标
					skillID = v.bufID,--buffID
					});
			end

		end
	end
	--完成回调处理方式
	if self.executeFinishType == 0 then
		if self.FinishCallBack then
			self.FinishCallBack(  );
		end
		self.fsm__:doEvent("attackfinish") ;
		
	end
	

end

--攻击完成
function commonAttack:CreateAttackFinish(  )
	-- 攻击完成
	if self.SkillCongfig.CastingTotalDamage and self.SkillCongfig.CastingTotalDamage == 1 then
		--创建总伤害提示
		EffectManager.CreateAllHPHurtPrompt({
			valuse = self.AttackConfig.SumHurtHP, -- 值
			offsettime = 0,-- 等待时间
		});
	end
	-- 去除所有
	self:getComponent("components.behavior.EventProtocol"):removeAllEventListeners();
end

-- 技能逻辑
function commonAttack:SkillLogic(  )
	
end

-- 技能完成监听
function commonAttack:SetSkillFinishCallBak( )
	-- body
end

return commonAttack;
