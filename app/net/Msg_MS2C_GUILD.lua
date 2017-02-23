--
-- Author: lipeng
-- Date: 2014-04-25 11:28:54
--
-- 公会数据 消息片

-- 获取公会列表
Msg_Logic[MSG_MS2C_GET_GUILD_LIST] = function ( tcp , msg  )
	printNetLog("[获取公会列表回复] 消息(MSG_MS2C_GET_GUILD_LIST)")
	local msgData = {}
	msgData.num = msg:ReadIntData()
	msgData.guildList = {}

	for i=1, msgData.num do
		msgData.guildList[i] = {}
		local guildInfo = msgData.guildList[i]
		guildInfo.id = msg:ReadString()
		guildInfo.name = msg:ReadString()
		--会长名
		guildInfo.managerName = msg:ReadString()
		--公会宣言
		guildInfo.declaration = msg:ReadString()
		guildInfo.faZhanDu = msg:ReadIntData()
		guildInfo.memberCurNum = msg:ReadIntData()
		guildInfo.memberMaxNum = msg:ReadIntData()
		guildInfo.isApply = msg:ReadIntData()
	end

	printNetLog(serialize(msgData))
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GET_GUILD_LIST), {msgData = msgData})
end


-- 更新公会列表
Msg_Logic[MSG_MS2C_UPDATE_GUILD_LIST] = function ( tcp , msg  )
	printLog("网络日志", "[更新公会列表回复] 消息(MSG_MS2C_UPDATE_GUILD_LIST)数据： ")
	local msgData = {}
    msgData.guildNum = msg:ReadIntData()
    msgData.guildList = {}

    printLog("网络日志", "公会数量: "..msgData.guildNum)

    local guildData = nil
    for i=1, msgData.guildNum do
        msgData.guildList[i] = {}
        guildData = msgData.guildList[i]
        guildData.guid = msg:ReadString()
        guildData.name = msg:ReadString()
        guildData.declaration = msg:ReadString()
        guildData.faZhanDu = msg:ReadIntData()
        guildData.memberCurNum = msg:ReadIntData()
        guildData.memberMaxNum = msg:ReadIntData()

        printLog("网络日志", "公会ID: "..guildData.guid..
        	"公会名: "..guildData.name..
        	"宣言内容: "..guildData.declaration..
        	"发展度: "..guildData.faZhanDu..
        	"成员数量: "..guildData.memberCurNum..
        	"成员数量上限: "..guildData.memberMaxNum
        )
    end

    dispatchGlobaleEvent("net", tostring(MSG_MS2C_UPDATE_GUILD_LIST), {msgData = msgData})
end


-- 玩家已申请公会列表
Msg_Logic[MSG_MS2C_GET_SHENQING_GUILD_LIST] = function ( tcp , msg  )

end


-- 玩家取消申请公会
Msg_Logic[MSG_MS2C_QUXIAO_SHENQING] = function ( tcp , msg  )
	printNetLog("[玩家取消申请公会] 消息(MSG_MS2C_QUXIAO_SHENQING)")
	
	local msgData = {}
    msgData.result = msg:ReadIntData()

    if eGUILD_QuxiaoSucced == msgData.result then
    	msgData.guid = msg:ReadString()

	    UIManager:CreateSamplePrompt("取消申请成功")
    end

    printNetLog(serialize(msgData))
    dispatchGlobaleEvent("net", tostring(MSG_MS2C_QUXIAO_SHENQING), {msgData = msgData})
end


-- 创建公会回复
Msg_Logic[MSG_MS2C_GUILD_CREATE] = function ( tcp , msg  )
	local msgData = {}

	msgData.result = msg:ReadIntData()

	printLog("网络日志",
		"[创建公会回复] 消息(MSG_MS2C_GUILD_CREATE), 结果: %d", 
		msgData.result
	)
	
	if eGUILD_CreateSuccess == msgData.result then
		msgData.guildGUID = msg:ReadString()
   		MAIN_PLAYER:getGuild():setGUID(msgData.guildGUID)

   		msgData.post = msg:ReadIntData()
   		MAIN_PLAYER:getGuild():setPost(msgData.post)

		--发送获取公会信息请求
		printLog("网络日志"," 发送获取公会信息请求: ")
		gameTcp:SendMessage(MSG_C2MS_GUILD_GETINFO)

		printLog("网络日志", "GUID: "..msgData.guildGUID..", 官职: "..
                msgData.post)
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_CREATE), {msgData = msgData})
end



