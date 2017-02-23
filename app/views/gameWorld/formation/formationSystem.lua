--
-- Author: lipeng
-- Date: 2015-07-21 19:25:41
-- 阵型


local class_controler_formation_ui_layer = import(".controler_UILayer.controler_formation_ui_layer")


local formationSystem = class("formationSystem")


function formationSystem:ctor()
	self:_initModels()
	-- body
	self:_registGlobalEventListeners()
end

--发送网络消息: 改变阵型
function formationSystem:sendNetMsg_changeFormation(formationID)
	local sendMsgData = {}

	--队伍索引
	sendMsgData[1] = MAIN_PLAYER:getTeamManager():getCurSelTeamIdx()

	--阵型ID
	sendMsgData[2] = formationID

	--战斗位置
	local battleHeroManager = MAIN_PLAYER:getTeamManager():getCurSelTeam():getBattleHeroManager()
	for i=1, MaxTeamMemberNum do
		sendMsgData[#sendMsgData+1] = battleHeroManager:getPos(i):getPosOnWar()
	end

	gameTcp:SendMessage(MSG_C2MS_TEAM_SET_BPOS, sendMsgData)
end


--发送网络消息: 交换战斗位置
function formationSystem:sendNetMsg_swapWarPos(srcWarPos, destWarPos)
	local sendMsgData = {}

	local teamManager = MAIN_PLAYER:getTeamManager()

	--队伍索引
	sendMsgData[1] = teamManager:getCurSelTeamIdx()

	local team = teamManager:getCurSelTeam()
	--阵型ID
	sendMsgData[2] = team:getFormationID()

	--战斗位置
	local battleHeroManager = MAIN_PLAYER:getTeamManager():getCurSelTeam():getBattleHeroManager()
	--获取战斗位置关联的上阵位置
	local srcBattlePos = battleHeroManager:getPosIdxWithPosOnWar(srcWarPos)
	local destBattlePos = battleHeroManager:getPosIdxWithPosOnWar(destWarPos)
	print("srcBattlePos = "..srcBattlePos.." destBattlePos = "..destBattlePos)
	print("srcWarPos = "..srcWarPos.." destWarPos = "..destWarPos)

	for i=1, MaxTeamMemberNum do
		local warPos = -1
		if srcBattlePos == i then
			warPos = destWarPos

		elseif destBattlePos == i then
			warPos = srcWarPos

		else
			warPos = battleHeroManager:getPos(i):getPosOnWar()
		end

		sendMsgData[#sendMsgData+1] = warPos
		print("i = "..i, "warPos = "..warPos)
	end

	gameTcp:SendMessage(MSG_C2MS_TEAM_SET_BPOS, sendMsgData)
end


function formationSystem:_initModels()
    self._controlerMap = {}
    self:_initDynamicResConfig()
end

function formationSystem:_initDynamicResConfig()
	ResConfig["ui_image/formation/widget"] = {
		restype = "plist",
		respath = "ui_image/formation/widget/",
		res = {"formation_widget"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/formation/widget",
	}
end


function formationSystem:_registGlobalEventListeners()
	self._globalEventListeners = {}

	local configs = {
		{modelName = "controler_team_ui_layer", eventName = "btn_zhenxingTouchEvent", callBack=handler(self, self._onBtn_zhenxingTouchEvent)},
		{modelName = "controler_formation_background_layer", eventName = "closeTouched", callBack=handler(self, self._onFormationViewCloseTouched)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function formationSystem:_createUILayer()
    return cc.CSLoader:createNode("ui_instance/formation/formation_ui_layer.csb")
end

function formationSystem:_onBtn_zhenxingTouchEvent()
	self.scene = APP:getCurScene()

	if self._controlerMap.zhenxing == nil then
		self._controlerMap.zhenxing = class_controler_formation_ui_layer.new(self:_createUILayer())
		self._controlerMap.zhenxing:addEventListener(handler(self, self._onEvent_controler_zhenxing))
		self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.zhenxing:getView())
		self._controlerMap.zhenxing:runAction({nameID="popupOut"})
	end

end


function formationSystem:_onFormationViewCloseTouched( event )
	self._controlerMap.zhenxing:runAction({nameID="popupBack"})
end

function formationSystem:_onEvent_controler_zhenxing( sender, eventName )
	if eventName == "popupBackActionFinish" then
		self:release()

	elseif eventName == "btn_lookTeamTouchEvent" then
		self._controlerMap.zhenxing:runAction({nameID="popupBack"})
	end
end


function formationSystem:release()
	if self._controlerMap.zhenxing ~= nil then
		self._controlerMap.zhenxing:getView():removeFromParent()
		self._controlerMap = {}
		release_res(self._dynamicResConfigIDs)
	end
end


function formationSystem.getInstance()
    if formationSystem.instance == nil then
        formationSystem.instance = formationSystem.new()
    end

    return formationSystem.instance
end


FormationSystemInstance = formationSystem.getInstance()


return formationSystem

