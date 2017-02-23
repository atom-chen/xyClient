--
-- Author: lipeng
-- Date: 2015-09-07 10:37:45
-- 雇佣


--玩家自身的雇佣信息
Msg_Logic[MSG_MS2C_HIRESYS_INFO] = function ( tcp , msg  )
	printNetLog("收到 玩家自身的雇佣信息(MSG_MS2C_HIRESYS_INFO) 消息")
	local msgData = {}
	--雇佣者ID
	msgData.gyStrID = msg:ReadString()

	if msgData.gyStrID ~= "" then
		msgData.playerID = msg:ReadString()
		msgData.playerName = msg:ReadString()
		msgData.playerLv = msg:ReadIntData()
		msgData.vipLv = msg:ReadIntData()
		msgData.power = msg:ReadIntData()
		msgData.heroTempleateID = msg:ReadIntData()
		msgData.gyTime = msg:ReadIntData()
		msgData.perSecGetExp = msg:ReadFloat()
		msgData.perSecGetGold = msg:ReadFloat()
		--初始身价, 当前身价在有降价时, 需要重新进行计算
		msgData.price = msg:ReadIntData()
		msgData.coolTime = msg:ReadIntData()
		msgData.reducePriceTime = msg:ReadIntData()
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_HIRESYS_INFO), msgData)
	printNetLog(serialize(msgData))
end


--雇员列表
Msg_Logic[MSG_MS2C_HIRESYS_HIRELING_INFO] = function ( tcp , msg  )
	printNetLog("收到 雇员列表(MSG_MS2C_HIRESYS_HIRELING_INFO) 消息")
	local msgData = {}
	--页数
	msgData.pageIdx = msg:ReadIntData()
	--信息总数(总页数=总信息数/信息数)
	msgData.infoTotalNum = msg:ReadIntData()
	--信息数
	msgData.infoNum = msg:ReadIntData()

	--信息列表
	msgData.listInfo = {}

	for i=1, msgData.infoNum do
		msgData.listInfo[i] = {}
		local info = msgData.listInfo[i]
		info.playerID = msg:ReadString()
		info.playerName = msg:ReadString()
		info.playerLv = msg:ReadIntData()
		info.vipLv = msg:ReadIntData()
		info.power = msg:ReadIntData()
		info.heroTempleateID = msg:ReadIntData()
		info.gyTime = msg:ReadIntData()

		info.perSecGetExp = msg:ReadFloat()
		info.perSecGetGold = msg:ReadFloat()
		--初始身价, 当前身价在有降价时, 需要重新进行计算
		info.price = msg:ReadIntData()
		info.coolTime = msg:ReadIntData()
		info.reducePriceTime = msg:ReadIntData()
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_HIRESYS_HIRELING_INFO), msgData)
	printNetLog(serialize(msgData))
end




--雇佣结果
Msg_Logic[MSG_MS2C_HIRESYS_HIRE_RESULT] = function ( tcp , msg  )
	printNetLog("收到 雇佣结果(MSG_MS2C_HIRESYS_HIRE_RESULT) 消息")
	local msgData = {}
	msgData.result = msg:ReadIntData()
	
	if msgData.result == eHS_BuySecced then
		msgData.id = msg:ReadString()
	end
	
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_HIRESYS_HIRE_RESULT), msgData)
	printNetLog(serialize(msgData))

	UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
end




--收益信息
Msg_Logic[MSG_MS2C_HIRESYS_YIELD_INFO] = function ( tcp , msg  )
	printNetLog("收到 收益信息(MSG_MS2C_HIRESYS_YIELD_INFO) 消息")
	local msgData = {}
	msgData.exp = msg:ReadIntData()
	msgData.gold = msg:ReadIntData() --银两
	
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_HIRESYS_YIELD_INFO), msgData)
	printNetLog(serialize(msgData))

	UIManager:CreateSamplePrompt(
		string.format("获得经验: %d  获得银两: %d", 
		msgData.exp,
		msgData.gold
		)
	)
end


