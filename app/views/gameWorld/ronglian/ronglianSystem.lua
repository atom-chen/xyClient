--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	ronglian_touched -- 开启界面
]]

local ronglianSystem = class("ronglianSystem")

local class_ronglian = import("app.views.gameWorld.ronglian.UI_Ronglian.lua")

function ronglianSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function ronglianSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "ronglian_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function ronglianSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local ronglian = class_ronglian:new()
	scene:addChildToLayer(LAYER_ID_POPUP, ronglian)

	GLOBAL_COMMON_ACTION:popupOut({
			node = ronglian.resourceNode_:getChildByName("main_layout"),
			shadowNode = ronglian.resourceNode_:getChildByName("shadow_layout"),
		})
end

return ronglianSystem
