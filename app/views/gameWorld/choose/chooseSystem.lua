--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:31:38
-- 

--[[发送全局事件名预览
eventModleName: choose_ctrl -- 任务界面内部控制
eventName: 

]]

--[[监听全局事件名预览
eventModleName: choose_ctrl
eventName:
	open -- 点击道具按钮
]]

local chooseSystem = class("chooseSystem")

local class_choose = import("app.views.gameWorld.choose.UI_Choose.lua")

function chooseSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function chooseSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "choose_ctrl", eventName = "open", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function chooseSystem:open(params)
	-- body
	local scene = MainPageSystemInstance.scene
	self.choose = class_choose:new()
	scene:addChildToLayer(LAYER_ID_POPUP, self.choose)

	if params._usedata.num then
		self.choose:setMax(params._usedata.num)
	end

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.choose.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.choose.resourceNode_:getChildByName("shadow_layout"),
		})
end

function chooseSystem.getInstance()
    if chooseSystem.instance == nil then
        chooseSystem.instance = chooseSystem.new()
    end

    return chooseSystem.instance
end


chooseSystemInstance = chooseSystem.getInstance()

return chooseSystem
