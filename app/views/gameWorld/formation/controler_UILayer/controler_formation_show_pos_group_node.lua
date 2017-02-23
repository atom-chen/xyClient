--
-- Author: lipeng
-- Date: 2015-07-22 19:58:26
-- 控制器: 展示位组(队伍所有主力)


local class_controler_formation_show_pos_node = import(".controler_formation_show_pos_node")
local controler_formation_show_pos_group_node = class("controler_formation_show_pos_group_node")


function controler_formation_show_pos_group_node:ctor(formation_show_pos_group_node, formationID)
	self:_initModels(formationID)

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._formation_show_pos_group_node = formation_show_pos_group_node

    self:_createControlerForUI()
    --self:_registUIEvent()
end


function controler_formation_show_pos_group_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中位置
function controler_formation_show_pos_group_node:getCurSelectedPos()
	return self._controlerMap.poses[self._curSelectedPos]
end

--通过touch位置获取展示位置
function controler_formation_show_pos_group_node:getPosWithTouchPos( touchPos )
	local poses = self._controlerMap.poses

	for i, v in ipairs(poses) do
		if v:containsPoint(touchPos) then
			--如果不可用
			if not v:isEnable() then
				return
			end
			return v
		end
	end
end


--设置替补列表
function controler_formation_show_pos_group_node:setZhuLiList(zhuLiList)
	self._zhuLiList = zhuLiList
end

--设置阵型
function controler_formation_show_pos_group_node:setFormationID(formationID)
	self._formationID = formationID
end

--设置视角
function controler_formation_show_pos_group_node:setLookDirect( direct )
	self._lookDirect = direct
end

--设置位置是否可用
function controler_formation_show_pos_group_node:setPosEnable( posIdx, isEnable )
	self._controlerMap.poses[posIdx]:setEnable(isEnable)
end


--更新所有视图
function controler_formation_show_pos_group_node:updateAllView()
	if self._lookDirect == Data_Battle.CONST_CAMP_PLAYER then
		self:_turnToPlayerDirect()
	else
		self:_turnToEnemyDirect()
	end
end


function controler_formation_show_pos_group_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil

    self._zhuLiList = nil

    self._curSelectedPos = -1
    self._formationID = 1
    self._lookDirect = Data_Battle.CONST_CAMP_PLAYER
end


--创建控制器: UI
function controler_formation_show_pos_group_node:_createControlerForUI()
	local view_posContainer = self._formation_show_pos_group_node

    --位置
    self._controlerMap.poses = {}
    for i=1, view_posContainer:getChildrenCount() do
	    self._controlerMap.poses[i] = class_controler_formation_show_pos_node.new(
	    	view_posContainer:getChildByName("pos"..i), i
	    )
	    self._controlerMap.poses[i]:addEventListener(handler(self, self._posEventListener))
	end

	self._controlerMap.poses[1]:getView():setLocalZOrder(31)
	self._controlerMap.poses[4]:getView():setLocalZOrder(32)
	self._controlerMap.poses[7]:getView():setLocalZOrder(33)
	self._controlerMap.poses[2]:getView():setLocalZOrder(21)
	self._controlerMap.poses[5]:getView():setLocalZOrder(22)
	self._controlerMap.poses[8]:getView():setLocalZOrder(23)
	self._controlerMap.poses[3]:getView():setLocalZOrder(11)
	self._controlerMap.poses[6]:getView():setLocalZOrder(12)
	self._controlerMap.poses[9]:getView():setLocalZOrder(13)


	self:_setCurSelPos(1)
end


function controler_formation_show_pos_group_node:_registUIEvent()

end



function controler_formation_show_pos_group_node:_posEventListener( sender, eventName )
	if "posTouchBegan" == eventName then
		self:_onPosTouchBegan(sender)
		self:_doEventCallBack(self, "posTouchBegan")

	elseif "posTouchMoved" == eventName then
		self:_doEventCallBack(self, "posTouchMoved")

	elseif "posTouchEnded" == eventName then
		self:_doEventCallBack(self, "posTouchEnded")

	elseif "posTouchCanceled" == eventName then
		local curSelPos = self:getCurSelectedPos()
		local touchCanceledOfShowPos = nil

		--如果touchBegan所选中的位置有关联武将
		if curSelPos:getBattlePos():getHeroGUID() ~= NULL_GUID then
			touchCanceledOfShowPos = self:getPosWithTouchPos(curSelPos:getTouchEndPos())
			--如果拾取到位置
			if touchCanceledOfShowPos ~= nil then
				if touchCanceledOfShowPos:isEnable() then
					FormationSystemInstance:sendNetMsg_swapWarPos(
						curSelPos:getZhuLiIdX(),
						touchCanceledOfShowPos:getZhuLiIdX()
					)
				end
			end
		end

		self:_doEventCallBack(self, "posTouchCanceled", {touchCanceledOfShowPos=touchCanceledOfShowPos})
	end
