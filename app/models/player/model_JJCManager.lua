--
-- Author: Wu Hengmin
-- Date: 2015-07-29 20:20:01
--

local model_JJCManager = class("model_JJCManager")
--[[发送全局事件名预览
eventModleName: model_JJCManager
eventName: 
	rank -- 打开/刷新排名界面
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_PVP_RANK_INFO_RE) -- 获得竞技场排行数据
]]
function model_JJCManager:ctor()
	-- body
	self.targetplayer = {}
	self.rankplayer = {}
	self.score = 0
	self.rank = 5000

	self.atttime = 0 -- 可挑战次数
	self.atked = 0 -- 已挑战次数
	self.getatk = 0 -- 购买次数

	self:_registGlobalEventListeners()
end

function model_JJCManager:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_PVP_RANK_INFO_RE), callBack=handler(self, self._onMSG_MS2C_PVP_RANK_INFO_RE)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function model_JJCManager:_onMSG_MS2C_PVP_RANK_INFO_RE()
	-- body
	dispatchGlobaleEvent("model_JJCManager", "rank")
end

return model_JJCManager
