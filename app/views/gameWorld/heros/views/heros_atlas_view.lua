--
-- Author: Wu Hengmin
-- Date: 2015-07-01 17:40:12
-- 武将图鉴部分

local heros_atlas = class("heros_atlas")

local class_heros_atlas_item = import("app.views.gameWorld.heros.heros_atlas_item.lua")

function heros_atlas:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    -- self:updateScroll(1)
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self._rootNode:setVisible(false)
end

--初始化数据
function heros_atlas:_initData()
	-- body
end

function heros_atlas:updateScroll(country)
	-- body
	local buttons = {}
	for i=1,4 do
		buttons[i] = self._rootNode:getChildByName("main_layout"):getChildByName("button_country_"..i)
		buttons[i]:loadTexture("ui_image/heros/buttons/heros_country_"..i.."_0.png", ccui.TextureResType.plistType)
	end
	buttons[country]:loadTexture("ui_image/heros/buttons/heros_country_"..country.."_1.png", ccui.TextureResType.plistType)

	local offy = math.ceil(#MAIN_PLAYER.heroManager.country[country]/5)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 2 then
        offy2 = 2
    end
    self.scrollview = self._rootNode:getChildByName("main_layout"):getChildByName("scrollview")
    self.scrollview:removeAllChildren()
	for i=1,#MAIN_PLAYER.heroManager.country[country] do
		local item = class_heros_atlas_item:new()
		item:setCascadeOpacityEnabled(true)
		item.resourceNode_:getChildByName("main_layout"):setSwallowTouches(false)
		item:setPosition(cc.p(80 + 165*((i-1)%5), 150+260* (offy2 - math.ceil(i/5))))
		item:update(MAIN_PLAYER.heroManager.country[country][i])
		self.scrollview:addChild(item)
	end
	local size = cc.size(0, 260*offy+20)
    self.scrollview:setInnerContainerSize(size)
    self.scrollview:jumpToTop()
end

--注册节点事件
function heros_atlas:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function heros_atlas:_registUIEvent()
	-- body
	local country_1 = self._rootNode:getChildByName("main_layout"):getChildByName("button_country_1")
	local country_2 = self._rootNode:getChildByName("main_layout"):getChildByName("button_country_2")
	local country_3 = self._rootNode:getChildByName("main_layout"):getChildByName("button_country_3")
	local country_4 = self._rootNode:getChildByName("main_layout"):getChildByName("button_country_4")

	local function touchEvent(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
	        	print(sender.type)
	        	self:updateScroll(sender.type)
	        end
    	end
	end
	country_1:addTouchEventListener(touchEvent)
	country_1.type = 1
	country_2:addTouchEventListener(touchEvent)
	country_2.type = 2
	country_3:addTouchEventListener(touchEvent)
	country_3.type = 3
	country_4:addTouchEventListener(touchEvent)
	country_4.type = 4
end

--注册全局事件监听器
function heros_atlas:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "heros_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function heros_atlas:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_atlas:disable()
	-- body
	self._rootNode:setVisible(false)
end

function heros_atlas:display()
	-- body
	self._rootNode:setVisible(true)
	self:updateScroll(1)
end

return heros_atlas
