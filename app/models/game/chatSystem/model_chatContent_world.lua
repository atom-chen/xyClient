--
-- Author: lipeng
-- Date: 2015-07-03 10:18:29
-- 聊天内容: 世界

local class_model_chatContent = import(".model_chatContent")

local model_chatContent_world = class("model_chatContent_world", class_model_chatContent)


function model_chatContent_world:ctor()
	self._titleName = "世界"
	self._senderName = "" --发送者名字
	self._sendContent = "" --发送内容
	self._senderVIPLv = 0 --发送者VIP等级
end


function model_chatContent_world:setSenderName( name )
	self._senderName = name
end

function model_chatContent_world:getSenderName()
	return self._senderName
end


function model_chatContent_world:setSendContent( content )
	self._sendContent = content
end

function model_chatContent_world:getSendContent()
	return self._sendContent
end


function model_chatContent_world:setSenderVIPLv( vipLv )
	self._senderVIPLv = vipLv
end


function model_chatContent_world:getSenderVIPLv()
	return self._senderVIPLv
end


return model_chatContent_world
