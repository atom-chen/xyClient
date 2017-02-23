--
-- Author: Wu Hengmin
-- Date: 2015-07-08 11:05:37
--

--[[发送全局事件名预览
eventModleName: market_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	shangcheng_touched -- 点击商城按钮
]]

local marketSystem = class("marketSystem")

local class_market = import(".UI_Market")

function marketSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function marketSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "shangcheng_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function marketSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local market = class_market:new()
	scene:addChildToLayer(LAYER_ID_POPUP, market)

	GLOBAL_COMMON_ACTION:popupOut({
			node = market.resourceNode_:getChildByName("main_layout"),
			shadowNode = market.resourceNode_:getChildByName("shadow_layout"),
		})
end

return marketSystem
