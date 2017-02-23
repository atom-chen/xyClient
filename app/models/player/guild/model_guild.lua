--
-- Author: lipeng
-- Date: 2015-08-05 17:01:14
-- 公会

local model_guild = class("model_guild")

function model_guild:ctor()
	self._guid = NULL_GUID --公会GUID
	self._post = 1 --职位
	self._name = "" --公会名
	self._lv = 1 --公会等级
	self._curPopularValue = 0 --公会人气
	self._declarationContent = "" --公会声明
	self._announcementContent = "" --公会公告
	self._memberCurNum = 0 -- 公会当前成员数量
	self._memberMaxNum = 0 -- 公会成员最大数量
	self._curDKP = 0
	self._systemMsgList = {} --系统消息列表
end


function model_guild:setGUID( guid )
	self._guid = guid
end

function model_guild:getGUID()
	return self._guid
end

function model_guild:setLv( lv )
	self._lv = lv
end

function model_guild:getLv()
	return self._lv
end

function model_guild:setPost( post )
	self._post = post
end

function model_guild:getPost()
	return self._post
end

function model_guild:setCurPopularValue( popularValue )
	self._curPopularValue = popularValue
end

function model_guild:getCurPopularValue()
	return self._curPopularValue
end

function model_guild:setDeclarationContent( str )
	self._declarationContent = str
end

function model_guild:getDeclarationContent()
	return self._declarationContent
end

function model_guild:setAnnouncementContent( str )
	self._announcementContent = str
end

function model_guild:getAnnouncementContent( str )
	return self._announcementContent
end

function model_guild:setName( name )
	self._name = name
end

function model_guild:getName()
	return self._name
end

function model_guild:setMaxMemberNum(num)
	self._memberMaxNum = num
end

function model_guild:getMaxMemberNum()
	return self._memberMaxNum
end

function model_guild:setMemberCurNum(num)
	self._memberCurNum = num
end

function model_guild:getMemberCurNum()
	return self._memberCurNum
end


function model_guild:setSystemMsgList( msgList )
	self._systemMsgList = clone(msgList)
end

function model_guild:getSystemMsgList()
	return self._systemMsgList
end

return model_guild
