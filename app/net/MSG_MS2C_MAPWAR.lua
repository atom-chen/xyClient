--
-- Author: lipeng
-- Date: 2015-09-14 17:55:30
-- 占城

-- 获取战场信息
Msg_Logic[MSG_MS2C_MAPWAR_MAP_INFO] = function ( tcp , msg  )
	printNetLog("[获取战场信息] 消息(MSG_MS2C_MAPWAR_MAP_INFO)")
	local msgData = {}
	msgData.cityNum = msg:ReadIntData()
	msgData.cityList = {}

	for i=1, msgData.cityNum do
		msgData.cityList[i] = {}
		local cityInfo = msgData.cityList[i]
		cityInfo.id = msg:ReadIntData()

		cityInfo.posNum = msg:ReadIntData()

		cityInfo.posList = {}
		for j=1, cityInfo.posNum do
			cityInfo.posList[j] = {}
			local posInfo = cityInfo.posList[j]
			posInfo.guildName = msg:ReadString()
			--如果公会名为"", 则说明没有被占领
			if posInfo.guildName ~= "" then
				posInfo.playerName = msg:ReadString()
				posInfo.playerLv = msg:ReadIntData()
				posInfo.playerVIPLv = msg:ReadIntData()
				posInfo.playerPower = msg:ReadIntData()
				posInfo.leaderTempleateID = msg:ReadIntData()
			end
		end
	end


	printNetLog(serialize(msgData))
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_MAPWAR_MAP_INFO), {msgData = msgData})
end


-- 购买战斗次数结果
Msg_Logic[MSG_MS2C_MAPWAR_BUY_RE] = function ( tcp , msg  )
	printNetLog("[购买战斗次数结果] 消息(MSG_MS2C_MAPWAR_BUY_RE)")
	local msgData = {}
	msgData.result = msg:ReadIntData()

	UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)

	printNetLog(serialize(msgData))
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_MAPWAR_BUY_RE), {msgData = msgData})
end


