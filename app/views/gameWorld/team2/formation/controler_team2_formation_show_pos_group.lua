--
-- Author: lipeng
-- Date: 2015-08-30 11:21:21
-- 控制器: 展示位组(队伍所有主力)


local class_controler_team2_formation_show_pos = import(".controler_team2_formation_show_pos")
local controler_team2_formation_show_pos_group = class("controler_team2_formation_show_pos_group")


function controler_team2_formation_show_pos_group:ctor(formation_show_pos_group_node, formationID)
	self:_initModels(formationID)

	--根层
	self._formation_show_pos_group_node = formation_show_pos_group_node

    self:_createControlerForUI()
end


function controler_team2_formation_show_pos_group:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中位置
function controler_team2_formation_show_pos_group:getCurSelectedPos()
	return self._controlerMap.poses[self._curSelectedPos]
end

--通过touch位置获取展示位置
function controler_team2_formation_show_pos_group:getPosWithTouchPos( touchPos )
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


--设置主力列表
function controler_team2_formation_show_pos_group:setZhuLiList(zhuLiList)
	self._zhuLiList = zhuLiList
end

--设置阵型
function controler_team2_formation_show_pos_group:setFormationID(formationID)
	self._formationID = formationID
end


--设置位置是否可用
function controler_team2_formation_show_pos_group:setPosEnable( posIdx, isEnable )
	self._controlerMap.poses[posIdx]:setEnable(isEnable)
end


--更新所有视图
function controler_team2_formation_show_pos_group:updateAllView()
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


function controler_team2_formation_show_pos_group:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil

    self._zhuLiList = nil

    self._curSelectedPos = -1
    self._formationID = 1
end


--创建控制器: UI
function controler_team2_formation_show_pos_group:_createControlerForUI()
	local view_posContainer = self._formation_show_pos_group_node

    --位置
    self._controlerMap.poses = {}
    for i=1, view_posContainer:getChildrenCount() do
	    self._controlerMap.poses[i] = class_controler_team2_formation_show_pos.new(
	    	view_posContainer:getChildByName("pos"..i), i
	    )
	    self._controlerMap.poses[i]:addEventListener(handler(self, self._posEventListener))
	end

	self:_setCurSelPos(1)
end



function controler_team2_formation_show_pos_group:_posEventListener( sender, eventName )
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
					teamSystem2Instance:sendNetMsg_swapWarPos(
						curSelPos:getZhuLiIdX(),
						touchCanceledOfShowPos:getZhuLiIdX()
					)
				end
			end
		end

		self:_doEventCallBack(self, "posTouchCanceled", {touchCanceledOfShowPos=touchCanceledOfShowPos})
	end
end


function controler_team2_formation_show_pos_group:_onPosTouchBegan( sender )
	self:_setCurSelPos(sender:getIdxInGroup())
end


function controler_team2_formation_show_pos_group:_doEventCallBack( sender, eventName, eventData )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, eventData)
	end
end


--设置当前选中位置
function controler_team2_formation_show_pos_group:_setCurSelPos( posIdx )
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


return controler_team2_formation_show_pos_group


