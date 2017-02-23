--
-- Author: Wu Hengmin
-- Date: 2014-03-18 13:49:49
-- 奖励消息

-- 获得任务数据列表
Msg_Logic[MSG_MS2C_MISSION_DATA] = function ( tcp , msg  )
	MAIN_PLAYER.missionManager.missions = {}
	MAIN_PLAYER.missionManager.dailys = {}
	MAIN_PLAYER.missionManager.achieves = {}
	local count = msg:ReadIntData()
	printLog("网络日志","收到任务数量："..count)

	for i=1,count do
		local params = {}
		params.ID = msg:ReadIntData()
		params.schedule = msg:ReadIntData()
		printLog("网络日志","收到任务ID："..params.ID)
		if Mission_BaseInfoSetup[params.ID] then
			if Mission_BaseInfoSetup[params.ID].BigType == 4 then -- 日常
				MAIN_PLAYER.missionManager:addDaily(params)
			elseif Mission_BaseInfoSetup[params.ID].BigType == 5 then -- 成就
				MAIN_PLAYER.missionManager:addAchieve(params)
			else -- 普通
				MAIN_PLAYER.missionManager:addMission(params)
			end
			
			printLog("网络日志","类型BigType:"..Mission_BaseInfoSetup[params.ID].BigType.." ID:"..params.ID.." 进度:"..params.schedule)
		else
			printLog("网络日志", "任务ID错误")
		end
	end

	dispatchGlobaleEvent("model_missionManager", "open_mission")
end

-- 完成任务返回消息
Msg_Logic[MSG_MS2C_COMPLETE_MISSION] = function ( tcp, msg )
	local result = msg:ReadIntData()
	printLog("网络日志", "完成结果:"..result)

	if result == eMISSION_Success then
		-- 奖励类型
		local rewardType = msg:ReadIntData()
		-- 奖励数量
		local rewardCount = msg:ReadIntData()
		-- 后续任务数量
		local nextCount = msg:ReadIntData()
		printLog("网络日志", "后续任务数量:"..nextCount)
		local nextAdds = {}
		for i=1,nextCount do
			local tmp = {}
			tmp.ID = msg:ReadIntData()
			tmp.schedule = msg:ReadIntData()
			printLog("网络日志","ID:"..tmp.ID.." 进度:"..tmp.schedule)
			table.insert(nextAdds, tmp)
		end

		-- UIManager.gameMain.center.Rewards:receivedMission(nextAdds)
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_COMPLETE_MISSION), {nextAdds = nextAdds})
	elseif result == eMISSION_ErrorID then
		gameTcp:SendMessage(MSG_C2MS_GET_MISSION_DATA)
	else
		-- UIManager:CreatePrompt_1( display.getRunningScene() , getErrorDescribe( result ))
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end
	-- TounchContrlScheduler(0, 1)
end

-- 获得成就数据列表
Msg_Logic[MSG_MS2C_ACHIEVE_DATA] = function ( tcp , msg )
	
end

-- 完成成就返回消息
Msg_Logic[MSG_MS2C_COMPLETE_ACHIEVE] = function ( tcp, msg )
	
end


