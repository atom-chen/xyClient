--
-- Author: Wu Hengmin
-- Date: 2015-07-08 11:05:37
--

--[[发送全局事件名预览
eventModleName: huodong_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_START_QIANDAO) -- 点击活动按钮
]]

local huodongSystem = class("huodongSystem")

local class_huodong = import(".UI_Huodong")

function huodongSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function huodongSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_START_QIANDAO), callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function huodongSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local huodong = class_huodong:new()
	scene:addChildToLayer(LAYER_ID_POPUP, huodong)

	GLOBAL_COMMON_ACTION:popupOut({
			node = huodong.resourceNode_:getChildByName("main_layout"),
			shadowNode = huodong.resourceNode_:getChildByName("shadow_layout"),
		})
	-- huodong.dialog = cc.CSLoader:createTimeline("ui_instance/huodong/huodong_layer.csb")
	-- huodong.resourceNode_:runAction(huodong.dialog)
	-- huodong.dialog:play("animation_0", false)
end

return huodongSystem
