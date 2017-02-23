--
-- Author: lipeng
-- Date: 2015-08-25 11:45:42
-- 阵型入口

local class_controler_team2_formation_type_group_node = import(".controler_team2_formation_type_group_node")
local class_controler_team2_formation_show_pos_group = import(".controler_team2_formation_show_pos_group")
local class_controler_team2_formation_order_group_node = import(".controler_team2_formation_order_group_node")



local controler_team2_formation_main_node = class("controler_team2_formation_main_node")


function controler_team2_formation_main_node:ctor( team2_formation_main_node )
	self:_initModels()

	self._team2_formation_main_node = team2_formation_main_node
	self._node_dragHeroIcon = self._team2_formation_main_node:getChildByName("dragHeroIcon")

	self:_createControlerForUI()
    self:_registUIEvent()

    self:_registGlobalEventListeners()
    self:_registNodeEvent()
end


function controler_team2_formation_main_node:getView()
	return self._team2_formation_main_node
end

function controler_team2_formation_main_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_formation_main_node:_initModels()
	self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._team = MAIN_PLAYER:getTeamManager():getCurSelTeam()
    --是否有拖拽的角色
    self._hasDragActor = false
end

function controler_team2_formation_main_node:_createControlerForUI()
	local formationID = self._team:getFormationID()
	--阵型类型
    self._controlerMap.formation_type_group = class_controler_team2_formation_type_group_node.new(
        self._team2_formation_main_node:getChildByName("formationType")
    )
    self._controlerMap.formation_type_group:setCurSelectedFormationID(formationID)


    --展示位组
    self._controlerMap.formation_show_pos_group_node = class_controler_team2_formation_show_pos_group.new(
        self._team2_formation_main_node:getChildByName("showPosGroup")
    )
    self._controlerMap.formation_show_pos_group_node:setFormationID(self._team:getFormationID())
    self._controlerMap.formation_show_pos_group_node:setZhuLiList(
    	self._team:getBattleHeroManager():getZhuLiListOnBattlePosIdxList()
    )
    self._controlerMap.formation_show_pos_group_node:updateAllView()

    self._controlerMap.formation_show_pos_group_node:addEventListener(handler(self, self._onShow_pos_group_nodeEventListener))

    --替补序列组
    self._controlerMap.formation_order_group_node = class_controler_team2_formation_order_group_node.new(
        self._team2_formation_main_node:getChildByName("orderGroup")
    )
    self._controlerMap.formation_order_group_node:setTiBuOnBattlePosIdxList(
    	self._team:getBattleHeroManager():getTiBuOnBattlePosIdxList()
    )

    self._controlerMap.formation_order_group_node:addEventListener(handler(self, self._onOrder_group_nodeEventListener))

end



function controler_team2_formation_main_node:_registUIEvent()
	--关闭
    local btn_close = self._team2_formation_main_node:getChildByName("btn_close")
    local function btn_closeTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            teamSystem2Instance:closeTeamView()
        end
    end
    btn_close:addTouchEventListener(btn_closeTouchEvent)
end


