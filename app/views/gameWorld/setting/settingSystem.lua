--
-- Author: Wu Hengmin
-- Date: 2015-07-09 12:03:50
--

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons1
eventName:
	shezhi_touched -- 点击设置按钮
]]

local settingSystem = class("settingSystem")

local class_setting = import(".UI_Setting")

function settingSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function settingSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons1", eventName = "shezhi_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function settingSystem:open()
	-- body
	print("settingSystem:open()")
	local scene = MainPageSystemInstance.scene
	local setting = class_setting:new()
	scene:addChildToLayer(LAYER_ID_POPUP, setting)

	GLOBAL_COMMON_ACTION:popupOut({
			node = setting.resourceNode_:getChildByName("main_layout"),
			shadowNode = setting.resourceNode_:getChildByName("shadow_layout"),
		})
end

return settingSystem
