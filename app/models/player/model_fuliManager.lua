--
-- Author: Wu Hengmin
-- Date: 2015-07-24 16:31:34
--

local model_fuliManager = class("model_fuliManager")

--[[发送全局事件名预览
eventModleName: model_fuliManager
eventName: 
	refresh -- 刷新
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_OPEN_YUEKA) -- 获得物品通知
]]

function model_fuliManager:ctor()
	-- body
	self.qiandao = {}
	self.monthly = {}

	self:_registGlobalEventListeners()
end


--注册全局事件监听器
function model_fuliManager:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "netMsg", eventName = tostring(MSG_MS2C_OPEN_YUEKA), callBack=handler(self, self._onMSG_MS2C_OPEN_YUEKA)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end



return model_fuliManager
