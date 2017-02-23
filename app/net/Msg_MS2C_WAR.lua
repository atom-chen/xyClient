--
-- Author: li Yang
-- Date: 2015-08-14 13:49:38
-- 副本消息

--[[ 发送副本数据
*
*	int		已通过关卡
*	int		可以领取奖励的关卡（过关后添加，领取后删除）数量
*	{
*		int		关卡ID
*	}
*
*
]]
Msg_Logic[MSG_MS2C_WAR_DATA_UPDATE] = function ( tcp , msg )
	printInfo("网络日志 %s","收到副本数据 MSG_MS2C_WAR_DATA_UPDATE");
	local passlevelkey = msg:ReadIntData();

	Data_Battle_Onhook.awardLevel = {};
	--奖励数量
	local awardcount = msg:ReadIntData();
	printInfo(" 关卡进度 = %s ,奖励数 = %s",passlevelkey,awardcount);
	for i=1,awardcount do
		--奖励关卡key
		local awardlevelkey = msg:ReadIntData();
		Data_Battle_Onhook.awardLevel[awardlevelkey] = true;
		print("   有奖励的关卡",awardlevelkey);
	end

	--设置boss挑战关卡
	Data_Battle_Onhook:setOpenLevel( passlevelkey );
end

--[[ 更新挂机相关信息
*
*	int		挂机关卡ID
*	int		挂机队伍ID
*
*	int		下次挂机战斗开始时间
*	int		挂机结果：战斗次数
*	int		挂机结果：在关卡上消耗的总时间
*	int		挂机结果：胜利次数
*	int		挂机结果：获得经验
*	int		挂机结果：获得银两
*
*
]]
Msg_Logic[MSG_MS2C_WAR_UPDATE_HOOK_INFO] = function ( tcp , msg )
	printInfo("网络日志 %s","收到挂机副本数据 MSG_MS2C_WAR_UPDATE_HOOK_INFO");
	--挂机关卡key
	local onhooklevelkey = msg:ReadIntData();
	--挂机队伍id
	local onhookteam = msg:ReadIntData();
	--下次挂机战斗时间
	local nextonhooktime = msg:ReadIntData();
	local onhookresult_count = msg:ReadIntData();--战斗次数
	local onhookresult_time = msg:ReadIntData();--挂机时间
	local onhookresult_win = msg:ReadIntData();--结果胜利次数
	printInfo(" 挂机关卡 = %s ,挂机队伍ID = %s ,下次战斗时间 = %s ,挂机战斗总次数 = %s ,挂机时间 = %s ,挂机胜利次数 = %s",
		onhooklevelkey,
		onhookteam,
		nextonhooktime,
		onhookresult_count,
		onhookresult_time,
		onhookresult_win);
	--设置挂机关卡
	Data_Battle_Onhook:setOnhookLevel( onhooklevelkey );
	Data_Battle_Onhook.onhookteam = onhookteam;
	--设置挂机信息
	Data_Battle_Onhook:updateOnhookInfo( onhookresult_count ,onhookresult_time ,onhookresult_win );
end

--[[ 挂机战斗奖励
*
*	int		获得经验
*	int		获得银两
*	int		掉落数
*	{掉落品
*		int		类型
*		int		ID
*		int		等级
*		int		数量
*		int		成功添加数量（有因为包裹满而装备被丢弃的可能）
*	}
*	
]]
Msg_Logic[MSG_MS2C_WAR_HOOK_RESULT] = function ( tcp , msg )
	printInfo("网络日志 %s","收到挂机结果数据 MSG_MS2C_WAR_HOOK_RESULT");
	--挂机战斗奖励
	local exp = msg:ReadIntData();
	local gold = msg:ReadIntData();
	local dropcount = msg:ReadIntData();
	for i=1,dropcount do
		--掉落类型
		local droptype = msg:ReadIntData();
		--掉落id
		local dropid = msg:ReadIntData();
		--物品等级
		local dropgrade = msg:ReadIntData();
		--掉落数量
		local count = msg:ReadIntData();
		--成功添加数量
		local addcount = msg:ReadIntData();
	end
	printInfo(" %s","经验:"..exp..",金币:"..gold..",掉落数量:"..dropcount);
