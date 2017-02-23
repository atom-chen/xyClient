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
local skillbase = import(".Skill_Base")

local skillLogic_common = class("skillLogic_common", skillbase);

skillLogic_common.CONST_LOGICTYPE_POINTTO = 1;--技能施法逻辑 指向性
skillLogic_common.CONST_LOGICTYPE_SCOPE = 2;--技能施法逻辑 范围
skillLogic_common.CONST_LOGICTYPE_Special_1 = 3;--特殊逻辑1
skillLogic_common.CONST_LOGICTYPE_Special_2 = 4;--多关联逻辑

function skillLogic_common:ctor()
	skillLogic_common.super.ctor(self)
	--初始化
	self:addEventListener(self.INIT_EVENT, handler(self, self.Initialize));
	self:addEventListener(self.EVENT_STARTBUF, handler(self, self.ExecuteStartBuf));
	self:addEventListener(self.EVENT_OPEN_STORY, handler(self, self.Create_OpenStory));
	self:addEventListener(self.EVENT_SKILL_PROMPT, handler(self, self.CreateSkillPrompt));
	self:addEventListener(self.EVENT_CASTING_EFFECT, handler(self, self.CreateSkillEffect));
	self:addEventListener(self.EVENT_HURT, handler(self, self.CreateSkillHurt));
	self:addEventListener(self.EVENT_ATTACK_FINISH, handler(self, self.CreateAttackFinish));
end

--[[ 设置技能数据
	params = {
		config = nil;-- 施法参数
		callback = nil; --完成回调
	}
]]
function skillLogic_common:setData( params )
	--攻击参数 和伤害数据
	self.AttackConfig = params.config;
	--技能解析
	self.skillID = self.AttackConfig.skillID;
	self.SkillCongfig = GetSkill( self.skillID );
	print("技能ID:",self.AttackConfig.skillID,self.SkillCongfig)

	--施法者解析
	self.releaseCamp = Data_Battle_Msg:ConvertCampData( self.AttackConfig.attackcamp );
	self.releaseData = control_Combat:getActorByPos( self.AttackConfig.pos , self.releaseCamp);
	print(self.releaseCamp ,self.releaseData);
	assert(self.releaseData,"技能施法：施法者为nil 值"..self.AttackConfig.pos..","..self.releaseCamp);

	
	--运行施法动作
	self.FinishCallBack = params.callback;

	--处理消失的buf
	self:doEvent("event_buf") ;
end

--处理buff逻辑
function skillLogic_common:ExecuteStartBuf(  )
	print("skillLogic_common:ExecuteStartBuf")
	if self.AttackConfig.buffCount > 0 then
		for i,v in ipairs(self.AttackConfig.buffList) do
			if v then
				--解析buff消失的对象
				local aimCamp = Data_Battle_Msg:ConvertCampData( v.camp );
				local aim = control_Combat:getActorByPos( v.pos , aimCamp);
				print("消失的buf:",v.camp,v.pos,v.buffId,aim)
				if aim then
					aim:RemoveBuff( v.buffId );
				end
			end
		end
	end
	--判断是否弄找到技能数据
	if self.SkillCongfig then
		self:doEvent("event_openstory");
	else
		printError("skill is  nil")
		self:doEvent("event_attackfinish");
	end
end

--执行开始剧情
function skillLogic_common:Create_OpenStory( event )
	print("skillLogic_common:Create_OpenStory")
	--执行技能提示
	self:doEvent("event_skillprompt") ;
end


--技能提示
function skillLogic_common:CreateSkillPrompt(  )
	--创建技能提示
	print("skillLogic_common:CreateSkillPrompt")
	--施法者技能t提示效果ID 为0 则进行技能动作
	if (not self.SkillCongfig.CastingNameShow) or self.SkillCongfig.CastingNameShow == 0 then
		self:doEvent("event_casting") ;
		return;
	end

	print("技能提示：",self.SkillCongfig.name,self.releaseData)
	--添加技能名称
	EffectManager.CreateBattleSkillPrompt({
		target = self.releaseData, 
		name = self.SkillCongfig.name,
	},function (  )
		self:doEvent("event_casting") ;
	end);
end


--得到第一个目标数据
function skillLogic_common:getFirstAimData(  )
	for i,v in ipairs(self.AttackConfig.AimData) do
		if v then
			return v;
		end
	end
	return nil;
end

