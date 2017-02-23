--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:41:05
--

--[[发送全局事件名预览
eventModleName: fuli_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	meirifuli_touched -- 点击每日福利按钮
]]

local fuliSystem = class("fuliSystem")

local class_fuli = import(".UI_Fuli")

function fuliSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function fuliSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "meirifuli_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function fuliSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local fuli = class_fuli:new()
	fuli:updateDisplay(1)
	scene:addChildToLayer(LAYER_ID_POPUP, fuli)

	GLOBAL_COMMON_ACTION:popupOut({
			node = fuli.resourceNode_:getChildByName("main_layout"),
			shadowNode = fuli.resourceNode_:getChildByName("shadow_layout"),
		})
end

return fuliSystem
