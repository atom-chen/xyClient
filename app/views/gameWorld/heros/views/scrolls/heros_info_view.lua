--
-- Author: Wu Hengmin
-- Date: 2015-07-02 17:58:33
--

local heros_info_view = class("heros_info_view", cc.load("mvc").ViewBase)

heros_info_view.RESOURCE_FILENAME = "ui_instance/heros/hero_info/hero_info_view.csb"

function heros_info_view:onCreate()
	-- body
	self.descrip = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("descrip_node")
	self.attr = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("attr_node")

	local button = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("button")
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.moved then
			globalTouchEvent(sender,eventType)
		elseif eventType == ccui.TouchEventType.ended then
			if globalTouchEvent(sender,eventType) then
	    		self:onClicked(sender)
	    	end
    	end
    end
    button:setSwallowTouches(false)
    button:addTouchEventListener(touchEvent)

end

function heros_info_view:onClicked(sender)
	-- body
	if self.descrip:isVisible() then
		sender:loadTexture("ui_image/heros/buttons/heros_view_button_0.png", ccui.TextureResType.plistType)
		self.descrip:setVisible(false)
		self.attr:setVisible(true)
	else
		sender:loadTexture("ui_image/heros/buttons/heros_view_button_1.png", ccui.TextureResType.plistType)
		self.descrip:setVisible(true)
		self.attr:setVisible(false)
	end
end

function heros_info_view:updateDisplay(hero)
	-- body
	if hero == nil then
		return
	end
	----------------- 更新武将名 -----------------
	local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name")
	name:setString(heroConfig[hero.id].name)

	local quality = self.resourceNode_:getChildByName("main_node"):getChildByName("quality")
	-- quality:setString(text)
	
	----------------- 更新属性 -----------------
	local attr = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_layout"):getChildByName("attr_node")
	attr:getChildByName("lv"):getChildByName("count"):setString(hero.curLv)
	attr:getChildByName("att"):getChildByName("count"):setString(hero:getAttackTotal())
	attr:getChildByName("wufang"):getChildByName("count"):setString(hero:getWuFangTotal())
	attr:getChildByName("baoji"):getChildByName("count"):setString((hero:getBaoJi()*100).."%")
	attr:getChildByName("mingzhong"):getChildByName("count"):setString((hero:getMingZhong()*100).."%")
	attr:getChildByName("skill"):getChildByName("count"):setString(hero.skillLv)
	attr:getChildByName("hp"):getChildByName("count"):setString(hero:getHPTotal())
	attr:getChildByName("fafang"):getChildByName("count"):setString(hero:getMoFangTotal())
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

return heros_info_view
