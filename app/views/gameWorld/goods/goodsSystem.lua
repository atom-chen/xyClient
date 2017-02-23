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
	daoju_touched -- 点击道具按钮
]]

local goodsSystem = class("goodsSystem")

local class_goods = import("app.views.gameWorld.goods.UI_Goods.lua")

function goodsSystem:ctor()
	-- body
	self:_registGlobalEventListeners()
end

function goodsSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "mainpage_popup_buttons2", eventName = "daoju_touched", callBack=handler(self, self.open)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function goodsSystem:open()
	-- body
	local scene = MainPageSystemInstance.scene
	local goods = class_goods:new()
	scene:addChildToLayer(LAYER_ID_POPUP, goods)

	GLOBAL_COMMON_ACTION:popupOut({
			node = goods.resourceNode_:getChildByName("main_layout"),
			shadowNode = goods.resourceNode_:getChildByName("shadow_layout"),
		})
	-- goods.dialog = cc.CSLoader:createTimeline("ui_instance/goods/goods_layer.csb")
	-- goods.resourceNode_:runAction(goods.dialog)
	-- goods.dialog:play("animation_0", false)
end

return goodsSystem
