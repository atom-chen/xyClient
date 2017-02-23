--
-- Author: Wu Hengmin
-- Date: 2015-07-22 14:08:59
--

local heros_upgrade_view = class("heros_upgrade_view", cc.load("mvc").ViewBase)

heros_upgrade_view.RESOURCE_FILENAME = "ui_instance/heros/hero_info/hero_upgrade_view.csb"

function heros_upgrade_view:onCreate()
	-- body
	self.attr = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout")
	self:_registUIEvent()
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function heros_upgrade_view:_registUIEvent()
	-- body
	local button1 = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout"):getChildByName("button_upgrade1")
	local function touchEvent1(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/wujiang29.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/wujiang27.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/wujiang27.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	    		-- 发送升级一次
	    		-- 判断人物等级
	    		gameTcp:SendMessage(MSG_C2MS_SEND_HERO_LEVELUP, {self.hero.guid, 1})
	    	end
    	end
    end
    button1:setSwallowTouches(false)
    button1:addTouchEventListener(touchEvent1)

	local button10 = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout"):getChildByName("button_upgrade10")
	local function touchEvent10(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/wujiang029.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/wujiang28.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/wujiang28.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	    		-- 发送升级十次
	    		local max = heroConfig[self.hero.id].lvLimit
				if max > MAIN_PLAYER.baseAttr._lv then
					max = MAIN_PLAYER.baseAttr._lv
				end
	    		gameTcp:SendMessage(MSG_C2MS_SEND_HERO_LEVELUP, {self.hero.guid, max})
	    	end
    	end
    end
    button10:setSwallowTouches(false)
    button10:addTouchEventListener(touchEvent10)
end

function heros_upgrade_view:updateDisplay(hero)
	-- body
	if hero == nil then
		return
	end
	self.hero = hero
	-- 得到当前能达到的最高级级
	local max = heroConfig[hero.id].lvLimit
	if max > MAIN_PLAYER.baseAttr._lv then
		max = MAIN_PLAYER.baseAttr._lv
	end
	----------------- 更新武将名 -----------------
	local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name")
	name:setString(heroConfig[hero.id].name)

	local quality = self.resourceNode_:getChildByName("main_node"):getChildByName("quality")
	-- quality:setString(text)

	----------------- 更新消耗 -----------------
	local ctrl = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout")
	local jingyan1 = ctrl:getChildByName("jingyan1")

	jingyan1:setString(cardLvUpNeedExpConfig[hero.curLv].needExp-hero.Exp)
	local yinliang1 = ctrl:getChildByName("yinliang1")
	yinliang1:setString((cardLvUpNeedExpConfig[hero.curLv].needExp-hero.Exp)*EXP_PER_GOLD)


	local jingyan10 = ctrl:getChildByName("jingyan10")
	jingyan10:setString(cardLvUpNeedExpConfig[max].zongExp-cardLvUpNeedExpConfig[hero.curLv].needExp-hero.Exp)
	local yinliang10 = ctrl:getChildByName("yinliang10")
	yinliang10:setString((cardLvUpNeedExpConfig[max].zongExp-cardLvUpNeedExpConfig[hero.curLv].needExp-hero.Exp)*EXP_PER_GOLD)

	----------------- 更新属性 -----------------
	-- 升级前面板
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

	-- 升级后面板
	local after = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("after")
	after.name = after:getChildByName("name")
	after.name:setString(heroConfig[hero.id].name)

	after.level = after:getChildByName("level")
	after.level:setString(hero.curLv+1)

	after.atk = after:getChildByName("atk")
	after.atk:setString(heroConfig_computeAttack(hero.id, hero.curLv+1))
	after.hp = after:getChildByName("hp")
	after.hp:setString(heroConfig_computeHP(hero.id, hero.curLv+1))
	after.wufang = after:getChildByName("wufang")
	after.wufang:setString(heroConfig_computePDef(hero.id, hero.curLv+1))
	after.fafang = after:getChildByName("fafang")
	after.fafang:setString(heroConfig_computeMDef(hero.id, hero.curLv+1))


	-- 如果已经升到最高级
	if heroConfig[hero.id].lvLimit > hero.curLv then
		after:setVisible(true)
	else
		after:setVisible(false)
	end

	-- 
end

function heros_upgrade_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_heroManager", eventName = "shengji", callBack=handler(self, self.onUpgrade)},
        
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heros_upgrade_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function heros_upgrade_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_upgrade_view:onUpgrade()
	-- body
	print("升级更新")
	-- self:updateDisplay(self.hero)
	dispatchGlobaleEvent("heros_ctrl", "upgrade")
end

return heros_upgrade_view

