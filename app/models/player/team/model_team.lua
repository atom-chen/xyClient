--
-- Author: lipeng
-- Date: 2015-07-09 15:26:05
-- 队伍

local class_model_team_battleHeroManager = import(".model_team_battleHeroManager")


local model_team = class("model_team")

--[[发送全局事件名预览
eventModleName: model_team
eventName: 
	powerValueChange --战力值改变
]]

function model_team:ctor()
	self:_initData()
	self:_registGlobalEventListeners()
end

function model_team:_initData()
	self._powerValue = 0--队伍战力值
	self._formationID = 1

	self._battleHeroManager = class_model_team_battleHeroManager.new(self)
end

function model_team:setPowerValue( value)
	self._powerValue = value
	dispatchGlobaleEvent("model_team", "powerValueChange", {sender=self, curPower=self._powerValue})
end


function model_team:getPowerValue()
	return self._powerValue
end

--获取上阵武将管理
function model_team:getBattleHeroManager()
	return self._battleHeroManager
end

--设置阵型ID
function model_team:setFormationID( id )
	self._formationID = id
	dispatchGlobaleEvent("model_team", "formationIDChange", {formationID=self._formationID})
end


--获取阵型ID
function model_team:getFormationID()
	return self._formationID
end



--注册全局事件监听器
function model_team:_registGlobalEventListeners()
	-- self._globalEventListeners = {}
	-- local configs = {
		
	-- }
	-- self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end



return model_team