function controler_team2_formation_main_node:_registGlobalEventListeners()
	self._globalEventListeners = {}

	local configs = {
		{modelName = "model_team", eventName = "powerValueChange", callBack=handler(self, self._onPowerValueChange)},
		{modelName = "net", eventName = tostring(MSG_MS2C_TEAM_UPDATE_BPOS), callBack=handler(self, self._onMSG_MS2C_TEAM_UPDATE_BPOS)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--注册节点事件
function controler_team2_formation_main_node:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self._team2_formation_main_node:registerScriptHandler(onNodeEvent)
end

function controler_team2_formation_main_node:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function controler_team2_formation_main_node:_updateView_powerValue(powerValue)
	self._team2_formation_main_node:getChildByName("text_powerValue"):setString(powerValue)
end


function controler_team2_formation_main_node:_onPowerValueChange( event )
	local useData = event._usedata
	if useData.sender == self._team then
		self:_updateView_powerValue(useData.curPower)
	end
end


function controler_team2_formation_main_node:_onMSG_MS2C_TEAM_UPDATE_BPOS( event )
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


function controler_team2_formation_main_node:_onShow_pos_group_nodeEventListener( sender, eventName, eventData )
	local curSelPos = self._controlerMap.formation_show_pos_group_node:getCurSelectedPos()
	
	if eventName == "posTouchBegan" then
		if curSelPos:getBattlePos():getHeroGUID() == NULL_GUID then
			return
		end
		self._hasDragActor = true
		curSelPos:hideHeroIcon()

		local posViewTouchCoording = curSelPos:getTouchBeginPos()
		local posView_localCoording = self._team2_formation_main_node:convertToNodeSpace(posViewTouchCoording)
		self._node_dragHeroIcon:setPosition(posView_localCoording)
		HERO_ICON_HELPER:updateIcon(
			{
				bgImg = self._node_dragHeroIcon:getChildByName("bg"),
				iconImg = self._node_dragHeroIcon:getChildByName("icon"),
				heroTempleateID = curSelPos:getHero():getTempleateID(),
				guideImg = self._node_dragHeroIcon:getChildByName("guide")
			}
		)
		self._node_dragHeroIcon:setVisible(true)

	elseif eventName == "posTouchMoved" then
		if not self._hasDragActor then
			return
		end
		local posViewTouchCoording = curSelPos:getTouchMovePos()
		local posView_localCoording = self._team2_formation_main_node:convertToNodeSpace(posViewTouchCoording)
		self._node_dragHeroIcon:setPosition(posView_localCoording)

	elseif eventName == "posTouchEnded" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._node_dragHeroIcon:setVisible(false)
		curSelPos:showHeroIcon()

	elseif eventName == "posTouchCanceled" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._node_dragHeroIcon:setVisible(false)

		local tiBuPos =	self._controlerMap.formation_order_group_node:getPosWithTouchPos(
			 curSelPos:getTouchEndPos()
		)
		if tiBuPos ~= nil then
			teamSystem2Instance:sendNetMsg_swapWarPos(
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
				curSelPos:showHeroIcon()
			end
		end
		
	end
end



function controler_team2_formation_main_node:_onOrder_group_nodeEventListener( sender, eventName, eventData )
	local curSelPos = self._controlerMap.formation_order_group_node:getCurSelectedPos()
	
	if eventName == "posTouchBegan" then
		if curSelPos:getBattlePos():getHeroGUID() == NULL_GUID then
			return
		end
		self._hasDragActor = true
		curSelPos:getHeroIconView():setVisible(false)

		local posViewTouchCoording = curSelPos:getTouchBeginPos()
		local posView_localCoording = self._team2_formation_main_node:convertToNodeSpace(posViewTouchCoording)
		self._node_dragHeroIcon:setPosition(posView_localCoording)
		HERO_ICON_HELPER:updateIcon(
			{
				bgImg = self._node_dragHeroIcon:getChildByName("bg"),
				iconImg = self._node_dragHeroIcon:getChildByName("icon"),
				heroTempleateID = curSelPos:getHero():getTempleateID()
			}
		)
		self._node_dragHeroIcon:setVisible(true)

	elseif eventName == "posTouchMoved" then
		if not self._hasDragActor then
			return
		end
		local posViewTouchCoording = curSelPos:getTouchMovePos()
		local posView_localCoording = self._team2_formation_main_node:convertToNodeSpace(posViewTouchCoording)
		self._node_dragHeroIcon:setPosition(posView_localCoording)

	elseif eventName == "posTouchEnded" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._node_dragHeroIcon:setVisible(false)
		curSelPos:getHeroIconView():setVisible(true)

	elseif eventName == "posTouchCanceled" then
		if not self._hasDragActor then
			return
		end
		self._hasDragActor = false
		self._node_dragHeroIcon:setVisible(false)

		local showPos =	self._controlerMap.formation_show_pos_group_node:getPosWithTouchPos(
			 curSelPos:getTouchEndPos()
		)
		if showPos ~= nil then
			teamSystem2Instance:sendNetMsg_swapWarPos(
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




function controler_team2_formation_main_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


return controler_team2_formation_main_node
