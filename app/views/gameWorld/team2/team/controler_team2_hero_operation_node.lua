--
-- Author: lipeng
-- Date: 2015-08-27 14:23:39
-- 控制器: 英雄操作


local class_controler_team2_equips = import(".controler_team2_equips")
local controler_team2_hero_operation_node = class("controler_team2_hero_operation_node")


function controler_team2_hero_operation_node:ctor(hero_operation_node)
	self:_initModels()

	self._hero_operation_node = hero_operation_node

    self._scrollViewContainer = self._hero_operation_node:getChildByName("scrollView")

    self:_createControlerForUI()
    self:_registUIEvent()
end

function controler_team2_hero_operation_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_hero_operation_node:setTeamBattlePos( pos )
	self._teamBattlePos = pos
	self._battleHero =  MAIN_PLAYER:getHeroManager():getHero(self._teamBattlePos:getHeroGUID()) 
	self._controlerMap.equips:setTeamBattlePos(pos)
	self:_updateView()
end

--获取当前选中装备
function controler_team2_hero_operation_node:getCurSelEquipItem()
	return self._controlerMap.equips:getCurSelectedEquip()
end


function controler_team2_hero_operation_node:_initModels()
	self._controlerMap = {}
	self._controlerEventCallBack = nil

	self._teamBattlePos = nil
	self._battleHero = nil
end


--创建控制器: UI
function controler_team2_hero_operation_node:_createControlerForUI()
	local scrollViewContainer = self._scrollViewContainer
	--装备组
	self._controlerMap.equips = class_controler_team2_equips.new(
		scrollViewContainer
	)
	self._controlerMap.equips:addEventListener(handler(self, self._onEvent_equips))
end

function controler_team2_hero_operation_node:_registUIEvent()
	--更换装备
	local btn_genghuan_wuJiang = self._scrollViewContainer:getChildByName("btn_genghuan_wuJiang")
    local function btn_genghuan_wuJiangTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	self:_doEventCallBack(self, "btn_genghuan_wuJiangTouchEvent")
        end
    end
    btn_genghuan_wuJiang:addTouchEventListener(btn_genghuan_wuJiangTouchEvent)

    local btn_autoEquip = self._scrollViewContainer:getChildByName("btn_autoEquip")

    local function btn_autoEquipTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	teamSystem2Instance:sendNetMsg_curSelMemberAutoEquip()
        end
    end
    btn_autoEquip:addTouchEventListener(btn_autoEquipTouchEvent)
end


function controler_team2_hero_operation_node:_updateView()
	self:_updateView_heroIcon()
	self:_updateView_heroName()
	self:_updateView_powerValue()
end


function controler_team2_hero_operation_node:_updateView_heroIcon()
	local iconNode = self._scrollViewContainer:getChildByName("node_heroAvatar")
	local mainLayout = iconNode:getChildByName("main_layout")
	local hero = self._battleHero
	if hero ~= nil then
		HERO_ICON_LARGE_HELPER:updateIcon(
			{
				bgImg = mainLayout:getChildByName("bg"),
				iconImg = mainLayout:getChildByName("icon"),
				heroTempleateID = hero:getTempleateID()
			}
		)
	else
		HERO_ICON_LARGE_HELPER:updateIcon(
			{
				bgImg = mainLayout:getChildByName("bg"),
				iconImg = mainLayout:getChildByName("icon"),
				heroTempleateID = -1
			}
		)
	end
	
end


--更新视图: 武将名
function controler_team2_hero_operation_node:_updateView_heroName()
	local viewHeroName = self._scrollViewContainer:getChildByName("text_heroName")
	local hero = self._battleHero
	if hero ~= nil then
		viewHeroName:setString(hero:getName())
	else
		viewHeroName:setString("--")
	end
	
end

--更新视图: 战斗力
function controler_team2_hero_operation_node:_updateView_powerValue()
	local viewHeroPower = self._scrollViewContainer:getChildByName("text_powerValue")
	local battleHero = self._battleHero
	if battleHero ~= nil then
		viewHeroPower:setString(self._teamBattlePos:getHeroAttr().power)
	else
		viewHeroPower:setString("0")
	end
	
end

function controler_team2_hero_operation_node:_onEvent_equips(sender, eventName)
	if eventName == "equipClick" then
		self:_doEventCallBack(self, "equipClick")
	end
end


function controler_team2_hero_operation_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end

return controler_team2_hero_operation_node






