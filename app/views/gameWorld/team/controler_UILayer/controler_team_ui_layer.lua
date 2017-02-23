--
-- Author: lipeng
-- Date: 2015-07-08 10:30:31
--

local class_controler_team_background_layer = import(".controler_team_background_layer")
local class_controler_team_selected_team_node = import(".controler_team_selected_team_node")
local class_controler_team_equip_node = import(".controler_team_equip_node")
local class_controler_team_heroinfo_node = import(".controler_team_heroinfo_node")
local class_controler_team_possetting_node = import(".controler_team_possetting_node")


local controler_team_ui_layer = class("controler_team_ui_layer")


function controler_team_ui_layer:ctor(team_ui_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_ui_layer = team_ui_layer
    self._team_ui_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._team_ui_layer)

    local layer_selected_team_mask = self._team_ui_layer:getChildByName("selected_team_mask")
    layer_selected_team_mask:setContentSize(visibleSize)
    ccui.Helper:doLayout(layer_selected_team_mask)

    self:_registGlobalEventListeners()

    self:_createControlerForUI()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_updateView()
end


function controler_team_ui_layer:getView()
    return self._team_ui_layer
end

function controler_team_ui_layer:getCurSelPos()
    return self._controlerMap.possetting:getCurSelectedPos():getIdx()
end


function controler_team_ui_layer:_initModels()
    self._controlerMap = {}
end

function controler_team_ui_layer:_registGlobalEventListeners()
    self._globalEventListeners = {}
    local configs = {
        {modelName = "model_teamManager", eventName = "curSelTeamChange", callBack=handler(self, self._onCurSelTeamChange)},
        {modelName = "model_team", eventName = "powerValueChange", callBack=handler(self, self._onPowerValueChange)},
        {modelName = "net", eventName = tostring(MSG_MS2C_TEAM_UPDATE_LEADER), callBack=handler(self, self._onMSG_MS2C_TEAM_UPDATE_LEADER)},
        {modelName = "net", eventName = tostring(MSG_MS2C_TEAM_UPDATE_MEMBER), callBack=handler(self, self._onMSG_MS2C_TEAM_UPDATE_MEMBER)},
        {modelName = "net", eventName = tostring(MSG_MS2C_EQUIPS_SETPOSITION), callBack=handler(self, self._onMSG_MS2C_EQUIPS_SETPOSITION)},
        {modelName = "net", eventName = tostring(MSG_MS2C_EQUIPS_UNLOADPOSITION), callBack=handler(self, self._onMSG_MS2C_EQUIPS_UNLOADPOSITION)},
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--注册节点事件
function controler_team_ui_layer:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._team_ui_layer:registerScriptHandler(onNodeEvent)
end


function controler_team_ui_layer:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

--创建控制器: UI
function controler_team_ui_layer:_createControlerForUI()
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()

    --默认选中上阵位置
    local defalutSelectedBattlePos = team:getBattleHeroManager():getPos(1)

    --背景层
    self._controlerMap.background = class_controler_team_background_layer.new(
        self._team_ui_layer:getChildByName("background")
    )

    --选择队伍
    self._controlerMap.selectedTeam = class_controler_team_selected_team_node.new(
        self._team_ui_layer:getChildByName("selected_team")
    )
    self._controlerMap.selectedTeam:setTeamManager(teamManager)
    
    --位置设置
    self._controlerMap.possetting = class_controler_team_possetting_node.new(
        self._team_ui_layer:getChildByName("possetting")
    )
    self._controlerMap.possetting:setTeam(team)
    self._controlerMap.possetting:addEventListener(handler(self, self._onEvent_controler_team_possetting_node))

    --装备
    self._controlerMap.equip = class_controler_team_equip_node.new(
        self._team_ui_layer:getChildByName("equip")
    )
    self._controlerMap.equip:setTeamBattlePos(defalutSelectedBattlePos)
    
    --英雄信息
    self._controlerMap.heroInfo = class_controler_team_heroinfo_node.new(
        self._team_ui_layer:getChildByName("heroinfo")
    )
    self._controlerMap.heroInfo:setTeamBattlePos(defalutSelectedBattlePos)

    
end


function controler_team_ui_layer:_registUIEvent()
    local layer_selected_team_mask = self._team_ui_layer:getChildByName("selected_team_mask")
    layer_selected_team_mask:addTouchEventListener(function ()
        printInfo("touch")
    end)

    local function selectedTeamMaskTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            dispatchGlobaleEvent("controler_team_ui_layer", "selectedTeamMaskTouch")
        end
    end
    layer_selected_team_mask:setSwallowTouches(false)
    layer_selected_team_mask:addTouchEventListener(selectedTeamMaskTouchEvent)  


    local btn_zhenxing = self._team_ui_layer:getChildByName("btn_zhenxing")

    local function btn_zhenxingTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            dispatchGlobaleEvent("controler_team_ui_layer", "btn_zhenxingTouchEvent")
        end
    end
    btn_zhenxing:addTouchEventListener(btn_zhenxingTouchEvent)

end



function controler_team_ui_layer:_onEvent_controler_team_possetting_node( sender, eventName )
    if eventName == "curSelectedPosChange" then
        local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
        
        local selectedIdx = sender:getCurSelectedPos():getIdx()
        local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
        self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
        self._controlerMap.equip:setTeamBattlePos(selectedBattlePos)
    end
end



function controler_team_ui_layer:_updateView()
    local view_zhanLiValue = self._team_ui_layer:getChildByName("text_zhandouli_value")
    local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
    view_zhanLiValue:setString(team:getPowerValue())
end


function controler_team_ui_layer:_onCurSelTeamChange( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
    self._controlerMap.equip:setTeamBattlePos(selectedBattlePos)
end


function controler_team_ui_layer:_onPowerValueChange( event )
    local eventUseData = event._usedata

    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()

    if eventUseData.sender == team then
        local view_zhanLiValue = self._team_ui_layer:getChildByName("text_zhandouli_value")
        view_zhanLiValue:setString(eventUseData.curPower)
    end
    
end


function controler_team_ui_layer:_onMSG_MS2C_TEAM_UPDATE_LEADER( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
end

function controler_team_ui_layer:_onMSG_MS2C_TEAM_UPDATE_MEMBER( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
end

function controler_team_ui_layer:_onMSG_MS2C_EQUIPS_SETPOSITION( event )
    local useData = event._usedata
    if useData.result == eEquip_Succed then
        local teamManager = MAIN_PLAYER:getTeamManager()
        local team = teamManager:getCurSelTeam()

        --当前选中的上阵位置
        local selectedBattlePos = team:getBattleHeroManager():getPos(self:getCurSelPos())
        self._controlerMap.equip:setTeamBattlePos(selectedBattlePos)
        self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
    end
end


function controler_team_ui_layer:_onMSG_MS2C_EQUIPS_UNLOADPOSITION( event )
    local useData = event._usedata
    if useData.result == eEquip_Succed then
        local teamManager = MAIN_PLAYER:getTeamManager()
        local team = teamManager:getCurSelTeam()

        --当前选中的上阵位置
        local selectedBattlePos = team:getBattleHeroManager():getPos(self:getCurSelPos())
        self._controlerMap.equip:setTeamBattlePos(selectedBattlePos)
        self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
    end
end


return controler_team_ui_layer


