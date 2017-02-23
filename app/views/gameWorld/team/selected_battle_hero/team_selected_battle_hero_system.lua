--
-- Author: lipeng
-- Date: 2015-07-16 16:18:51
-- 系统: 选择上阵武将


local class_controler_team_selected_battle_hero_layer = import(".controler_team_selected_battle_hero_layer")

local team_selected_battle_hero_system = class("team_selected_battle_hero_system")


function team_selected_battle_hero_system:ctor()
	self:_initModels()
	-- body
	--self:_registGlobalEventListeners()
end

function team_selected_battle_hero_system:getCurSelPos()
	return self._curSelPos
end

function team_selected_battle_hero_system:_initModels()
	self._curSelPos = -1 -- 当前选中的位置
    self._controlerMap = {}
    self:_initDynamicResConfig()
end

function team_selected_battle_hero_system:_initDynamicResConfig()
	-- ResConfig["ui_image/team/widget"] = {
	-- 	restype = "plist",
	-- 	respath = "ui_image/team/widget/",
	-- 	res = {"team_widget"}
	-- }

	-- ResConfig["ui_image/team/background"] = {
	-- 	restype = "plist",
	-- 	respath = "ui_image/team/",
	-- 	res = {"team_background"}
	-- }

	-- self._dynamicResConfigIDs = {
	-- 	"ui_image/team/widget",
	-- 	"ui_image/team/background"
	-- }
end


function team_selected_battle_hero_system:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "controler_team_possetting_node", eventName = "clickPos", callBack=handler(self, self._onTeamClickBattleHeroPos)},
		{modelName = "controler_team_heroinfo_node", eventName = "btn_genghuan_wuJiangTouchEvent", callBack=handler(self, self._onBtn_genghuan_wuJiangTouchEvent)},
		{modelName = "net", eventName = tostring(MSG_MS2C_TEAM_UPDATE_LEADER), callBack=handler(self, self._onMSG_MS2C_TEAM_UPDATE_LEADER)},
		{modelName = "net", eventName = tostring(MSG_MS2C_TEAM_UPDATE_MEMBER), callBack=handler(self, self._onMSG_MS2C_TEAM_UPDATE_MEMBER)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function team_selected_battle_hero_system:_createLayer()
    return cc.CSLoader:createNode("ui_instance/team/selected_battle_hero/team_selected_battle_hero_layer.csb")
end



function team_selected_battle_hero_system:_onTeamClickBattleHeroPos(event)
	self.scene = APP:getCurScene()
	local useData = event._usedata
	self._curSelPos = useData.pos
	if self._controlerMap.selected_battle_hero == nil then
		self._controlerMap.selected_battle_hero = class_controler_team_selected_battle_hero_layer.new(self:_createLayer())
		self._controlerMap.selected_battle_hero:addEventListener(handler(self, self._onEvent_controler_selected_battle_hero))
		self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.selected_battle_hero:getView())
		self._controlerMap.selected_battle_hero:runAction({nameID="popupOut"})
	end

end


function team_selected_battle_hero_system:_onBtn_genghuan_wuJiangTouchEvent(event)
	self.scene = APP:getCurScene()
	local useData = event._usedata
	self._curSelPos = useData.pos
	if self._controlerMap.selected_battle_hero == nil then
		self._controlerMap.selected_battle_hero = class_controler_team_selected_battle_hero_layer.new(self:_createLayer())
		self._controlerMap.selected_battle_hero:addEventListener(handler(self, self._onEvent_controler_selected_battle_hero))
		self.scene:addChildToLayer(LAYER_ID_POPUP, self._controlerMap.selected_battle_hero:getView())
		self._controlerMap.selected_battle_hero:runAction({nameID="popupOut"})
	end

end




function team_selected_battle_hero_system:_onTeamViewCloseTouched( event )
	self._controlerMap.selected_battle_hero:runAction({nameID="popupBack"})
end


function team_selected_battle_hero_system:_onMSG_MS2C_TEAM_UPDATE_LEADER( event )
	if self._controlerMap.selected_battle_hero ~= nil then
		self._controlerMap.selected_battle_hero:runAction({nameID="popupBack"})
	end
end

function team_selected_battle_hero_system:_onMSG_MS2C_TEAM_UPDATE_MEMBER( event )
	if self._controlerMap.selected_battle_hero ~= nil then
		self._controlerMap.selected_battle_hero:runAction({nameID="popupBack"})
	end
end


function team_selected_battle_hero_system:_onEvent_controler_selected_battle_hero( sender, eventName )
	if eventName == "popupBackActionFinish" then
		self:release()
	end
end


function team_selected_battle_hero_system:release()
	if self._controlerMap.selected_battle_hero ~= nil then
		self._controlerMap.selected_battle_hero:getView():removeFromParent()
		self._controlerMap = {}
		--release_res(self._dynamicResConfigIDs)
	end
end

function team_selected_battle_hero_system.getInstance()
    if team_selected_battle_hero_system.instance == nil then
        team_selected_battle_hero_system.instance = team_selected_battle_hero_system.new()
    end

    return team_selected_battle_hero_system.instance
end


TeamSelectedBattleHeroSystemInstance = team_selected_battle_hero_system.getInstance()


return team_selected_battle_hero_system
