--
-- Author: Wu Hengmin
-- Date: 2015-07-28 16:26:28
--
local friends = class("friends");
-------------------基础信息-------------------------
-- 好友名称
friends.Name = "";
--公会名称
friends.AborNnionName = "";

--好友GUID
friends.GUID = "";

-- 好友等级
friends.grade = 10;

-- 好友登陆时间
friends.loginTime = "";

-- 好友签名
friends.signature = "";

-- 好友备注
friends.remarkname = "";

-- 团队实力
friends.strength = 1000;

-- 头衔等级
friends.title = 1;

--公会名称
friends.societyName = "";

--好友在线标示 0在线 1 不在线
friends.mark_online = 0;

-------------------好友队长英雄信息----------------------------------
-- 好友队长英雄
friends.captainhero = nil;


--------------------好友交互信息------------------------------
--[[好友是否送自己体力标示
	0 领取完了
	1 没领
	2 已经得到
]]
friends.mark_Stamina_get = 0;

--[[ 送好友标示
	0 没送
	1 已送
]]
friends.mark_Stamina_send = 0;

--关系标示 0 推荐者 1 普通朋友 2 小伙伴
friends.mark_Little_friends = 0;

--师徒标示
function friends:ctor()
	self.teamData = nil;
end

return friends;
