--
-- Author: Wu Hengmin
-- Date: 2014-04-23 16:34:25
--

-- 碎片数据
Msg_Logic[MSG_MS2C_PIECE_HERO_DATA] = function ( tcp , msg )
	printLog("网络日志","碎片数据消息")
	MAIN_PLAYER.heroManager.fragments = {}
	local count = msg:ReadIntData()
	printLog("网络日志","碎片种类数量:"..count)
	for i=1,count do
		local ID = msg:ReadIntData()
		local COUNT = msg:ReadIntData()
		printLog("网络日志","碎片ID:"..ID.."  碎片数量:"..COUNT)
		if ID == 0 then
			MAIN_PLAYER.universalfrag = COUNT
		-- elseif ID > 99 then

		elseif ID < 10000 then
			print("碎片ID错误")
		else
			MAIN_PLAYER.heroManager:addFragment({
				id = ID, 
				count = COUNT,
			})
		end
	end

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PIECE_HERO_DATA), {sender=sender, eventType=eventType})
end

-- 卡牌合成消息
Msg_Logic[MSG_MS2C_PIECE_HERO_MERGE_RE] = function ( tcp , msg )
	printLog("网络日志","卡牌合成消息")
	local result = msg:ReadIntData()
	printLog("网络日志","卡牌合成结果:"..result)
	if result == ePH_Success then
		print("合成成功")
		local id = msg:ReadIntData()
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PIECE_HERO_MERGE_RE))
	else
		print(getErrorDescribe( result ))
		-- UIManager:CreatePrompt_1( display.getRunningScene() , getErrorDescribe( result ) or "未知")
	end
end

-- 卡牌分解消息
Msg_Logic[MSG_MS2C_PIECE_HERO_SPLIT_RE] = function ( tcp , msg )
	printLog("网络日志","卡牌分解消息")
	local result = msg:ReadIntData()
	printLog("网络日志","卡牌分解结果:"..result)
	if result == ePH_Success then
		printLog("网络日志","卡牌碎化成功")
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PIECE_HERO_SPLIT_RE))
	else
		printLog(getErrorDescribe( result ))
	end
end

-- 新获得武将碎片
Msg_Logic[MSG_MS2C_PIECE_UPDATE] = function ( tcp , msg )
	printLog("网络日志","新获得武将碎片消息")
	local ID = msg:ReadIntData()
	local COUNT = msg:ReadIntData()
	printLog("网络日志","新获得武将碎片ID:"..ID.." 数量:"..COUNT)
	if ID == 0 then
		MAIN_PLAYER.universalfrag = COUNT
	-- elseif ID > 99 then

	elseif ID < 10000 then
		print("碎片ID错误")
	else
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PIECE_UPDATE), {ID=ID, COUNT=COUNT})
	end
end

-- 分解碎片获将魂
Msg_Logic[MSG_MS2C_PIECE_TO_SOUL_RE] = function ( tcp , msg )
	printLog("网络日志","分解碎片获将魂消息")
	local resault = msg:ReadIntData()
	if resault == ePH_Success then
		print("分解成功")
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_PIECE_TO_SOUL_RE))
	else
		print("分解失败")
	end
end