end


function controler_formation_show_pos_group_node:_onPosTouchBegan( sender )
	self:_setCurSelPos(sender:getIdxInGroup())
end


function controler_formation_show_pos_group_node:_doEventCallBack( sender, eventName, eventData )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, eventData)
	end
end


--设置当前选中位置
function controler_formation_show_pos_group_node:_setCurSelPos( posIdx )
	if self._curSelectedPos ~= -1 then
		local oldSelPos = self:getCurSelectedPos()
		if posIdx == oldSelPos:getIdxInGroup() then
			return
		end
		--设置上次选中的按钮为: 未选中
		oldSelPos:setSelected(false)
	end
	--更新当前选中位置
	self._curSelectedPos = posIdx

	local curSelPos = self._controlerMap.poses[self._curSelectedPos]
	curSelPos:setSelected(true)
	self:_doEventCallBack(self, "curSelectedPosChange")
end

--转向玩家视角
function controler_formation_show_pos_group_node:_turnToPlayerDirect()
	self._controlerMap.poses[1]:setPosName("前排")
	self._controlerMap.poses[2]:setPosName("前排")
	self._controlerMap.poses[3]:setPosName("前排")
	self._controlerMap.poses[4]:setPosName("中排")
	self._controlerMap.poses[5]:setPosName("中排")
	self._controlerMap.poses[6]:setPosName("中排")
	self._controlerMap.poses[7]:setPosName("后排")
	self._controlerMap.poses[8]:setPosName("后排")
	self._controlerMap.poses[9]:setPosName("后排")

	local poses = self._controlerMap.poses
	local len = #poses
	local posV = nil

	for posIdx=1, len do
		posV = self._controlerMap.poses[posIdx]

		--设置不可站立的位置
		local hasStandPos = formationConfig_hasStandPos(self._formationID, posIdx)
		if hasStandPos then
			posV:setZhuLiIdx(formationConfig_getOpenposIdxWithStandPos(self._formationID, posIdx))
			posV:setEnable(true)
		else
			posV:setZhuLiIdx(-1)
			posV:setEnable(false)
		end

		--该view是否有对应的主力数据
		local hasData = false

		for _, zhuLiV in ipairs(self._zhuLiList) do
			--找到站立位置数据
			if posIdx == zhuLiV:getStandPosOnWar(self._formationID) then
				
				--更新视图
				posV:setBattlePos(zhuLiV)
				posV:setActorDirect(Data_Battle.CONST_CAMP_PLAYER)
				posV:updateAllView()
				hasData = true
				break
			end
		end

		--无对应的主力数据
		if not hasData then
			posV:setBattlePos(nil)
			posV:updateAllView()
		end
	end

end

--转向敌人视角
function controler_formation_show_pos_group_node:_turnToEnemyDirect()
	self._controlerMap.poses[1]:setPosName("后排")
	self._controlerMap.poses[2]:setPosName("后排")
	self._controlerMap.poses[3]:setPosName("后排")
	self._controlerMap.poses[4]:setPosName("中排")
	self._controlerMap.poses[5]:setPosName("中排")
	self._controlerMap.poses[6]:setPosName("中排")
	self._controlerMap.poses[7]:setPosName("前排")
	self._controlerMap.poses[8]:setPosName("前排")
	self._controlerMap.poses[9]:setPosName("前排")

	local poses = self._controlerMap.poses
	local len = #poses

	for i=len, 1, -1 do
		posV = self._controlerMap.poses[i]
		posIdx = 9 - i + 1

		--设置不可站立的位置
		local hasStandPos = formationConfig_hasStandPos(self._formationID, posIdx)
		if hasStandPos then
			posV:setZhuLiIdx(formationConfig_getOpenposIdxWithStandPos(self._formationID, posIdx))
			posV:setEnable(true)
		else
			posV:setZhuLiIdx(-1)
			posV:setEnable(false)
		end

		--该view是否有对应的主力数据
		local hasData = false

		for _, zhuLiV in ipairs(self._zhuLiList) do
			--找到站立位置数据
			if posIdx == zhuLiV:getStandPosOnWar(self._formationID) then
				--更新视图
				posV:setBattlePos(zhuLiV)
				posV:setActorDirect(Data_Battle.CONST_CAMP_ENEMY)
				posV:updateAllView()
				hasData = true
				break
			end
		end

		--无对应的主力数据
		if not hasData then
			--
			posV:setBattlePos(nil)
			posV:updateAllView()
		end
	end
end


return controler_formation_show_pos_group_node








