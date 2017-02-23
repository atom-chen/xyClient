--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: model_missionManager
eventName:
	open_mission -- 开启界面
]]

local missionSystem = class("missionSystem")

local class_mail = import("app.views.gameWorld.mission2.UI_Mission.lua")

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
	local mail = class_mail:new()
	scene:addChildToLayer(LAYER_ID_POPUP, mail)

	GLOBAL_COMMON_ACTION:popupOut({
			node = mail.resourceNode_:getChildByName("main_layout"),
			shadowNode = mail.resourceNode_:getChildByName("shadow_layout"),
		})
end

return missionSystem