-- 申请加入公会回复
Msg_Logic[MSG_MS2C_GUILD_JOIN] = function ( tcp , msg  )
	printNetLog("[申请加入公会回复] 消息(MSG_MS2C_GUILD_JOIN)数据： ")
	
	local msgData = {}
	msgData.result = msg:ReadIntData()
	if eGUILD_ApplySucced == msgData.result then
		msgData.guid = msg:ReadString()
		UIManager:CreateSamplePrompt("已向军团发出加入申请")
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end
	
	printNetLog(serialize(msgData))
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_JOIN), {msgData = msgData})
end



-- 获取公会信息回复
Msg_Logic[MSG_MS2C_GUILD_GETINFO] = function ( tcp , msg  )
	local msgData = {}
	msgData.result = msg:ReadIntData() 

	printLog("网络日志",
		"[获取公会信息回复] 消息(MSG_MS2C_GUILD_GETINFO), 结果: %d", 
		msgData.result
	)

	if msgData.result == eGUILD_FindSucced then
		msgData.curPopularity = msg:ReadIntData() -- 公会当前资源
		msgData.name = msg:ReadString() -- 公会名称
		msgData.declaration = msg:ReadString() -- 公会宣言
		msgData.announcement = msg:ReadString() -- 公会公告
		msgData.lv = msg:ReadIntData() -- 发展度
		msgData.curMemberNum = msg:ReadIntData() -- 当前成员数量
		msgData.maxMemberNum = msg:ReadIntData() -- 最大成员数量
		msgData.systemMsgNum = msg:ReadIntData() -- 事件内容的条数

		msgData.systemMsgList = {}

		printLog("网络日志", "系统消息数量:"..msgData.systemMsgNum)
		for i=1, msgData.systemMsgNum do
			msgData.systemMsgList[i] = msg:ReadString() --事件内容
			printLog("网络日志", msgData.systemMsgList[i])
		end

		local guildData = MAIN_PLAYER:getGuild()
		guildData:setLv(msgData.lv)
		guildData:setCurPopularValue(msgData.curPopularity)
		guildData:setName(msgData.name)
		guildData:setDeclarationContent(msgData.declaration)
		guildData:setAnnouncementContent(msgData.announcement)
		guildData:setMemberCurNum(msgData.curMemberNum)
		guildData:setMaxMemberNum(msgData.maxMemberNum)
		guildData:setSystemMsgList(msgData.systemMsgList)

		printLog("网络日志",
			"公会等级 "..msgData.lv..
			", 当前资源"..msgData.curPopularity..
			", 公会名"..msgData.name..
			", 公会宣言"..msgData.declaration..
			", 公会公告"..msgData.announcement..
            ", 发展度"..msgData.lv..
            ", 当前成员数量"..msgData.curMemberNum..
            ", 最大成员数量"..msgData.maxMemberNum
        )
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_GETINFO), {msgData=msgData})
end



