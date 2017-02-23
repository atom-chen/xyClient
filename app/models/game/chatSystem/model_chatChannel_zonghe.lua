--
-- Author: lipeng
-- Date: 2015-07-03 09:45:31
-- 综合聊天频道

local model_chatChannel_zonghe = class("model_chatChannel_zonghe")


function model_chatChannel_zonghe:ctor()
	self._contentList = {}
	self._contentMaxNum = 30
end

--获取聊天内容最大数量
function model_chatChannel_zonghe:getContentMaxNum()
	return self._contentMaxNum
end

--清空内容列表
function model_chatChannel_zonghe:clearContents()
	self._contentList = {}
end

--获取当前内容数量
function model_chatChannel_zonghe:getCurContentNum()
	return #self._contentList
end


function model_chatChannel_zonghe:pushBackContent( content )
	self._contentList[#self._contentList + 1] = content

	if #self._contentList > self._contentMaxNum then
        table.remove(self._contentList, 1)
    end
end


function model_chatChannel_zonghe:forEachContentDoSomething( callBack )
	local isBreak = false
	for i,v in ipairs(self._contentList) do
		isBreak = callBack(i, v)
		if isBreak then
			break
		end
	end
end


return model_chatChannel_zonghe
