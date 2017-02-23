--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: wujiangup_ctrl
eventName:
	open -- 开启界面
]]

local wujiangupSystem = class("wujiangupSystem")

local class_wujiangup = import("app.views.gameWorld.wujiangup.UI_Wujiangup.lua")

function wujiangupSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function wujiangupSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "wujiangup_ctrl", eventName = "open", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function wujiangupSystem:open(params)
	-- body
	print("打开武将升级界面")
	local data = params._usedata.data
	local scene = MainPageSystemInstance.scene
	local wujiangup = class_wujiangup:new()
	wujiangup:updateTo(data)
	scene:addChildToLayer(LAYER_ID_POPUP, wujiangup)

	GLOBAL_COMMON_ACTION:popupOut({
			node = wujiangup.resourceNode_:getChildByName("main_layout"),
			shadowNode = wujiangup.resourceNode_:getChildByName("shadow_layout"),
		})
end

return wujiangupSystem
