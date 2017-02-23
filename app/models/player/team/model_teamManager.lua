--
-- Author: lipeng
-- Date: 2015-07-10 16:32:32
-- 队伍管理

local class_model_team = import(".model_team")
local model_teamManager = class("model_teamManager")


function model_teamManager:ctor(target)
	self._target = target

	self._teams = {}
	for i=1, MaxPlayerTeamNum do
		self._teams[i] = class_model_team:new()
	end
	self._curSelTeamIdx = 1--当前所选团队
end


--清除队伍数据
function model_teamManager:clearTeamData()
	self._teams = {}
	for i=1,MaxPlayerTeamNum do
		self._teams[i] = class_model_team:new()
	end
	self._curSelTeamIdx = 1
end

--选中下一个团队
function model_teamManager:selectNextTeam()
	self._curSelTeamIdx = self._curSelTeamIdx + 1
	if self._curSelTeamIdx > MaxPlayerTeamNum then
		self._curSelTeamIdx = 1
	end
end


--选中上一个团队
function model_teamManager:selectPrepTeam()
	self._curSelTeamIdx = self._curSelTeamIdx - 1
	if self._curSelTeamIdx < 1 then
		self._curSelTeamIdx = MaxPlayerTeamNum
	end
end


--获取当前选中团队
function model_teamManager:getCurSelTeam()
	return self._teams[self._curSelTeamIdx]
end

--获取当前选中队伍索引
function model_teamManager:getCurSelTeamIdx()
	return self._curSelTeamIdx
end


--设置当前选择的团队
function model_teamManager:setCurSelTeam( index )
	self._curSelTeamIdx = index

	if self._curSelTeamIdx > MaxPlayerTeamNum then
		self._curSelTeamIdx = MaxPlayerTeamNum
	end
	
	if self._curSelTeamIdx < 1 then
		self._curSelTeamIdx = 1
	end

	dispatchGlobaleEvent("model_teamManager", "curSelTeamChange")
end

--获取指定队伍
function model_teamManager:getTeam(teamIdx)
	return self._teams[teamIdx]
end

--指定英雄是否在队伍中
function model_teamManager:isInTeam( heroGUID )
	for i=1, MaxPlayerTeamNum do
		if self._teams[i]:getBattleHeroManager():hasHero(heroGUID) then
			return true
		end
	end

	return false
end

--是否穿戴目标装备
function model_teamManager:isTakeEquip( equipGUID )
	for i=1, MaxPlayerTeamNum do
		if nil ~= self._teams[i]:getBattleHeroManager():getPosIdxWithEquip(equipGUID) then
			return true
		end
	end

	return false
end





return model_teamManager
