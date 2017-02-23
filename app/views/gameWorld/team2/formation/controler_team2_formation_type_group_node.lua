--
-- Author: lipeng
-- Date: 2015-08-30 10:36:10
-- 控制器: 阵型选择单选按钮组


local class_controler_team2_formation_type_node = import(".controler_team2_formation_type_node")
local controler_team2_formation_type_group_node = class("controler_team2_formation_type_group_node")


function controler_team2_formation_type_group_node:ctor(formation_type_group_node)
	self:_initModels()

	--根层
	self._formation_type_group_node = formation_type_group_node
	self._scrollView = self._formation_type_group_node:getChildByName("scrollView") 

    self:_createControlerForUI()
    self:_registUIEvent()
end


function controler_team2_formation_type_group_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中位置
function controler_team2_formation_type_group_node:getCurSelectedPos()
	return self._controlerMap.poses[self._curSelectedPos]
end

--设置当前选中阵型ID
function controler_team2_formation_type_group_node:setCurSelectedFormationID(formationID)
	local pos = self:formationIDToPosIdx(formationID)
	self:setCurSelPos(pos)
	
	self:_updateView()
end


--阵型ID转换为按钮索引
function controler_team2_formation_type_group_node:formationIDToPosIdx(id)
	local view_posContainer = self._scrollView

	for i,v in ipairs(self._controlerMap.poses) do
		if v:getFormationID() == id then
			return v:getIdx()
		end
	end
end


--按钮索引转换为阵型ID
function controler_team2_formation_type_group_node:posIdxToformationID(posIdx)
	local view_posContainer = self._scrollView

	for i,v in ipairs(self._controlerMap.poses) do
		if v:getIdx() == i then
			return v:getFormationID()
		end
	end
end


--设置当前选中位置
function controler_team2_formation_type_group_node:setCurSelPos( posIdx )
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


function controler_team2_formation_type_group_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil

    self._formationIdList = formationConfig_getPlayerFormationIDList()

    self._curSelectedPos = -1
end


--创建控制器: UI
function controler_team2_formation_type_group_node:_createControlerForUI()
	local view_posContainer = self._scrollView

    --位置
    self._controlerMap.poses = {}
    for i=1, view_posContainer:getChildrenCount() do
	    self._controlerMap.poses[i] = class_controler_team2_formation_type_node.new(
	    	view_posContainer:getChildByName("zhenxing"..i), i
	    )
	    self._controlerMap.poses[i]:setFormationID(i)
	    self._controlerMap.poses[i]:addEventListener(handler(self, self._posEventListener))
	end

	self:setCurSelPos(1)
end


function controler_team2_formation_type_group_node:_registUIEvent()

end



function controler_team2_formation_type_group_node:_posEventListener( sender, eventName )
	if "posTouchEnded" == eventName then
		self:_doEventCallBack(sender, "posTouchEnded")
	end
end


function controler_team2_formation_type_group_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


function controler_team2_formation_type_group_node:_updateView()
	local controlerPoses = self._controlerMap.poses
	for i,v in ipairs(self._formationIdList) do
		controlerPoses[i]:setFormationID(v)
	end
end




return controler_team2_formation_type_group_node