--范围攻击逻辑
function skillLogic_common:CreateSkillEffect( event )
	print("skillLogic_common:CreateSkillEffect")
	--[[分三种
		1.单体攻击
		2.施法效果 1 对多
		3.施法效果 多 对多
	]]
	-- 释放技能效果
	if self.SkillCongfig.CastingEffectID == 0 then
		self:doEvent("event_hurt") ;
		return;
	end

	--创建施法效果
	--得到目标(范围攻击随便解析个目标)
	local data = self:getFirstAimData(  );
	if not data then
		print("error --->"..self.__cname..",223","data 为nil");
		return;
	end
	local Camp = Data_Battle_Msg:ConvertCampData( data.aimcamp );
	local aimdata = control_Combat:getActorByPos( data.aimpos , Camp);
	if not aimdata then
		print("error --->"..self.__cname..",232","aimdata 为nil");
		return;
	end
	if EffectManager.CreateEffect[self.SkillCongfig.CastingEffectID] then
		--创建技能效果
		local effect = EffectManager.CreateEffect[self.SkillCongfig.CastingEffectID]({
				name = self.SkillCongfig.name,
				release = self.releaseData, --释放者
				releaseCamp = self.releaseData:getCamp(),--释放者阵营
				aimData = self.AttackConfig.AimData,-- 目标数据
				aimCamp = aimdata:getCamp(), --目标阵营
				hurtData = self.AttackConfig.HurtData,--伤害数据
			});
		effect:setFinishCallback(function (  )
				print("技能1 施法完成 --- >进入伤害逻辑阶段")
				self:doEvent("event_hurt") ;
			end);

	else
		local effect = EffectManager.CreateSkillDescribe({
				name = self.SkillCongfig.name,
				release = self.releaseData, --释放者
				releaseCamp = self.releaseData:getCamp(),--释放者阵营
				aimData = self.AttackConfig.AimData,-- 目标数据
				aimCamp = aimdata:getCamp(), --目标阵营
				hurtData = self.AttackConfig.HurtData,--伤害数据
			});
		effect:setFinishCallback(function (  )
				print("技能1 施法完成 --- >进入伤害逻辑阶段")
				self:doEvent("event_hurt") ;
			end);
	end
	
	
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
function skillLogic_common:CreateSkillHurt(  )
	print("skillLogic_common:CreateSkillHurt")
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
		local Camp = Data_Battle_Msg:ConvertCampData( v.aimcamp );
		local hurtdata = control_Combat:getActorByPos( v.aimpos , Camp);

		if hurtdata and (not hurtdata:isDead()) then
			if v.IsHurt > 0 then
				---------------------伤害提示---------------------
				
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
						end
					end
					bufQueueManage:setFinishCallBack(function (  )
						--更新角色HP进度
						print("角色死亡检查")
						hurtdata:DeadCheck(  );
						self.bufEffectCount = self.bufEffectCount - 1;
						if self.bufEffectCount < 1 then
							self:doEvent("event_attackfinish") ;
						end
					end);
					bufQueueManage:ExecuteBuff( );--执行buf
				else
					--角色死亡检查
					hurtdata:DeadCheck();
				end

				------------------目标添加buff-------------------------
				if v.bufID > 0 then
					--执行buf数据
					print("伤害-------------> 添加buff:",v.bufID);
					bufManager:CreateBuf({
						aim = hurtdata,--buff作用目标
						skillID = v.bufID,--buffID
						});
				end
			end
		end
	end
	--完成回调处理方式
	if self.executeFinishType == 0 then
		self:doEvent("event_attackfinish") ;
	end
	

end

--攻击完成
function skillLogic_common:CreateAttackFinish( event )
	-- 攻击完成创建总伤害
	-- if self.SkillCongfig.CastingTotalDamage and self.SkillCongfig.CastingTotalDamage == 1 then
	-- 	--创建总伤害提示
	-- 	EffectManager.CreateAllHPHurtPrompt({
	-- 		valuse = self.AttackConfig.SumHurtHP, -- 值
	-- 		offsettime = 0,-- 等待时间
	-- 	});
	-- end
	if self.FinishCallBack then
		self.FinishCallBack(  );
	end
	-- 去除所有
	self:removeAllEventListeners();
end


-- 技能完成监听
function skillLogic_common:SetSkillFinishCallBak( )
	-- body
end

return skillLogic_common;
