--
-- Author: Wu Hengmin
-- Date: 2015-07-02 17:58:33
--

local heros_chongsheng_view = class("heros_chongsheng_view", cc.load("mvc").ViewBase)

heros_chongsheng_view.RESOURCE_FILENAME = "ui_instance/heros/hero_info/hero_chongsheng_view.csb"

function heros_chongsheng_view:onCreate()
	-- body

	local button = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout"):getChildByName("button_juexing")
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/wujiang034.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/wujiang036.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/wujiang036.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	    		print("点击重生")
	    		gameTcp:SendMessage(MSG_C2MS_HERO_REDUCED, {self.hero.guid})
	    	end
    	end
    end
    button:setSwallowTouches(false)
    button:addTouchEventListener(touchEvent)

	self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function heros_chongsheng_view:updateDisplay(hero)
	-- body
	if hero == nil then
		return
	end
	self.hero = hero
	----------------- 更新武将名 -----------------
	local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name")
	name:setString(heroConfig[hero.id].name)

	local quality = self.resourceNode_:getChildByName("main_node"):getChildByName("quality")
	-- quality:setString(text)


end

function heros_chongsheng_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_heroManager", eventName = "chongsheng", callBack=handler(self, self.onUpgrade)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heros_chongsheng_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function heros_chongsheng_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_chongsheng_view:onUpgrade()
	-- body
	dispatchGlobaleEvent("heros_ctrl", "upgrade")
end

return heros_chongsheng_view
