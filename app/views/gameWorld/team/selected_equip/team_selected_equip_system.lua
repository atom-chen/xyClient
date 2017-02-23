--
-- Author: lipeng
-- Date: 2015-07-16 16:18:51
-- 系统: 选择上阵武将


local class_controler_team_selected_equip_layer = import(".controler_team_selected_equip_layer")

local team_selected_equip_system = class("team_selected_equip_system")


function team_selected_equip_system:ctor()
	self:_initModels()
	--self:_registGlobalEventListeners()
	--TEST_CMD_SERVER_MSG["MSG_MS2C_EQUIPS_GETLIST"]()
end

function team_selected_equip_system:getCurSelEquipType()
	return self._curSelEquipType
end


function team_selected_equip_system:_initModels()
    self._controlerMap = {}
    self:_initDynamicResConfig()
end

function team_selected_equip_system:_initDynamicResConfig()

end


function team_selected_equip_system:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "controler_team_equip_node", eventName = "clickPos", callBack=handler(self, self._onTeamClickEquipPos)},
		{modelName = "net", eventName = tostring(MSG_MS2C_EQUIPS_SETPOSITION), callBack=handler(self, self._onMSG_MS2C_EQUIPS_SETPOSITION)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function team_selected_equip_system:_createLayer()
    return cc.CSLoader:createNode("ui_instance/team/selected_equip/team_selected_equip_layer.csb")
end

function team_selected_equip_system:_onTeamClickEquipPos(event)
	self.scene = APP:getCurScene()
	local useData = event._usedata
	self._curSelEquipType = useData.equipType

	if self._controlerMap.selected_equip == nil then
		self._controlerMap.selected_equip = class_controler_team_selected_equip_layer.new(self:_createLayer())
		self._controlerMap.selected_equip:addEventListener(handler(self, self._onEvent_controler_selected_equip))
		self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.selected_equip:getView())
		self._controlerMap.selected_equip:runAction({nameID="popupOut"})
	end

end

function team_selected_equip_system:_onMSG_MS2C_EQUIPS_SETPOSITION(event)
	local useData = event._usedata
	if useData.result == eEquip_Succed and self._controlerMap.selected_equip ~= nil then
		self._controlerMap.selected_equip:runAction({nameID="popupBack"})
	end
end


function team_selected_equip_system:_onTeamViewCloseTouched( event )
	self._controlerMap.selected_equip:runAction({nameID="popupBack"})
end


function team_selected_equip_system:_onEvent_controler_selected_equip( sender, eventName )
	if eventName == "popupBackActionFinish" then
		self:release()
	end
end


function team_selected_equip_system:release()
	if self._controlerMap.selected_equip ~= nil then
		self._controlerMap.selected_equip:getView():removeFromParent()
		self._controlerMap = {}
		--release_res(self._dynamicResConfigIDs)
	end
end

function team_selected_equip_system.getInstance()
    if team_selected_equip_system.instance == nil then
        team_selected_equip_system.instance = team_selected_equip_system.new()
    end

    return team_selected_equip_system.instance
end


TeamSelectedEquipSystemInstance = team_selected_equip_system.getInstance()


return team_selected_equip_system
