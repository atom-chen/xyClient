--
-- Author: lipeng
-- Date: 2015-08-27 16:57:51
-- 控制器: 队伍英雄信息

local controler_team_heroinfo_node = class("controler_team2_heroinfo_node")


function controler_team_heroinfo_node:ctor(team_heroinfo_node)
	self:_initModels()

	--根层
	self._team_heroinfo_node = team_heroinfo_node

    self._scrollViewContainer = self._team_heroinfo_node:getChildByName("scrollView")

    self:_createControlerForUI()
    self:_registUIEvent()
end

function controler_team_heroinfo_node:getView()
	return self._team_heroinfo_node
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
	
end


function controler_team_heroinfo_node:_registUIEvent()
	local scrollViewContainer = self._scrollViewContainer

	local btn_lookMoreAttr = scrollViewContainer:getChildByName("btn_lookMoreAttr")
    local function btn_lookMoreAttrTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "btn_lookMoreAttrTouchEvent")
        end
    end
    btn_lookMoreAttr:addTouchEventListener(btn_lookMoreAttrTouchEvent)

    --查看技能
    local btn_lookSkill = scrollViewContainer:getChildByName("btn_lookSkill")
    local function btn_lookSkillTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "btn_lookSkillTouchEvent")
        end
    end
    btn_lookSkill:addTouchEventListener(btn_lookSkillTouchEvent)
end


function controler_team_heroinfo_node:_updateView()
	self:_updateView_attack()
	self:_updateView_heroHP()
	self:_updateView_heroWuFang()
	self:_updateView_heroFaFang()
	self:_updateView_skillsIcon()
end


--更新视图: 武将HP
function controler_team_heroinfo_node:_updateView_heroHP()
	local battlePos = self._teamBattlePos
	local viewHeroHP = self._scrollViewContainer:getChildByName("node_hp")
	viewHeroHP:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().hp))
	viewHeroHP:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_hp))
end

--更新视图: 武将攻击
function controler_team_heroinfo_node:_updateView_attack()
	local battlePos = self._teamBattlePos
	local viewHeroAttack = self._scrollViewContainer:getChildByName("node_gongji")
	if self._battleHero ~= nil then
		viewHeroAttack:getChildByName("text"):
			setString(self._battleHero:getStrAtkType()..":")
	end
	viewHeroAttack:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().atk))
	viewHeroAttack:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_atk))
end

--更新视图: 武将物防
function controler_team_heroinfo_node:_updateView_heroWuFang()
	local battlePos = self._teamBattlePos
	local viewHeroWuFang = self._scrollViewContainer:getChildByName("node_wufang")
	viewHeroWuFang:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().pdef))
	viewHeroWuFang:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_pdef))
end

--更新视图: 武将法防
function controler_team_heroinfo_node:_updateView_heroFaFang()
	local battlePos = self._teamBattlePos
	local viewHeroFaFang = self._scrollViewContainer:getChildByName("node_fafang")
	viewHeroFaFang:getChildByName("baseValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().mdef))
	viewHeroFaFang:getChildByName("addtionValue"):setString(HeroMainAttrToInt(battlePos:getHeroAttr().delta_mdef))
end

--更新视图: 所有技能图标
function controler_team_heroinfo_node:_updateView_skillsIcon()
	local skillIconContainer = self._scrollViewContainer

	if self._battleHero ~= nil then
		local skillSet = self._battleHero:getSkillSet()
		local skillIDList = {}

		for i=1, #skillSet.active do
			skillIDList[#skillIDList+1] = skillSet.active[i]
		end

		for i=1, #skillSet.passive do
			skillIDList[#skillIDList+1] = skillSet.passive[i]
		end

		local skillIconContainer = self._scrollViewContainer
		for i=1, 3 do
			local icon = skillIconContainer:
				getChildByName("icon_skill"..i):
				getChildByName("icon")

			if skillIDList[i] ~= nil then
				widgetHelper:loadTextureWithPlist(
					icon, 
					SKILL_ICON_HELPER:getIconImageName(skillIDList[i])
				)
				icon:setVisible(true)
			else
				icon:setVisible(false)
			end
		end
	else
		for i=1, 3 do
			skillIconContainer:
				getChildByName("icon_skill"..i):
				getChildByName("icon"):
				setVisible(false)
		end
	end
end



function controler_team_heroinfo_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


return controler_team_heroinfo_node








