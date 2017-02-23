--
-- Author: lipeng
-- Date: 2015-09-06 20:47:57
-- 雇佣面板入口节点

local controler_guyong_main_node = class("controler_guyong_main_node")


function controler_guyong_main_node:ctor(guyong_main_node)
	self:_initModels()

	self._guyong_main_node = guyong_main_node

	self:_registUIEvent()
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
	self:_createControlerForUI()

	self:_initViews()

	self:_timerStart()
end


function controler_guyong_main_node:getView()
	return self._guyong_main_node
end

function controler_guyong_main_node:_initModels()
	self._controlerMap = {}
	self._hiresysInfo = {} --雇佣信息
	self._hiresysInfo.gyStrID = ""
	--被雇佣者的状态:
	--保护, 降价
	self._gyState = "初始"
	self._lastTime = 0
end

function controler_guyong_main_node:_registUIEvent()
	--领取收益
	local btn_lqsy = self._guyong_main_node:getChildByName("btn_lqsy")
	local function btn_lqsyTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			gameTcp:SendMessage(MSG_C2MS_HIRESYS_GET_YIELD)
			printNetLog("发送 领取收益(MSG_C2MS_HIRESYS_GET_YIELD) 消息")
        end
	end
	btn_lqsy:addTouchEventListener(btn_lqsyTouched)

	--关闭
	local btn_close = self._guyong_main_node:getChildByName("btn_close")
	local function btn_closeTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			guyongSystemInstance:closeGuYongView()
        end
	end
	btn_close:addTouchEventListener(btn_closeTouched)
end

--注册节点事件
function controler_guyong_main_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._guyong_main_node:registerScriptHandler(onNodeEvent)
end

function controler_guyong_main_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_guyong_main_node:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_HIRESYS_INFO), callBack=handler(self, self._onNetEvent_MSG_MS2C_HIRESYS_INFO)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function controler_guyong_main_node:_createControlerForUI()
	self._controlerMap.heroIcon = UIManager:CreateAvatarPart(
		0, 
		{resourceNode = self._guyong_main_node:getChildByName("heroicon")}
	)
end

function controler_guyong_main_node:_initViews()
	self:_updateAllViews()
end


function controler_guyong_main_node:_onNetEvent_MSG_MS2C_HIRESYS_INFO( event )
    local msgData = event._usedata
    self._hiresysInfo = clone(msgData)

    if msgData.gyStrID ~= "" then
    	if self:_isProtectState() then
	    	self._gyState = "保护"
	    	self._stateUpdateRemainTime = guyongSystemInstance:BGY_protectRemainTime(self._hiresysInfo.coolTime)
	    else
	    	self._gyState = "降价"
	    	self._stateUpdateRemainTime = guyongSystemInstance:compute_BGY_nextReducePriceRemainSec(self._hiresysInfo.reducePriceTime)
	    end

	else
		self._gyState = "初始"
		self._stateUpdateRemainTime = 0
    end
    
    self:_updateAllViews()
end

--更新所有视图
function controler_guyong_main_node:_updateAllViews()
	self:_updateView_heroIcon()
	self:_updateView_playerName()
	self:_updateView_playerLv()
	self:_updateView_playerVIPLv()
	self:_updateView_power()
	self:_updateView_jyValue()
	self:_updateView_text_ylValue()
	self:_updateView_text_gy_time_value()
	self:_updateView_text_bh_time()
	self:_updateView_text_bh_time_value()
	self:_updateView_curPrice()
	self:_updateView_lb_bh_time()
	self:_updateView_lb_jj_time()
end


--更新武将ICON
function controler_guyong_main_node:_updateView_heroIcon()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	self._controlerMap.heroIcon:setAvatarByHeroID(self._hiresysInfo.heroTempleateID)
    	self._controlerMap.heroIcon:getResourceNode():setVisible(true)
	else
		self._controlerMap.heroIcon:getResourceNode():setVisible(false)
	end
end

--更新玩家名
function controler_guyong_main_node:_updateView_playerName()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	UIContainer:getChildByName("pn_value"):setString(self._hiresysInfo.playerName)
	else
		UIContainer:getChildByName("pn_value"):setString("")
	end
end


--更新玩家等级
function controler_guyong_main_node:_updateView_playerLv()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	UIContainer:getChildByName("als_lvValue"):setString(self._hiresysInfo.playerLv)
	else
		UIContainer:getChildByName("als_lvValue"):setString(0)
	end
end


--更新玩家VIP等级
function controler_guyong_main_node:_updateView_playerVIPLv()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	UIContainer:getChildByName("text_vipValue"):setString(self._hiresysInfo.vipLv)
	else
		UIContainer:getChildByName("text_vipValue"):setString(0)
	end
end


--更新战斗力
function controler_guyong_main_node:_updateView_power()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	UIContainer:getChildByName("text_powerValue"):setString(self._hiresysInfo.power)
	else
		UIContainer:getChildByName("text_powerValue"):setString(0)
	end
end


