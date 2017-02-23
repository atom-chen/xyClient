--
-- Author: lipeng
-- Date: 2015-07-10 17:32:06
-- 上阵位置信息

local model_team_battleHeroPos = class("model_team_battleHeroPos")

--[[发送全局事件名预览
eventModleName: model_team_battleHeroPos
eventName: 
	posOnWarChange --在战斗中的位置发生了改变
]]

--替补在阵型位置中的起始索引
TIBU_START_IDX = 7


function model_team_battleHeroPos:ctor(idxInGroup)
	self:_initEquip()
	self:_initHeroAttr()
	--在战斗中的位置
	self._posOnWar = -1
	--在容器中的索引
	self._idxInGroup = idxInGroup
end

function model_team_battleHeroPos:getIdxInGroup()
	return self._idxInGroup
end

function model_team_battleHeroPos:setEquip( equipType, guid )
	self._equipMap[equipType+1] = guid
end

function model_team_battleHeroPos:getEquip( equipType )
	return self._equipMap[equipType+1]
end

function model_team_battleHeroPos:setHeroAttrWithoutGUID( heroAttr )
	self._heroAttr.hp = heroAttr.hp
	self._heroAttr.atk = heroAttr.atk
	self._heroAttr.pdef = heroAttr.pdef
	self._heroAttr.mdef = heroAttr.mdef
	self._heroAttr.miss = heroAttr.miss --闪避
	self._heroAttr.hit = heroAttr.hit --命中
	self._heroAttr.crit = heroAttr.crit--暴击
	self._heroAttr.crit_damage = heroAttr.crit_damage--爆伤
	self._heroAttr.tenacity = heroAttr.tenacity--韧性
	self._heroAttr.skillLv = heroAttr.skillLv

	self._heroAttr.delta_hp = heroAttr.delta_hp
	self._heroAttr.delta_atk = heroAttr.delta_atk
	self._heroAttr.delta_pdef = heroAttr.delta_pdef
	self._heroAttr.delta_mdef = heroAttr.delta_mdef
	self._heroAttr.delta_miss = heroAttr.delta_miss
	self._heroAttr.delta_hit = heroAttr.delta_hit
	self._heroAttr.delta_crit = heroAttr.delta_crit
	self._heroAttr.delta_crit_damage = heroAttr.delta_crit_damage
	self._heroAttr.delta_tenacity = heroAttr.delta_tenacity
	self._heroAttr.delta_skill_lv = heroAttr.delta_skill_lv

	--战斗力
	self._heroAttr.power = heroAttr.power
end

function model_team_battleHeroPos:swapPosOnWar( destPos )
	local tempPos = self._posOnWar

	self._posOnWar = destPos._posOnWar
	destPos._posOnWar = tempPos

	dispatchGlobaleEvent("model_team_battleHeroPos", "swapPosOnWar", {sender=self})
end


--以替补起始索引为基础, 设置在战斗中的位置
function model_team_battleHeroPos:setPosOnWarUseTibuStartIdx(idx)
	self._posOnWar = TIBU_START_IDX + idx
	dispatchGlobaleEvent("model_team_battleHeroPos", "posOnWarChange", {sender=self})
end

--以主力起始索引为基础, 设置在战斗中的位置
function model_team_battleHeroPos:setPosOnWarUseZhuLiStartIdx(idx)
	self._posOnWar = 1 + idx
	dispatchGlobaleEvent("model_team_battleHeroPos", "posOnWarChange", {sender=self})
end

--通过在阵型中的位置, 设置在战斗中的位置
function model_team_battleHeroPos:setPosOnWarWithFormationPos(formationPosIdx)
	self._posOnWar = 1 + idx
	dispatchGlobaleEvent("model_team_battleHeroPos", "posOnWarChange", {sender=self})
end

function model_team_battleHeroPos:setPosOnWar(pos)
	self._posOnWar = pos
	dispatchGlobaleEvent("model_team_battleHeroPos", "posOnWarChange", {sender=self})
end

function model_team_battleHeroPos:getPosOnWar()
	return self._posOnWar
end

function model_team_battleHeroPos:getEquipGUID(equipType)
	return self._equipMap[equipType]
end

--检查是否有目标装备
function model_team_battleHeroPos:hasEquip( equipGUID )
	for i=1, EquipTypeNum do
		if self._equipMap[i] == equipGUID then
			return true
		end
	end

	return false
end


function model_team_battleHeroPos:setHeroGUID( guid )
	self._heroAttr.guid = guid
end

function model_team_battleHeroPos:getHeroGUID()
	return self._heroAttr.guid
end


function model_team_battleHeroPos:getHeroAttr()
	return self._heroAttr
end

--在战斗中是否为替补
function model_team_battleHeroPos:isTiBuOnWar()
	return self._posOnWar >= TIBU_START_IDX
end

--获取在战斗中的替补位置
function model_team_battleHeroPos:getTiBuPos()
	if self:isTiBuOnWar() then
		return self._posOnWar - TIBU_START_IDX + 1
	end

	return nil
end

--在战斗中是否为主力
function model_team_battleHeroPos:isZhuLiOnWar()
	return self._posOnWar > 0 and
		self._posOnWar < TIBU_START_IDX 
end


--通过阵型ID， 获取在战斗中的站立位置
function model_team_battleHeroPos:getStandPosOnWar(formationID)
	if self:isZhuLiOnWar() then
		return formationConfig_getStandPos(formationID, self._posOnWar)
	end

	return nil
end

function model_team_battleHeroPos:_initEquip()
	self._equipMap = {}
	for i=1, EquipTypeNum do
		self._equipMap[i] = NULL_GUID
	end
end


function model_team_battleHeroPos:_initHeroAttr()
	self._heroAttr = {}
	self._heroAttr.guid = NULL_GUID
	self._heroAttr.hp = 0
	self._heroAttr.atk = 0
	self._heroAttr.pdef = 0
	self._heroAttr.mdef = 0
	self._heroAttr.miss = 0 --闪避
	self._heroAttr.hit = 0 --命中
	self._heroAttr.crit = 0--暴击
	self._heroAttr.crit_damage = 0--爆伤
	self._heroAttr.tenacity = 0--韧性
	self._heroAttr.skillLv = 0

	self._heroAttr.delta_hp = 0
	self._heroAttr.delta_atk = 0
	self._heroAttr.delta_pdef = 0
	self._heroAttr.delta_mdef = 0
	self._heroAttr.delta_miss = 0
	self._heroAttr.delta_hit = 0
	self._heroAttr.delta_crit = 0
	self._heroAttr.delta_crit_damage = 0
	self._heroAttr.delta_tenacity = 0
	self._heroAttr.delta_skill_lv = 0
end


return model_team_battleHeroPos
