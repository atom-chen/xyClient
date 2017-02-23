--
-- Author: liYang
-- Date: 2015-06-15 11:40:29
-- 战场服务器数据

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_WAR_HOOK_DATA) --挂机战斗数据
]]

local model_msg = class("model_msg")

function model_msg:ctor()
	--场景ID
	-- self.SceneID = 1;
	-- --战场攻击方角色
	-- self.attackcamp = {};
	-- --防守方角色
	-- self.defendcamp = {};
	-- --战斗数据
	-- self.fightData = {};
	-- --战斗结果数据
	-- self.ResultData = {};
	-- --战斗编码
	-- self.BattleCode = 0;

	self:_registGlobalEventListeners();
	--数据执行列表
	self.dataList = {};

	--每个记录执行数据
	self.currentEcecuteIndex = 0;

	self.count = 0;

	--执行队列的长度
	self.QueueLen = 1;

	-- self:setTestData();
end

--注册全局事件监听器
function model_msg:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		--挂机战斗数据
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_WAR_HOOK_DATA), callBack=handler(self, self.createBattlefieldLogic)},
		--挑战boss战斗数据
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_WAR_BOSS_RESULT), callBack=handler(self, self.createBattlefieldLogic)},
		--奇遇战斗数据
		{modelName = "netMsg", eventName = "qiyu_result", callBack=handler(self, self.createBattlefieldLogic)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--得到回合数据
function model_msg:get_BattleBoutData( Schedule , boutcount )
	return self.fightData[Schedule][boutcount];
end

--保存数据
function model_msg:SaveBattleData( battleData )
	--保存角色数据
	local roleStrData = serialize(battleData);
	local path = string.gsub(device.writablePath, "[\\\\/]+$", "") .. "/BattleData.txt";
	ManageResUpdate:writeFile(path, roleStrData);

end

--添加战斗的执行数据
function model_msg:addExecuteFightData( data )
	if self.currentEcecuteIndex + self.QueueLen == self.count then
		print("数据执行队列满了")
		return;
	end
	self.count = self.count + 1;
	self.dataList[self.count] = data;
end

function model_msg:removeFightData( index )
	self.dataList[index] = nil;
end

--更新执行数据
function model_msg:updateExecuteData(  )
	--清除显示的数据
	self.dataList[self.currentEcecuteIndex] = nil;
	self.currentEcecuteIndex = self.currentEcecuteIndex + 1;
end

--得到当前战斗数据
function model_msg:getCurrentFightData()
	return self.dataList[self.currentEcecuteIndex];
end

--解析战场数据
function model_msg:analysisBattleData( msg ,fightType , des)
	local battleData = {};
	battleData.fightType = fightType;
	battleData.describe = des;--描述信息
	self:addExecuteFightData( battleData );
	battleData.SceneID = 1;
	--战场攻击方角色
	battleData.attackcamp = {};
	--防守方角色
	battleData.defendcamp = {};
	--战斗数据
	battleData.fightData = {};
	--战斗结果数据
	battleData.ResultData = {};
	--战斗编码
	battleData.BattleCode = 0;

	--设置战斗关卡
	--战斗结果
	battleData.battleResult = msg:ReadIntData();
	printInfo("战斗结果 = %s", battleData.battleResult);
	--跳过时间
	battleData.skipTime = msg:ReadIntData();
	--攻防总伤害
	battleData.AttackSumHurt = msg:ReadIntData();

	battleData.ResultData.AttackSumHurt = battleData.AttackSumHurt;
	--战斗场景ID
	battleData.SceneID = msg:ReadIntData();
	
	--最大回合数
	battleData.MaxBoutCount = msg:ReadIntData();
	printInfo("跳过时间 = %s场景ID = %s,最大回合数 = %s ,攻击总伤害 = %s",
		battleData.skipTime,
		battleData.SceneID,
		battleData.MaxBoutCount,
		battleData.AttackSumHurt);
	--攻击方士气
	battleData.AttackMorale = msg:ReadIntData();
	--攻击方队伍数量
	local attackcampactorCount = msg:ReadIntData();
	battleData.attackcampactorCount = attackcampactorCount;
	printInfo("战场攻击方队伍数量：%s ,士气值 = %s",attackcampactorCount,battleData.AttackMorale)
	for i=1,attackcampactorCount do
		battleData.attackcamp[i] = {};
		battleData.attackcamp[i].formation = msg:ReadIntData();--阵型ID
		--首发整容个数
		local firstcount = msg:ReadIntData();
		printInfo("   队伍 %s",i..","..battleData.attackcamp[i].formation..",数量:"..firstcount);
		local firstlist = {};
		battleData.attackcamp[i].FirstList = firstlist;
		for i=1,firstcount do

			firstlist[i] = {};
			firstlist[i].actorID = msg:ReadIntData();--角色id
			firstlist[i].BossMark = msg:ReadIntData();--boss标示
			firstlist[i].pos = msg:ReadIntData();--阵型位置
			-- AddHeroResByHeroID( firstlist[i].actorID, 1 ,false);
			printInfo("               首发%s" ,"位置:"..firstlist[i].pos.." ,id:"..firstlist[i].actorID..",boss标示："..firstlist[i].BossMark );
		end

		local twocount = msg:ReadIntData();
		print("替补位置:",twocount)
		local twolist = {};
		battleData.attackcamp[i].TwoList = twolist;
		for i=1,twocount do
			twolist[i] = {};
			twolist[i].actorID = msg:ReadIntData();--角色id
			twolist[i].BossMark = msg:ReadIntData();--boss标示
			printInfo("               替补%s" ,"位置:"..i.." ,id:"..twolist[i].actorID..",boss标示："..twolist[i].BossMark );
		end
	end
	--防守方士气
	battleData.defendcampactorMorale = msg:ReadIntData();
	--防守方队伍数量
	local defendcampactorCount = msg:ReadIntData();
	--总的防守方队伍数量
	battleData.SumSegments = defendcampactorCount;
	battleData.defendcampactorCount = defendcampactorCount;
	printInfo("战场防守方队伍数量：%s ,士气值 = %s",defendcampactorCount,battleData.defendcampactorMorale)
	for i=1,defendcampactorCount do
		battleData.defendcamp[i] = {};
		battleData.defendcamp[i].formation = msg:ReadIntData();--阵型ID
		printInfo("   队伍 %s",i..","..battleData.attackcamp[i].formation);
		--首发整容个数
		local firstcount = msg:ReadIntData();
		local firstlist = {};
		battleData.defendcamp[i].FirstList = firstlist;
		for i=1,firstcount do
			
			firstlist[i] = {};
			firstlist[i].actorID = msg:ReadIntData();--角色id
			firstlist[i].BossMark = msg:ReadIntData();--boss标示
			firstlist[i].pos = msg:ReadIntData();--阵型位置
			-- AddHeroResByHeroID( firstlist[i].actorID, 1 ,false);
			printInfo("               首发%s" ,"位置:"..firstlist[i].pos.." ,id:"..firstlist[i].actorID..",boss标示："..firstlist[i].BossMark );
		end

		local twocount = msg:ReadIntData();
		local twolist = {};
		battleData.defendcamp[i].TwoList = twolist;
		for i=1,twocount do
			twolist[i] = {};
			twolist[i].actorID = msg:ReadIntData();--角色id
			twolist[i].BossMark = msg:ReadIntData();--boss标示
			printInfo("               替补%s" ,"位置:"..i.." ,id:"..twolist[i].actorID..",boss标示："..twolist[i].BossMark );
		end
	end
	
	-- BattleRes.recordUseNeed = {};
	--对战局数
	local inningsCount = msg:ReadIntData();
	battleData.fightData.InningsCount = inningsCount;
	battleData.fightData.InningsData = {};
	printInfo("对战局数：%s" , inningsCount)
	for i=1,inningsCount do
		local unitInningsData = {};
		--攻击方阵营
		local attackCampId = msg:ReadIntData();
		local count = msg:ReadIntData();
		printInfo("   攻击方队伍: %s 阵型ID: %s",attackCampId,battleData.attackcamp[attackCampId].formation);
		local attackActor = {};--攻击者本局信息
		for unit_i=1,count do
			attackActor[unit_i] = {};
			local actorpos = msg:ReadIntData();--pos
			local actorHP = msg:ReadIntData(); --血量
			--最大血量
			local maxHP = msg:ReadIntData(); --最大血量

			printInfo("          位置: %d,CurrentHP: %d ,maxHP: %s", actorpos,actorHP,maxHP);
			attackActor[unit_i].pos = actorpos;
			attackActor[unit_i].actorHP = actorHP;
			attackActor[unit_i].maxHP = maxHP;
		end

		unitInningsData.AttackActor = attackActor;
		unitInningsData.AttackTeamId = attackCampId;
		-- 防守方阵营
		local defendCampId = msg:ReadIntData();
		local count = msg:ReadIntData();
		printInfo("   防守方队伍: %s ,阵型ID: %s",defendCampId,battleData.defendcamp[defendCampId].formation)
		local defendActor = {};--防守者本局信息
		for unit_i=1,count do
			defendActor[unit_i] = {};
			local actorpos = msg:ReadIntData();--pos
			local actorHP = msg:ReadIntData(); --血量
			local maxHP = msg:ReadIntData(); --最大血量
			printInfo("          位置: %d,CurrentHP: %d ,maxHP : %s", actorpos,actorHP,maxHP);
			defendActor[unit_i].pos = actorpos;
			defendActor[unit_i].actorHP = actorHP;
			defendActor[unit_i].maxHP = maxHP;
		end
		unitInningsData.DefendActor = defendActor;
		unitInningsData.DefendTeamId = attackCampId;
		--被动buff
		local cardCount = msg:ReadIntData();--拥有被动技能的卡牌数量
		printInfo("   第%d局，被动buff拥有数量:%d",i,cardCount);
		unitInningsData.PassivityBufCount = cardCount;--被动技能数量
		unitInningsData.PassivityBuf = {};--被动技能
		local index = 1;
		for i=1,cardCount do
			local camp = msg:ReadIntData();--正营
			local pos = msg:ReadIntData();--位置
			local buffcount = msg:ReadIntData();--buff数量
			printInfo("		 位置：%d,正营：%d,buff数量: %d",pos,camp,buffcount);
			for j=1,buffcount do
				local buffID = msg:ReadIntData();--buffID
				-- BattleRes:AddUseRecord( 2 , buffID );
				printInfo("			  buffID:%d",buffID);
				local bufdata = {};
				bufdata.aimcamp = camp;
				bufdata.aimpos = pos;
				bufdata.bufID = buffID;
				unitInningsData.PassivityBuf[index] = bufdata;
				index = index + 1;
			end
		end

		-- 回合数
		local boutCount = msg:ReadIntData();
		unitInningsData.attackCampId = attackCampId;
		unitInningsData.defendCampId = defendCampId;
		unitInningsData.boutCount = boutCount;
		unitInningsData.boutData = {};
		printInfo("第%d局，攻击方阵营：%s ,防守阵营: %s ,回合数:%d",i,attackCampId,defendCampId,boutCount);
		for j=1,boutCount do
			-- 单位回合数据
			local unitBoutData = {};
			--buff执行数据(回合开始的buff执行数据)
			local buffcount = msg:ReadIntData();
			unitBoutData.buffcount = buffcount;
			unitBoutData.BeforeBoutData = {};
			printInfo("   第%d回合 ,行动前执行buff单位数量:%d",j,buffcount) 
			for k=1,buffcount do
				--回合前数据
				local beforeBoutData = {};
				--单位正营
				local camp = msg:ReadIntData();
				--单位位置
				local pos = msg:ReadIntData();
				--单位最终血量
				local hp = msg:ReadIntData();
				--单位buff动作数
				local count = msg:ReadIntData();
				beforeBoutData.buffData = {};
				printInfo("           	 行动前单位 %s",k..",正营:"..camp..",位置:"..pos..",剩余血量："..hp..",执行的buff数量："..count);
				for f=1,count do
					beforeBoutData.buffData[f] = {};
					beforeBoutData.buffData[f].affectAim = {};
					-- buf ID
					local buffID = msg:ReadIntData();
					--buff对HP造成的伤害
					local buffhurtvaluse = msg:ReadIntData();

					-- BattleRes:AddUseRecord( 2 , buffID );
					beforeBoutData.buffData[f].bufID = buffID;--buf ID
					beforeBoutData.buffData[f].releasecamp = camp;--施法者阵营
					beforeBoutData.buffData[f].releasepos = pos;--施法者位置
					beforeBoutData.buffData[f].aimcount = 1;--影响目标的数量
					beforeBoutData.buffData[f].executeMark = 2;--执行标示(回合开始前)

					local affectaim = {};--影响的目标
					affectaim.aimcamp = camp;--目标阵营
					affectaim.aimpos = pos;--目标位置
					affectaim.hurtvaluse = buffhurtvaluse;--伤害测血量
					affectaim.hp = -1;--剩余血量
					affectaim.isDead = false;
					if hp <= 0 then
						affectaim.isDead = true;
					end
					beforeBoutData.buffData[f].affectAim[1] = affectaim;
					
					printInfo("           		buff--> %s",f..",buffID:"..buffID..",伤害:"..buffhurtvaluse);

				end
				beforeBoutData.camp = camp;
				beforeBoutData.pos = pos;
				beforeBoutData.hp = hp;
				beforeBoutData.count = count;
				unitBoutData.BeforeBoutData[k] = beforeBoutData; 
			end
			--整容替换
			-- 数量
			-- {方向 ,位置 ，替补索引}
			local replacecount = msg:ReadIntData();--替换数量
			printInfo("   第%d回合 ,行动替换单位数量:%d",j,replacecount) 
			unitBoutData.replacecount = replacecount;
			unitBoutData.replaceList = {};
			for i=1,replacecount do
				local replacecamp = msg:ReadIntData();--替换阵营
				local replacepos = msg:ReadIntData();--替换位置
				local replaceindex = msg:ReadIntData();--替补索引
				unitBoutData.replaceList[i] = {};
				unitBoutData.replaceList[i].replacecamp = replacecamp;
				unitBoutData.replaceList[i].replacepos = replacepos;
				unitBoutData.replaceList[i].replaceindex = replaceindex;
				printInfo("           	 阵营 %d 位置 %d ，替换 %d" ,replacecamp ,replacepos ,replaceindex);
			end
			-- 单位行动数量
			local actionCount = msg:ReadIntData();
			unitBoutData.actionCount = actionCount;
			unitBoutData.actionData = {};
			printInfo("   第%d回合 ,单位行动数:%d",j,actionCount) 
			for l=1,actionCount do
				printInfo("		第%s回合 ,行动数 %s",j,l);
				local UnitActionData = {};

				--行动前，消失的buff（全阵营）列表
				--建议只管自己
				local buffCount = msg:ReadIntData();
				printInfo("			单位行动前消失的buff数量:%d",buffCount) 
				local buffList = {};
				for m=1,buffCount do
					local buffData = {};
					-- 阵营方向
					buffData.camp = msg:ReadIntData();
					-- 位置
					buffData.pos = msg:ReadIntData();
					-- 消失的buffid
					buffData.buffId = msg:ReadIntData();
					-- BattleRes:AddUseRecord( 2 , buffData.buffId );
					buffList[m] = buffData;
					printInfo("				单位行动前消失的buff: %s %s %s ",buffData.camp,buffData.pos,buffData.buffId);
				end
				UnitActionData.buffCount = buffCount;
				UnitActionData.buffList = buffList;
				
				-- 行动单位阵营
				local attackcamp = msg:ReadIntData();
				-- 位置
				local pos = msg:ReadIntData();
				-- 技能ID
				local skillID = msg:ReadIntData();
				-- BattleRes:AddUseRecord( 1 , skillID );
				--目标数量(0 为全体正营 )
				-- local targetCount = 1
				-- for m=1,targetCount do
				-- 	local targetCamp = 1 ; --目标阵营
				-- 	local targetpos = 1 ;--目标位置
				-- end

				UnitActionData.attackcamp = attackcamp;
				UnitActionData.pos = pos;
				UnitActionData.skillID = skillID;
				UnitActionData.HurtCount = 0;--受伤数量
				--技能ID为0 则 不会有后面的数据
				if skillID ~= 0 then
					-- 受伤的数量
					local hurtCount = msg:ReadIntData();
					UnitActionData.HurtCount = hurtCount;
				else
					--todo
				end
				UnitActionData.AimData = {}; --目标数据
				UnitActionData.HurtData = {};--伤害数据
				UnitActionData.SumHurtHP = 0;--总伤害数量
				-- self.SpecialLogicConfig = {};
				printInfo("			行动单位 {%d} ,阵营: %s,pos:%s,skillID:%s,目标数量：%s,消失的buff数量：%s",
					l,
					attackcamp,
					pos,
					skillID,
					UnitActionData.HurtCount,
					buffCount );
				UnitActionData.AimCount = 0; --目标数量
				for h=1,UnitActionData.HurtCount do
					printInfo("				伤害目标 %s 信息",h);
					local SpecialLogicData = nil;
					local UnitAimData = {};
					-- 目标阵营
					local aimcamp = msg:ReadIntData();
					-- 目标pos
					local aimpos = msg:ReadIntData();
					-- 目标类型 1 主目标 2 受牵连
					local aimtype = msg:ReadIntData();
					-- 伤害buf id
					local bufID = msg:ReadIntData();
					-- BattleRes:AddUseRecord( 2 , bufID );
					--是否有伤害
					local IsHurt = msg:ReadIntData();
					UnitAimData.IsHurt = IsHurt;
					UnitAimData.aimcamp = aimcamp;
					UnitAimData.aimpos = aimpos;
					UnitAimData.aimtype = aimtype;
					UnitAimData.bufID = bufID;
					if IsHurt ~= 0 then
						-- 目标是否miss
						local miss = msg:ReadIntData();
						-- 目标是否暴击
						local crit = msg:ReadIntData();
						-- 伤害值
						local hurtvaluse = msg:ReadIntData();
						--受影响单位剩余血量
						local Hp = msg:ReadIntData();

						
						UnitAimData.miss = miss;
						UnitAimData.crit = crit;
						UnitAimData.hurtvaluse = hurtvaluse;
						UnitAimData.Hp = Hp;
						UnitActionData.SumHurtHP = UnitActionData.SumHurtHP + hurtvaluse;
						
						-- buff数量
						local bufcount = msg:ReadIntData();
						UnitAimData.bufcount = bufcount;
						UnitAimData.buffData = {};
						printInfo("					目标单位:%s ,是否有被动动buf：%s",h,bufcount);
						for b=1,bufcount do
							local buf = {};
							--产生行为的BUFF_ID
							local bufID = msg:ReadIntData();
							-- BattleRes:AddUseRecord( 2 , bufID );
							--产生的行为buf是否消失
							local isvanish = msg:ReadIntData();
							--目标的数量
							local aimcount = msg:ReadIntData();

							buf.bufID = bufID;
							buf.isvanish = isvanish;
							buf.aimcount = aimcount;
							buf.releasecamp = aimcamp;--施法者阵营
							buf.releasepos = aimpos;--施法者位置
							buf.executeMark = 3;--执行标示(收到攻击后的执行)

							print("						受到buf伤害",bufID,aimcount,isvanish);
							buf.affectAim = {};
							-- TypeId = 10, --逻辑ID
							-- buffData = nil,--buf伤害数据
							-- skillHurtData = nil, -- 技能伤害数据
							SpecialLogicData = {};
							SpecialLogicData.TypeId = bufID;
							for c=1,aimcount do
								local affectaim = {};
								--受影响的单位的方向
								local aimcamp = msg:ReadIntData();
								--受影响单位所在位置
								local aimpos = msg:ReadIntData();
								--受影响单位收到的伤害
								local hurtvaluse = msg:ReadIntData();
								--受影响单位剩余血量
								local hp = msg:ReadIntData();
								--是否有新增加buff
								local newsbuff = msg:ReadIntData();
								if newsbuff > 0 then
									-- BattleRes:AddUseRecord( 2 , newsbuff );
								end
								print("						目标：",aimcamp,aimpos,hurtvaluse,hp,newsbuff);
								affectaim.aimcamp = aimcamp;
								affectaim.aimpos = aimpos;
								affectaim.hurtvaluse = hurtvaluse;
								affectaim.Hp = hp;
								affectaim.newsbuff = newsbuff;
								buf.affectAim[c] = affectaim;
							end
							
							UnitAimData.buffData[b] = buf;
							SpecialLogicData.buffData = buf;
						end
					else
						UnitAimData.miss = 0;
						UnitAimData.crit = 0;
						UnitAimData.hurtvaluse = 0;
						UnitAimData.Hp = 0;
						UnitAimData.bufcount = 0;
						UnitAimData.bufData = {};
					end
					-- 是否有掉落
					-- local isdrop = msg:ReadIntData();
					
					-- UnitAimData.isdrop = isdrop;
					-- UnitAimData.dropData = {};
					printInfo("					目标单位:%s,阵营:%s,pos:%s,是否是主目标：%s，是否受到buf：%s，是否有伤害：%s，是否miss：%s，是否暴击：%s，伤害值：%s,剩余血量:%s",
						h,
						aimcamp,
						aimpos,
						aimtype,
						bufID,
						IsHurt,
						UnitAimData.miss,
						UnitAimData.crit,
						UnitAimData.hurtvaluse,
						UnitAimData.Hp);
					-- 目标数据
					UnitActionData.HurtData[h] = UnitAimData;
					-- 伤害数据
					if aimtype == 1 then
						UnitActionData.AimCount = UnitActionData.AimCount + 1;
						UnitActionData.AimData[UnitActionData.AimCount] = UnitAimData;
					end
					
					-- if SpecialLogicData then
					-- 	self.SpecialLogicConfig[SpecialLogicData] = SpecialLogicData;
					-- end
				end
				-- 行动数据
				unitBoutData.actionData[l] = UnitActionData;
				--一些因为后端逻辑执行先后顺序 和前端表现顺序产生错误后的 特殊处理
				-- for k,v in pairs(self.SpecialLogicConfig) do
				-- 	if v then
				-- 		v.skillHurtData = UnitActionData.HurtData;
				-- 		self:ExecuteSpecialLogic(v);
				-- 	end
				-- end
			end
			-- 回合数据
			unitInningsData.boutData[j] = unitBoutData;
		end
		battleData.fightData.InningsData[i] = unitInningsData;
	end
	print("战斗数据解析完成");
	return battleData;
	
end

--特殊逻辑参数
--[[
	params = {
		TypeId = 10, --逻辑ID
		buffData = nil,--buf伤害数据
		skillHurtData = nil, -- 技能伤害数据
	}
]]
model_msg.SpecialLogicConfig = {};

--执行被动buf特殊逻辑
--一些因为后端逻辑执行先后顺序 和前端表现顺序产生错误后的 特殊处理
function model_msg:ExecuteSpecialLogic( params )
	if params.TypeId == 1726 then
		--治疗共享
		local gxActor = params.buffData.affectAim[1]
		if not gxActor then
			return;
		end
		-- gxActor.aimcamp = aimcamp;
		-- gxActor.aimpos = aimpos;
		-- gxActor.hurtvaluse = hurtvaluse;
		-- gxActor.hp = hp;
		-- local actorID = gxActor.;--资料的角色ID
		for k,v in pairs(params.skillHurtData) do
			if v and v.aimcamp == gxActor.aimcamp and v.aimpos == gxActor.aimpos  then
				-- v.aimcamp = aimcamp;
				-- v.aimpos = aimpos;
				-- v.aimtype = aimtype;
				-- v.bufID = bufID;
				-- v.miss = miss;
				-- v.crit = crit;
				-- v.hurtvaluse = hurtvaluse;
				gxActor.hp = v.Hp;
				v.Hp = v.Hp - gxActor.hurtvaluse;
				return;
			end
		end
	elseif params.TypeId == 1710 then
		--伤害转换为治疗
		local gxActor = params.buffData.affectAim[1]
		if not gxActor then
			return;
		end
		local isDelet = false;
		for k,v in pairs(params.skillHurtData) do
			if v and v.aimcamp == gxActor.aimcamp and v.aimpos == gxActor.aimpos  then
				if v.Hp <= 0 then
					isDelet = true;
				end
				break;
			end
		end
		-- buf.releasecamp = aimcamp;--施法者阵营
		-- buf.releasepos = aimpos;
		if not isDelet then
			return;
		end
		local markpos = 0;
		for k,v in pairs(params.skillHurtData) do
			if v and v.buffData then
				for j,k in pairs(v.buffData) do
					if k and k.bufID == 1710 and 
						k.releasecamp == params.buffData.releasecamp and 
						k.releasepos == params.buffData.releasepos then
						v.buffData[j] = nil;
						v.bufcount = v.bufcount - 1;
						-- markpos = j;
						return;
					end
				end
			end
		end
	end
end

--得到战斗局数据
function model_msg:getCombatInningData( index )
	return self:getCurrentFightData().fightData.InningsData[index];
end

--[[得到回合数据
]]
function model_msg:getBoutData( inningindex , boutindex )
	local inningdata = self:getCombatInningData( inningindex );
	if not inningdata then
		return nil;
	end
	return inningdata.boutData[boutindex];
end

--转换阵营数据
function model_msg:ConvertCampData( msgcamp )
	local Camp = Data_Battle.CONST_CAMP_ENEMY;
	if msgcamp == 1 then
		Camp = Data_Battle.CONST_CAMP_PLAYER;
	end
	return Camp;
end

--解析
function model_msg:analysisAttackAimProtagonistCount( msgdata )
	local count = 0;
	for k,v in pairs(msgdata) do
		if v.aimtype == 1 then
			count = count + 1;
		end
	end
	return count;
end

--解析攻击的主目标
function model_msg:analysisAttackAimProtagonist( msgdata )
	local count = 0;
	local aimlist = {};
	for k,v in pairs(msgdata) do
		if v.aimtype == 1 then
			count = count + 1;
			aimlist[count] = v;
		end
	end
	return aimlist , count;
end

--[[解析攻击主要目标的第一个
	主要用于单对单 技能
]]
function model_msg:analysisAttackAimProtagonistFirst( msgdata ,executeMark)
	for k,v in pairs(msgdata) do
		--表示是被动技能数据
		if executeMark == 3 then
			return v;
		end
		if v.aimtype == 1 then
			return  v ;
		end
	end
	return nil;
end

function model_msg:analysisAttackAimBy( msgdata ,pos )
	for i,v in ipairs(msgdata) do
		--解析目标
		if pos == v.aimpos then
			local Camp = self:ConvertCampData( v.aimcamp );
			local hurtAim = control_Combat:getActorByPos( v.aimpos , Camp);
			return hurtAim
		end
	end
	return nil;
end

--[[解析伤害类型
	1 普通伤害
	2 暴击伤害
	3 miss
]]
function model_msg:analysisHurtType( msgdata)
	--解析伤害类型

	local hurttype = 1;
	if msgdata.crit > 0 then
	 	--暴击
	 	hurttype = 2;
	end
	if msgdata.miss > 0 then
	 	--miss
	 	hurttype = 3;
	end
end

-- function model_msg:analysisHurtDataExecute( ... )
-- 	-- body
-- end


--[[解析技能伤害数据执行逻辑
	msgdata 伤害数据
	pos [数据对象 nil将全部执行]
]]
function model_msg:analysisSkillHurtDataExecuteLogic( msgdata , pos )
	--执行伤害逻辑
	local function isexecute( aimpos )
		if not pos then
			return true;
		else
			if pos == aimpos then
				return true;
			end
		end
	end
	for i,v in ipairs(msgdata) do
		--解析目标
		local isexecute = isexecute( v.aimpos );
		local Camp = self:ConvertCampData( v.aimcamp );
		local hurtAim = control_Combat:getActorByPos( v.aimpos , Camp);
		if hurtAim and (not hurtAim:isDead()) and isexecute then
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
				HurtPromptManager:AddPromptObject( {
					hurtType = hurttype, --类型(比如暴击，普通伤害 ,miss)
					aim = hurtAim, -- 目标
					valuse = v.hurtvaluse, -- 值
				} );
				--设置剩余血量
				if v.Hp == -1 then
					hurtAim:UpDataCurrentHp( v.hurtvaluse ,v.isDead);
				else
					hurtAim:updata_hp(v.Hp);
				end
			end
			------------------目标添加buff-------------------------
			-- if v.newsbuff and v.newsbuff > 0 then
			-- 	--执行buf数据
			-- 	print("--LY--313:commonAttack-------------> 添加buff:",v.bufID);
			-- 	-- EffectManager.CreateBuffEffect({
			-- 	-- 	aim = BattleManager:getActorView( hurtdata),--buff作用目标
			-- 	-- 	skillID = v.bufID,--buffID
			-- 	-- 	});
			-- end
		end
		if isexecute and pos then
			return;
		end
	end
end

function model_msg:analysisBufHurtDataExecuteLogic( msgdata , pos )
	--执行伤害逻辑
	local function isexecute( aimpos )
		if not pos then
			return true;
		else
			if pos == aimpos then
				return true;
			end
		end
	end

	for i,v in ipairs(msgdata) do
		--解析目标
		local isexecute = isexecute( v.aimpos );
		local Camp = self:ConvertCampData( v.aimcamp );
		local hurtAim = control_Combat:getActorByPos( v.aimpos , Camp);
		if hurtAim and (not hurtAim:isDead()) and isexecute then
			if v.IsHurt > 0 then
				---------------------伤害提示---------------------
				if v.hurtvaluse ~= 0 or v.miss > 0 then
					print(v.miss,v.hurtvaluse,v.IsHurt)
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
					--添加伤害提示
					HurtPromptManager:AddPromptObject( {
						hurtType = hurttype, --类型(比如暴击，普通伤害 ,miss)
						aim = hurtAim, -- 目标
						valuse = v.hurtvaluse, -- 值
						} );
					--更新角色HP进度
					print("角色血量---------------------",v.Hp)
					-- hurtAim:setCurrentHp(v.Hp)
				end
			end

			-- ------------------目标添加buff-------------------------
			-- if v.bufID > 0 then
			-- 	--执行buf数据
			-- 	print("伤害-------------> 添加buff:",v.bufID);
			-- 	bufManager:CreateBuf({
			-- 		aim = hurtAim,--buff作用目标
			-- 		skillID = v.bufID,--buffID
			-- 		});
			-- end
		end
		if isexecute and pos then
			return;
		end
	end
end

--解析战斗资源数据
function model_msg:analysisBattleDataRes( data )
	--解析角色数据

end

--[[
	初始化每局资源
	data 目标数据
	inning 局数
	operation 操作函数
]]
function model_msg:analysisInviInningsRes( data , inning ,operation)
	local inningdata = data.fightData.InningsData[inning];
	--初始化角色资源(入场 idle)
	--攻击方
	local attackcampActor = data.attackcamp[inningdata.AttackTeamId];
	for k,v in pairs(attackcampActor.FirstList) do
		-- print("model_msg:analysisInviInningsRes",v.actorID,inningdata.AttackTeamId)
		if v.actorID > 0 then
			local reslist ,armaturelist = ManagerBattleRes:analysisActorActionRes( v.actorID ,Data_Battle.CONST_CAMP_PLAYER , "entrance" );
			-- print("model_msg:analysisInviInningsRes",table.nums(armaturelist))
			ManagerBattleRes:addDynamicRes( reslist ,armaturelist,operation);
			reslist,armaturelist = ManagerBattleRes:analysisActorActionRes( v.actorID ,Data_Battle.CONST_CAMP_PLAYER , "idle" );
			ManagerBattleRes:addDynamicRes( reslist ,armaturelist,operation);
		end
	end
	--防守方
	local defendcampActor = data.defendcamp[inningdata.DefendTeamId];
	for k,v in pairs(defendcampActor.FirstList) do
		-- print("model_msg:analysisInviInningsRes",v.actorID,inningdata.DefendTeamId)
		if v.actorID > 0 then
			local reslist,armaturelist = ManagerBattleRes:analysisActorActionRes( v.actorID ,Data_Battle.CONST_CAMP_ENEMY , "entrance" );
			ManagerBattleRes:addDynamicRes( reslist ,armaturelist,operation);
			reslist ,armaturelist = ManagerBattleRes:analysisActorActionRes( v.actorID ,Data_Battle.CONST_CAMP_ENEMY , "idle" );
			ManagerBattleRes:addDynamicRes( reslist ,armaturelist,operation);
		end
	end
	--解析回合数据
	for i,v in ipairs(inningdata.boutData) do
		self:analysisBoutRes( data , v ,operation);
	end
end

--[[解析回合资源
	data 局数据
	boutData 回合数据
]]
function model_msg:analysisBoutRes( data ,boutData ,operation)
	for i,v in ipairs(boutData.actionData) do
		local skillID = v.skillID;
		local releasecamp = self:ConvertCampData( v.attackcamp )
		-- attackcamp = 1,
		-- pos = 1,
		local templeID = self:analysisAimActor( data ,v.pos , releasecamp );
		local reslist,armaturelist = ManagerBattleRes:analysisSkillIDRes( skillID , templeID ,releasecamp);
		ManagerBattleRes:addDynamicRes( reslist ,armaturelist,operation);
	end
end

--解析回合释放的资源
function model_msg:analysisBoutDestroyRes( boutData )
	
end

--解析每局释放的资源
function model_msg:analysisInningsDestroyRes( inning )
	
end

--[[解析目标角色
	data 数据
	pos 位置 
	camp 阵营
]]
function model_msg:analysisAimActor( data , pos , camp )
	local actorlist = nil;
	if camp == Data_Battle.CONST_CAMP_PLAYER then
		actorlist = data.attackcamp;
	else
		actorlist = data.defendcamp;
	end
	for i,v in ipairs(actorlist[1].FirstList) do
		if v.pos == pos then
			return v.actorID;
		end
	end
	return nil;
end

--设置测试数据
function model_msg:setTestData( fightType , des )
	local battleData = {};
	battleData.fightType = fightType;--Data_Battle.CONST_BATTLE_TYPE_ONHOOK;
	battleData.describe = des;--描述信息
	self:addExecuteFightData( battleData );
	--攻击方队伍数量
	local attackcampactorCount = 1;
	battleData.attackcampactorCount = attackcampactorCount;
	printInfo("战场攻击方队伍数量：%s",attackcampactorCount)
	battleData.attackcamp = {
		[1] = {
			formation = 1,
			FirstList = {
				{actorID = 100004 , BossMark = 0, pos = 1},--吕布
				{actorID = 100005 , BossMark = 0, pos = 2},--周瑜
				{actorID = 100104 , BossMark = 0, pos = 3},--大桥
				{actorID = 100106 , BossMark = 0, pos = 4},--法阵
				{actorID = 100142 , BossMark = 0, pos = 5},--关羽
				{actorID = 100111 , BossMark = 0, pos = 6},--黄月英

				-- {actorID = 20006 , BossMark = 0, pos = 7},
				-- {actorID = 20007 , BossMark = 0, pos = 8},
				-- {actorID = 20008 , BossMark = 0, pos = 9},
			},
			TwoList = {

			},
		},
	};
	
	--防守方士气
	battleData.defendcampactorMorale = 200;
	--防守方队伍数量
	local defendcampactorCount = 1;
	--总的防守方队伍数量
	battleData.SumSegments = defendcampactorCount;
	battleData.defendcampactorCount = defendcampactorCount;
	printInfo("战场防守方队伍数量：%s ,%s",defendcampactorCount,battleData.defendcampactorMorale)
	battleData.defendcamp = {
		[1] = {
			formation = 1,
			FirstList = {
				{actorID = 100117 , BossMark = 0, pos = 1},
				{actorID = 100309 , BossMark = 0, pos = 2},
				{actorID = 100126 , BossMark = 0, pos = 3},
				
				{actorID = 100320 , BossMark = 0, pos = 4},
				
				{actorID = 100118 , BossMark = 0, pos = 5},
				{actorID = 100130 , BossMark = 0, pos = 6},

				-- {actorID = 20006 , BossMark = 0, pos = 7},
				-- {actorID = 20007 , BossMark = 0, pos = 8},
				-- {actorID = 20008 , BossMark = 0, pos = 9},
			},
			TwoList = {

			},
		},
	};
	--局数据
	battleData.fightData = {
		InningsCount = 1,
		InningsData = {
			[1] = {
				["AttackActor"] = {
					[1] = {pos = 1,actorHP = 2000,maxHP = 2000,},
					[2] = {pos = 2,actorHP = 2000,maxHP = 2000,},
					[3] = {pos = 3,actorHP = 2000,maxHP = 2000,},
					[4] = {pos = 4,actorHP = 2000,maxHP = 2000,},
					[5] = {pos = 5,actorHP = 2000,maxHP = 2000,},
					[6] = {pos = 6,actorHP = 2000,maxHP = 2000,},
					-- [7] = {pos = 7,actorHP = 2000,maxHP = 2000,},
					-- [8] = {pos = 8,actorHP = 2000,maxHP = 2000,},
					-- [9] = {pos = 9,actorHP = 2000,maxHP = 2000,},

				},
				["DefendActor"] = {
					[1] = {pos = 1,actorHP = 2000,maxHP = 2000,},
					[2] = {pos = 2,actorHP = 2000,maxHP = 2000,},
					[3] = {pos = 3,actorHP = 2000,maxHP = 2000,},
					[4] = {pos = 4,actorHP = 2000,maxHP = 2000,},
					[5] = {pos = 5,actorHP = 2000,maxHP = 2000,},
					[6] = {pos = 6,actorHP = 2000,maxHP = 2000,},
					-- [7] = {pos = 7,actorHP = 2000,maxHP = 2000,},
					-- [8] = {pos = 8,actorHP = 2000,maxHP = 2000,},
					-- [9] = {pos = 9,actorHP = 2000,maxHP = 2000,},
				},
				["AttackTeamId"] = 1,
				["DefendTeamId"] = 1,
				PassivityBuf = {},
				["boutCount"] = 2,
				["boutData"] = {
					[1] = {
						buffcount = 0,
						BeforeBoutData = {
							-- [1] = {
							-- 	camp = 1,
							-- 	pos = 2,
							-- 	hp = 1000,
							-- 	count = 1,
							-- 	buffData = {
							-- 		bufID = 10,--buf ID
							-- 		releasecamp = 1,--施法者阵营
							-- 		releasepos = 2,--施法者位置
							-- 		aimcount = 1,--影响目标的数量
							-- 		executeMark = 2,--执行标示(回合开始前)
							-- 		affectAim = {
							-- 			aimcamp = 1;--目标阵营
							-- 			aimpos = 2;--目标位置
							-- 			hurtvaluse = 30;--伤害测血量
							-- 			hp = 100;--剩余血量
							-- 			isDead = false;
							-- 		},
							-- 	},
							-- },
						},
						actionCount = 6,
						actionData = {
							[1] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 0,
								pos = 1,
								skillID = 10011701,--技能ID
								HurtCount = 1,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 1517,
										miss = 0,
										crit = 0,
										hurtvaluse = -300,
										Hp = 1700,
										bufcount = 0,
									},
									[2] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 5,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = -300,
										Hp = 1700,
										bufcount = 0,
									},
									-- [3] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 3,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 300,
									-- 	Hp = 1700,
									-- 	bufcount = 0,
									-- },
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 1517,
										miss = 0,
										crit = 0,
										hurtvaluse = -300,
										Hp = 1700,
										bufcount = 0,
									},
									[2] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 5,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = -300,
										Hp = 1700,
										bufcount = 0,
									},
									-- [3] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 3,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 300,
									-- 	Hp = 1700,
									-- 	bufcount = 0,
									-- },
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[2] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 0,
								pos = 4,
								skillID = 10032002,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = -2000,
										Hp = 1000,
										bufcount = 0,
										-- buffData = {
										-- 	[1] = {
										-- 		bufID = 1711,--bufID
										-- 		isvanish = false,
										-- 		aimcount = 1,--目标数量
										-- 		releasecamp = 1,--施法者阵营
										-- 		releasepos = 2,
										-- 		executeMark = 3,
										-- 		affectAim = {
										-- 			[1] = {
										-- 				aimcamp = 1,
										-- 				aimpos = 3,
										-- 				hurtvaluse = 300,
										-- 				Hp = 1000,
										-- 				newsbuff = 0,
										-- 			}
													
										-- 		},
										-- 	},
											
										-- },
									},
									-- [2] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 3,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 1000,
									-- 	Hp = 1000,
									-- 	bufcount = 0,
									-- },
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = -2000,
										Hp = 1000,
										bufcount = 0,
										-- buffData = {
										-- 	[1] = {
										-- 		bufID = 1711,--bufID
										-- 		isvanish = false,
										-- 		aimcount = 1,--目标数量
										-- 		releasecamp = 1,--施法者阵营
										-- 		releasepos = 2,
										-- 		executeMark = 3,
										-- 		affectAim = {
										-- 			[1] = {
										-- 				aimcamp = 1,
										-- 				aimpos = 3,
										-- 				hurtvaluse = 300,
										-- 				Hp = 1000,
										-- 				newsbuff = 0,
										-- 			}
													
										-- 		},
										-- 	},
											
										-- },
									},
									-- [2] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 3,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 1000,
									-- 	Hp = 1000,
									-- 	bufcount = 0,
									-- },
									-- [3] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 3,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 1000,
									-- 	Hp = 1000,
									-- 	bufcount = 0,
									-- },
									-- [4] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 4,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 1000,
									-- 	Hp = 1000,
									-- 	bufcount = 0,
									-- },
									-- [5] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 5,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 1000,
									-- 	Hp = 1000,
									-- 	bufcount = 0,
									-- },
									-- [6] = {
									-- 	IsHurt = 1,
									-- 	aimcamp = 1,
									-- 	aimpos = 6,
									-- 	aimtype = 1,
									-- 	bufID = 0,
									-- 	miss = 0,
									-- 	crit = 0,
									-- 	hurtvaluse = 1000,
									-- 	Hp = 1000,
									-- 	bufcount = 0,
									-- },
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[3] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 1,
								pos = 2,
								skillID = 20004,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 4,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
									[2] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 5,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 4,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
									[2] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 5,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[4] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 0,
								pos = 3,
								skillID = 20004,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 4,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
									[2] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 5,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 4,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
									[2] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 5,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1200,
										Hp = 800,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[5] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 1,
								pos = 4,
								skillID = 20006,--技能ID
								HurtCount = 1,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 6,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 600,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 6,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 600,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[6] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 0,
								pos = 4,
								skillID = 20006,--技能ID
								HurtCount = 1,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 6,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 600,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 6,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 600,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
						},
					},
					[2] = {
						buffcount = 1,
						BeforeBoutData = {
							[1] = {
								camp = 1,
								pos = 2,
								hp = 1000,
								count = 1,
								buffData = {
									bufID = 10,--buf ID
									releasecamp = 1,--施法者阵营
									releasepos = 2,--施法者位置
									aimcount = 1,--影响目标的数量
									executeMark = 2,--执行标示(回合开始前)
									affectAim = {
										aimcamp = 1;--目标阵营
										aimpos = 2;--目标位置
										hurtvaluse = 30;--伤害测血量
										hp = 100;--剩余血量
										isDead = false;
									},
								},
							},
						},
						actionCount = 4,
						actionData = {
							[1] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 1,
								pos = 2,
								skillID = 20003,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 3,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 10,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 3,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 10,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[2] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 0,
								pos = 2,
								skillID = 20002,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 10,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 300,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[3] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 1,
								pos = 3,
								skillID = 20005,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 10,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 0,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 10,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},
							[4] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 0,
								pos = 3,
								skillID = 20005,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 2000,
										Hp = 10,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 10,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},

						},
					},
					[3] = {
						buffcount = 1,
						BeforeBoutData = {
							[1] = {
								camp = 1,
								pos = 2,
								hp = 1000,
								count = 1,
								buffData = {
									bufID = 10,--buf ID
									releasecamp = 1,--施法者阵营
									releasepos = 2,--施法者位置
									aimcount = 1,--影响目标的数量
									executeMark = 2,--执行标示(回合开始前)
									affectAim = {
										aimcamp = 1;--目标阵营
										aimpos = 2;--目标位置
										hurtvaluse = 30;--伤害测血量
										hp = 100;--剩余血量
										isDead = false;
									},
								},
							},
						},
						actionCount = 1,
						actionData = {
							[1] = {
								buffCount = 1,
								buffList = {
									camp = 1,
									-- 位置
									pos = 2,
									-- 消失的buffid
									buffId = 3,
								},
								attackcamp = 0,
								pos = 1,
								skillID = 20001,--技能ID
								HurtCount = 2,--受伤数量
								AimData = {
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 0,
										Hp = 0,
										bufcount = 0,
									},
								}, --目标数据
								HurtData = {
									
									[1] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 2,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 0,
										bufcount = 0,
									},
									[2] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 3,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 0,
										bufcount = 0,
									},
									[3] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 4,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 0,
										bufcount = 0,
									},
									[4] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 5,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 0,
										bufcount = 0,
									},
									[5] = {
										IsHurt = 1,
										aimcamp = 1,
										aimpos = 6,
										aimtype = 1,
										bufID = 0,
										miss = 0,
										crit = 0,
										hurtvaluse = 1000,
										Hp = 0,
										bufcount = 0,
									},
								},--伤害数据
								SumHurtHP = 10000,--总伤害数量
							},

						},
					},
				},
			},
		}
	}
	--战斗结果数据
	battleData.ResultData = {
		result = 0,
		score = 0,
		AttackSumHurt = 15000,
		sumBout = 30,--总回合数
		boutCount = 10,--回合数
		nextprompt = "下场开始倒计时", --下一场战斗提示
        countdown = 10,--倒计时
	};
	self:msgDataAddExecuteLogic( battleData );
