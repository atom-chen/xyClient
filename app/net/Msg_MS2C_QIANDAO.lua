--
-- Author: Wu Hengmin
-- Date: 2015-03-05 15:46:56
--

Msg_Logic[MSG_MS2C_START_QIANDAO] = function ( tcp , msg  )
	printLog("网络日志","签到数据")

	MAIN_PLAYER.qiandaoManager.jinri = msg:ReadIntData()
	printLog("网络日志","今日是否已签到:"..MAIN_PLAYER.qiandaoManager.jinri)

	MAIN_PLAYER.qiandaoManager.leiji = msg:ReadIntData()
	printLog("网络日志","累计签到天数:"..MAIN_PLAYER.qiandaoManager.leiji)

	MAIN_PLAYER.qiandaoManager.kebuqian = msg:ReadIntData()
	printLog("网络日志","可补签次数:"..MAIN_PLAYER.qiandaoManager.kebuqian)

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_START_QIANDAO))

end

Msg_Logic[MSG_MS2C_QIANDAO] = function ( tcp , msg  )
	local code  = msg:ReadIntData()
	printLog("网络日志","签到结果:"..code)
	if code == eRI_QiandaoSucced then
		-- gameTcp:SendMessage(MSG_C2MS_START_QIANDAO )
		-- 加入本次签到获取的奖励并显示
		MAIN_PLAYER.qiandaoManager.leiji = MAIN_PLAYER.qiandaoManager.leiji + 1
		print("签到成功")
		dispatchGlobaleEvent("huodong_ctrl", "refreshlist")
	else
		print(getErrorDescribe(code))
	end
end

Msg_Logic[MSG_MS2C_BUQIAN] = function ( tcp , msg  )
	local code  = msg:ReadIntData()
	printLog("网络日志","补签结果:"..code)
	if code == eRI_BuQianSucced then
		-- UIManager:CreatePrompt_1( display.getRunningScene() , "补签成功")
		-- gameTcp:SendMessage(MSG_C2MS_START_QIANDAO )
		-- 加入本次签到获取的奖励并显示
		MAIN_PLAYER.qiandaoManager.leiji = MAIN_PLAYER.qiandaoManager.leiji + 1
		MAIN_PLAYER.qiandaoManager.kebuqian = MAIN_PLAYER.qiandaoManager.kebuqian - 1
		print("签到成功")
		dispatchGlobaleEvent("huodong_ctrl", "refreshlist")
	else
		print(getErrorDescribe(code))
	end
end

-- 月卡信息
Msg_Logic[MSG_MS2C_OPEN_YUEKA] = function ( tcp , msg  )
	printLog("网络日志","月卡信息")

	MAIN_PLAYER.fuliManager.monthly.count = msg:ReadIntData()
	printLog("网络日志","月卡剩余:"..MAIN_PLAYER.fuliManager.monthly.count)

	MAIN_PLAYER.fuliManager.monthly.ready = msg:ReadIntData()
	printLog("网络日志","月卡可领取:"..MAIN_PLAYER.fuliManager.monthly.ready)

	MAIN_PLAYER.fuliManager.monthly.count_pro = msg:ReadIntData()
	printLog("网络日志","高级月卡剩余:"..MAIN_PLAYER.fuliManager.monthly.count_pro)

	MAIN_PLAYER.fuliManager.monthly.ready_pro = msg:ReadIntData()
	printLog("网络日志","高级月卡可领取:"..MAIN_PLAYER.fuliManager.monthly.ready_pro)

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_OPEN_YUEKA))
end

-- 领取结果
Msg_Logic[MSG_MS2C_LINGQU_YUEKA] = function ( tcp , msg  )
	printLog("网络日志","月卡领取结果")
	local resault = msg:ReadIntData()
	if resault == eRI_YueKa_Lingqu_Succed then
		print("领取成功")
	else
		print(getErrorDescribe(resault))
	end
	gameTcp:SendMessage(MSG_C2MS_OPEN_YUEKA)
end

-- vip工资领取结果
Msg_Logic[MSG_MS2C_VIP_DAILY_GET_RESAULT] = function ( tcp , msg  )
	print("MSG_MS2C_VIP_DAILY_GET_RESAULT")
end