-- 请求公会成员审核列表回复
Msg_Logic[MSG_MS2C_GUILD_GET_APPLYMEMBER] = function ( tcp , msg  )
	local msgData = {}
	msgData.result = msg:ReadIntData()

	printNetLog("[请求公会成员审核列表回复] 消息(MSG_MS2C_GUILD_GET_APPLYMEMBER) 结果： "..msgData.result)
	
	if eGUILD_GetSuccess == msgData.result then
		msgData.num = msg:ReadIntData()

		printNetLog("数量 "..msgData.num)
		msgData.verifyList = {}

		for i=1, msgData.num do
			msgData.verifyList[i] = {}
			local verifyData = msgData.verifyList[i]
			verifyData.playerGUID = msg:ReadString()
			verifyData.playerName = msg:ReadString()
			verifyData.qianMing = msg:ReadString()
			verifyData.playerLv = msg:ReadIntData()
			verifyData.lastLoginTime = msg:ReadIntData()
			verifyData.power = msg:ReadIntData()
			verifyData.leaderTempleateID = msg:ReadIntData()
			verifyData.leaderLv = msg:ReadIntData()
			verifyData.addtionHP = msg:ReadIntData()
			verifyData.addtionAttack = msg:ReadIntData()

			printNetLog(
				"玩家ID "..verifyData.playerGUID..
				",  玩家名 "..verifyData.playerName..
				",  签名 "..verifyData.qianMing..
				",  玩家等级 "..verifyData.playerLv..
				",  上次登陆时间 "..verifyData.lastLoginTime..
				",  战斗力 "..verifyData.power..
				",  队长模板ID "..verifyData.leaderTempleateID..
				",  队长等级 "..verifyData.leaderLv..
				",  生命 "..verifyData.addtionHP..
				",  攻击 "..verifyData.addtionAttack
			)
		end

	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end
	
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_GET_APPLYMEMBER), {msgData=msgData})
end



-- 同意待审核玩家加入公会回复
Msg_Logic[MSG_MS2C_GUILD_INSERT_MEMBER] = function ( tcp , msg  )
	printNetLog("[同意待审核玩家加入公会回复] 消息(MSG_MS2C_GUILD_INSERT_MEMBER)")
	
	local msgData = {}
	msgData.result = msg:ReadIntData()

	if eGUILD_InsertSuccess == msgData.result then
		msgData.playerName = msg:ReadString()
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end


	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_INSERT_MEMBER), {msgData=msgData})
end


-- 拒绝待审核玩家加入公会请求回复
Msg_Logic[MSG_MS2C_GUILD_CANCEL_APPLY] = function ( tcp , msg  )
	printNetLog("[拒绝待审核玩家加入公会请求回复] 消息(MSG_MS2C_GUILD_CANCEL_APPLY)")
	
	local msgData = {}
	msgData.result = msg:ReadIntData()

	if eGUILD_CancelSuccess == msgData.result then
		msgData.playerName = msg:ReadString()
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end


	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_CANCEL_APPLY), {msgData=msgData})
end



-- 获取公会成员列表回复
Msg_Logic[MSG_MS2C_GUILD_GET_MEMBER] = function ( tcp , msg  )
	local msgData = {}
	msgData.result = msg:ReadIntData()

	printNetLog("[获取公会成员列表回复] 消息(MSG_C2MS_GUILD_GET_MEMBER) 结果： "..msgData.result)
	
	if eGUILD_GetSuccess == msgData.result then
		msgData.curMemberNum = msg:ReadIntData()
		msgData.maxMemberNum = msg:ReadIntData()

		msgData.num = msg:ReadIntData()
		msgData.memberList = {}

		printNetLog("数量 "..msgData.num)

		for i=1, msgData.num do
			msgData.memberList[i] = {}
			local member = msgData.memberList[i]
			member.onlineState = msg:ReadIntData() -- 0: 不在线 1: 在线
			member.playerGUID = msg:ReadString()
			member.playerName = msg:ReadString()
			member.qianMing = msg:ReadString() --玩家签名
			member.playerLv = msg:ReadIntData()
			member.lastLoginTime = msg:ReadIntData()
			member.power = msg:ReadIntData() -- 战力值
			member.leaderTempleateID = msg:ReadIntData()
			member.addtionHP = msg:ReadIntData()
			member.addtionAttack = msg:ReadIntData()
			member.post = msg:ReadIntData() --官职
			member.dkp = msg:ReadIntData()

			printNetLog(
				"在线状态 "..member.onlineState..
				",  玩家ID "..member.playerGUID..
				",  玩家名 "..member.playerName..
				",  玩家签名 "..member.qianMing..
				",  玩家等级 "..member.playerLv..
				",  上次登陆时间 "..member.lastLoginTime..
				",  战力值 "..member.power..
				",  队长模板ID "..member.leaderTempleateID..
				",  官职 "..member.post..
				",  dkp "..member.dkp)
		end

		--玩家列表排序
		table.sort( msgData.memberList, function ( a, b )
			--官职相同
			if a.post == b.post then
				--都在线
				if a.onlineState == 1 and 
					b.onlineState == 1 then
					--玩家等级高的在前面
					return a.playerLv > b.playerLv

				else
					--在线的在前面
					return a.onlineState == 1
				end

			--官职不同
			else
				--官职大的在前面(因为会长是1, 副会长是2)
				return a.post < b.post
			end
		end )

	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_GET_MEMBER), {msgData=msgData})
