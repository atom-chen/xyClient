--
-- Author: lipeng
-- Date: 2015-07-22 14:49:27
--

local class_controler_formation_background_layer = import(".controler_formation_background_layer")
local class_controler_formation_type_group_node = import(".controler_formation_type_group_node")
local class_controler_formation_order_group_node = import(".controler_formation_order_group_node")
local class_controler_formation_show_pos_group_node = import(".controler_formation_show_pos_group_node")


local controler_formation_ui_layer = class("controler_formation_ui_layer")

--[[----------------------
公有成员函数
-------------------------]]
function controler_formation_ui_layer:ctor(formation_ui_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._formation_ui_layer = formation_ui_layer
	self._formation_ui_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._formation_ui_layer)

    self._node_dragActor = self._formation_ui_layer:getChildByName("node_dragActor")
	
	self:_registGlobalEventListeners()
 	self:_createControlerForUI()
 	self:_registNodeEvent()
    self:_registUIEvent()
    self:_updateView()
end

function controler_formation_ui_layer:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_formation_ui_layer:getView()
    return self._formation_ui_layer
end

--params.nameID
function controler_formation_ui_layer:runAction( params )
	if params.nameID == "popupOut" then
		self:_runAction_popupOut()

	elseif params.nameID == "popupBack" then
		self:_runAction_popupBack()
	end
end


--[[----------------------
私有成员函数
-------------------------]]
function controler_formation_ui_layer:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
    --视角类型(CONST_CAMP_ENEMY: 敌方视角; CONST_CAMP_PLAYER:玩家视角)
    self._lookDirect = Data_Battle.CONST_CAMP_PLAYER
    --是否有拖拽的角色
    self._hasDragActor = false
end

