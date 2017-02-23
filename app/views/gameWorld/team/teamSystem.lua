--
-- Author: lipeng
-- Date: 2015-07-02 10:59:57
-- 队伍

import(".selected_battle_hero.team_selected_battle_hero_system")
import(".selected_equip.team_selected_equip_system")

local class_controler_team_ui_layer = import(".controler_UILayer.controler_team_ui_layer")


local teamSystem = class("teamSystem")


function teamSystem:ctor()
	self:_initModels()
	-- body
	--self:_registGlobalEventListeners()
	--TEST_CMD_SERVER_MSG["MSG_MS2C_BACKPACK"]()
end


--发送网络消息: 改变成员
--pos: 上阵位置索引
--newHeroGUID: 新英雄的GUID
function teamSystem:sendNetMsg_changeMember(posIdx, newHeroGUID)
	local teamManager = MAIN_PLAYER:getTeamManager()
	local curSelTeamIdx = teamManager:getCurSelTeamIdx()
	local pos = posIdx
   	local battleHeroManager = teamManager:getCurSelTeam():getBattleHeroManager()


   	if pos == 1 then
   		if newHeroGUID == NULL_GUID then
   			UIManager:CreatePrompt_Operate( {
				mark = "controler_team_possetting_node",
		        title = "提示",
		        content = "不能卸下队长",
			} )
   			return
   		end
   	end

   	--目标位置没有武将, 则不能卸载
   	if battleHeroManager:getPos(pos):getHeroGUID() == NULL_GUID and
   		newHeroGUID == NULL_GUID then
   		return
   	end


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
	
	if pos == 1 then
		printLog("网络日志",
			"发送设置队长请求：MSG_C2MS_TEAM_SET_LEADER, "..
			curSelTeamIdx..",  "..
			newHeroGUID
		)
		gameTcp:SendMessage(
				MSG_C2MS_TEAM_SET_LEADER,
				{
					curSelTeamIdx,
					newHeroGUID
				}
			)
	end
	
end

--发送网络消息: 给当前选中成员穿戴装备
function teamSystem:sendNetMsg_curSelMemberTakeEquip( equipGUID )
	local teamManager = MAIN_PLAYER:getTeamManager()
	local curSelTeamIdx = teamManager:getCurSelTeamIdx()
	local pos = self._controlerMap.team:getCurSelPos()

	local sendMsgData = {}
	sendMsgData[1] = curSelTeamIdx
	sendMsgData[2] = pos - 1
	sendMsgData[3] = equipGUID

	printLog("网络日志",
		"发送穿戴装备请求：MSG_C2MS_EQUIPS_SETPOSITION"
	)

	gameTcp:SendMessage(
		MSG_C2MS_EQUIPS_SETPOSITION,
		sendMsgData
	)
end



--发送网络消息: 卸下当前成员的所有装备
function teamSystem:sendNetMsg_curSelMemberUnloadAllEquip()
	local teamManager = MAIN_PLAYER:getTeamManager()
	local curSelTeam = teamManager:getCurSelTeam()
	local curSelTeamIdx = teamManager:getCurSelTeamIdx()
	local posIdx = self._controlerMap.team:getCurSelPos()
	local battlePos = curSelTeam:getBattleHeroManager():getPos(posIdx)

	for i=1, EquipTypeNum do
		local equipType = i - 1
		if battlePos:getEquip(equipType) ~= NULL_GUID then
			local sendMsgData = {}
			sendMsgData[1] = curSelTeamIdx
			sendMsgData[2] = posIdx - 1
			sendMsgData[3] = equipType

			printLog("网络日志",
				"发送卸下装备请求：MSG_C2MS_EQUIPS_UNLOADPOSITION"
			)

			gameTcp:SendMessage(
				MSG_C2MS_EQUIPS_UNLOADPOSITION,
				sendMsgData
			)
		end
	end

end