end

--数据添加执行逻辑
function model_msg:msgDataAddExecuteLogic( data )
	-- if data.fightType == Data_Battle.CONST_BATTLE_TYPE_ONHOOK then
	-- 	--执行挂机数据
	-- 	dispatchGlobaleEvent( "onhook" ,"create");
	-- elseif data.fightType == Data_Battle.CONST_BATTLE_TYPE_BOSS then
	-- 	--boss挑战类型
	-- 	--必须马上执行
	-- 	dispatchGlobaleEvent( "challengeboss" ,"create");
	-- elseif data.fightType == Data_Battle.CONST_BATTLE_TYPE_test then
	-- 	dispatchGlobaleEvent( "testbattlefield" ,"create");
	-- else
	-- 	--测试战场
	-- end
	--创作战场切换逻辑
	dispatchGlobaleEvent( "battlefieldcut" ,"create" ,{ battledata = data});
end

--挂机战斗
-- function model_msg:msgFight_Onhook(  )
-- 	-- 创建挂机战场
-- 	dispatchGlobaleEvent( "onhook" ,"create");
-- end

-- function model_msg:msgFight_Boss(  )
-- 	-- 创建boss战场
-- 	dispatchGlobaleEvent( "challengeboss" ,"create");
-- end

--创建战场逻辑
function model_msg:createBattlefieldLogic( event )

	local  data = event._usedata[1];
	--创作战场切换逻辑
	dispatchGlobaleEvent( "battlefieldcut" ,"create" ,{ battledata = data});
end


return model_msg


