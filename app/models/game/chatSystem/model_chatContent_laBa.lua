--
-- Author: lipeng
-- Date: 2015-07-03 10:35:21
-- 聊天内容: 喇叭

local class_model_chatContent = import(".model_chatContent")

local model_chatContent_laBa = class("model_chatContent_laBa", class_model_chatContent)


function model_chatContent_laBa:ctor()
	self._titleName = "喇叭"
	self._senderName = "" --发送者的名字
	self._sendContent = "" --发送的内容
end



return model_chatContent_laBa


