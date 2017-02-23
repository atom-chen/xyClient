--
-- Author: lipeng
-- Date: 2015-06-12 19:02:19
-- 玩家数据

local model_player = class("model_player")

-- 基础属性
local playerBaseAttrClass = import(".model_playerBaseAttr")
-- 英雄管理
local heroManagerClass = import(".model_heroManager")
-- 道具管理
local goodsManagerClass = import(".model_goodsManager")
-- 任务管理
local missionManagerClass = import(".model_missionManager")
-- 商城管理
local marketManagerClass = import(".model_marketManager")
-- 装备管理
local equipManagerClass = import(".model_equipManager")
-- 队伍管理
local teamManagerClass = import(".team.model_teamManager")
-- 助阵者管理
local helperManagerClass = import(".model_helperManager")
-- 好友管理
local friendsManagerClass = import(".model_friendsManager")
-- 邮件管理
local mailManagerClass = import(".model_mailManager")
-- 福利管理
local fuliManagerClass = import(".model_fuliManager")
-- VIP管理
local VIPManagerClass = import(".model_VIPManager")
-- 竞技场数据管理
local JJCManagerClass = import(".model_JJCManager")
-- 公会
local guildClass = import(".guild.model_guild")
-- 签到数据管理
local qiandaoManagerClass = import(".model_qiandaoManager")
-- boss数据管理
local bossManagerClass = import(".model_bossManager")
-- 抽卡数据管理
local drawcardManagerClass = import(".model_drawcardManager")


function model_player:ctor()
	self.baseAttr = playerBaseAttrClass.new()
	self.heroManager = heroManagerClass.new()
	self.goodsManager = goodsManagerClass.new()
	self.missionManager = missionManagerClass:new()
	self.marketManager = marketManagerClass.new()
	self.equipManager = equipManagerClass.new()
	self.teamManager = teamManagerClass.new()
	self.helperManager = helperManagerClass.new()
	self.friendsManager = friendsManagerClass.new()
	self.mailManager = mailManagerClass.new()
	self.fuliManager = fuliManagerClass.new()
	self.VIPManager = VIPManagerClass.new()
	self.JJCManager = JJCManagerClass.new()
	self.guild = guildClass.new()
	self.qiandaoManager = qiandaoManagerClass.new()
	self.bossManager = bossManagerClass.new()
	self.drawcardManager = drawcardManagerClass.new()
end

function model_player:getBaseAttr()
	return self.baseAttr
end

function model_player:getHeroManager()
	return self.heroManager
end

function model_player:getGoodsManager()
	return self.goodsManager
end

function model_player:getTeamManager()
	return self.teamManager
end

function model_player:getEquipManager()
	return self.equipManager
end

function model_player:getGuild()
	return self.guild
end

--是否允许穿戴装备
function model_player:isAllowWearEquip( equip )
	return equip:getLv() <= self.baseAttr:getLv()
end


return model_player
