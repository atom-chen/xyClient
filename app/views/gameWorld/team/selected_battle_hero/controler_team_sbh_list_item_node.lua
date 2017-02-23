--
-- Author: lipeng
-- Date: 2015-07-17 10:23:32
-- 选择上阵武将列表item

local controler_team_sbh_list_item_node = class("controler_team_sbh_list_item_node")

local RESOURCE_FILENAME = "ui_instance/team/selected_battle_hero/team_sbh_list_item_node.csb"

function controler_team_sbh_list_item_node:ctor()
	-- body
	self._itemView = createListViewItemWithNodeCSB(RESOURCE_FILENAME, "main_layout")
	
	self._icon = UIManager:CreateAvatarPart(0, {resourceNode=self._itemView:getChildByName("icon")})

	self:_registUIEvent()
end


function controler_team_sbh_list_item_node:getHero()
	return self._hero
end


function controler_team_sbh_list_item_node:getView()
	return self._itemView
end


function controler_team_sbh_list_item_node:update(hero)
	-- body
	self._hero = hero

	self._itemView:getChildByName("name"):setString(heroConfig[hero.id].name)
	self._itemView:getChildByName("lv"):setString(hero.curLv)

	-- 更新属性
	local attr = self._itemView:getChildByName("attr_layout")
	attr:getChildByName("att"):getChildByName("attr"):setString(hero:getBaseAttack())
	attr:getChildByName("hp"):getChildByName("attr"):setString(hero:getBaseHP())

	-- 更新头像
	self._icon:setAvatarByHeroID(hero.id)

	-- 是否上阵
	local yishangzhen = self._itemView:getChildByName("yishangzhen")
	-- if xxx then
	-- 	yishangzhen:setVisible(false)
	-- else
	-- 	yishangzhen:setVisible(true)
	-- end

end


function controler_team_sbh_list_item_node:_registUIEvent()
	local btn_shangzhen = self._itemView:getChildByName("btn_shangzhen")
	local function btn_shangzhenTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	local pos = TeamSelectedBattleHeroSystemInstance:getCurSelPos()
        	local newHeroGUID = self._hero:getGUID()
        	TeamSystemInstance:sendNetMsg_changeMember(pos, newHeroGUID)
        end
    end
    btn_shangzhen:addTouchEventListener(btn_shangzhenTouchEvent)
end


function controler_team_sbh_list_item_node:_sendMsg_MSG_C2MS_TEAM_SET_MEMBER()
	local teamManager = MAIN_PLAYER:getTeamManager()
	local curSelTeamIdx = teamManager:getCurSelTeamIdx()
	local pos = TeamSelectedBattleHeroSystemInstance:getCurSelPos()
   	local newHeroGUID = self._hero:getGUID()

	local battleHeroManager = teamManager:getCurSelTeam():getBattleHeroManager()
           		
	local sendMsgData = {}
	sendMsgData[1] = curSelTeamIdx
	printLog("网络日志",
		"发送设置队员请求：MSG_C2MS_TEAM_SET_MEMBER, 队伍 "..
		curSelTeamIdx
	)

	--
	--i==1是队长, 所以不发送
	for i=2, MaxTeamMemberNum do
		local oldHeroGUID = battleHeroManager:getPos(i):getHeroGUID()
		--如果新上阵的成员已经在上阵位置中
		if newHeroGUID == oldHeroGUID then
			--则将以前位置的英雄GUID设置为NULL_GUID
			oldHeroGUID = NULL_GUID
		end

		if i ~= pos then
			sendMsgData[#sendMsgData+1] = oldHeroGUID
		else
			sendMsgData[#sendMsgData+1] = newHeroGUID
		end
		
	end

	gameTcp:SendMessage(MSG_C2MS_TEAM_SET_MEMBER, sendMsgData)
end


return controler_team_sbh_list_item_node
