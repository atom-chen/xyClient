--
-- Author: Wu Hengmin
-- Date: 2015-07-07 10:55:45
--


local heros_fenjie_view = class("heros_fenjie_view", cc.load("mvc").ViewBase)

heros_fenjie_view.RESOURCE_FILENAME = "ui_instance/heros/hero_info/hero_fenjie_view.csb"

function heros_fenjie_view:onCreate()
	-- body
	
    self:_registUIEvent()
    self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function heros_fenjie_view:_registUIEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("button")
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/heros_fenjie_view_button_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/heros_fenjie_view_button_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/heros_fenjie_view_button_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	    		-- 发送碎化消息
	    		print(self.hero.guid)
	    		gameTcp:SendMessage(MSG_C2MS_PIECE_HERO_SPLIT, {self.hero.guid})
	    	end
    	end
    end
    button:setSwallowTouches(false)
    button:addTouchEventListener(touchEvent)
end

function heros_fenjie_view:updateDisplay(hero)
	-- body
	if hero == nil then
		return
	end
	if MAIN_PLAYER.heroManager:getHero(hero.guid) == nil then
		self:setVisible(false)
		return
	else
		self:setVisible(true)
	end
	self.hero = hero
	----------------- 更新武将名 -----------------
	local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name")
	name:setString(heroConfig[hero.id].name)

	local quality = self.resourceNode_:getChildByName("main_node"):getChildByName("quality")
	-- quality:setString(text)
	
	----------------- 更新属性 -----------------
	local attr = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout")
	attr:getChildByName("lv"):getChildByName("count"):setString(hero.curLv)
	attr:getChildByName("att"):getChildByName("count"):setString(hero:getBaseAttack())
	attr:getChildByName("wufang"):getChildByName("count"):setString(hero:getBaseWuFang())
	attr:getChildByName("baoji"):getChildByName("count"):setString((hero:getBaoJi()*100).."%")
	attr:getChildByName("mingzhong"):getChildByName("count"):setString((hero:getMingZhong()*100).."%")
	attr:getChildByName("skill"):getChildByName("count"):setString(hero.skillLv)
	attr:getChildByName("hp"):getChildByName("count"):setString(hero:getBaseHP())
	attr:getChildByName("fafang"):getChildByName("count"):setString(hero:getBaseMoFang())
	attr:getChildByName("baoshang"):getChildByName("count"):setString((hero:getBaoShang()*100).."%")
	attr:getChildByName("shanbi"):getChildByName("count"):setString((hero:getShanBi()*100).."%")
	
	----------------- 更新武将生平 -----------------
	local descrip = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("descrip_node")
	-- descrip:getChildByName("text"):setString(text)
	
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

function heros_fenjie_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_heroManager", eventName = "suihua", callBack=handler(self, self.onUpgrade)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heros_fenjie_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function heros_fenjie_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_fenjie_view:onUpgrade()
	-- body
	dispatchGlobaleEvent("heros_ctrl", "upgrade")
end

return heros_fenjie_view