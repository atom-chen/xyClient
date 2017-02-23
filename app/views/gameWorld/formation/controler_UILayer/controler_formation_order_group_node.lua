--
-- Author: lipeng
-- Date: 2015-07-22 19:58:26
-- 控制器: 替补序列(队伍所有替补)


local class_controler_formation_order_node = import(".controler_formation_order_node")
local controler_formation_order_group_node = class("controler_formation_order_group_node")


function controler_formation_order_group_node:ctor(formation_type_group_node)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._formation_type_group_node = formation_type_group_node
	self._baseContainer = self._formation_type_group_node:getChildByName("BaseContainer") 

    self:_createControlerForUI()
    self:_registUIEvent()
end


function controler_formation_order_group_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中位置
function controler_formation_order_group_node:getCurSelectedPos()
	return self._controlerMap.poses[self._curSelectedPos]
end

--设置替补列表
function controler_formation_order_group_node:setTiBuOnBattlePosIdxList(list)
	self._tiBuOnBattlePosIdxList = list
	self:_updateView()
end

--通过touch位置获取替补位置
function controler_formation_order_group_node:getPosWithTouchPos( touchPos )
	local poses = self._controlerMap.poses

	for i, v in ipairs(poses) do
		if v:containsPoint(touchPos) then
			return v
		end
	end
end


function controler_formation_order_group_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil

    self._tiBuOnBattlePosIdxList = nil

    self._curSelectedPos = -1
end


--创建控制器: UI
function controler_formation_order_group_node:_createControlerForUI()
	local view_posContainer = self._baseContainer

    --位置
    self._controlerMap.poses = {}
    for i=1, view_posContainer:getChildrenCount() do
	    self._controlerMap.poses[i] = class_controler_formation_order_node.new(
	    	view_posContainer:getChildByName("order"..i), i
	    )
	    self._controlerMap.poses[i]:addEventListener(handler(self, self._posEventListener))
	end

	self:setCurSelPos(1)
end


function controler_formation_order_group_node:_registUIEvent()

end



function controler_formation_order_group_node:_posEventListener( sender, eventName )
	if "posTouchBegan" == eventName then
		self:_onPosTouchBegan(sender)
		self:_doEventCallBack(self, "posTouchBegan")

	elseif "posTouchMoved" == eventName then
		self:_doEventCallBack(self, "posTouchMoved")

	elseif "posTouchEnded" == eventName then
		self:_doEventCallBack(self, "posTouchEnded")

	elseif "posTouchCanceled" == eventName then
		local curSelPos = self:getCurSelectedPos()
		local touchCanceledOfOrderPos = nil
		--如果touchBegan所选中的位置有关联武将
		if curSelPos:getBattlePos():getHeroGUID() ~= NULL_GUID then
			touchCanceledOfOrderPos = self:getPosWithTouchPos(curSelPos:getTouchEndPos())
			if touchCanceledOfOrderPos ~= nil then
				FormationSystemInstance:sendNetMsg_swapWarPos(
						curSelPos:getPosOnWar(),
						touchCanceledOfOrderPos:getPosOnWar()
					)
			end
		end

		self:_doEventCallBack(self, "posTouchCanceled", {touchCanceledOfOrderPos=touchCanceledOfOrderPos})
	end
end


function controler_formation_order_group_node:_onPosTouchBegan( sender )
	self:setCurSelPos(sender:getIdx())
end


function controler_formation_order_group_node:_doEventCallBack( sender, eventName, eventData )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, eventData)
	end
end


function controler_formation_order_group_node:_updateView()
	local poses = self._controlerMap.poses
	for posIdx, posV in ipairs(poses) do
		--该view是否有对应的替补数据
		local hasData = false

		for _, tiBuV in ipairs(self._tiBuOnBattlePosIdxList) do
			--找到替补数据

			if posIdx == tiBuV:getTiBuPos() then
				--更新视图
				posV:setBattlePos(tiBuV)
				hasData = true
				break
			end
		end

		--无对应的替补数据
		if not hasData then
			--print(posIdx)
			--
			posV:setBattlePos(nil)
		end
	end
end


--设置当前选中位置
function controler_formation_order_group_node:setCurSelPos( posIdx )
	if self._curSelectedPos ~= -1 then
		local oldSelPos = self:getCurSelectedPos()
		if posIdx == oldSelPos:getIdx() then
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

return controler_formation_order_group_node








