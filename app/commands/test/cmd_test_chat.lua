--
-- Author: lipeng
-- Date: 2015-07-03 17:55:14
-- 测试命令: 聊天

G_onCommand["cmd_test_chat"] = {}
local onCommand = G_onCommand["cmd_test_chat"]


onCommand["MSG_MS2C_SEND_WORLD_CHAT"] = function (parmas)
	local msgData = {}
	msgData.content = {}

	local content = msgData.content
	content.typeName = "世界"

	if content.typeName == "世界" then
		content.senderName = "测试:"
		content.sendContent = parmas.sendContent or "我的个去阿德拔凉的房间里的三间房打法asd是lerewr大放送发斯蒂芬斯蒂芬斯蒂芬访问法认为发斯蒂芬斯蒂芬红太阳教育课YukiYui 如同一人头呀"
		content.senderVIPLv = math.random(0, 1)

	elseif content.typeName == "喇叭" then
		
	elseif content.typeName == "公告" then
		
	end

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_SEND_WORLD_CHAT), {msgData=msgData})
end


onCommand["MSG_MS2C_INSAID_CHAT_ROOM"] = function ()
	local msgData = {}
	msgData.contentNum = 30
	msgData.contentList = {}

	for i=1, msgData.contentNum do
		msgData.contentList[i] = {}
		local content = msgData.contentList[i]
		content.typeName = "世界"

		if content.typeName == "世界" then
			content.senderName = "测试:"
			content.sendContent = "我的个去阿德拔凉的房间里的三间房打法asd是lerewr大放送发斯蒂芬斯蒂芬斯蒂芬访问法认为发斯蒂芬斯蒂芬红太阳教育课YukiYui 如同一人头呀"..i
			content.senderVIPLv = i%5

		elseif content.typeName == "喇叭" then
			
		elseif content.typeName == "公告" then
			
		end
	end

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_INSAID_CHAT_ROOM), {msgData=msgData})
end




