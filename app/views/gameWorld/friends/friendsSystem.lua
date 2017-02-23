--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 

--[[发送全局事件名预览
eventModleName: friends_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: model_friendsManager
eventName:
	openfriends -- 点击好友按钮
]]

local friendsSystem = class("friendsSystem")

local class_friends = import("app.views.gameWorld.friends.UI_Friends.lua")

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
	local friends = class_friends:new()
	scene:addChildToLayer(LAYER_ID_POPUP, friends)

	GLOBAL_COMMON_ACTION:popupOut({
			node = friends.resourceNode_:getChildByName("main_layout"),
			shadowNode = friends.resourceNode_:getChildByName("shadow_layout"),
		})
end

return friendsSystem
