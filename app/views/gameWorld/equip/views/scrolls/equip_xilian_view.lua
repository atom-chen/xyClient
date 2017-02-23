--
-- Author: Wu Hengmin
-- Date: 2015-07-09 17:36:26
--

local equip_xilian_view = class("equip_xilian_view", cc.load("mvc").ViewBase)

equip_xilian_view.RESOURCE_FILENAME = "ui_instance/equip/equip_info/equip_xilian_view.csb"

function equip_xilian_view:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
	self:registUIEvent()
end

function equip_xilian_view:registUIEvent()
	-- body
	local function clickEvent1(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/equip/zhuangbei020.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/equip/zhuangbei010.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			-- dispatchGlobaleEvent("goods_ctrl", "refreshlist", {})
			sender:loadTexture("ui_image/equip/zhuangbei010.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
				print("洗炼1")
				gameTcp:SendMessage(MSG_C2MS_EQUIPS_ACTIVE, {self.guid, 1, 1})
			end
		elseif eventType == ccui.TouchEventType.canceled then
			sender:loadTexture("ui_image/equip/zhuangbei010.png", ccui.TextureResType.plistType)
		end
	end
	local button_1 = self.resourceNode_:getChildByName("main_node"):getChildByName("button_xilian1")
	button_1:setSwallowTouches(false)
	button_1:addTouchEventListener(clickEvent1)


	local function clickEvent10(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/equip/zhuangbei019.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/equip/zhuangbei011.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			-- dispatchGlobaleEvent("goods_ctrl", "refreshlist", {})
			sender:loadTexture("ui_image/equip/zhuangbei011.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
				print("洗炼10")
				gameTcp:SendMessage(MSG_C2MS_EQUIPS_ACTIVE, {self.guid, 0, 10})
			end
		elseif eventType == ccui.TouchEventType.canceled then
			sender:loadTexture("ui_image/equip/zhuangbei011.png", ccui.TextureResType.plistType)
		end
	end
	local button_10 = self.resourceNode_:getChildByName("main_node"):getChildByName("button_xilian10")
	button_10:setSwallowTouches(false)
	button_10:addTouchEventListener(clickEvent10)
	
end

function equip_xilian_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_equipManager", eventName = "equipactive", callBack=handler(self, self.acviteUP)},
        
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function equip_xilian_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function equip_xilian_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function equip_xilian_view:acviteUP(params)
	-- body
	local count = params._usedata.count
	local daoju = params._usedata.daoju
	MAIN_PLAYER.equipManager:upgradeOffLevel(self.guid, count)
	MAIN_PLAYER.equipManager:updateDaoju(self.guid, daoju)
	self:update(self.guid)
	dispatchGlobaleEvent("equip_ctrl", "shengjiORactive", {})
end

function equip_xilian_view:update(guid)
	-- body
	if guid then
		self.guid = guid
		local equip = MAIN_PLAYER.equipManager:getEquipByGuid(guid)
		----------------- 更新武将名 -----------------
		local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name"):setString(EquipConfig[equip.id].name)
		
		----------------- 更新属性 -----------------
		local attr = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_node")
		local lv1 = attr:getChildByName("lv1")
		lv1:getChildByName("count"):setString(equip.offlevel) -- 当前等级
		lv1:getChildByName("main_attr"):setString(MAIN_PLAYER.equipManager:getMainTypeByGuid(guid)..":") -- 主属性类型
		lv1:getChildByName("main_attr"):getChildByName("count"):setString(MAIN_PLAYER.equipManager:getMainAttr(guid)) -- 主属性值
		lv1:getChildByName("off_attr"):setString(MAIN_PLAYER.equipManager:getOffTypeByGuid(guid)..":") -- 副属性类型
		lv1:getChildByName("off_attr"):getChildByName("count"):setString(MAIN_PLAYER.equipManager:getOffAttr(guid)) -- 副属性值

		local lv2 = attr:getChildByName("lv2")
		lv2:getChildByName("count"):setString(equip.offlevel+1) -- 下一等级
		lv2:getChildByName("main_attr"):setString(MAIN_PLAYER.equipManager:getMainTypeByGuid(guid)..":") -- 主属性类型
		lv2:getChildByName("main_attr"):getChildByName("count"):setString(MAIN_PLAYER.equipManager:getMainAttr(guid)) -- 主属性值
		lv2:getChildByName("off_attr"):setString(MAIN_PLAYER.equipManager:getOffTypeByGuid(guid)..":") -- 副属性类型
		lv2:getChildByName("off_attr"):getChildByName("count"):setString(MAIN_PLAYER.equipManager:getOffAttrWithNextLevel(guid)) -- 副属性值
	
		---------------- icon --------------------
		local iconbg = self.resourceNode_:getChildByName("main_node"):getChildByName("icon_node"):getChildByName("bg")
		iconbg:removeAllChildren()
		local icon = UIManager:CreateDropOutFrame("装备", MAIN_PLAYER.equipManager:getEquipByGuid(guid).id):getResourceNode()
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(112, 111)
		iconbg:addChild(icon)

	else

	end
end

return equip_xilian_view