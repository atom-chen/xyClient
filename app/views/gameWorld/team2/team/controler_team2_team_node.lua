--
-- Author: lipeng
-- Date: 2015-08-25 11:41:34
-- 队伍入口

local class_controler_team2_possetting_node = import(".controler_team2_possetting_node")
local class_controler_team2_hero_operation_node = import(".controler_team2_hero_operation_node")
local class_controler_team2_hero_info_node = import(".controler_team2_hero_info_node")
local class_controler_team2_hero_all_attr_info_node = import(".controler_team2_hero_all_attr_info_node")
local class_controler_team2_hero_all_skill_info_node = import(".controler_team2_hero_all_skill_info_node")
local class_controler_team2_change_equip_node = import(".controler_team2_change_equip_node")
local class_controler_team2_change_hero_node = import(".controler_team2_change_hero_node")




local controler_team2_team_node = class("controler_team2_team_node")


function controler_team2_team_node:ctor( team_node )
	self:_initModels()

	self._team_node = team_node

	self:_createControlerForUI()
	self:_initView()
    self:_registUIEvent()

    self:_registNodeEvent()
    self:_registGlobalEventListeners()
end


function controler_team2_team_node:getView()
	return self._team_node
end

function controler_team2_team_node:getCurSelPos()
    return self._controlerMap.possetting:getCurSelectedPos():getIdx()
end

function controler_team2_team_node:_initModels()
	self._controlerMap = {}
end


function controler_team2_team_node:_createControlerForUI()
	local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()

    --默认选中上阵位置
    local defalutSelectedBattlePos = team:getBattleHeroManager():getPos(1)

    --位置设置
    self._controlerMap.possetting = class_controler_team2_possetting_node.new(
        self._team_node:getChildByName("possetting")
    )
    self._controlerMap.possetting:setTeam(team)
    self._controlerMap.possetting:addEventListener(handler(self, self._onEvent_controler_team_possetting_node))
    
    --武将操作
    self._controlerMap.heroOperation = class_controler_team2_hero_operation_node.new(
        self._team_node:getChildByName("heroOperation")
    )
    self._controlerMap.heroOperation:setTeamBattlePos(defalutSelectedBattlePos)
    self._controlerMap.heroOperation:addEventListener(handler(self, self._onEvent_heroOperation))

    --武将信息
    self._controlerMap.heroInfo = class_controler_team2_hero_info_node.new(
        self._team_node:getChildByName("heroInfo")
    )
    self._controlerMap.heroInfo:setTeamBattlePos(defalutSelectedBattlePos)

    self._controlerMap.heroInfo:addEventListener(handler(self, self._onEvent_heroInfo))
end

function controler_team2_team_node:_initView()
	local text_powerValue = self._team_node:getChildByName("text_powerValue")
    local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
    text_powerValue:setString(team:getPowerValue())
end

function controler_team2_team_node:_registUIEvent()
    --关闭
    local btn_close = self._team_node:getChildByName("btn_close")
    local function btn_closeTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            teamSystem2Instance:closeTeamView()
        end
    end
    btn_close:addTouchEventListener(btn_closeTouchEvent)
end

--注册节点事件
function controler_team2_team_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._team_node:registerScriptHandler(onNodeEvent)
end

function controler_team2_team_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end


function controler_team2_team_node:_registGlobalEventListeners()
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


function controler_team2_team_node:_onCurSelTeamChange( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)

    self._controlerMap.heroOperation:setTeamBattlePos(selectedBattlePos)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
end


function controler_team2_team_node:_onPowerValueChange( event )
    local eventUseData = event._usedata

    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()

    if eventUseData.sender == team then
        local view_zhanLiValue = self._team_node:getChildByName("text_powerValue")
        view_zhanLiValue:setString(eventUseData.curPower)
    end
    
end


function controler_team2_team_node:_onMSG_MS2C_TEAM_UPDATE_LEADER( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)

    self._controlerMap.heroOperation:setTeamBattlePos(selectedBattlePos)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)

    if self._controlerMap.changeHero ~= nil then
        self._controlerMap.changeHero:getView():removeFromParent()
        self._controlerMap.changeHero = nil
    end
end


function controler_team2_team_node:_onMSG_MS2C_TEAM_UPDATE_MEMBER( event )
    local teamManager = MAIN_PLAYER:getTeamManager()
    local team = teamManager:getCurSelTeam()
    
    self._controlerMap.possetting:setTeam(team)
    local selectedIdx = self._controlerMap.possetting:getCurSelectedPos():getIdx()
    local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
   
    self._controlerMap.heroOperation:setTeamBattlePos(selectedBattlePos)
    self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)

    if self._controlerMap.changeHero ~= nil then
        self._controlerMap.changeHero:getView():removeFromParent()
        self._controlerMap.changeHero = nil
    end
