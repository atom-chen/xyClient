--
-- Author: lipeng
-- Date: 2014-02-11 10:45:58
-- 队伍数据 消息片


-- 收到队伍数据
Msg_Logic[MSG_MS2C_TEAM_DATA] = function ( tcp , msg  )
	local teamManager = MAIN_PLAYER:getTeamManager()
	printLog("网络日志","收到 [队伍数据] 消息(MSG_MS2C_TEAM_DATA)：玩家队伍数量上限: "..MaxPlayerTeamNum)

	for i=1, MaxPlayerTeamNum do
		local team = teamManager:getTeam(i)
		local battleHeroManager = team:getBattleHeroManager()
		local formationID = msg:ReadIntData()--阵型ID
		team:setFormationID(formationID)
		printLog("网络日志","队伍："..i.."   阵型ID: "..formationID)

		for j=1, MaxTeamMemberNum do
			local memberGUID = msg:ReadString() --成员GUID
			local posOnWar = msg:ReadIntData() --战斗中的位置

			local battlePos = battleHeroManager:getPos(j) --上阵位置(在队伍中的位置)
			battlePos:setHeroGUID(memberGUID)
			battlePos:setPosOnWar(posOnWar)
			printLog("网络日志","成员索引："..j..",guid："..memberGUID..",战斗位置："..posOnWar)

			for e=1, EquipTypeNum do
				local equipGUID = msg:ReadString()
				battlePos:setEquip(e-1, equipGUID)
				printLog("网络日志","装备："..e..",guid："..equipGUID)
			end
		end
	end
end


-- 更新一个队伍领导
Msg_Logic[MSG_MS2C_TEAM_UPDATE_LEADER] = function ( tcp , msg  )
	local teamIdx = msg:ReadIntData()
	local leaderGUID = msg:ReadString()
	printLog("网络日志","收到 [更新一个队伍领导] 消息(MSG_MS2C_TEAM_UPDATE_LEADER)："..teamIdx..",  "..leaderGUID)

	--数据更新
	local leaderPos = MAIN_PLAYER:getTeamManager():getTeam(teamIdx):getBattleHeroManager():getLeaderPos()
	leaderPos:setHeroGUID(leaderGUID)
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_TEAM_UPDATE_LEADER))
end


--更新一个队伍的成员(不包括队长)
Msg_Logic[MSG_MS2C_TEAM_UPDATE_MEMBER] = function ( tcp , msg  )
	printLog("网络日志", "收到 [更新一个队伍的成员] 消息(MSG_MS2C_TEAM_UPDATE_MEMBER)：")
	local teamIdx = msg:ReadIntData()
	local memberGUIDList = {}
	for i=1,11 do
		memberGUIDList[i] = msg:ReadString()
		printLog("网络日志", "成员索引：%d, GUID = %s", i, memberGUIDList[i])
	end

	--数据更新
	local team = MAIN_PLAYER:getTeamManager():getTeam(teamIdx)
	local battleHeroManager = team:getBattleHeroManager()
	for i,v in ipairs(memberGUIDList) do
		--因为不包括队长, 所以从2开始
		local pos = battleHeroManager:getPos(i+1)
		pos:setHeroGUID(v)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_TEAM_UPDATE_MEMBER))
end



--更新一个队伍的战斗位置
Msg_Logic[MSG_MS2C_TEAM_UPDATE_BPOS] = function ( tcp , msg  )
	printLog("网络日志", "收到 [更新一个队伍的战斗位置] 消息(MSG_MS2C_TEAM_UPDATE_BPOS)：")
	local msgData = {}
	msgData.teamIdx = msg:ReadIntData()
	msgData.formationID = msg:ReadIntData()

	printLog("网络日志", "队伍索引: %d, 阵型ID: %d ", 
		msgData.teamIdx,
		msgData.formationID
	)

	local team = MAIN_PLAYER:getTeamManager():getTeam(msgData.teamIdx)
	team:setFormationID(msgData.formationID)

	msgData.bposList = {}
	local battleHeroManager = team:getBattleHeroManager()
	for i=1, MaxTeamMemberNum do
		msgData.bposList[i] = msg:ReadIntData()
		local pos = battleHeroManager:getPos(i)
		pos:setPosOnWar(msgData.bposList[i])
		printLog("网络日志", "上阵位置: %d, 战斗位置: %d ", 
			i,
			msgData.bposList[i]
		)
	end


	dispatchGlobaleEvent("net", tostring(MSG_MS2C_TEAM_UPDATE_BPOS))
end



