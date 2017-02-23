--
-- Author: Li Yang
-- Date: 2014-04-08 14:12:09
-- 好友数据

local model_friends = class("model_friends");
-------------------基础信息-------------------------
-- 好友名称
model_friends.Name = "";
--公会名称
model_friends.AborNnionName = "";

--好友GUID
model_friends.GUID = "";

-- 好友等级
model_friends.grade = 10;

-- 好友登陆时间
model_friends.loginTime = "";

-- 好友签名
model_friends.signature = "";

-- 好友备注
model_friends.remarkname = "";

-- 团队实力
model_friends.strength = 1000;

-- 头衔等级
model_friends.title = 1;

--公会名称
model_friends.societyName = "";

--好友在线标示 0在线 1 不在线
model_friends.mark_online = 0;

-------------------好友队长英雄信息----------------------------------
-- 好友队长英雄
model_friends.captainhero = nil;


--------------------好友交互信息------------------------------
--[[好友是否送自己体力标示
	0 领取完了
	1 没领
	2 已经得到
]]
model_friends.mark_Stamina_get = 0;

--[[ 送好友标示
	0 没送
	1 已送
]]
model_friends.mark_Stamina_send = 0;

--关系标示 0 推荐者 1 普通朋友 2 小伙伴
model_friends.mark_Little_model_friends = 0;

--师徒标示
function model_friends:ctor()
	self.teamData = nil;
end

return model_friends;
