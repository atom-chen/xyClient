--
-- Author: Wu Hengmin
-- Date: 2015-08-27 11:34:28
--


local zhaomu_view = class("zhaomu_view")


function zhaomu_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:_registUIEvent()
    self:_registNodeEvent()
	self:_registGlobalEventListeners()
    self:init()

end

function zhaomu_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "zhaomuctrl", eventName = "refresh", callBack=handler(self, self.update)},
		-- {modelName = "netMsg", eventName = tostring(MSG_MS2C_VIP_BASE_INFO_CHANGE), callBack=handler(self, self.updateVIP)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function zhaomu_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function zhaomu_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self._rootNode:registerScriptHandler(onNodeEvent)
end

function zhaomu_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
	self.items = {}
	self.avatar = {}
	if #MAIN_PLAYER.drawcardManager.data > 0 then
		-- 已抽取但未选择的情况
		print("已抽取但未选择的情况")
		-- print(#MAIN_PLAYER.drawcardManager.data)
		-- UIManager:createZhaomuDialog(MAIN_PLAYER.drawcardManager.data)
		local params = {}
		params._usedata = {}
		params._usedata.data = MAIN_PLAYER.drawcardManager.data
		-- dispatchGlobaleEvent("zhaomuctrl", "refresh", {data = MAIN_PLAYER.drawcardManager.data})
		self:update(params)
	else
		self:update()
	end
end

function zhaomu_view:getResourceNode()
	-- body
	return self._rootNode
end

function zhaomu_view:_registUIEvent()
	-- body
	local zhaomu = self._rootNode:getChildByName("Panel_1"):getChildByName("Button_1")
	local function zhaomuClicked(sender)
		if VipConfig[MAIN_PLAYER.baseAttr._vipLv].every_day.draw_num - MAIN_PLAYER.drawcardManager.drwaedCardTime <= 0 
			and MAIN_PLAYER.baseAttr._yuanBao < 50 then
			UIManager:CreatePrompt_Bar( {content = "元宝不足"})
		end
        gameTcp:SendMessage(MSG_C2MS_DRAW_BEGIN)
	end
	zhaomu:addClickEventListener(zhaomuClicked)

	local queding = self._rootNode:getChildByName("Panel_1"):getChildByName("Button_1_0")
	local function quedingClicked(sender)
		if self.choose ~= 0 then
			gameTcp:SendMessage(MSG_C2MS_DRAW_SELECT, {self.choose, 0})
			self._rootNode:getChildByName("Panel_1"):getChildByName("hero_"..(self.choose-1)):getChildByName("Image_2"):setVisible(false)
			self:update()
		else

		end
	end
	queding:addClickEventListener(quedingClicked)




	local function clickEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			if self.choose then
				for i=1,5 do
					self._rootNode:getChildByName("Panel_1"):getChildByName("hero_"..(i-1)):getChildByName("Image_2"):setVisible(false)
				end
				self._rootNode:getChildByName("Panel_1"):getChildByName("hero_"..(sender.index-1)):getChildByName("Image_2"):setVisible(true)
				self.choose = sender.index
			end
		end
	end
	-- 选择
	for i=1,5 do
		local icon = self._rootNode:getChildByName("Panel_1"):getChildByName("hero_"..(i-1))
		icon.index = i
		icon:addTouchEventListener(clickEvent)
	end
	
end

function zhaomu_view:update(params)
	-- body
	print("zhaomu_view:update")
	if params then
		self.choose = 0
		local data = params._usedata.data
		-- 有招募数据
		print("有招募数据")

		self._rootNode:getChildByName("Panel_1"):getChildByName("Button_1"):setVisible(false)
		self._rootNode:getChildByName("Panel_1"):getChildByName("Button_1_0"):setVisible(true)
		self.avatar = {}
		for i=1,5 do
			local icon = self._rootNode:getChildByName("Panel_1"):getChildByName("hero_"..(i-1))
			
			local delay = cc.DelayTime:create(0.1*i)
			local orbit1 = CCOrbitCamera:create(0.1, 1, 0, 0, -90, 90, 0)
			local orbit2 = CCOrbitCamera:create(0.1, 1, -90, 90, 90, -90, 0)
			local a_callfunc = cc.CallFunc:create(function (  )
				icon:getChildByName("Image_1"):setVisible(false)
				self.avatar[i] = UIManager:CreateDropOutFrame(
						data[i].type_,
						data[i].id
					):getResourceNode()
				if self.avatar[i] then
					self.avatar[i]:setCascadeOpacityEnabled(true)
					self.avatar[i]:setTouchEnabled(false)
					self.avatar[i]:setPosition(50, 50)
					icon:addChild(self.avatar[i])
				end
			end)
			local b_callfunc = cc.CallFunc:create(function (  )
				print("卡牌type:"..eDT_Card)
				print("碎片type:"..eDT_CardPiece)
				print("当前:"..data[i].type_)
				icon:getChildByName("Text_2"):setString(UIManager:createDropName(data[i].type_, data[i].id).."x"..data[i].num)
				icon:getChildByName("Text_2"):setVisible(true)
			end)
			icon:runAction(cc.Sequence:create(delay, orbit1, a_callfunc, orbit2, b_callfunc))
		end
		local times = VipConfig[MAIN_PLAYER.baseAttr._vipLv].every_day.draw_num - MAIN_PLAYER.drawcardManager.drwaedCardTime
		self._rootNode:getChildByName("Panel_1"):getChildByName("Text_5"):setString("今日剩余免费次数:"..times)
		self._rootNode:getChildByName("Panel_1"):getChildByName("Image_11"):setVisible(false)
		self._rootNode:getChildByName("Panel_1"):getChildByName("Text_5_0"):setVisible(false)
	else
		self.choose = nil
		-- 无招募数据
		print("无招募数据")
		self._rootNode:getChildByName("Panel_1"):getChildByName("Button_1"):setVisible(true)
		self._rootNode:getChildByName("Panel_1"):getChildByName("Button_1_0"):setVisible(false)
		for i=1,#self.avatar do
			local icon = self._rootNode:getChildByName("Panel_1"):getChildByName("hero_"..(i-1))
			icon:getChildByName("Text_2"):setVisible(false)
			
			local delay = cc.DelayTime:create(0.1*i)
			local orbit1 = CCOrbitCamera:create(0.1, 1, 0, 0, -90, 90, 0)
			local orbit2 = CCOrbitCamera:create(0.1, 1, -90, 90, 90, -90, 0)
			local a_callfunc = cc.CallFunc:create(function (  )
				icon:getChildByName("Image_1"):setVisible(true)
				self.avatar[i]:removeFromParentAndCleanup(true)
			end)
			icon:runAction(cc.Sequence:create(delay, orbit1, a_callfunc, orbit2))
		end

		local times = VipConfig[MAIN_PLAYER.baseAttr._vipLv].every_day.draw_num - MAIN_PLAYER.drawcardManager.drwaedCardTime
		self._rootNode:getChildByName("Panel_1"):getChildByName("Text_5"):setString("今日剩余免费次数:"..times)
		if times < 1 then
			self._rootNode:getChildByName("Panel_1"):getChildByName("Image_11"):setVisible(true)
			self._rootNode:getChildByName("Panel_1"):getChildByName("Text_5_0"):setVisible(true)
		else
			self._rootNode:getChildByName("Panel_1"):getChildByName("Image_11"):setVisible(false)
			self._rootNode:getChildByName("Panel_1"):getChildByName("Text_5_0"):setVisible(false)
		end

	end


end

return zhaomu_view