end



-- 退出公会回复
Msg_Logic[MSG_MS2C_GUILD_MEMBER_QUITGUILD] = function ( tcp , msg  )
	printNetLog("[退出公会回复] 消息(MSG_MS2C_GUILD_MEMBER_QUITGUILD)")

	local msgData = {}

	msgData.result = msg:ReadIntData()

	if eGUILD_QuitSucced == msgData.result then
		UIManager:CreateSamplePrompt("退出军团成功")
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_MEMBER_QUITGUILD), {msgData=msgData})
end


-- 踢出公会成员回复
Msg_Logic[MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD] = function ( tcp , msg  )
	printNetLog("[踢出公会成员回复] 消息(MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD)")

	local msgData = {}

	msgData.result = msg:ReadIntData()

	if eGUILD_QuitSucced == msgData.result then
		UIManager:CreateSamplePrompt("踢出成员成功")
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD), {msgData=msgData})
end



-- 解散公会回复
Msg_Logic[MSG_MS2C_GUILD_DISSOLVE] = function ( tcp , msg  )
	
end


-- 公会出价
Msg_Logic[MSG_MS2C_YUANBAO_JINGBIAO] = function ( tcp , msg  )
	local msgData = {}
	msgData.result = msg:ReadIntData()

	printNetLog("[公会出价] 消息(MSG_MS2C_YUANBAO_JINGBIAO) 结果： "..msgData.result)
	
	if eGUILD_Jingbiaochenggong ~= msgData.result then
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	else
		UIManager:CreateSamplePrompt("竞价成功")
	end
	
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_YUANBAO_JINGBIAO), {msgData=msgData})
end


-- 公会竞价列表
Msg_Logic[MSG_MS2C_RUSH_JINGBIAO_LIST] = function ( tcp , msg  )
	
end




-- 请求公会展示列表回复
Msg_Logic[MSG_MS2C_GET_ZHANSHI_LIST] = function ( tcp , msg  )
	printNetLog("[请求公会展示列表回复] 消息(MSG_MS2C_GET_ZHANSHI_LIST)： ")

	local msgData = {}
    msgData.guildNum = msg:ReadIntData()
    msgData.guildList = {}

    printNetLog("公会数量: %d", msgData.guildNum)

    local guildData = nil
    for i=1, msgData.guildNum do
        msgData.guildList[i] = {}
        guildData = msgData.guildList[i]
        guildData.guid = msg:ReadString()
        guildData.name = msg:ReadString()
        guildData.declaration = msg:ReadString()
        guildData.lv = msg:ReadIntData()
        guildData.memberCurNum = msg:ReadIntData()
        guildData.memberMaxNum = msg:ReadIntData()
        guildData.guildManagerName = "我是团长"

        printNetLog("公会ID: "..guildData.guid..
        	"公会名: "..guildData.name..
        	"宣言内容: "..guildData.declaration..
        	"等级: "..guildData.lv..
        	"成员数量: "..guildData.memberCurNum..
        	"成员数量上限: "..guildData.memberMaxNum
        )
    end

    dispatchGlobaleEvent("net", tostring(MSG_MS2C_GET_ZHANSHI_LIST), {msgData=msgData})
end


--打开公会商店
Msg_Logic[MSG_MS2C_OPEN_GUILD_SHOP] = function ( tcp , msg )
	
end


--公会商店补货
Msg_Logic[MSG_MS2C_GUILD_SHOP_BUHUO] = function ( tcp , msg )
	
end


--竞拍结果
Msg_Logic[MSG_MS2C_ITEM_JINGPAI] = function ( tcp , msg )
	
end