end


function controler_team2_team_node:_onMSG_MS2C_EQUIPS_SETPOSITION( event )
    local useData = event._usedata
    if useData.result == eEquip_Succed then
        local teamManager = MAIN_PLAYER:getTeamManager()
        local team = teamManager:getCurSelTeam()

        --当前选中的上阵位置
        local selectedBattlePos = team:getBattleHeroManager():getPos(self:getCurSelPos())
        self._controlerMap.heroOperation:setTeamBattlePos(selectedBattlePos)
        self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
        
        if self._controlerMap.changeEquip ~= nil then
            self._controlerMap.changeEquip:getView():removeFromParent()
            self._controlerMap.changeEquip = nil
        end
    end
end


function controler_team2_team_node:_onMSG_MS2C_EQUIPS_UNLOADPOSITION( event )
    local useData = event._usedata
    if useData.result == eEquip_Succed then
        local teamManager = MAIN_PLAYER:getTeamManager()
        local team = teamManager:getCurSelTeam()

        --当前选中的上阵位置
        local selectedBattlePos = team:getBattleHeroManager():getPos(self:getCurSelPos())
        self._controlerMap.heroOperation:setTeamBattlePos(selectedBattlePos)
        self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
        
        if self._controlerMap.changeEquip ~= nil then
            self._controlerMap.changeEquip:getView():removeFromParent()
            self._controlerMap.changeEquip = nil
        end
    end
end



function controler_team2_team_node:_onEvent_controler_team_possetting_node( sender, eventName )
    if eventName == "curSelectedPosChange" then
        local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
        
        local selectedIdx = sender:getCurSelectedPos():getIdx()
        local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
        self._controlerMap.heroOperation:setTeamBattlePos(selectedBattlePos)
        self._controlerMap.heroInfo:setTeamBattlePos(selectedBattlePos)
    	if self._controlerMap.allAttrInfo ~= nil then
    		self._controlerMap.allAttrInfo:setTeamBattlePos(selectedBattlePos)
    	end
    	if self._controlerMap.allSkillInfo ~= nil then
    		self._controlerMap.allSkillInfo:setTeamBattlePos(selectedBattlePos)
    	end

    elseif eventName == "posClick" then
        if self._controlerMap.changeHero == nil then
            local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
            local selectedIdx = self:getCurSelPos()
            local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
            local hero = MAIN_PLAYER:getHeroManager():getHero(selectedBattlePos:getHeroGUID())
            
            self._controlerMap.changeHero = class_controler_team2_change_hero_node.new(
                self:_createView_changeHero(), selectedIdx
            )
            self._controlerMap.changeHero:addEventListener(handler(self, self._onEvent_changeHero))
            self._controlerMap.changeHero:setCurSelHero(hero)
            self._team_node:getChildByName("changeHeroPos"):
                addChild(self._controlerMap.changeHero:getView())
        end
    end
end

function controler_team2_team_node:_onEvent_heroInfo( sender, eventName )
    if eventName == "btn_lookMoreAttrTouchEvent" then
    	self._controlerMap.heroInfo:getView():setVisible(false)

        if self._controlerMap.allAttrInfo == nil then
        	self._controlerMap.allAttrInfo = class_controler_team2_hero_all_attr_info_node.new(
        		self:_createView_allAttrInfo()
        	)

        	local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
 
	        local selectedIdx = self:getCurSelPos()
	        local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
        	self._controlerMap.allAttrInfo:setTeamBattlePos(selectedBattlePos)
        	self._controlerMap.allAttrInfo:addEventListener(handler(self, self._onEvent_allAttrInfo))
        	self._team_node:getChildByName("allAttrInfoPos"):
	        	addChild(self._controlerMap.allAttrInfo:getView())
        end

    elseif eventName == "btn_lookSkillTouchEvent" then
    	self._controlerMap.heroInfo:getView():setVisible(false)

        if self._controlerMap.allSkillInfo == nil then
        	self._controlerMap.allSkillInfo = class_controler_team2_hero_all_skill_info_node.new(
        		self:_createView_allSkillInfo()
        	)

        	local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
 
	        local selectedIdx = self:getCurSelPos()
	        local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
        	self._controlerMap.allSkillInfo:setTeamBattlePos(selectedBattlePos)
        	self._controlerMap.allSkillInfo:addEventListener(handler(self, self._onEvent_allSkillInfo))
        	self._team_node:getChildByName("allSkillInfoPos"):
	        	addChild(self._controlerMap.allSkillInfo:getView())
        end
    end
end