end

--[[离线挂机奖励结果
*
*	int		离线时间
*	int		进行场次
*	int		总经验
*	int		总银两
*	int		胜利场次
*	int		掉落数
*	{掉落品
*		int		类型
*		int		ID
*		int		等级
*		int		数量
*		int		成功添加数量（有因为包裹满而装备被丢弃的可能）
*	}
*	
]]
Msg_Logic[MSG_MS2C_WAR_OFFLINE_RESULT] = function ( tcp , msg )
	printInfo("网络日志 %s","收到挂机战斗离线结果 MSG_MS2C_WAR_OFFLINE_RESULT");
	local offlinetime = msg:ReadIntData();--运行时间
	local runtime = msg:ReadIntData();--运行次数
	-- local sumexp = msg:ReadIntData();--总经验
	-- local sumgold = msg:ReadIntData();--总银两
	local wintime = msg:ReadIntData();--胜利次数
	local dropcount = msg:ReadIntData();--掉落数
	print(offlinetime,runtime,sumexp,sumgold,wintime,dropcount);
	local offLineData = {};
	offLineData.offlinetime = offlinetime;
	offLineData.runtime = runtime;
	offLineData.sumexp = sumexp;
	offLineData.sumgold = sumgold;
	offLineData.dropcount = dropcount;
	offLineData.dropGoods = {};
	
	--添加离线掉落信息
	for i=1,dropcount do
		local goods = {};
		--掉落类型
		goods.droptype = msg:ReadIntData();
		--掉落id
		goods.dropid = msg:ReadIntData();
		--物品等级
		goods.dropgrade = msg:ReadIntData();
		--掉落数量
		goods.count = msg:ReadIntData();
		--成功添加数量
		goods.addcount = msg:ReadIntData();
		offLineData.dropGoods[i] = goods;
	end
	Data_Battle.offLineData = offLineData;

end

--[[挂机战斗数据
]]
Msg_Logic[MSG_MS2C_WAR_HOOK_DATA] = function ( tcp , msg )
	printInfo("网络日志 %s","收到挂机战斗数据 MSG_MS2C_WAR_HOOK_DATA");
	--解析挂机数据
	local battledata = Data_Battle_Msg:analysisBattleData( msg ,Data_Battle.CONST_BATTLE_TYPE_ONHOOK , Data_Battle_Onhook.LevelData.name);
	local ResultData = {
		result = battledata.battleResult,
		score = 0,
		AttackSumHurt = battledata.AttackSumHurt,
		sumBout = 30,--总回合数
		boutCount = battledata.MaxBoutCount,--回合数
		nextprompt = "下场开始倒计时", --下一场战斗提示
        countdown = 10,--倒计时
        dropout = {},--掉落
	};
	battledata.ResultData = ResultData;
	--发送挂机战斗结果消息
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_WAR_HOOK_DATA),{battledata})
end

--[[ BOSS战斗结果通知
*
*	战斗数据
*
*	int		关卡ID
*	int		是否胜利
*	如果胜利，则有：
*	{
*		int		掉落数
*		{掉落品
*			int		类型
*			int		ID
*			int		等级
*			int		数量
*		}
*	}
*	
]]
Msg_Logic[MSG_MS2C_WAR_BOSS_RESULT] = function ( tcp , msg )
	printInfo("网络日志 %s","收到boss战斗数据 MSG_MS2C_WAR_BOSS_RESULT");
	--解析boss战斗数据
	local battledata = Data_Battle_Msg:analysisBattleData( msg ,Data_Battle.CONST_BATTLE_TYPE_BOSS , Data_Battle_Onhook.LevelData.name);
	local ResultData = {
		result = battledata.battleResult,
		score = 0,
		AttackSumHurt = battledata.AttackSumHurt,
		sumBout = 30,--总回合数
		boutCount = battledata.MaxBoutCount,--回合数
		-- nextprompt = "下场开始倒计时", --下一场战斗提示
        -- countdown = 20,--倒计时
        dropout = {},--掉落
	};
	ResultData.LevelKey = msg:ReadIntData();
	print("		boss挑战结果:",ResultData.LevelKey,ResultData.result)
	if ResultData.result == 1 then
		local dropcount = msg:ReadIntData();--掉落数
		print("    掉落数量",dropcount);
		
		for i=1,dropcount do
			--掉落类型
			local droptype = msg:ReadIntData();
			--掉落id
			local dropid = msg:ReadIntData();
			--物品等级
			local dropgrade = msg:ReadIntData();
			--掉落数量
			local count = msg:ReadIntData();
			local wuping = {};
			wuping.droptype = droptype;
			wuping.dropid = dropid;
			wuping.dropgrade = dropgrade;
			wuping.count = count;
			ResultData.dropout[i] = wuping;
			print("    掉落",i,droptype,dropid,dropgrade,count);
		end
	end
	battledata.ResultData = ResultData;
	--发送挂机战斗结果消息
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_WAR_BOSS_RESULT),{battledata})
end


