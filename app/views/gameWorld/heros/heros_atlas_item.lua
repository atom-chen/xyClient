--
-- Author: Wu Hengmin
-- Date: 2015-07-02 17:09:48
-- 武将图鉴item

local heros_atlas_item = class("heros_atlas_item", cc.load("mvc").ViewBase)

heros_atlas_item.RESOURCE_FILENAME = "ui_instance/heros/heros_view/heros_atlas_item.csb"

local class_hero_avatar = import("app.views.gameWorld.heros.hero_avatar")

function heros_atlas_item:onCreate()
	self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()
    self.icon = class_hero_avatar.new(self.resourceNode_:getChildByName("main_layout"):getChildByName("icon"))
end

--初始化数据
function heros_atlas_item:_initData()
	-- body
end

--注册节点事件
function heros_atlas_item:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self.resourceNode_:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function heros_atlas_item:_registUIEvent()
	-- body
	local main_layout = self.resourceNode_:getChildByName("main_layout")
	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
		        print("弹出武将信息")
		    end
	    end
    end
    main_layout:addTouchEventListener(touchEvent)
end

--注册全局事件监听器
function heros_atlas_item:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "heros_ctrl", eventName = "nameChange", callBack=handler(self, self._onNameChange)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function heros_atlas_item:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_atlas_item:update(hero)
	-- body
	self.hero = hero
	self.icon:update(hero)
	local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("name")
	name:setString(hero.name)
end

return heros_atlas_item
