--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	shangcheng_touched -- 开启界面
]]

local marketSystem = class("marketSystem")

local class_market = import("app.views.gameWorld.market2.UI_Market.lua")

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
