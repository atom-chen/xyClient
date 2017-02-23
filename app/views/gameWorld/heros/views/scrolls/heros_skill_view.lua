--
-- Author: Wu Hengmin
-- Date: 2015-07-02 17:58:33
--

local heros_skill_view = class("heros_skill_view", cc.load("mvc").ViewBase)

heros_skill_view.RESOURCE_FILENAME = "ui_instance/heros/hero_info/hero_skill_view.csb"

function heros_skill_view:onCreate()
	-- body

	local button = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout"):getChildByName("button_upgrade")
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/wujiang033.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/wujiang035.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/wujiang035.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	    		print("点击提升技能")
	    		gameTcp:SendMessage(MSG_C2MS_HERO_UPGRADE_SKILL, {self.hero.guid})
	    	end
    	end
    end
    button:setSwallowTouches(false)
    button:addTouchEventListener(touchEvent)

	self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function heros_skill_view:updateDisplay(hero)
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

	----------------- 更新武将技能强度 -----------------
	local ctrl = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout")
	local power = ctrl:getChildByName("power")
	power:setString(hero:getSkillLv())
	
	----------------- 更新武将技能顺序 -----------------
	local skillcast = self.resourceNode_:getChildByName("main_node"):getChildByName("skillcast")
	local skillicon1 = skillcast:getChildByName("skill_icon_1")
	-- skillicon1:loadTexture("", ccui.TextureResType.plistType)
	local skillicon2 = skillcast:getChildByName("skill_icon_2")
	-- skillicon2:loadTexture("", ccui.TextureResType.plistType)
	local skillicon3 = skillcast:getChildByName("skill_icon_3")
	-- skillicon3:loadTexture("", ccui.TextureResType.plistType)

	----------------- 更新武将技能说明 -----------------
	local skillinfo = self.resourceNode_:getChildByName("main_node"):getChildByName("skillcast")
	local skill1 = skillinfo:getChildByName("skill_1")
	-- skill1:getChildByName("icon"):loadTexture("", ccui.TextureResType.plistType)
	-- skill1:getChildByName("name"):setString()
	-- skill1:getChildByName("descrip"):setString()
	local skill2 = skillinfo:getChildByName("skill_2")
	-- skill2:getChildByName("icon"):loadTexture("", ccui.TextureResType.plistType)
	-- skill2:getChildByName("name"):setString()
	-- skill2:getChildByName("descrip"):setString()
	local skill3 = skillinfo:getChildByName("skill_3")
	-- skill3:getChildByName("icon"):loadTexture("", ccui.TextureResType.plistType)
	-- skill3:getChildByName("name"):setString()
	-- skill3:getChildByName("descrip"):setString()

end

function heros_skill_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_heroManager", eventName = "skill", callBack=handler(self, self.onUpgrade)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heros_skill_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function heros_skill_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_skill_view:onUpgrade()
	-- body
	print("技能更新")
	-- self:updateDisplay(self.hero)
	dispatchGlobaleEvent("heros_ctrl", "upgrade")
end

return heros_skill_view
