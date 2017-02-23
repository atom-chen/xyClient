--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:41:05
--

--[[发送全局事件名预览
eventModleName: equip_ctrl -- 任务界面内部控制
eventName: 
	refreshlist -- 刷新内容
	clickSubTitleList -- 点击了导航栏
	clickSubTitleButtom -- 响应导航按钮
]]

--[[监听全局事件名预览
eventModleName: model_equipManager
eventName:
	openequip -- 点击任务按钮
]]

local equipSystem = class("equipSystem")

local class_equip = import(".UI_Equip")

function equipSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function equipSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_equipManager", eventName = "openequip", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function equipSystem:open(params)
	-- body
	local target = nil
	local guid = nil
	if type(params) == "table" then
		target = params.target
		guid = params.guid
	end
	local scene = MainPageSystemInstance.scene
	local equip = class_equip:new()
	equip:switchDisplay(target or "装备列表", true, guid)
	scene:addChildToLayer(LAYER_ID_POPUP, equip)

	GLOBAL_COMMON_ACTION:popupOut({
			node = equip.resourceNode_:getChildByName("main_layout"),
			shadowNode = equip.resourceNode_:getChildByName("shadow_layout"),
		})
end



function equipSystem.getInstance()
    if equipSystem.instance == nil then
        equipSystem.instance = equipSystem.new()
    end

    return equipSystem.instance
end


equipSystemInstance = equipSystem.getInstance()

return equipSystem
