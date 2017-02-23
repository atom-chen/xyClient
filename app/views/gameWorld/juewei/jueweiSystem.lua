--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	daoju_touched -- 开启界面
]]

local jueweiSystem = class("jueweiSystem")

local class_juewei = import("app.views.gameWorld.juewei.UI_Juewei.lua")

function jueweiSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function jueweiSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons1", eventName = "shezhi_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function jueweiSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local juewei = class_juewei:new()
	scene:addChildToLayer(LAYER_ID_POPUP, juewei)

	GLOBAL_COMMON_ACTION:popupOut({
			node = juewei.resourceNode_:getChildByName("main_layout"),
			shadowNode = juewei.resourceNode_:getChildByName("shadow_layout"),
		})
end

return jueweiSystem
