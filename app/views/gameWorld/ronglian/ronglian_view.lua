--
-- Author: Wu Hengmin
-- Date: 2015-08-17 11:24:00
--

local ronglian_view = class("ronglian_view")

function ronglian_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

	self:_registNodeEvent()
	self:_registGlobalEventListeners()
    self.itemModel = cc.CSLoader:createNode("ui_instance/ronglian/ronglian_log_item.csb")
    self.itemModel:retain()

    self:updateRonglian()
end

function ronglian_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "ronglian_ctrl", eventName = "update", callBack=handler(self, self.update)},
		{modelName = "choose", eventName = "updatedata", callBack=handler(self, self.updateWithChoose)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function ronglian_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function ronglian_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function ronglian_view:getResourceNode()
	-- body
	return self._rootNode
end

function ronglian_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self._rootNode:registerScriptHandler(onNodeEvent)
end


function ronglian_view:_registUIEvent()
	-- body

	-- 自动选取武将
	local screen_wujiang = self._rootNode:getChildByName("main_layout"):getChildByName("Button_1")
	local function wujiangClicked(sender)
		self:updateTargItem(2)
	end
	screen_wujiang:addClickEventListener(wujiangClicked)

	-- 自动选取装备
	local screen_equip = self._rootNode:getChildByName("main_layout"):getChildByName("Button_1_0")
	local function equipClicked(sender)
		self:updateTargItem(1)
	end
	screen_equip:addClickEventListener(equipClicked)

	-- 熔炼
	local xilian = self._rootNode:getChildByName("main_layout"):getChildByName("Button_1_1")
	local function xilianClicked(sender)
		-- 熔炼消息
		if self.mode == 1 then
			local tmp = {}
			tmp[1] = #self.data
			
			for i=1,#self.data do
				table.insert(tmp, self.data[i].guid)
			end
			gameTcp:SendMessage(MSG_C2MS_EQUIPS_SMELT, tmp)
		elseif self.mode == 2 then
			local tmp = {}
			tmp[1] = #self.data
			
			for i=1,#self.data do
				table.insert(tmp, self.data[i].guid)
			end

			gameTcp:SendMessage(MSG_C2MS_PIECE_HERO_SPLIT, tmp)
		end
	end
	xilian:addClickEventListener(xilianClicked)




	-- 点击熔点选择
	for i=1,8 do
		local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_"..(i-1)):getChildByName("Panel_1")
		local function touchEvent(sender,eventType)
			if eventType == ccui.TouchEventType.ended then
				dispatchGlobaleEvent("choose_ctrl", "open", {num = 8})
				print("点击打开选择")
			end
		end
		iconNode:addTouchEventListener(touchEvent)
	end

end

-- 手动选择
function ronglian_view:updateWithChoose(params)
	-- body
	local mode = params._usedata.mode
	if mode == 1 then
		self.data = MAIN_PLAYER.equipManager:getXilianTargWithGuid(params._usedata.data)
	elseif mode == 2 then
		self.data = MAIN_PLAYER.heroManager:getXilianTargWithGuid(params._usedata.data)
	end
	self.mode = mode
	for i=1,8 do
		local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_"..(i-1)):getChildByName("Panel_1")
		iconNode:removeAllChildren()
		iconNode:setCascadeOpacityEnabled(true)
		local type_ = ""
		if mode == 1 then
			type_ = "装备"
		else
			type_ = "卡片"
		end
		if i <= #self.data then
			local icon = UIManager:CreateDropOutFrame(
				type_,
				self.data[i].id
			):getResourceNode()
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(50, 50)
			iconNode:addChild(icon)
		end
	end

end

-- 自动选择
function ronglian_view:updateTargItem(mode)
	-- body
	self.mode = mode
	if mode == 1 then
		self.data = MAIN_PLAYER.equipManager:getXilianTarg()
		for i=1,8 do
			local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_"..(i-1)):getChildByName("Panel_1")
			iconNode:removeAllChildren()
			iconNode:setCascadeOpacityEnabled(true)
			if i <= #self.data then
				local icon = UIManager:CreateDropOutFrame(
					"装备",
					self.data[i].id
				):getResourceNode()
				icon:setSwallowTouches(false)
				icon:setCascadeOpacityEnabled(true)
				icon:setPosition(50, 50)
				iconNode:addChild(icon)
			end
		end

	elseif mode == 2 then
		self.data = MAIN_PLAYER.heroManager:getXilianTarg()
		
		for i=1,8 do
			local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_"..(i-1)):getChildByName("Panel_1")
			iconNode:removeAllChildren()
			iconNode:setCascadeOpacityEnabled(true)
			if i <= #self.data then
				local icon = UIManager:CreateDropOutFrame(
					"卡片",
					self.data[i].id
				):getResourceNode()
				icon:setSwallowTouches(false)
				icon:setCascadeOpacityEnabled(true)
				icon:setPosition(50, 50)
				iconNode:addChild(icon)
			end
		end
	end
	
end

function ronglian_view:update(params)
	-- body
	local effect = self._rootNode:getChildByName("main_layout"):getChildByName("ArmatureNode_1")
	effect:setVisible(true)
	local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.loopComplete then

        elseif movementType == ccs.MovementEventType.complete then
        	effect:setVisible(false)
        	for i=1,8 do
				local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_"..(i-1)):getChildByName("Panel_1")
				iconNode:removeAllChildren()
				iconNode:setCascadeOpacityEnabled(true)
			end
        elseif movementType == ccs.MovementEventType.start then

        end
    end
    effect:getAnimation():setMovementEventCallFunc(animationEvent)
	effect:getAnimation():play("Animation1", -1 , 0)

	self:updateLog(params._usedata.data)
	self:updateRonglian()
	
end

-- 更新熔炼日志
function ronglian_view:updateLog(data)
	-- body
	self.listview = self._rootNode:getChildByName("main_layout"):getChildByName("Panel_51"):getChildByName("ListView_1")
	
	
	for i=1,#data do
		printLog("网络日志","产物:"..UIManager:createDropName(data[i].type_, data[i].id))
		local item = self.itemModel:getChildByName("Panel_1"):clone()
		item:setCascadeOpacityEnabled(true)
		self.listview:pushBackCustomItem(item)
		if data[i].type_ == eDT_SmeltValue then
			item:getChildByName("Text_12"):setString("获得熔炼值x"..data[i].num)
			item:getChildByName("Text_12_0"):setVisible(false)
			item:getChildByName("Text_12_1"):setVisible(false)
			item:getChildByName("Text_12_2"):setVisible(false)
		elseif data[i].type_ == eDT_Equip then
			item:getChildByName("Text_12"):setString("获得Lv."..data[i].lv)
			item:getChildByName("Text_12_0"):setVisible(false)
			item:getChildByName("Text_12_1"):setString(UIManager:createDropName(data[i].type_, data[i].id))
			item:getChildByName("Text_12_1"):setColor(ResIDConfig:getEquipQualityInfo(EquipConfig[data[i].id].quality).color)
			item:getChildByName("Text_12_2"):setVisible(false)
		elseif data[i].type_ == eDT_Item then
			item:getChildByName("Text_12"):setString("获得")
			item:getChildByName("Text_12_0"):setVisible(false)
			item:getChildByName("Text_12_1"):setVisible(false)
			item:getChildByName("Text_12_2"):setString(UIManager:createDropName(data[i].type_, data[i].id))
			item:getChildByName("Text_12_2"):setColor(ResIDConfig:getEquipQualityInfo(ItemsConfig[data[i].id].quality).color)
		end
		
	end
	self.listview:refreshView()
	self.listview:scrollToBottom(1, true)

	-- local listview = 
end

function ronglian_view:updateRonglian()
	-- body
	self._rootNode:getChildByName("Panel_53"):getChildByName("Text_1_0"):setString(MAIN_PLAYER.baseAttr._ronglianzhi)
end


return ronglian_view
