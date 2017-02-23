--
-- Author: lipeng
-- Date: 2014-12-18 11:28:54
--
-- 聊天数据 消息片


-- 群发在线玩家聊天信息
Msg_Logic[MSG_MS2C_SEND_WORLD_CHAT] = function ( tcp , msg  )
	printLog("网络日志","收到 [群发在线玩家聊天信息] 消息(MSG_MS2C_SEND_WORLD_CHAT)：")

	-- local msgData = {}
	-- msgData.chatContent = {}
	-- msgData.chatType = msg:ReadIntData()
	-- msgData.chatContent.name = msg:ReadString()
	-- msgData.vipLv = msg:ReadIntData()
	-- msgData.chatContent.originalName = msgData.chatContent.name
	-- if msgData.chatContent.name ~= user.player.name then
	-- 	msgData.chatContent.name = string.format("[image=#vip.png][/][labelAtlas=numberatlas/number190x24.png|%d|19|24|48|1.1][/] [color=66|251|251]%s:[/]\n", msgData.vipLv, msgData.chatContent.name)
	-- else
	-- 	msgData.chatContent.name = string.format("[image=#vip.png][/][labelAtlas=numberatlas/number190x24.png|%d|19|24|48|1.1][/] [color=40|251|45]%s:[/]\n", msgData.vipLv, msgData.chatContent.name)
	-- end



	-- msgData.chatContent.content = msg:ReadString()


	local msgData = {}
	msgData.chatType = msg:ReadIntData()
	msgData.content = {}

	local content = msgData.content
	content.typeName = "世界" --暂时没有处理其他类型

	if content.typeName == "世界" then
		content.senderName = msg:ReadString()
		content.senderVIPLv = msg:ReadIntData()
		content.sendContent = msg:ReadString()
		
	elseif content.typeName == "喇叭" then
		
	elseif content.typeName == "公告" then
		
	end

	local msgDataString = string.format("类型名字: %s, 内容: %s",
		msgData.chatContent.name,
		msgData.chatContent.content)
	
	printLog("网络日志", "类型: %d, 名字: %s, VIP等级: %d, 内容: %s",
		msgData.chatType,
		content.senderName,
		content.senderVIPLv,
		content.sendContent
	)

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_SEND_WORLD_CHAT), {msgData=msgData})
end

-- 获得高品质物品广播
Msg_Logic[MSG_MS2C_SEND_GETGOODS_CHAT] = function ( tcp , msg  )
	print("MSG_MS2C_SEND_GETGOODS_CHAT")
end


-- 进入聊天室返回上次说话的系统时间
Msg_Logic[MSG_MS2C_INSAID_CHAT_ROOM] = function ( tcp , msg  )
	print("MSG_MS2C_INSAID_CHAT_ROOM")
end



-- 获取玩家信息
Msg_Logic[MSG_MS2C_GET_PLAYER_INFO] = function ( tcp , msg  )
	print("MSG_MS2C_GET_PLAYER_INFO")
end

-- 玩家阵型数据
Msg_Logic[MSG_MS2C_GET_PLAYER_TEAM] = function ( tcp , msg  )
	print("MSG_MS2C_GET_PLAYER_TEAM")
end

-- 全服通告数据
Msg_Logic[MSG_MS2C_GET_ALL_TAKE_NOTICE] = function ( tcp , msg  )
	print("MSG_MS2C_GET_ALL_TAKE_NOTICE")
	
end


-- 群发公会在线玩家聊天信息
Msg_Logic[MSG_MS2C_GUILD_SENDCHAT] = function ( tcp , msg  )
	print("MSG_MS2C_GUILD_SENDCHAT")
end



-- 打开公会聊天
Msg_Logic[MSG_MS2C_GUILD_OPEN_CHAT] = function ( tcp , msg  )
	print("MSG_MS2C_GUILD_OPEN_CHAT")
end


