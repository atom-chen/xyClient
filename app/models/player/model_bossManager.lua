--
-- Author: Wu Hengmin
-- Date: 2015-08-07 10:37:50
--

local model_bossManager = class("model_bossManager")
--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_CAMPAIGN_BOSS_INFO) -- 打开boss面板
]]
function model_bossManager:ctor()
	-- body
	self.data = {}
	for i=1,4 do
		self.data[i] = {
			time = 0, -- 开启时间
			level = 99,
			hp = 9999999,
			max = 9999999,
			atk = 0.8,
			isdrum = 1,
			damage = 9999,
			rank = 99,
			colddown = 30,
			fuhuo = 1,
			state = 2,
			closetime = 0, -- 可进攻关闭时间
		}
	end


	self.ranks = {
		id = 3004,
		bosslevel = 99,
		hp = 999999,
		time = 9999,
		kill = {
			name = "测试",
			damage = 99999,
		},
		ranks = {},
		lucks = {},
	}

	self:_registGlobalEventListeners()
end

function model_bossManager:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_CAMPAIGN_BOSS_INFO), callBack=handler(self, self._onMSG_MS2C_CAMPAIGN_BOSS_INFO)},
		
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function model_bossManager:_onMSG_MS2C_CAMPAIGN_BOSS_INFO(params)
	-- body
	local k = params._usedata.k
	UIManager:createBossDialog(k)
end

return model_bossManager