function controler_team2_team_node:_onEvent_allAttrInfo( sender, eventName )
	if "btn_backTouchEvent" == eventName then
		self._controlerMap.allAttrInfo:getView():removeFromParent()
		self._controlerMap.allAttrInfo = nil
		self._controlerMap.heroInfo:getView():setVisible(true)
	end
end


function controler_team2_team_node:_onEvent_allSkillInfo( sender, eventName )
	if "btn_backTouchEvent" == eventName then
		self._controlerMap.allSkillInfo:getView():removeFromParent()
		self._controlerMap.allSkillInfo = nil
		self._controlerMap.heroInfo:getView():setVisible(true)
	end
end

function controler_team2_team_node:_onEvent_heroOperation( sender, eventName )
    if "equipClick" == eventName then
        local seledEquipItem = self._controlerMap.heroOperation:getCurSelEquipItem()

        if seledEquipItem:getEquip() ~= nil then
            self._controlerMap.equipDialog = UIManager:createEquipDialog(seledEquipItem:getEquip(), true)
            self._controlerMap.equipDialog:addEventListener(handler(self, self._onEvent_equipDialog))
        else
            if self._controlerMap.changeEquip == nil then
                self._controlerMap.changeEquip = class_controler_team2_change_equip_node.new(
                    self:_createView_changeEquip()
                )

                local seledEquipItem = self._controlerMap.heroOperation:getCurSelEquipItem()
                self._controlerMap.changeEquip:setCurSelEquip(seledEquipItem)
                self._controlerMap.changeEquip:addEventListener(handler(self, self._onEvent_changeEquip))
                self._team_node:getChildByName("changeEquipPos"):
                    addChild(self._controlerMap.changeEquip:getView())
            end
        end

    elseif "btn_genghuan_wuJiangTouchEvent"  == eventName then
        if self._controlerMap.changeHero == nil then
            local team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
            local selectedIdx = self:getCurSelPos()
            local selectedBattlePos = team:getBattleHeroManager():getPos(selectedIdx)
            local hero = MAIN_PLAYER:getHeroManager():getHero(selectedBattlePos:getHeroGUID())
            
            self._controlerMap.changeHero = class_controler_team2_change_hero_node.new(
                self:_createView_changeHero(), selectedIdx
            )
            self._controlerMap.changeHero:addEventListener(handler(self, self._onEvent_changeHero))
            self._controlerMap.changeHero:setCurSelHero(hero)
            self._team_node:getChildByName("changeHeroPos"):
                addChild(self._controlerMap.changeHero:getView())
        end
    end
end


function controler_team2_team_node:_onEvent_equipDialog( sender, eventName )
    if eventName == "button_genghuanClicked" then
        if self._controlerMap.equipDialog ~= nil then
            self._controlerMap.equipDialog:close()
            self._controlerMap.equipDialog = nil

            if self._controlerMap.changeEquip == nil then
                self._controlerMap.changeEquip = class_controler_team2_change_equip_node.new(
                    self:_createView_changeEquip()
                )

                local seledEquipItem = self._controlerMap.heroOperation:getCurSelEquipItem()
                self._controlerMap.changeEquip:setCurSelEquip(seledEquipItem)
                self._controlerMap.changeEquip:addEventListener(handler(self, self._onEvent_changeEquip))
                self._team_node:getChildByName("changeEquipPos"):
                    addChild(self._controlerMap.changeEquip:getView())
            end
            
        end
    end
end


function controler_team2_team_node:_onEvent_changeEquip( sender, eventName )
    if eventName == "btn_closeTouchEvent" then
        if self._controlerMap.changeEquip ~= nil then
            self._controlerMap.changeEquip:getView():removeFromParent()
            self._controlerMap.changeEquip = nil
        end
    end
end

function controler_team2_team_node:_onEvent_changeHero( sender, eventName )
    if eventName == "btn_closeTouchEvent" then
        if self._controlerMap.changeHero ~= nil then
            self._controlerMap.changeHero:getView():removeFromParent()
            self._controlerMap.changeHero = nil
        end
    end
end



function controler_team2_team_node:_createView_allAttrInfo()
	return cc.CSLoader:createNode("ui_instance/team2/team/team2_hero_all_attr_info_node.csb")
end


function controler_team2_team_node:_createView_allSkillInfo()
	return cc.CSLoader:createNode("ui_instance/team2/team/team2_hero_all_skill_info_node.csb")
end

function controler_team2_team_node:_createView_changeEquip()
    return cc.CSLoader:createNode("ui_instance/team2/team/team2_change_equip_node.csb")
end

function controler_team2_team_node:_createView_changeHero()
    return cc.CSLoader:createNode("ui_instance/team2/team/team2_change_hero_node.csb")
end

return controler_team2_team_node
