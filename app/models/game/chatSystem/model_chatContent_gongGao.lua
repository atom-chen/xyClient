--
-- Author: lipeng
-- Date: 2015-07-03 10:28:33
-- 聊天内容: 公告

local class_model_chatContent = import(".model_chatContent")

local model_chatContent_gongGao = class("model_chatContent_gongGao", class_model_chatContent)


function model_chatContent_gongGao:ctor()
	self._titleName = "公告"
	self._gongGao_content = "" --公告的内容
end



return model_chatContent_gongGao

