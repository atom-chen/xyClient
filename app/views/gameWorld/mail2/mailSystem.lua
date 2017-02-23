--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 


--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	daoju_touched -- 开启界面
]]

local mailSystem = class("mailSystem")

local class_mail = import("app.views.gameWorld.mail2.UI_Mail.lua")

function mailSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function mailSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "youjian_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function mailSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local mail = class_mail:new()
	scene:addChildToLayer(LAYER_ID_POPUP, mail)

	GLOBAL_COMMON_ACTION:popupOut({
			node = mail.resourceNode_:getChildByName("main_layout"),
			shadowNode = mail.resourceNode_:getChildByName("shadow_layout"),
		})
end

return mailSystem
