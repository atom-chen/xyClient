--
-- Author: Wu Hengmin
-- Date: 2015-08-05 19:49:28
--

local model_qiandaoManager = class("model_qiandaoManager")
--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_START_QIANDAO) -- 签到数据
]]
function model_qiandaoManager:ctor()
	-- body
	self.leiji = 8
	self.kebuqian = 10

	self.yuekashengyu = 0
	self.yuekakelingqu = 0

	self.gaojiyueshengyu = 0
	self.gaojiyuekelingqu = 0

	self:_registGlobalEventListeners()
end

function model_qiandaoManager:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "netMsg", eventName = tostring(MSG_MS2C_START_QIANDAO), callBack=handler(self, self._onMSG_MS2C_START_QIANDAO)},
		
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


return model_qiandaoManager