--更新公会信息
Msg_Logic[MSG_MS2C_UPDATE_GUILD_INFO] = function ( tcp , msg )
	
end


--打开公会科技列表
Msg_Logic[MSG_MS2C_OPEN_KEJI_LIST] = function ( tcp , msg )
	printNetLog("[请求打开公会科技列表回复] 消息(MSG_MS2C_OPEN_KEJI_LIST)： ")

	local msgData = {}
	msgData.keJiList = {}
	msgData.num = msg:ReadIntData()
	printNetLog("数量: "..msgData.num)

	local keJiData = nil
	for i=1, msgData.num do
		msgData.keJiList[i] = {}
		keJiData = msgData.keJiList[i]
		keJiData.id = msg:ReadIntData()
		keJiData.lv = msg:ReadIntData()

		printNetLog("科技ID: "..keJiData.id..
			"等级: "..keJiData.lv
		)
	end

	msgData.guildCurPopularity = msg:ReadIntData()
	MAIN_PLAYER:getGuild():setCurPopularValue(msgData.guildCurPopularity)
	printNetLog("军团资源: "..msgData.guildCurPopularity)

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_OPEN_KEJI_LIST), {msgData=msgData})
end



--升级科技结果
Msg_Logic[MSG_MS2C_LVUP_KEJI] = function ( tcp , msg )
	printNetLog("[请求公会升级科技回复] 消息(MSG_MS2C_LVUP_KEJI)： ")

	local msgData = {}
	msgData.result = msg:ReadIntData()
	printNetLog("结果: "..msgData.result)

	if msgData.result == eGUILD_KejiLvupSucced then
		msgData.id = msg:ReadIntData()
		msgData.lv = msg:ReadIntData()
		msgData.guildCurPopularity = msg:ReadIntData()
		local guildData = MAIN_PLAYER:getGuild()
		guildData:setCurPopularValue(msgData.guildCurPopularity)
		printNetLog("军团资源: "..msgData.guildCurPopularity)

		printNetLog(
			"科技ID: "..msgData.id..
			"等级: "..msgData.lv..
			"资源: "..msgData.guildCurPopularity
		)
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_LVUP_KEJI), {msgData=msgData})
end



--提交资源结果
Msg_Logic[MSG_MS2C_GUILD_PAY_RES_RE] = function ( tcp , msg )
	
end


--设置公会宣言
Msg_Logic[MSG_MS2C_SET_XUANYAN] = function ( tcp , msg )
	printLog("网络日志","[设置公会宣言结果] 消息(MSG_MS2C_SET_XUANYAN)： ")

	local msgData = {}
	msgData.result = msg:ReadIntData()
	if msgData.result == eGUILD_SetXuanyan_Succed then
		msgData.xuanYan = msg:ReadString()
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_SET_XUANYAN), {msgData=msgData})
end


--设置公会公告
Msg_Logic[MSG_MS2C_SET_GONGGAO] = function ( tcp , msg )
	printLog("网络日志","[设置公会公告结果] 消息(MSG_MS2C_SET_GONGGAO)： ")

	local msgData = {}
	msgData.result = msg:ReadIntData()
	if msgData.result == eGUILD_SetGonggao_Succed then
		msgData.gongGao = msg:ReadString()
	else
		UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_SET_GONGGAO), {msgData=msgData})
end


--设置官职
Msg_Logic[MSG_MS2C_SET_GUANZHI] = function ( tcp , msg )
	
end


--转让军团给副团长
Msg_Logic[MSG_MS2C_ZHUANRANG_GUILD] = function ( tcp , msg )
	printNetLog("收到消息 转让军团给副团长(MSG_MS2C_ZHUANRANG_GUILD)")

	local msgData = {}
	msgData.result = msg:ReadIntData()

	UIManager:CreatePrompt_NetMsgErrorDescribe(msgData.result)

	if msgData.result == eGUILD_ShanRang_Succed then
		gameTcp:SendMessage(MSG_C2MS_GUILD_GET_MEMBER)
	end
end


--群发邮件结果
Msg_Logic[MSG_MS2C_SENDMAIL_TO_MEMBER] = function ( tcp , msg )
	
end