--发送网络消息: 当前选中成员自动穿戴装备
function teamSystem:sendNetMsg_curSelMemberAutoEquip()
	local teamManager = MAIN_PLAYER:getTeamManager()
	local curSelTeam = teamManager:getCurSelTeam()
	local curSelTeamIdx = teamManager:getCurSelTeamIdx()
	local curSelPosIdx = self._controlerMap.team:getCurSelPos()
	local battleHeroManager = curSelTeam:getBattleHeroManager()
	local curSelBattlePos = battleHeroManager:getPos(curSelPosIdx)

	local equipList = MAIN_PLAYER:getEquipManager():cloneEquipDataToList()

	--按战斗力排序, 战斗力高的排前面
	table.sort( equipList, function ( a, b )
		return a:getZhanDouLi() > b:getZhanDouLi()
	end )

	--最大战力的装备
	local maxZhanLi_equips = {}

	--获取当前角色允许穿戴的最大战力装备
	for i,v in ipairs(equipList) do
		local equipType = v:getType()
		
		--如果还没有最大战力值的该装备类型
		if maxZhanLi_equips[equipType] == nil then
			local equipGUID = v:getGUID()

			--[[
			检查除开当前选中成员的其他成员是否已经穿戴该装备
			]]
			--装备对应的上阵位置索引
			local equipInPosIdx = battleHeroManager:getPosIdxWithEquip(equipGUID)
			--如果成员没有穿戴该装备
			if equipInPosIdx == nil then
				--则允许穿戴
				maxZhanLi_equips[equipType] = equipGUID
			else
				--如果当前选中的角色已经穿戴该装备
				if equipInPosIdx == curSelPosIdx then
					maxZhanLi_equips[equipType] = equipGUID
				end
			end
			
		end
	end


	for k,v in pairs(maxZhanLi_equips) do
		local sendMsgData = {}
		sendMsgData[1] = curSelTeamIdx
		sendMsgData[2] = curSelPosIdx - 1
		sendMsgData[3] = v

		printLog("网络日志",
			"发送穿戴装备请求：MSG_C2MS_EQUIPS_SETPOSITION"
		)

		gameTcp:SendMessage(
			MSG_C2MS_EQUIPS_SETPOSITION,
			sendMsgData
		)

	end

end


function teamSystem:_initModels()
    self._controlerMap = {}
    self:_initDynamicResConfig()
end

function teamSystem:_initDynamicResConfig()
	ResConfig["ui_image/team/widget"] = {
		restype = "plist",
		respath = "ui_image/team/widget/",
		res = {"team_widget"}
	}

	ResConfig["ui_image/team/background"] = {
		restype = "plist",
		respath = "ui_image/team/",
		res = {"team_background"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/team/widget",
		"ui_image/team/background"
	}
end


function teamSystem:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mainpage_popup_buttons2", eventName = "duiwu_touched", callBack=handler(self, self._onDuiwu_touched)},
		{modelName = "controler_team_background_layer", eventName = "closeTouched", callBack=handler(self, self._onTeamViewCloseTouched)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function teamSystem:_createUILayer()
    return cc.CSLoader:createNode("ui_instance/team/team_ui_layer.csb")
end

function teamSystem:_onDuiwu_touched()
	self.scene = APP:getCurScene()
	if self._controlerMap.team == nil then
		self._controlerMap.team = class_controler_team_ui_layer.new(self:_createUILayer())
		self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.team:getView())

		GLOBAL_COMMON_ACTION:popupOut({node=self._controlerMap.team:getView()})
	end

end


function teamSystem:_onTeamViewCloseTouched( event )
	local function popupBackActionCallBack()
		if self._controlerMap.team ~= nil then
			self._controlerMap.team:getView():removeFromParent()
			self._controlerMap = {}
			release_res(self._dynamicResConfigIDs)
		end
		
	end
	GLOBAL_COMMON_ACTION:popupBack({node=self._controlerMap.team:getView(), callback=popupBackActionCallBack})
	
end



function teamSystem.getInstance()
    if teamSystem.instance == nil then
        teamSystem.instance = teamSystem.new()
    end

    return teamSystem.instance
end


TeamSystemInstance = teamSystem.getInstance()


return teamSystem
