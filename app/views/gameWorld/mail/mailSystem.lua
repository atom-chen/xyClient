--
-- Author: Wu Hengmin
-- Date: 2015-07-08 11:05:37
--

--[[发送全局事件名预览
eventModleName: mail_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	youjian_touched -- 点击邮件按钮
]]

local mailSystem = class("mailSystem")

local class_mail = import(".UI_Mail")

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
