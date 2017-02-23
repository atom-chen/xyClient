--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_OPEN_QIYU_LIST) -- 开启界面
]]
dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_OPEN_QIYU_LIST))
local qiyuSystem = class("qiyuSystem")

local class_qiyu = import("app.views.gameWorld.qiyu.UI_Qiyu.lua")

function qiyuSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function qiyuSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_OPEN_QIYU_LIST), callBack=handler(self, self.open)},
		{modelName = "model_qiyuManager", eventName = "open_qiyu", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function qiyuSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local qiyu = class_qiyu:new()
	scene:addChildToLayer(LAYER_ID_POPUP, qiyu)

	GLOBAL_COMMON_ACTION:popupOut({
			node = qiyu.resourceNode_:getChildByName("main_layout"),
			shadowNode = qiyu.resourceNode_:getChildByName("shadow_layout"),
		})
end

return qiyuSystem
