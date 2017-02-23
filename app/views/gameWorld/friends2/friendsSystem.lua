--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: model_friendsManager
eventName:
	openfriends -- 开启界面
]]

local friendsSystem = class("friendsSystem")

local class_friends = import("app.views.gameWorld.friends2.UI_Friends.lua")

function friendsSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function friendsSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_friendsManager", eventName = "openfriends", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function friendsSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local firends = class_friends:new()
	scene:addChildToLayer(LAYER_ID_POPUP, firends)

	GLOBAL_COMMON_ACTION:popupOut({
			node = firends.resourceNode_:getChildByName("main_layout"),
			shadowNode = firends.resourceNode_:getChildByName("shadow_layout"),
		})
end

return friendsSystem
