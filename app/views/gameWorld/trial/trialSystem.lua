--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:41:05
--

--[[发送全局事件名预览
eventModleName: trial_ctrl -- 试炼界面内部控制
eventName: 
]]

--[[监听全局事件名预览
eventModleName: controler_mainpage_zhanyi2_layer
eventName:
	zhanyi_touched -- 打开试炼
]]

local trialSystem = class("trialSystem")

local class_trial = import(".UI_Trial")



function trialSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
	self.display = false
end

function trialSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "controler_mainpage_zhanyi2_layer", eventName = "zhanyi_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function trialSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	self.shiji = class_trial:new()
	scene:addChildToLayer(LAYER_ID_POPUP, self.shiji)

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.shiji.resourceNode_:getChildByName("main_layout"),
		})
end


return trialSystem
