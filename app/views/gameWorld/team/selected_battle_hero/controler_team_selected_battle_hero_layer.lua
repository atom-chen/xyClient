--
-- Author: lipeng
-- Date: 2015-07-16 15:49:29
-- 控制器: 选择上阵武将

local class_controler_team_sbh_country_selected_node = import(".controler_team_sbh_country_selected_node")
local class_controler_team_sbh_list_node = import(".controler_team_sbh_list_node")
local class_team_sbh_heroInfo_node = import(".team_sbh_heroInfo_node")

local controler_team_selected_battle_hero_layer = class("controler_team_selected_battle_hero_layer")


function controler_team_selected_battle_hero_layer:ctor(team_selected_battle_hero_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_selected_battle_hero_layer = team_selected_battle_hero_layer
	self._team_selected_battle_hero_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._team_selected_battle_hero_layer)

	self._shadow_layout = self._team_selected_battle_hero_layer:getChildByName("shadow_layout")
	self._shadow_layout:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._shadow_layout)
	
 	self:_createControlerForUI()
    self:_registUIEvent()
end

function controler_team_selected_battle_hero_layer:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team_selected_battle_hero_layer:getView()
    return self._team_selected_battle_hero_layer
end

--params.nameID
function controler_team_selected_battle_hero_layer:runAction( params )
	if params.nameID == "popupOut" then
		self:_runAction_popupOut()

	elseif params.nameID == "popupBack" then
		self:_runAction_popupBack()
	end
end



function controler_team_selected_battle_hero_layer:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
end


--创建控制器: UI
function controler_team_selected_battle_hero_layer:_createControlerForUI()
	--默认选中国家的ID
	local defalutSelectedCountryIDList = {1, 2, 3, 4}
	local backgroundNode = self._team_selected_battle_hero_layer:getChildByName("background")

    --选择国家
    self._controlerMap.team_sbh_country_selected_node = class_controler_team_sbh_country_selected_node.new(
        backgroundNode:getChildByName("country_selected")
    )
    self._controlerMap.team_sbh_country_selected_node:addEventListener(handler(self, self._onEvent_country_selected_node))

    --武将列表
    self._controlerMap.team_sbh_list_node = class_controler_team_sbh_list_node.new(
        backgroundNode:getChildByName("herolist")
    )
    self._controlerMap.team_sbh_list_node:addEventListener(handler(self, self._onEvent_herolist_node))

    --武将信息
    self._controlerMap.team_sbh_heroInfo_node = class_team_sbh_heroInfo_node.new(
        backgroundNode:getChildByName("heroInfo")
    )

    self._controlerMap.team_sbh_list_node:updateListWithCountryIDList(defalutSelectedCountryIDList)
    self._controlerMap.team_sbh_heroInfo_node:setHero(
    	self._controlerMap.team_sbh_list_node:getCurSelectedHero()
    )
    
end


function controler_team_selected_battle_hero_layer:_registUIEvent()
	local backgroundNode = self._team_selected_battle_hero_layer:getChildByName("background")

	local function closeTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	self:runAction({nameID="popupBack"})
        end
    end

    local btn_close = backgroundNode:getChildByName("framework"):getChildByName("button_exit")
	btn_close:addTouchEventListener(closeTouchEvent)  
end

function controler_team_selected_battle_hero_layer:_runAction_popupOut( params )
	GLOBAL_COMMON_ACTION:popupOut({
		node=self._team_selected_battle_hero_layer, 
		shadowNode=self._shadow_layout
	})
end


function controler_team_selected_battle_hero_layer:_runAction_popupBack( params )
	local function actionFinishCallback()
		self:_doEventCallBack(self, "popupBackActionFinish")
	end
	GLOBAL_COMMON_ACTION:popupBack({
		node=self._team_selected_battle_hero_layer, 
		shadowNode=self._shadow_layout,
		callback=actionFinishCallback
	})
end


function controler_team_selected_battle_hero_layer:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


function controler_team_selected_battle_hero_layer:_onEvent_country_selected_node( sender, eventName )
	if eventName == "updateSelectedCountryIDList" then
		self._controlerMap.team_sbh_list_node:updateListWithCountryIDList(sender:getSelectedCountryIDList())
		self._controlerMap.team_sbh_heroInfo_node:setHero(
	    	self._controlerMap.team_sbh_list_node:getCurSelectedHero()
	    )
	end
end


function controler_team_selected_battle_hero_layer:_onEvent_herolist_node( sender, eventName )
	if eventName == "onSelItemEnd" then
		self._controlerMap.team_sbh_heroInfo_node:setHero(
	    	sender:getCurSelectedHero()
	    )
	end
end



return controler_team_selected_battle_hero_layer










