--
-- Author: Wu Hengmin
-- Date: 2014-06-23 17:20:57
--


Msg_Logic[MSG_MS2C_PVP_INFO_RE] = function ( tcp , msg  )
	printLog("网络日志", "竞技场基本信息")
	MAIN_PLAYER.rank = msg:ReadIntData()
	MAIN_PLAYER.atttime = msg:ReadIntData()
	MAIN_PLAYER.getatk = msg:ReadIntData()
	printLog("网络日志", "排名:"..MAIN_PLAYER.rank.."可挑战次数:"..MAIN_PLAYER.atttime.."已购买次数:"..MAIN_PLAYER.getatk)
	gameTcp:SendMessage(MSG_C2MS_PVP_GET_TARGET)
end

-- 获取竞技场排行信息
Msg_Logic[MSG_MS2C_PVP_RANK_INFO_RE] = function ( tcp , msg  )
	printLog("网络日志", "获取玩家排名信息")
	local count = msg:ReadIntData()
	printLog("网络日志", "获取玩家排名信息,数量："..count)

	for i=1,count do
		local rank = msg:ReadIntData()
		local script = msg:ReadString()
		MAIN_PLAYER.JJCManager.rankplayer[i] = {rank = rank, data = unserialize(script)}
		printLog("网络日志", "排名:"..rank)
	end

	table.sort(MAIN_PLAYER.JJCManager.rankplayer, function (a, b)
		-- body
		return a.rank > b.rank
	end)

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PVP_RANK_INFO_RE))
end

-- 获取可挑战玩家信息
Msg_Logic[MSG_MS2C_PVP_TARGET_RE] = function ( tcp , msg  )
	printLog("网络日志", "获取可挑战玩家信息")
	local count = msg:ReadIntData()
	printLog("网络日志", "获取可挑战玩家信息,数量："..count)

	for i=1,count do
		local rank = msg:ReadIntData()
		local script = msg:ReadString()
		MAIN_PLAYER.JJCManager.targetplayer[i] = {rank = rank, data = unserialize(script)}
		printLog("网络日志", "排名:"..rank)
	end

	table.sort(MAIN_PLAYER.JJCManager.targetplayer, function (a, b)
		-- body
		return a.rank > b.rank
	end)

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PVP_TARGET_RE))
end

-- 更新一个PVP的次数信息
Msg_Logic[MSG_MS2C_PVP_PLAY_NUM_UDDATE] = function ( tcp , msg  )
	printLog("网络日志", "更新一个PVP的次数信息")
	-- user.player.jjcManager.yiwancishu = msg:ReadIntData()
	-- user.player.jjcManager.yigoumaicishu = msg:ReadIntData()
	-- user.player.VIPManager.purchased_jjc = user.player.jjcManager.yigoumaicishu
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PVP_PLAY_NUM_UDDATE))
end

--[[ 竞技场战斗结果通知
*
*	int		操作结果
*	如果操作成功：
*	int		结果 1=胜利 0=失败
*	
]]
Msg_Logic[MSG_MS2C_PVP_PLAY_RESULT] = function ( tcp , msg  )
	printLog("网络日志", "竞技场战斗结果通知")
	local result = msg:ReadIntData()
	if result == ePVP_Succed then
		local playresult = msg:ReadIntData()
		if playresult == 1 then
			print("赢")
		elseif playresult == 0 then
			print("输")
		end
		-- 战斗数据
		-- local battledata = Data_Battle_Msg:analysisBattleData( msg ,Data_Battle.CONST_BATTLE_TYPE_QIYU , "奇遇战斗");
		-- local ResultData = {
		-- 	result = battledata.battleResult,
		-- 	score = 0,
		-- 	AttackSumHurt = battledata.AttackSumHurt,
		-- 	sumBout = 30,--总回合数
		-- 	boutCount = battledata.MaxBoutCount,--回合数
		-- 	nextprompt = "下场开始倒计时", --下一场战斗提示
		-- 	countdown = 10,--倒计时
		-- 	dropout = {},--掉落
		-- };
		-- battledata.ResultData = ResultData;
		-- --发送挂机战斗结果消息
		-- dispatchGlobaleEvent("netMsg", "qiyu_result",{battledata})
		-----------------------------------------------------------------
	else
		print(getErrorDescribe( result ))
	end

	-- 重新请求竞技场信息

end


--[[ 购买商品
*
*	int 结果
* 	int 领取奖励的ID
]]
Msg_Logic[MSG_MS2C_PVP_BUY_GOODS] = function ( tcp , msg  )
	printLog("网络日志", "购买商品")
	local result = msg:ReadIntData()
	if ePVP_Succed == result then
		print("购买成功")
	else
		print(getErrorDescribe( result ))
	end
end



Msg_Logic[MSG_MS2C_PVP_BUY_PLAY_NUM_RE] = function ( tcp , msg  )
	print("MSG_MS2C_PVP_BUY_PLAY_NUM_RE")
end

-- 挑战错误提示信息
Msg_Logic[MSG_MS2C_PVP_PLAY_ERROR] = function ( tcp , msg  )
	printLog("网络日志", "挑战错误提示信息")
	printLog("网络日志", getErrorDescribe( result ))
end