--[[快速战斗结果通知
*
*	int		离线时间
*	int		进行场次
*	int		总经验
*	int		总银两
*	int		胜利场次
*	int		掉落数
*	{掉落品
*		int		类型
*		int		ID
*		int		等级
*		int		数量
*		int		成功添加数量（有因为包裹满而装备被丢弃的可能）
*	}
]]
Msg_Logic[MSG_MS2C_WAR_QUICK_RESULT] = function ( tcp , msg )
	printInfo("网络日志 %s","收到快速战斗结果数据 MSG_MS2C_WAR_QUICK_RESULT");
	local offlinetime = msg:ReadIntData();--运行时间
	local runtime = msg:ReadIntData();--运行次数
	-- local sumexp = msg:ReadIntData();--总经验
	-- local sumgold = msg:ReadIntData();--总银两
	local wintime = msg:ReadIntData();--胜利次数
	local dropcount = msg:ReadIntData();--掉落数
	local sumexp = 0;--总经验
	local sumgold = 0;--总银两
	print(offlinetime,runtime,sumexp,sumgold,wintime,dropcount);
	local offLineData = {};
	offLineData.offlinetime = offlinetime;
	offLineData.runtime = runtime;
	offLineData.sumexp = sumexp;
	offLineData.sumgold = sumgold;
	offLineData.dropcount = dropcount;
	offLineData.dropGoods = {};
	for i=1,dropcount do
		local goods = {};
		--掉落类型
		goods.droptype = msg:ReadIntData();
		--掉落id
		goods.dropid = msg:ReadIntData();
		--物品等级
		goods.dropgrade = msg:ReadIntData();
		--掉落数量
		goods.count = msg:ReadIntData();
		--成功添加数量
		goods.addcount = msg:ReadIntData();
		offLineData.dropGoods[i] = goods;
		print("   ",goods.droptype,goods.dropid,goods.dropgrade,goods.count,goods.addcount)
	end
	--发送挂机战斗结果消息
	dispatchGlobaleEvent( "onhook" ,"msg_quickcombat_result",{offLineData});
end

--[[扫荡数据
]]
Msg_Logic[MSG_MS2C_WAR_RUSH_RESULT] = function ( tcp , msg )
	printInfo("网络日志 %s","收到扫荡数据 MSG_MS2C_WAR_RUSH_RESULT");
end

--[[通关奖励
]]
Msg_Logic[MSG_MS2C_WAR_REWARD] = function ( tcp , msg )
	printInfo("网络日志 %s","收到通关奖励 MSG_MS2C_WAR_REWARD");
	local levelkey = msg:ReadIntData();
	Data_Battle_Onhook.awardLevel[levelkey] = false;
	--通知刷新结果
	dispatchGlobaleEvent( "onhook" ,"getaward_result",{levelkey});
end

--[[副本错误码
]]
Msg_Logic[MSG_MS2C_WAR_ERROR] = function ( tcp , msg )
	local errorcode = msg:ReadIntData();
	printInfo("网络日志 %s, %s","收到副本错误码 MSG_MS2C_WAR_ERROR",errorcode);
	UIManager:CreatePrompt_Bar( {
			content = getErrorDescribe( errorcode ),
		} )
end



