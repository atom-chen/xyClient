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

local backpackSystem = class("backpackSystem")

local class_backpack = import("app.views.gameWorld.backpack.UI_Backpack.lua")

function backpackSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function backpackSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "zhuangbei_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function backpackSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local backpack = class_backpack:new()
	scene:addChildToLayer(LAYER_ID_POPUP, backpack)

	GLOBAL_COMMON_ACTION:popupOut({
			node = backpack.resourceNode_:getChildByName("main_layout"),
			shadowNode = backpack.resourceNode_:getChildByName("shadow_layout"),
		})
end

return backpackSystem
