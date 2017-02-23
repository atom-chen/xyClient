--
-- Author: Wu Hengmin
-- Date: 2015-08-10 14:49:02
--

local drawcardManager = class("drawcardManager")
--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_DRAW_UPDATE) -- 抽卡
	
]]
function drawcardManager:ctor()
	-- body
	self.drwaedCardTime = 0
	self.drwaedCardNum = 0

	self.data = {}

	self:_registGlobalEventListeners()
end

function drawcardManager:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_DRAW_UPDATE), callBack=handler(self, self._onMSG_MS2C_DRAW_UPDATE)},
		
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function drawcardManager:_onMSG_MS2C_DRAW_UPDATE()
	-- body
	if #self.data > 0 then
		-- UIManager:createZhaomuDialog(self.data)
		-- 更新招募显示
		dispatchGlobaleEvent("zhaomuctrl", "refresh", {data = self.data})
	end
end


return drawcardManager