function controler_formation_ui_layer:_registGlobalEventListeners()
	self._globalEventListeners = {}

	local configs = {
		{modelName = "model_team", eventName = "powerValueChange", callBack=handler(self, self._onPowerValueChange)},
		{modelName = "net", eventName = tostring(MSG_MS2C_TEAM_UPDATE_BPOS), callBack=handler(self, self._onMSG_MS2C_TEAM_UPDATE_BPOS)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--注册节点事件
function controler_formation_ui_layer:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self._formation_ui_layer:registerScriptHandler(onNodeEvent)
end


function controler_formation_ui_layer:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end



--创建控制器: UI
function controler_formation_ui_layer:_createControlerForUI()
	local formationID = self._team:getFormationID()

	--背景
    self._controlerMap.background = class_controler_formation_background_layer.new(
        self._formation_ui_layer:getChildByName("background")
    )

    --阵型类型
    self._controlerMap.formation_type_group = class_controler_formation_type_group_node.new(
        self._formation_ui_layer:getChildByName("zhenxingGroup")
    )
    self._controlerMap.formation_type_group:setCurSelectedFormationID(formationID)

    self._controlerMap.formation_type_group:addEventListener(handler(self, self._onFormation_type_groupEventListener))

    --替补序列组
    self._controlerMap.formation_order_group_node = class_controler_formation_order_group_node.new(
        self._formation_ui_layer:getChildByName("orderGroup")
    )
    self._controlerMap.formation_order_group_node:setTiBuOnBattlePosIdxList(
    	self._team:getBattleHeroManager():getTiBuOnBattlePosIdxList()
    )

    self._controlerMap.formation_order_group_node:addEventListener(handler(self, self._onOrder_group_nodeEventListener))

    --展示位组
    self._controlerMap.formation_show_pos_group_node = class_controler_formation_show_pos_group_node.new(
        self._formation_ui_layer:getChildByName("formation_show")
    )
    self._controlerMap.formation_show_pos_group_node:setFormationID(self._team:getFormationID())
    self._controlerMap.formation_show_pos_group_node:setZhuLiList(
    	self._team:getBattleHeroManager():getZhuLiListOnBattlePosIdxList()
    )
    self._controlerMap.formation_show_pos_group_node:setLookDirect(self._lookDirect)
    self._controlerMap.formation_show_pos_group_node:updateAllView()

    self._controlerMap.formation_show_pos_group_node:addEventListener(handler(self, self._onShow_pos_group_nodeEventListener))

    --可拖拽角色
    self._controlerMap.actorView = ManagerActor:CreateActor( {
		-- herodata = nil,--英雄数据
		-- mark = "456",-- 角色GUID
		camp = self._lookDirect,-- 阵营
		-- bossmark = 0,是否是boss
		-- frompos = 1, ,位置
		templateid = 20000,
		map_x = 0,
		map_y = 0,
	})

    self._controlerMap.actorView:doEvent("event_initializeshow", {
    		parentnode = self._node_dragActor
    	})
    self._controlerMap.actorView:doEvent("event_hide")
end


function controler_formation_ui_layer:_registUIEvent()
	--查看队伍
	local btn_lookTeam = self._formation_ui_layer:getChildByName("btn_lookTeam")

    local function btn_lookTeamTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "btn_lookTeamTouchEvent")
        end
    end
    btn_lookTeam:addTouchEventListener(btn_lookTeamTouchEvent)

    --切换视角
    local btn_change_shijiao = self._formation_ui_layer:getChildByName("btn_change_shijiao")

    local function btn_change_shijiaoTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
           	if self._lookDirect == Data_Battle.CONST_CAMP_ENEMY then
           		self._lookDirect = Data_Battle.CONST_CAMP_PLAYER
           	else
           		self._lookDirect = Data_Battle.CONST_CAMP_ENEMY
           	end
      --      	--更新拖拽角色朝向
      --      	self._controlerMap.actorView:setActorShowView(0, self._lookDirect)

      --      	--更新展示位角色朝向
      --      	self._controlerMap.formation_show_pos_group_node:setLookDirect(
		    -- 	self._lookDirect
		    -- )
		    -- self._controlerMap.formation_show_pos_group_node:updateAllView()
        end
    end
    btn_change_shijiao:addTouchEventListener(btn_change_shijiaoTouchEvent)
end

function controler_formation_ui_layer:_runAction_popupOut( params )
	GLOBAL_COMMON_ACTION:popupOut({
		node=self._formation_ui_layer, 
	})
end


function controler_formation_ui_layer:_runAction_popupBack( params )
	local function actionFinishCallback()
		self:_doEventCallBack(self, "popupBackActionFinish")
	end
	GLOBAL_COMMON_ACTION:popupBack({
		node=self._formation_ui_layer,
		callback=actionFinishCallback
	})
end


function controler_formation_ui_layer:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


function controler_formation_ui_layer:_updateView()
	self:_updateView_powerValue(self._team:getPowerValue())
end


function controler_formation_ui_layer:_updateView_powerValue(powerValue)
	self._formation_ui_layer:getChildByName("text_zhandouli_value"):setString(powerValue)
end


function controler_formation_ui_layer:_onPowerValueChange( event )
	local useData = event._usedata
	if useData.sender == self._team then
		self:_updateView_powerValue(useData.curPower)
	end
end


function controler_formation_ui_layer:_onMSG_MS2C_TEAM_UPDATE_BPOS( event )
	local formationID = self._team:getFormationID()
	self._controlerMap.formation_type_group:setCurSelectedFormationID(formationID)
	self._controlerMap.formation_show_pos_group_node:setFormationID(formationID)
	self._controlerMap.formation_show_pos_group_node:setZhuLiList(
    	self._team:getBattleHeroManager():getZhuLiListOnBattlePosIdxList()
    )
	self._controlerMap.formation_show_pos_group_node:updateAllView()

	self._controlerMap.formation_order_group_node:setTiBuOnBattlePosIdxList(
    	self._team:getBattleHeroManager():getTiBuOnBattlePosIdxList()
    )
end


function controler_formation_ui_layer:_onFormation_type_groupEventListener( sender, eventName )
	if "posTouchEnded" == eventName then
		
	end
end


function controler_formation_ui_layer:_onOrder_group_nodeEventListener( sender, eventName, eventData )
	local curSelPos = self._controlerMap.formation_order_group_node:getCurSelectedPos()
	
	if eventName == "posTouchBegan" then
		if curSelPos:getBattlePos():getHeroGUID() == NULL_GUID then
			return
		end
		self._hasDragActor = true
		curSelPos:getHeroIconView():setVisible(false)

		local posViewTouchCoording = curSelPos:getTouchBeginPos()
		local posView_localCoording = self._formation_ui_layer:convertToNodeSpace(posViewTouchCoording)
		self._node_dragActor:setPosition(posView_localCoording)
		--self._controlerMap.actorView:setActorShowView(0, self._lookDirect)
		self._controlerMap.actorView:doEvent("event_exitHide")

	elseif eventName == "posTouchMoved" then
		if not self._hasDragActor then
			return
		end
		local posViewTouchCoording = curSelPos:getTouchMovePos()
		local posView_localCoording = self._formation_ui_layer:convertToNodeSpace(posViewTouchCoording)
		self._node_dragActor:setPosition(posView_localCoording)

	elseif eventName == "posTouchEnded" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._controlerMap.actorView:doEvent("event_hide")
		curSelPos:getHeroIconView():setVisible(true)

	elseif eventName == "posTouchCanceled" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._controlerMap.actorView:doEvent("event_hide")

		local showPos =	self._controlerMap.formation_show_pos_group_node:getPosWithTouchPos(
			 curSelPos:getTouchEndPos()
		)
		if showPos ~= nil then
			FormationSystemInstance:sendNetMsg_swapWarPos(
				curSelPos:getPosOnWar(),
				showPos:getZhuLiIdX()
			)

		else
			--如果touchCanceled事件没有拾取到序列位置
			if eventData.touchCanceledOfOrderPos == nil then
				curSelPos:getHeroIconView():setVisible(true)
			end
		end

		
	end
end



function controler_formation_ui_layer:_onShow_pos_group_nodeEventListener( sender, eventName, eventData )
	local curSelPos = self._controlerMap.formation_show_pos_group_node:getCurSelectedPos()
	
	if eventName == "posTouchBegan" then
		if curSelPos:getBattlePos():getHeroGUID() == NULL_GUID then
			return
		end
		self._hasDragActor = true
		curSelPos:getActorView():doEvent("event_hide")

		local posViewTouchCoording = curSelPos:getTouchBeginPos()
		local posView_localCoording = self._formation_ui_layer:convertToNodeSpace(posViewTouchCoording)
		self._node_dragActor:setPosition(posView_localCoording)
		--self._controlerMap.actorView:setActorShowView(0, self._lookDirect)
		self._controlerMap.actorView:doEvent("event_exitHide")

	elseif eventName == "posTouchMoved" then
		if not self._hasDragActor then
			return
		end
		local posViewTouchCoording = curSelPos:getTouchMovePos()
		local posView_localCoording = self._formation_ui_layer:convertToNodeSpace(posViewTouchCoording)
		self._node_dragActor:setPosition(posView_localCoording)

	elseif eventName == "posTouchEnded" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._controlerMap.actorView:doEvent("event_hide")
		curSelPos:getActorView():doEvent("event_exitHide")

	elseif eventName == "posTouchCanceled" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._controlerMap.actorView:doEvent("event_hide")
		local tiBuPos =	self._controlerMap.formation_order_group_node:getPosWithTouchPos(
			 curSelPos:getTouchEndPos()
		)
		if tiBuPos ~= nil then
			FormationSystemInstance:sendNetMsg_swapWarPos(
				curSelPos:getZhuLiIdX(),
				tiBuPos:getPosOnWar()
			)

			if tiBuPos:getBattlePos() == nil then
				curSelPos:getBattlePos():setPosOnWarUseTibuStartIdx(tiBuPos:getIdx()-1)
			else
				curSelPos:getBattlePos():swapPosOnWar(tiBuPos:getBattlePos())
			end

		else
			--如果touchCanceled事件没有拾取到展示位置
			if eventData.touchCanceledOfShowPos == nil or
				not eventData.touchCanceledOfShowPos:isEnable() then
				curSelPos:getActorView():doEvent("event_exitHide")
			end
		end
		
	end
end


return controler_formation_ui_layer











