--
-- Author: Wu Hengmin
-- Date: 2015-08-17 14:37:49
--


local chongsheng_view = class("chongsheng_view")

function chongsheng_view:ctor(node)
	-- body

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:init()
    self:_registUIEvent()

    -- 测试用

    -- self:update(MAIN_PLAYER.heroManager:getRandHero())
    self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function chongsheng_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "choose", eventName = "updatedata", callBack=handler(self, self.updateWithChoose)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function chongsheng_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function chongsheng_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self._rootNode:registerScriptHandler(onNodeEvent)
end

function chongsheng_view:init()
	-- body
	self._rootNode:setCascadeOpacityEnabled(true)
end

function chongsheng_view:getResourceNode()
	-- body
	return self._rootNode
end


function chongsheng_view:_registUIEvent()
	-- body
	-- 重生
	local chongsheng = self._rootNode:getChildByName("main_layout"):getChildByName("Button_1")
	local function Clicked(sender)
		if self.mode == 1 then
			gameTcp:SendMessage(MSG_C2MS_HERO_REDUCED, {self.data})
		elseif self.mode == 2 then
			gameTcp:SendMessage(MSG_C2MS_HERO_REDUCED, {self.data})
		end
	end
	chongsheng:addClickEventListener(Clicked)



	local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_0")
	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			dispatchGlobaleEvent("choose_ctrl", "open", {num = 1})
			print("点击打开选择")
		end
	end
	iconNode:addTouchEventListener(touchEvent)

end

function chongsheng_view:updateWithChoose(params)
	-- body
	if self._rootNode:isVisible() == false then
		return
	end
	local mode = params._usedata.mode
	local data = nil
	if mode == 1 then
		data = MAIN_PLAYER.equipManager:getEquipByGuid(params._usedata.data[1])
	elseif mode == 2 then
		data = MAIN_PLAYER.heroManager:getHero(params._usedata.data[1])
	end
	self.data = params._usedata.data[1]
	self.mode = mode

	local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_0")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)
	local type_ = ""
	if mode == 1 then
		type_ = "装备"
	else
		type_ = "卡片"
	end
	if data then
		local icon = UIManager:CreateDropOutFrame(
			type_,
			data.id
		):getResourceNode()
		icon:setSwallowTouches(false)
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		iconNode:addChild(icon)
	end


end

-- function chongsheng_view:update(data)
-- 	-- body
-- 	self.data = data

-- 	local iconNode = self._rootNode:getChildByName("main_layout"):getChildByName("icon_node_0")
-- 	iconNode:removeAllChildren()
-- 	iconNode:setCascadeOpacityEnabled(true)
-- 	local icon = UIManager:CreateDropOutFrame(
-- 		"卡片",
-- 		self.data.id
-- 	):getResourceNode()
-- 	icon:setSwallowTouches(false)
-- 	icon:setCascadeOpacityEnabled(true)
-- 	icon:setPosition(50, 50)
-- 	iconNode:addChild(icon)


-- end


return chongsheng_view
