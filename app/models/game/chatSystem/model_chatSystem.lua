--
-- Author: lipeng
-- Date: 2015-07-02 20:12:46
-- 聊天系统

local class_model_chatContent_world = import(".model_chatContent_world")
local class_model_chatContent_laBa = import(".model_chatContent_laBa")
local class_model_chatContent_gongGao = import(".model_chatContent_gongGao")

local class_model_chatChannel_zonghe = import(".model_chatChannel_zonghe")


local model_chatSystem = class("model_chatSystem")

--[[发送全局事件名预览
eventModleName: model_chatSystem
eventName: 
	chatChannel_zonghe_updateAllContent --综合聊天频道更新所有内容
	chatChannel_zonghe_addContent --综合聊天频道新增内容
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_SEND_WORLD_CHAT)
	tostring(MSG_MS2C_INSAID_CHAT_ROOM)
]]



function model_chatSystem:ctor()
	self.chatChannelMap = {}
	self.chatChannelMap["综合"] = class_model_chatChannel_zonghe.new()

	--消息接收开关
	self._receiveMsgSwitch = true

	self:_registGlobalEventListeners()
end


function model_chatSystem:setReceiveMsgSwitch( isReceive )
	self._receiveMsgSwitch = isReceive
end



--注册全局事件监听器
function model_chatSystem:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_SEND_WORLD_CHAT), callBack=handler(self, self._onMSG_MS2C_SEND_WORLD_CHAT)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_INSAID_CHAT_ROOM), callBack=handler(self, self._onMSG_MS2C_INSAID_CHAT_ROOM)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--通过服务器消息数据创建聊天内容
local function __createChatContentWithMsgData(msgData)
	local content = nil
	--根据不同的内容类型创建内容
	if msgData.typeName == "世界" then
		content = class_model_chatContent_world.new()
		content:setSenderName(msgData.senderName)
		content:setSendContent(msgData.sendContent)
		content:setSenderVIPLv(msgData.senderVIPLv)

	elseif msgData.typeName == "喇叭" then
		content = class_model_chatContent_laBa.new()

	elseif msgData.typeName == "公告" then
		content = class_model_chatContent_gongGao.new()

	end

	return content
end


--响应综合聊天频道新增内容
function model_chatSystem:_onMSG_MS2C_SEND_WORLD_CHAT( event )
	local msgData = event._usedata.msgData
	local content = __createChatContentWithMsgData(msgData.content)
	self.chatChannelMap["综合"]:pushBackContent(content)
	
	dispatchGlobaleEvent("model_chatSystem", "chatChannel_zonghe_addContent", 
		{
			newContent=content,
			chatChannel_zonghe_instance=self.chatChannelMap["综合"]
		}
	)
end


--响应进入综合聊天频道
function model_chatSystem:_onMSG_MS2C_INSAID_CHAT_ROOM( event )
	self.chatChannelMap["综合"]:clearContents()

	local msgData = event._usedata.msgData

	for i=1, msgData.contentNum do
		--创建内容
		local content = __createChatContentWithMsgData(msgData.contentList[i])
		--将内容存入综合频道
		self.chatChannelMap["综合"]:pushBackContent(content)
	end
	
	dispatchGlobaleEvent("model_chatSystem", "chatChannel_zonghe_updateAllContent", 
		{
			chatChannel_zonghe_instance=self.chatChannelMap["综合"]
		}
	)
end


return model_chatSystem

