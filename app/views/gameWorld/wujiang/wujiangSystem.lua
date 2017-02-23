--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 

--[[发送全局事件名预览
eventModleName: backpack_ctrl -- 任务界面内部控制
eventName: 

]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	daoju_touched -- 点击道具按钮
]]

local wujiangSystem = class("wujiangSystem")

local class_wujiang = import("app.views.gameWorld.wujiang.UI_Wujiang.lua")

function wujiangSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function wujiangSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_PIECE_HERO_DATA), callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function wujiangSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local wujiang = class_wujiang:new()
	scene:addChildToLayer(LAYER_ID_POPUP, wujiang)

	GLOBAL_COMMON_ACTION:popupOut({
			node = wujiang.resourceNode_:getChildByName("main_layout"),
			shadowNode = wujiang.resourceNode_:getChildByName("shadow_layout"),
		})
end

return wujiangSystem
