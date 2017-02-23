--
-- Author: Wu Hengmin
-- Date: 2015-07-24 17:20:30
--
local model_VIPManager = class("model_VIPManager")

function model_VIPManager:ctor()
	-- body
	-- VIP等级
	self.VipGrade = 0;
	-- 历史充值金额
	self.chongzhijine = 0
	-- 已购买好友次数
	self.purchased_friends = 0
	-- 已购买背包次数
	self.purchased_herolist = 0
	-- 已购买仓库次数
	self.purchased_wearhouselist = 0
	-- 已购买装备背包次数
	self.purchased_equipment = 0
	-- 已购买竞技场进攻次数
	self.purchased_jjc = 0
	-- 已购买体力次数
	self.purchased_tili = 0
	-- 已购买精力次数
	self.purchased_jingli = 0
	-- 已扫荡次数
	self.rushed = 0
	-- 记录礼包购买情况
	self.giftpackage = {}
	-- 将魂购买已刷新次数
	self.jianged = 0
	-- vip工资领取情况
	self.gongzi = 0
end

--得到剩余扫荡次数
function model_VIPManager:getSurplusSweepTime(  )
	local vipData = GetVipCfg(self.VipGrade);
	return vipData.every_day.rush_num - self.rushed;
end

--得到当前战斗的最大速度
function model_VIPManager:getCurrentBattleSpeed(  )
	return GetVipCfg(self.VipGrade).speed_lvl;
end

--更改扫荡次数
function model_VIPManager:UpDataSweepTime( valuse )
	self.rushed = self.rushed + valuse;
end

return model_VIPManager
