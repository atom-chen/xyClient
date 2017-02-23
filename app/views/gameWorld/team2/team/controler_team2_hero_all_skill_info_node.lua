--
-- Author: lipeng
-- Date: 2015-08-28 11:44:08
-- 控制器: 所有技能信息


local controler_team2_hero_all_skill_info_node = class("controler_team2_hero_all_skill_info_node")

function controler_team2_hero_all_skill_info_node:ctor( hero_all_skill_info_node )
	self:_initModels()

	self._hero_all_skill_info_node = hero_all_skill_info_node
	self._scrollViewContainer = self._hero_all_skill_info_node:getChildByName("scrollView")

	self:_initSkillListView()
	self:_registUIEvent()
end

function controler_team2_hero_all_skill_info_node:getView()
	return self._hero_all_skill_info_node
end


function controler_team2_hero_all_skill_info_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_hero_all_skill_info_node:setTeamBattlePos( pos )
	self._teamBattlePos = pos
	self._battleHero =  MAIN_PLAYER:getHeroManager():getHero(self._teamBattlePos:getHeroGUID()) 
	self:_updateView()
end


function controler_team2_hero_all_skill_info_node:_initModels()
	self._controlerEventCallBack = nil

    self._battleHero = nil
    self._teamBattlePos = nil
end


function controler_team2_hero_all_skill_info_node:_initSkillListView()
	self._listView = self._scrollViewContainer:getChildByName("skillList")

	local listItemTempleate = self._hero_all_skill_info_node:getChildByName("skillInfoTempleate")

	self._listView:setItemModel(
		listItemTempleate:clone()
	)
end

function controler_team2_hero_all_skill_info_node:_registUIEvent()
	local btn_back = self._scrollViewContainer:getChildByName("btn_back")
    local function btn_backTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "btn_backTouchEvent")
        end
    end
    btn_back:addTouchEventListener(btn_backTouchEvent)
end


function controler_team2_hero_all_skill_info_node:_updateView()
	self:_updateView_skillOrder()
	self:_updateView_skillList()
end


--更新视图: 技能释放顺序
function controler_team2_hero_all_skill_info_node:_updateView_skillOrder()
	local skillIconContainer = self._scrollViewContainer

	if self._battleHero ~= nil then
		local skillSet = self._battleHero:getSkillSet()

		local skillIconContainer = self._scrollViewContainer

		for i=1, 3 do
			local icon = skillIconContainer:
				getChildByName("icon_skill"..i):
				getChildByName("icon")

			if skillSet.order[i] ~= nil then
				local activeSkillIdx = skillSet.order[i]
				local skillID = skillSet.active[activeSkillIdx]
				
				widgetHelper:loadTextureWithPlist(
					icon, 
					SKILL_ICON_HELPER:getIconImageName(skillID)
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

function controler_team2_hero_all_skill_info_node:_updateView_skillList()
	self._listView:removeAllChildren()

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

		for i,v in ipairs(skillIDList) do
			local skillID = v
			local config = GetSkill(skillID)

			self._listView:pushBackDefaultItem()
			local newItem = self._listView:getItem(i-1)
			newItem:setVisible(true)
			--名字
			newItem:getChildByName("name"):setString(config.name)
			--icon
			local icon = newItem:getChildByName("icon")
			widgetHelper:loadTextureWithPlist(
				icon, 
				SKILL_ICON_HELPER:getIconImageName(skillID)
			)
			--描述
			newItem:getChildByName("dec"):setString(config.description)
		end
	end
end


function controler_team2_hero_all_skill_info_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end

return controler_team2_hero_all_skill_info_node

