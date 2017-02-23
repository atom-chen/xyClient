--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 

--[[发送全局事件名预览
eventModleName: goods_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: mainpage_popup_buttons2
eventName:
	qian_dao_touched -- 点击道具按钮
]]

local arenaSystem = class("arenaSystem")

local class_arena = import("app.views.gameWorld.arena.UI_Arena.lua")

function arenaSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function arenaSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_PVP_TARGET_RE), callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function arenaSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local arena = class_arena:new()
	scene:addChildToLayer(LAYER_ID_POPUP, arena)

	GLOBAL_COMMON_ACTION:popupOut({
			node = arena.resourceNode_:getChildByName("main_layout"),
		})
end

return arenaSystem
