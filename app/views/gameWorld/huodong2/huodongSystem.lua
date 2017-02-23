--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: model_missionManager
eventName:
	open_mission -- 开启界面
]]

local huodongSystem = class("huodongSystem")

local class_huodong = import("app.views.gameWorld.huodong2.UI_Huodong.lua")

function huodongSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function huodongSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_START_QIANDAO), callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function huodongSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local huodong = class_huodong:new()
	scene:addChildToLayer(LAYER_ID_POPUP, huodong)

	GLOBAL_COMMON_ACTION:popupOut({
			node = huodong.resourceNode_:getChildByName("main_layout"),
			shadowNode = huodong.resourceNode_:getChildByName("shadow_layout"),
		})
end

return huodongSystem
