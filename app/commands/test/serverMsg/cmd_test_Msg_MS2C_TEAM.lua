--
-- Author: lipeng
-- Date: 2015-07-23 16:25:59
--

local onCommand = TEST_CMD_SERVER_MSG

onCommand["MSG_MS2C_TEAM_DATA"] = function ( parmas )
	-- local msgData = {}
	-- msgData.playerTeamNum = MaxPlayerTeamNum
	-- msgData.teamList = {}

	-- printLog("测试日志","收到 [队伍数据] 消息(MSG_MS2C_TEAM_DATA)："..msgData.playerTeamNum)
	-- for i=1, msgData.playerTeamNum do
	-- 	msgData.teamList[i] = {}
	-- 	local team = msgData.teamList[i]
	-- 	team.formationID = i
	-- 	printLog("测试日志","[队伍数据] 消息(MSG_MS2C_TEAM_DATA)数据___队伍："..i.."   阵型ID: "..team.formationID)

	-- 	team.maxTeamMemberNum = MaxTeamMemberNum
	-- 	team.battleHeroList = {} --上阵武将列表
	-- 	for j=1, team.maxTeamMemberNum do
	-- 		team.battleHeroList[i] = {}
	-- 		local battleHero = team.battleHeroList[i]
	-- 		battleHero.memberGUID = tostring(j) --服务器数据
	-- 		battleHero.memberPos = j
	-- 		teamMember[j] = memberGUID;
	-- 		membersBattlePos[memberPos] = j --战斗位置对应的角色位置
	-- 		printLog("测试日志","[队伍数据] 消息(MSG_MS2C_TEAM_DATA)数据__成员索引："..j..",guid："..memberGUID..",战斗位置："..memberPos)
	-- 	end
	-- end
end


