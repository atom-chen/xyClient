--
-- Author: lipeng
-- Date: 2015-07-16 15:49:29
-- 控制器: 选择装备

local class_controler_team_se_equipList_node = import(".controler_team_se_equipList_node")
local class_controler_team_se_equipInfo_node = import(".controler_team_se_equipInfo_node")

local controler_team_selected_equip_layer = class("controler_team_selected_equip_layer")


function controler_team_selected_equip_layer:ctor(team_selected_equip_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_selected_equip_layer = team_selected_equip_layer
	self._team_selected_equip_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._team_selected_equip_layer)

	self._shadow_layout = self._team_selected_equip_layer:getChildByName("shadow_layout")
	self._shadow_layout:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._shadow_layout)
	
 	self:_createControlerForUI()
    self:_registUIEvent()
end

function controler_team_selected_equip_layer:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team_selected_equip_layer:getView()
    return self._team_selected_equip_layer
end

--params.nameID
function controler_team_selected_equip_layer:runAction( params )
	if params.nameID == "popupOut" then
		self:_runAction_popupOut()

	elseif params.nameID == "popupBack" then
		self:_runAction_popupBack()
	end
end



function controler_team_selected_equip_layer:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
end


--创建控制器: UI
function controler_team_selected_equip_layer:_createControlerForUI()
	local backgroundNode = self._team_selected_equip_layer:getChildByName("background")

    --装备列表
    self._controlerMap.team_se_equipList_node = class_controler_team_se_equipList_node.new(
        backgroundNode:getChildByName("equipList")
    )
    self._controlerMap.team_se_equipList_node:addEventListener(handler(self, self._onEvent_equiplist_node))

    --武将信息
    self._controlerMap.team_se_equipInfo_node = class_controler_team_se_equipInfo_node.new(
        backgroundNode:getChildByName("equipInfo")
    )

    self._controlerMap.team_se_equipInfo_node:setEquip(
    	self._controlerMap.team_se_equipList_node:getCurSelectedEquip()
    )
    
end


function controler_team_selected_equip_layer:_registUIEvent()
	local backgroundNode = self._team_selected_equip_layer:getChildByName("background")

	local function closeTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	self:runAction({nameID="popupBack"})
        end
    end

    local btn_close = backgroundNode:getChildByName("framework"):getChildByName("button_exit")
	btn_close:addTouchEventListener(closeTouchEvent)  
end

function controler_team_selected_equip_layer:_runAction_popupOut( params )
	GLOBAL_COMMON_ACTION:popupOut({
		node=self._team_selected_equip_layer, 
		shadowNode=self._shadow_layout
	})
end


function controler_team_selected_equip_layer:_runAction_popupBack( params )
	local function actionFinishCallback()
		self:_doEventCallBack(self, "popupBackActionFinish")
	end
	GLOBAL_COMMON_ACTION:popupBack({
		node=self._team_selected_equip_layer, 
		shadowNode=self._shadow_layout,
		callback=actionFinishCallback
	})
end


function controler_team_selected_equip_layer:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


function controler_team_selected_equip_layer:_onEvent_equiplist_node( sender, eventName )
	if eventName == "onSelItemEnd" then
		self._controlerMap.team_se_equipInfo_node:setEquip(
	    	sender:getCurSelectedEquip()
	    )
	end
end



return controler_team_selected_equip_layer










