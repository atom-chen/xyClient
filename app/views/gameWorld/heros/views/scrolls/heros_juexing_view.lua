--
-- Author: Wu Hengmin
-- Date: 2015-07-22 14:08:59
--

local heros_juexing_view = class("heros_juexing_view", cc.load("mvc").ViewBase)

heros_juexing_view.RESOURCE_FILENAME = "ui_instance/heros/hero_info/hero_juexing_view.csb"

function heros_juexing_view:onCreate()
	-- body
	self.attr = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout")
	self:_registUIEvent()
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function heros_juexing_view:_registUIEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout"):getChildByName("button_juexing")
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/wujiang031.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/wujiang032.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/wujiang032.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	    		-- 发送觉醒
	    		gameTcp:SendMessage(MSG_C2MS_SEND_HERO_EVOLUTION, {self.hero.guid})
	    	end
    	end
    end
    button:setSwallowTouches(false)
    button:addTouchEventListener(touchEvent)
end

function heros_juexing_view:updateDisplay(hero)
	-- body
	if hero == nil then
		return
	end
	self.hero = hero

	-- 判断可否觉醒
	local allow = heroConfig[hero.id].wake_des_id ~= 0
	
	----------------- 更新武将名 -----------------
	local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name")
	name:setString(heroConfig[hero.id].name)

	local quality = self.resourceNode_:getChildByName("main_node"):getChildByName("quality")
	-- quality:setString(text)

	----------------- 觉醒描述 -----------------
	local descrip = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout"):getChildByName("descrip")
	descrip:setString("觉醒+"..(math.floor(hero.id/1000)%10+1).."需要:")

	----------------- 更新消耗 -----------------
	local ctrl = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout")

	local yinliang = ctrl:getChildByName("yinliang")
	if allow then
		yinliang:setString(heroConfig[hero.id].wake_gold)
	else
		yinliang:setString(0)
	end

	local jianghun = ctrl:getChildByName("jianghun")
	if allow then
		jianghun:setString(heroConfig[hero.id].wake_JH)
	else
		jianghun:setString(0)
	end


	----------------- 更新属性 -----------------
	-- 觉醒前面板
	local befor = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("befor")
	befor.name = befor:getChildByName("name")
	befor.name:setString(heroConfig[hero.id].name)

	befor.level = befor:getChildByName("level")
	befor.level:setString(hero.curLv)

	befor.atk = befor:getChildByName("atk")
	befor.atk:setString(hero:getAttackTotal())
	befor.hp = befor:getChildByName("hp")
	befor.hp:setString(hero:getHPTotal())
	befor.wufang = befor:getChildByName("wufang")
	befor.wufang:setString(hero:getWuFangTotal())
	befor.fafang = befor:getChildByName("fafang")
	befor.fafang:setString(hero:getMoFangTotal())


	----------------- 武将碎片和觉醒材料 -----------------

	-- 是否已经觉醒到最高
	if allow then
		-- 觉醒后面板
		local afterID = heroConfig[hero.id].wake_des_id
		print("afterID:"..afterID)
		local after = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("after")
		after.name = after:getChildByName("name")
		after.name:setString(heroConfig[afterID].name)

		after.level = after:getChildByName("level")
		after.level:setString(hero.curLv)

		after.atk = after:getChildByName("atk")
		after.atk:setString(heroConfig_computeAttack(afterID, hero.curLv))
		after.hp = after:getChildByName("hp")
		after.hp:setString(heroConfig_computeHP(afterID, hero.curLv))
		after.wufang = after:getChildByName("wufang")
		after.wufang:setString(heroConfig_computePDef(afterID, hero.curLv))
		after.fafang = after:getChildByName("fafang")
		after.fafang:setString(heroConfig_computeMDef(afterID, hero.curLv))


		after:setVisible(true)
	else
		after:setVisible(false)
	end

	
end

function heros_juexing_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_heroManager", eventName = "juexing", callBack=handler(self, self.onUpgrade)},
        
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heros_juexing_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function heros_juexing_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_juexing_view:onUpgrade()
	-- body
	print("觉醒更新")
	-- self:updateDisplay(self.hero)
	dispatchGlobaleEvent("heros_ctrl", "upgrade")
end

return heros_juexing_view

