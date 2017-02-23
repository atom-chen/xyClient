--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:41:05
--

--[[发送全局事件名预览
eventModleName: shiji_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: model_marketManager
eventName:
	openXiangou -- 打开或更新
]]

local shijiSystem = class("shijiSystem")

local class_shiji = import(".UI_Shiji")



function shijiSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
	self.display = false
end

function shijiSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_marketManager", eventName = "openXiangou", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function shijiSystem:open()
	-- body
	if self.display then
		dispatchGlobaleEvent("shiji_ctrl", "refreshlist", {})
	else
		local scene = MainPageSystemInstance.scene
		self.shiji = class_shiji:new()
		scene:addChildToLayer(LAYER_ID_POPUP, self.shiji)

		GLOBAL_COMMON_ACTION:popupOut({
				node = self.shiji.resourceNode_:getChildByName("main_layout"),
				shadowNode = self.shiji.resourceNode_:getChildByName("shadow_layout"),
			})

		self.display = true
	end
end

function shijiSystem.getInstance()
    if shijiSystem.instance == nil then
        shijiSystem.instance = shijiSystem.new()
    end

    return shijiSystem.instance
end


shijiSystemInstance = shijiSystem.getInstance()

return shijiSystem