--更新每秒获得经验
function controler_guyong_main_node:_updateView_jyValue()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	UIContainer:getChildByName("text_jyValue"):setString(math.floor(self._hiresysInfo.perSecGetExp))
	else
		UIContainer:getChildByName("text_jyValue"):setString(0)
	end
end


--更新每秒获得银两
function controler_guyong_main_node:_updateView_text_ylValue()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	UIContainer:getChildByName("text_ylValue"):setString(math.floor(self._hiresysInfo.perSecGetGold))
	else
		UIContainer:getChildByName("text_ylValue"):setString(0)
	end
end


--更新已雇佣时间
function controler_guyong_main_node:_updateView_text_gy_time_value()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
    	local ygySec = guyongSystemInstance:YGYSec(self._hiresysInfo.gyTime)
		local ygyDay, ygyHour, ygyMin = TIME_HELPER:timeBySecond(ygySec)
		
		UIContainer:getChildByName("text_gy_time_value"):setString(
			string.format("%d天%d小时%d分",
				ygyDay, ygyHour, ygyMin
			)
		)
	else
		UIContainer:getChildByName("text_gy_time_value"):setString("--")
	end
end



--更新保护文本信息
function controler_guyong_main_node:_updateView_text_bh_time()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
		--是否处于保护状态
		if self:_isProtectState() then
			UIContainer:getChildByName("text_bh_time"):setString("保护倒计时:")
		else
			UIContainer:getChildByName("text_bh_time"):setString("降价倒计时:")
		end
	else
		UIContainer:getChildByName("text_bh_time"):setString("保护倒计时:")
	end
end

--更新保护时间文本信息
function controler_guyong_main_node:_updateView_text_bh_time_value()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
		local remainSec = self._stateUpdateRemainTime

		local remainTime = TIME_HELPER:secondToTime(remainSec)
		UIContainer:getChildByName("text_bh_time_value"):setString(
			string.format("%02d:%02d:%02d",
				remainTime.hour,
				remainTime.min,
				remainTime.sec
			)
		)
	else
		UIContainer:getChildByName("text_bh_time_value"):setString("--")
	end
end


--更新当前身价UI
function controler_guyong_main_node:_updateView_curPrice()
	local UIContainer = self._guyong_main_node

	if self._hiresysInfo.gyStrID ~= "" then
		--当前身价
		local curPrice = guyongSystemInstance:compute_BGY_CurPrice(
			self._hiresysInfo.price, 
			self._hiresysInfo.reducePriceTime
		)

		UIContainer:getChildByName("text_sj_value"):setString(math.floor(curPrice))
	else
		UIContainer:getChildByName("text_sj_value"):setString(0)
	end
end


--更新保护loadingBar
function controler_guyong_main_node:_updateView_lb_bh_time()
	local UIContainer = self._guyong_main_node
	local view = UIContainer:getChildByName("lb_bh_time")

	if self._hiresysInfo.gyStrID ~= "" then
		--是否处于保护状态
		if guyongSystemInstance:isProtectStateForBGY(self._hiresysInfo.coolTime) then
			local remainSec = self._stateUpdateRemainTime
			local percent = remainSec / HIRE_FREEZE_SEC
			view:setPercent(percent)
			view:setVisible(true)
		else
			view:setVisible(false)
		end
	else
		view:setVisible(false)
	end
end


--更新降价loadingBar
function controler_guyong_main_node:_updateView_lb_jj_time()
	local UIContainer = self._guyong_main_node
	local view = UIContainer:getChildByName("lb_jj_time")

	if self._hiresysInfo.gyStrID ~= "" then
		--是否处于保护状态
		if guyongSystemInstance:isProtectStateForBGY(self._hiresysInfo.coolTime) then
			view:setVisible(false)
		else
			local remainSec = self._stateUpdateRemainTime
			local percent = remainSec / HIRE_REDUCE_SEC
			view:setPercent(percent)
			view:setVisible(true)
		end
	else
		view:setVisible(false)
	end
end

--是否处于保护状态
function controler_guyong_main_node:_isProtectState()
	return guyongSystemInstance:isProtectStateForBGY(self._hiresysInfo.coolTime)
end

--计时器开启
function controler_guyong_main_node:_timerStart()
	local function timerFun(dt)
		if os.time() - self._lastTime >= 1 then
			self._lastTime = os.time()

			if self._gyState == "初始" then
				return
			end

			self._stateUpdateRemainTime = self._stateUpdateRemainTime - 1

			if self._gyState == "保护" then
				if self._stateUpdateRemainTime <= 0 then
					self._stateUpdateRemainTime = HIRE_REDUCE_SEC - 1
					self._gyState = "降价"
				end

			else
				if self._stateUpdateRemainTime <= 0 then
					self._stateUpdateRemainTime = HIRE_REDUCE_SEC - 1
				end
			end

			self:_updateView_text_bh_time()
			self:_updateView_text_bh_time_value()
			self:_updateView_curPrice()
			self:_updateView_lb_bh_time()
			self:_updateView_lb_jj_time()
			self:_updateView_text_gy_time_value()
		end
        
    end

    
	self._guyong_main_node:scheduleUpdateWithPriorityLua(timerFun, 0)
end

return controler_guyong_main_node
