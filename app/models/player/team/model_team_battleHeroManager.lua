--
-- Author: lipeng
-- Date: 2015-07-10 15:55:52
-- 上阵武将管理

local class_model_team_battlePos = import(".model_team_battlePos")

local model_team_battleHeroManager = class("model_team_battleHeroManager")



function model_team_battleHeroManager:ctor(target)
	self._target = target

	self:_initPos()
end

--获取队长位置
function model_team_battleHeroManager:getLeaderPos()
	return self._poses[1]
end

--目标英雄是否为队长
function model_team_battleHeroManager:isLeader( heroGUID )
	return self._poses[1]:getHeroGUID() == heroGUID
end


--查看上阵队列中是否有目标英雄
function model_team_battleHeroManager:hasHero( guid )
	for i=1, MaxTeamMemberNum do
		if  guid == self._poses[i]:getHeroGUID() then
			return true
		end
	end

	return false
end

function model_team_battleHeroManager:getPos( idx )
	return self._poses[idx]
end

--通过战斗位置索引获取上阵位置索引
function model_team_battleHeroManager:getPosIdxWithPosOnWar( posOnWar )
	for i=1, MaxTeamMemberNum do
		if  self._poses[i]:getPosOnWar() == posOnWar then
			return i
		end
	end
end


--通过装备GUID获取上阵位置索引
function model_team_battleHeroManager:getPosIdxWithEquip( equipGUID )
	for i=1, MaxTeamMemberNum do
		if  self._poses[i]:hasEquip(equipGUID) then
			return i
		end
	end
end


--获取主力在上阵武将中的位置列表
function model_team_battleHeroManager:getZhuLiListOnBattlePosIdxList()
	local zhuLiListOnBattlePosIdxList = {}
	for i=1, MaxTeamMemberNum do
		if  self._poses[i]:isZhuLiOnWar() then
			zhuLiListOnBattlePosIdxList[#zhuLiListOnBattlePosIdxList+1] = self._poses[i]
		end
	end

	return zhuLiListOnBattlePosIdxList
end


--获取替补在上阵武将位置中的索引列表
function model_team_battleHeroManager:getTiBuOnBattlePosIdxList()

	local tiBuOnBattlePosIdxList = {}
	for i=1, MaxTeamMemberNum do
		if  self._poses[i]:isTiBuOnWar() then
			tiBuOnBattlePosIdxList[#tiBuOnBattlePosIdxList+1] = self._poses[i]
		end
	end

	return tiBuOnBattlePosIdxList
end


function model_team_battleHeroManager:_initPos()
	self._poses = {}
	for i=1, MaxTeamMemberNum do
		self._poses[i] = class_model_team_battlePos.new(i)
	end
end

return model_team_battleHeroManager
