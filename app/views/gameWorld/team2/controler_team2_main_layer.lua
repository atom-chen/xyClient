--
-- Author: lipeng
-- Date: 2015-07-08 10:30:31
-- 控制器: 新队伍系统入口节点

local class_controler_team2_tablist = import(".controler_team2_tablist")
local class_controler_team2_team_node = import(".team.controler_team2_team_node")
local class_controler_team2_formation_main_node = import(".formation.controler_team2_formation_main_node")

local controler_team2_main_layer = class("controler_team2_main_layer")


function controler_team2_main_layer:ctor(team2_main_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team2_main_layer = team2_main_layer
    self._team2_main_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._team2_main_layer)

    --self:_registGlobalEventListeners()

    self:_createControlerForUI()
    -- self:_registNodeEvent()
    -- self:_registUIEvent()
end


function controler_team2_main_layer:getView()
    return self._team2_main_layer
end

function controler_team2_main_layer:getCurSelPos()
    return self._controlerMap.team:getCurSelPos()
end


function controler_team2_main_layer:_initModels()
    self._controlerMap = {}
end

function controler_team2_main_layer:_registGlobalEventListeners()
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
function controler_team2_main_layer:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._team2_main_layer:registerScriptHandler(onNodeEvent)
end


function controler_team2_main_layer:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

--创建控制器: UI
function controler_team2_main_layer:_createControlerForUI()
    local UIContainer = self._team2_main_layer
    self._controlerMap.team = class_controler_team2_team_node.new(
        UIContainer:getChildByName("team")
    )

    self._controlerMap.formation = class_controler_team2_formation_main_node.new(
        UIContainer:getChildByName("formation")
    )

    self._controlerMap.tabList = class_controler_team2_tablist.new(
        UIContainer:getChildByName("tabList")
    )

    self._controlerMap.tabList:addEventListener(handler(self, self._onEvent_tabList))
    self._controlerMap.tabList:setSelectedTab("队伍")
end


function controler_team2_main_layer:_registUIEvent()
    local layer_selected_team_mask = self._team2_main_layer:getChildByName("selected_team_mask")
    layer_selected_team_mask:addTouchEventListener(function ()
        printInfo("touch")
    end)

    local function selectedTeamMaskTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            dispatchGlobaleEvent("controler_team2_main_layer", "selectedTeamMaskTouch")
        end
    end
    layer_selected_team_mask:setSwallowTouches(false)
    layer_selected_team_mask:addTouchEventListener(selectedTeamMaskTouchEvent)  


    local btn_zhenxing = self._team2_main_layer:getChildByName("btn_zhenxing")

    local function btn_zhenxingTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            dispatchGlobaleEvent("controler_team2_main_layer", "btn_zhenxingTouchEvent")
        end
    end
    btn_zhenxing:addTouchEventListener(btn_zhenxingTouchEvent)

end

function controler_team2_main_layer:_onEvent_tabList( sender, eventName, data )
    if eventName == "selectedTabChange" then
        if self._curShowPanleControler ~= nil then
            self._curShowPanleControler:getView():setVisible(false)
        end

        if data.curSelTabName == "队伍" then
            self._curShowPanleControler = self._controlerMap.team

        elseif data.curSelTabName == "阵型" then
            self._curShowPanleControler = self._controlerMap.formation
        end
        
        self._curShowPanleControler:getView():setVisible(true)
    end
end


function controler_team2_main_layer:_onEvent_controler_team_possetting_node( sender, eventName )
    if eventName == "curSelectedPosChange" then
        local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
        
        local selectedIdx = sender:getCurSelectedPos():getIdx()
        local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
        self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
        self._controlerMap.equip:setTeamBattlePos(selectedBattlePos)
    end
end



function controler_team2_main_layer:_updateView()
    local view_zhanLiValue = self._team2_main_layer:getChildByName("text_zhandouli_value")
    local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
    view_zhanLiValue:setString(team:getPowerValue())
end


function controler_team2_main_layer:_onCurSelTeamChange( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
    self._controlerMap.equip:setTeamBattlePos(selectedBattlePos)
end


function controler_team2_main_layer:_onPowerValueChange( event )
    local eventUseData = event._usedata

    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()

    if eventUseData.sender == team then
        local view_zhanLiValue = self._team2_main_layer:getChildByName("text_zhandouli_value")
        view_zhanLiValue:setString(eventUseData.curPower)
    end
    
end


function controler_team2_main_layer:_onMSG_MS2C_TEAM_UPDATE_LEADER( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
end

function controler_team2_main_layer:_onMSG_MS2C_TEAM_UPDATE_MEMBER( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
end

function controler_team2_main_layer:_onMSG_MS2C_EQUIPS_SETPOSITION( event )
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


function controler_team2_main_layer:_onMSG_MS2C_EQUIPS_UNLOADPOSITION( event )
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


return controler_team2_main_layer


