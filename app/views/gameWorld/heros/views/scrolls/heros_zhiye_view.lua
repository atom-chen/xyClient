--
-- Author: Wu Hengmin
-- Date: 2015-07-22 14:08:59
--

local heros_zhiye_view = class("heros_zhiye_view", cc.load("mvc").ViewBase)

heros_zhiye_view.RESOURCE_FILENAME = "ui_instance/heros/hero_info/hero_zhiye_view.csb"

function heros_zhiye_view:onCreate()
	-- body
	self:_registUIEvent()
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
end

function heros_zhiye_view:_registUIEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout"):getChildByName("button_zhiye")
	local function touchEvent1(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			sender:loadTexture("ui_image/heros/buttons/button_qianghua_1.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			sender:loadTexture("ui_image/heros/buttons/button_qianghua_0.png", ccui.TextureResType.plistType)
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			sender:loadTexture("ui_image/heros/buttons/button_qianghua_0.png", ccui.TextureResType.plistType)
			if globalTouchEvent(sender,eventType) then
	    		-- 发送职业强化
	    		gameTcp:SendMessage(MSG_C2MS_HERO_OCCU_UPGRADE, {self.hero.guid})
	    	end
    	end
    end
    button:setSwallowTouches(false)
    button:addTouchEventListener(touchEvent1)
end

function heros_zhiye_view:updateDisplay(hero)
	-- body
	if hero == nil then
		return
	end
	self.hero = hero
	-- 得到当前能达到的最高职业强度
	local max = #OccuCfg[heroConfig[hero.id].profession].upgrade
	print("职业强度上限:"..max)
	print("当前强度:"..hero.occupatpower)
	----------------- 更新武将名 -----------------
	local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name")
	name:setString(heroConfig[hero.id].name)

	local quality = self.resourceNode_:getChildByName("main_node"):getChildByName("quality")
	-- quality:setString(text)

	----------------- 更新消耗 -----------------
	local ctrl = self.resourceNode_:getChildByName("main_node"):getChildByName("ctrl_layout")
	local yinliang = ctrl:getChildByName("yinliang")
	yinliang:setString(OccuCfg[heroConfig[hero.id].profession].upgrade[hero.occupatpower+1].gold)

	local power = ctrl:getChildByName("lv")
	power:setString(hero.occupatpower.."/"..max)

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

	-- -- 升级后面板
	local after = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("after")
	after.name = after:getChildByName("name")
	after.name:setString(heroConfig[hero.id].name)

	after.level = after:getChildByName("level")
	after.level:setString(hero.curLv)

	after.atk = after:getChildByName("atk")
	after.atk:setString(hero:getAttackTotalWithNextOccupatpower())
	after.hp = after:getChildByName("hp")
	after.hp:setString(hero:getHPTotalWithNextOccupatpower())
	after.wufang = after:getChildByName("wufang")
	after.wufang:setString(hero:getWuFangTotalWithNextOccupatpower())
	after.fafang = after:getChildByName("fafang")
	after.fafang:setString(hero:getMoFangTotalWithNextOccupatpower())

	----------------- 得到升级所需道具 -----------------
	-- OccuCfg[heroConfig[hero.id].profession].upgrade[hero.occupatpower+1].item_id
	-- OccuCfg[heroConfig[hero.id].profession].upgrade[hero.occupatpower+1].item_num
	local iconNode = ctrl:getChildByName("goods_node")
	iconNode:removeAllChildren()
	print(OccuCfg[heroConfig[hero.id].profession].upgrade[hero.occupatpower+1].item_id)
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			OccuCfg[heroConfig[hero.id].profession].upgrade[hero.occupatpower+1].item_id
		):getResourceNode()
	if icon then
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(40, 40)
		iconNode:addChild(icon)
	end
	local countStr = ctrl:getChildByName("count")
	local count1 = MAIN_PLAYER.goodsManager:getCount(OccuCfg[heroConfig[hero.id].profession].upgrade[hero.occupatpower+1].item_id)
	countStr:setString(OccuCfg[heroConfig[hero.id].profession].upgrade[hero.occupatpower+1].item_num.."/"..count1)
end

function heros_zhiye_view:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_heroManager", eventName = "zhiye", callBack=handler(self, self.onUpgrade)},
        
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function heros_zhiye_view:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function heros_zhiye_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_zhiye_view:onUpgrade()
	-- body
	-- self:updateDisplay(self.hero)
	dispatchGlobaleEvent("heros_ctrl", "upgrade")
end

return heros_zhiye_view

