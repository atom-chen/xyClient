--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:41:05
--

--[[发送全局事件名预览
eventModleName: mission_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: model_missionManager
eventName:
	open_mission -- 点击任务按钮
]]

local missionSystem = class("missionSystem")

local class_mission = import(".UI_Mission")

function missionSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function missionSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_missionManager", eventName = "open_mission", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function missionSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local mission = class_mission:new()
	scene:addChildToLayer(LAYER_ID_POPUP, mission)

	GLOBAL_COMMON_ACTION:popupOut({
			node = mission.resourceNode_:getChildByName("main_layout"),
			shadowNode = mission.resourceNode_:getChildByName("shadow_layout"),
		})
end

return missionSystem
