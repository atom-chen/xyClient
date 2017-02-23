--
-- Author: lipeng
-- Date: 2015-07-08 10:43:04
-- 控制器: 队伍英雄信息

local class_controle_hero_avatar = require("app.views.gameWorld.heros.hero_avatar")
local controler_team_heroinfo_node = class("controler_team_heroinfo_node")


function controler_team_heroinfo_node:ctor(team_heroinfo_node)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_heroinfo_node = team_heroinfo_node

    self._scrollViewContainer = self._team_heroinfo_node:getChildByName("scrollView")

    self:_createControlerForUI()
    self:_registUIEvent()
end

function controler_team_heroinfo_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team_heroinfo_node:setTeamBattlePos( pos )
	self._teamBattlePos = pos
	self._battleHero =  MAIN_PLAYER:getHeroManager():getHero(self._teamBattlePos:getHeroGUID()) 
	self:_updateView()
end


function controler_team_heroinfo_node:_initModels()
	self._controlerMap = {}
    self._controlerEventCallBack = nil

    self._battleHero = nil
    self._teamBattlePos = nil
end


function controler_team_heroinfo_node:_createControlerForUI()
	local scrollViewContainer = self._scrollViewContainer

    --位置
    self._controlerMap.node_heroAvatar = class_controle_hero_avatar.new(
    	scrollViewContainer:getChildByName("node_heroAvatar")
    )

end


function controler_team_heroinfo_node:_registUIEvent()
	local scrollViewContainer = self._scrollViewContainer

   	local btn_xieXia_wuJiang = scrollViewContainer:getChildByName("btn_xieXia_wuJiang")

    local function btn_xieXia_wuJiangTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            TeamSystemInstance:sendNetMsg_changeMember(
            	self._teamBattlePos:getIdxInGroup(), NULL_GUID
            )

        end
    end
    btn_xieXia_wuJiang:addTouchEventListener(btn_xieXia_wuJiangTouchEvent)


    local btn_genghuan_wuJiang = scrollViewContainer:getChildByName("btn_genghuan_wuJiang")

    local function btn_genghuan_wuJiangTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	dispatchGlobaleEvent(
        		"controler_team_heroinfo_node", 
        		"btn_genghuan_wuJiangTouchEvent", 
        		{pos=self._teamBattlePos:getIdxInGroup()}
        	)
        end
    end
    btn_genghuan_wuJiang:addTouchEventListener(btn_genghuan_wuJiangTouchEvent)


    local btn_wuJiang_shengji = scrollViewContainer:getChildByName("btn_wuJiang_shengji")

    local function btn_wuJiang_shengjiTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	dispatchGlobaleEvent(
        		"controler_team_heroinfo_node", 
        		"btn_wuJiang_shengjiTouchEvent", 
        		{heroGUID=self._teamBattlePos:getHeroGUID()}
        	)
        end
    end
    btn_wuJiang_shengji:addTouchEventListener(btn_wuJiang_shengjiTouchEvent)
end


function controler_team_heroinfo_node:_updateView()
	self._controlerMap.node_heroAvatar:update(self._battleHero)
	self:_updateView_heroName(self._battleHero)
	self:_updateView_heroPinZhi(self._battleHero)
	self:_updateView_heroLv(self._battleHero)
	self:_updateView_heroSkillLv(self._teamBattlePos)
	self:_updateView_heroHP(self._teamBattlePos)
	self:_updateView_heroWuFang(self._teamBattlePos)
	self:_updateView_heroFaFang(self._teamBattlePos)
	self:_updateView_heroBaoJi(self._teamBattlePos)
	self:_updateView_heroBaoShang(self._teamBattlePos)
	self:_updateView_heroMingzhong(self._teamBattlePos)
	self:_updateView_heroShanBi(self._teamBattlePos)
end

--更新视图: 武将名
function controler_team_heroinfo_node:_updateView_heroName( hero )
	local viewHeroName = self._scrollViewContainer:getChildByName("text_heroName")
	if hero ~= nil then
		viewHeroName:setString(hero:getName())
	else
		viewHeroName:setString("--")
	end
	
end

--更新视图: 武将品质
function controler_team_heroinfo_node:_updateView_heroPinZhi( hero )
	local viewHeroPinZhi = self._scrollViewContainer:getChildByName("text_hero_pinZhi_value")
	if hero ~= nil then
		viewHeroPinZhi:setString(hero:getPinZhi())
	else
		viewHeroPinZhi:setString(0)
	end
	
end

--更新视图: 武将等级
function controler_team_heroinfo_node:_updateView_heroLv( hero )
	local viewHeroLv = self._scrollViewContainer:getChildByName("text_hero_lv_value")
	if hero ~= nil then
		viewHeroLv:setString(hero:getCurLv())
	else
		viewHeroLv:setString(0)
	end
end


--更新视图: 武将技能强度
function controler_team_heroinfo_node:_updateView_heroSkillLv( battlePos )
	local viewHeroSkilllv = self._scrollViewContainer:getChildByName("node_skilllv")
	viewHeroSkilllv:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().skillLv))
	viewHeroSkilllv:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_skill_lv))
end


--更新视图: 武将HP
function controler_team_heroinfo_node:_updateView_heroHP( battlePos )
	local viewHeroHP = self._scrollViewContainer:getChildByName("node_hp")
	viewHeroHP:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().hp))
	viewHeroHP:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_hp))
end

--更新视图: 武将物防
function controler_team_heroinfo_node:_updateView_heroWuFang( battlePos )
	local viewHeroWuFang = self._scrollViewContainer:getChildByName("node_wufang")
	viewHeroWuFang:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().pdef))
	viewHeroWuFang:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_pdef))
end

--更新视图: 武将法防
function controler_team_heroinfo_node:_updateView_heroFaFang( battlePos )
	local viewHeroFaFang = self._scrollViewContainer:getChildByName("node_fafang")
	viewHeroFaFang:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().mdef))
	viewHeroFaFang:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_mdef))
end

--更新视图: 武将暴击
function controler_team_heroinfo_node:_updateView_heroBaoJi( battlePos )
	local viewHeroBaoJi = self._scrollViewContainer:getChildByName("node_baoji")
	viewHeroBaoJi:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().crit))
	viewHeroBaoJi:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_crit))
end


--更新视图: 武将爆伤
function controler_team_heroinfo_node:_updateView_heroBaoShang( battlePos )
	local viewHeroBaoShang = self._scrollViewContainer:getChildByName("node_baoshang")
	viewHeroBaoShang:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().crit_damage))
	viewHeroBaoShang:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_crit_damage))
end



--更新视图: 武将命中
function controler_team_heroinfo_node:_updateView_heroMingzhong( battlePos )
	local viewHeroMingzhong = self._scrollViewContainer:getChildByName("node_mingzhong")
	viewHeroMingzhong:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().hit))
	viewHeroMingzhong:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_hit))
end


--更新视图: 武将闪避
function controler_team_heroinfo_node:_updateView_heroShanBi( battlePos )
	local viewHeroShanBi = self._scrollViewContainer:getChildByName("node_shanbi")
	viewHeroShanBi:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().miss))
	viewHeroShanBi:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_miss))
end


function controler_team_heroinfo_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


return controler_team_heroinfo_node






