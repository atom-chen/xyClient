--
-- Author: lipeng
-- Date: 2015-08-27 20:24:04
--

local controler_team2_hero_all_attr_info_node = class("controler_team2_hero_all_attr_info_node")

function controler_team2_hero_all_attr_info_node:ctor( hero_all_attr_info_node )
	self:_initModels()

	self._hero_all_attr_info_node = hero_all_attr_info_node
	self._scrollViewContainer = self._hero_all_attr_info_node:getChildByName("scrollView")

	self:_registUIEvent()
end

function controler_team2_hero_all_attr_info_node:getView()
	return self._hero_all_attr_info_node
end


function controler_team2_hero_all_attr_info_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_hero_all_attr_info_node:setTeamBattlePos( pos )
	self._teamBattlePos = pos
	self._battleHero =  MAIN_PLAYER:getHeroManager():getHero(self._teamBattlePos:getHeroGUID()) 
	self:_updateView()
end


function controler_team2_hero_all_attr_info_node:_initModels()
	self._controlerEventCallBack = nil

    self._battleHero = nil
    self._teamBattlePos = nil
end

function controler_team2_hero_all_attr_info_node:_registUIEvent()
	local btn_back = self._scrollViewContainer:getChildByName("btn_back")
    local function btn_backTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "btn_backTouchEvent")
        end
    end
    btn_back:addTouchEventListener(btn_backTouchEvent)
end


function controler_team2_hero_all_attr_info_node:_updateView()
	self:_updateView_wg()
	self:_updateView_fg()
	self:_updateView_heroHP()
	self:_updateView_heroWuFang()
	self:_updateView_heroFaFang()
	self:_updateView_hit()
	self:_updateView_miss()
	self:_updateView_baoJi()
	self:_updateView_baoshang()
end


--更新视图: 武将HP
function controler_team2_hero_all_attr_info_node:_updateView_heroHP()
	local battlePos = self._teamBattlePos
	local viewHeroHP = self._scrollViewContainer:getChildByName("node_hp")
	viewHeroHP:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().hp))
	viewHeroHP:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_hp))
end

--更新视图: 武将物攻
function controler_team2_hero_all_attr_info_node:_updateView_wg()
	local battlePos = self._teamBattlePos
	local viewHeroAttack = self._scrollViewContainer:getChildByName("node_wg")
	if self._battleHero ~= nil and 
		"物攻" == self._battleHero:getStrAtkType() then
		viewHeroAttack:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().atk))
		viewHeroAttack:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_atk))
	else
		viewHeroAttack:getChildByName("baseValue"):setString(0)
		viewHeroAttack:getChildByName("addtionValue"):setString(0)
	end
end

--更新视图: 武将法攻
function controler_team2_hero_all_attr_info_node:_updateView_fg()
	local battlePos = self._teamBattlePos
	local viewHeroAttack = self._scrollViewContainer:getChildByName("node_fg")
	if self._battleHero ~= nil and 
		"法攻" == self._battleHero:getStrAtkType() then
		viewHeroAttack:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().atk))
		viewHeroAttack:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_atk))
	else
		viewHeroAttack:getChildByName("baseValue"):setString(0)
		viewHeroAttack:getChildByName("addtionValue"):setString(0)
	end
end

--更新视图: 武将物防
function controler_team2_hero_all_attr_info_node:_updateView_heroWuFang()
	local battlePos = self._teamBattlePos
	local viewHeroWuFang = self._scrollViewContainer:getChildByName("node_wufang")
	viewHeroWuFang:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().pdef))
	viewHeroWuFang:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_pdef))
end

--更新视图: 武将法防
function controler_team2_hero_all_attr_info_node:_updateView_heroFaFang()
	local battlePos = self._teamBattlePos
	local viewHeroFaFang = self._scrollViewContainer:getChildByName("node_fafang")
	viewHeroFaFang:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().mdef))
	viewHeroFaFang:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_mdef))
end


--更新视图: 武将命中
function controler_team2_hero_all_attr_info_node:_updateView_hit()
	local battlePos = self._teamBattlePos
	local viewHeroHit = self._scrollViewContainer:getChildByName("node_hit")
	viewHeroHit:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().hit))
	viewHeroHit:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_hit))
end

--更新视图: 武将闪避
function controler_team2_hero_all_attr_info_node:_updateView_miss()
	local battlePos = self._teamBattlePos
	local viewHeroHit = self._scrollViewContainer:getChildByName("node_miss")
	viewHeroHit:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().miss))
	viewHeroHit:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_miss))
end


--更新视图: 武将暴击
function controler_team2_hero_all_attr_info_node:_updateView_baoJi()
	local battlePos = self._teamBattlePos
	local viewHeroHit = self._scrollViewContainer:getChildByName("node_baoji")
	viewHeroHit:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().crit))
	viewHeroHit:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_crit))
end

--更新视图: 武将爆伤
function controler_team2_hero_all_attr_info_node:_updateView_baoshang()
	local battlePos = self._teamBattlePos
	local viewHeroHit = self._scrollViewContainer:getChildByName("node_baoshang")
	viewHeroHit:getChildByName("baseValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().crit_damage))
	viewHeroHit:getChildByName("addtionValue"):setString(HeroFuAttrToInt(battlePos:getHeroAttr().delta_crit_damage))
end


function controler_team2_hero_all_attr_info_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end

return controler_team2_hero_all_attr_info_node
