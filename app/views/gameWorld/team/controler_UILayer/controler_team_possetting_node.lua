--
-- Author: lipeng
-- Date: 2015-07-08 10:43:18
-- 控制器: 队伍位置设置

local class_controler_team_pos = import(".controler_team_pos")
local controler_team_possetting_node = class("controler_team_possetting_node")


function controler_team_possetting_node:ctor(team_possetting_node)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_possetting_node = team_possetting_node

    self._baseContainer = self._team_possetting_node:getChildByName("BaseContainer")

    self._posContainer = self._baseContainer:getChildByName("posContainer")

    self:_createControlerForUI()
    self:_registUIEvent()
end


function controler_team_possetting_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中位置
function controler_team_possetting_node:getCurSelectedPos()
	return self._controlerMap.poses[self._curSelectedPos]
end

--更新视图
function controler_team_possetting_node:setTeam(team)
	self._team = team
	self:_updateView()
end


function controler_team_possetting_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil

    self._team = nil
    self._curSelectedPos = 1
end


--创建控制器: UI
function controler_team_possetting_node:_createControlerForUI()
	local view_posContainer = self._posContainer

    --位置
    self._controlerMap.poses = {}
    for i=1, view_posContainer:getChildrenCount() do
	    self._controlerMap.poses[i] = class_controler_team_pos.new(
	    	view_posContainer:getChildByName("pos"..i), i
	    )
	    self._controlerMap.poses[i]:addEventListener(handler(self, self._posEventListener))
	end

	self:getCurSelectedPos():setSelected(true)
end


function controler_team_possetting_node:_registUIEvent()

end



function controler_team_possetting_node:_posEventListener( sender, eventName )
	if "posTouchEnded" == eventName then
		self:_onPosTouchEnded(sender)
	end
end


function controler_team_possetting_node:_onPosTouchEnded( sender )
	--如果位置已经被选中
	if sender:getSelected() then
		--进入选择武将界面
		dispatchGlobaleEvent("controler_team_possetting_node", "clickPos", {pos=sender:getIdx()})
	else
		self:_setCurSelectedPos(sender:getIdx())
	end
end

--设置当前选中位置
function controler_team_possetting_node:_setCurSelectedPos( posIdx )
	
	local battleHeroManager = self._team:getBattleHeroManager()
	--如果没有队长, 并且不是切换到队长位置
	if battleHeroManager:getLeaderPos():getHeroGUID() == NULL_GUID and 
		posIdx ~= 1  then
		--则不做任何处理
		UIManager:CreatePrompt_Operate( {
			mark = "controler_team_possetting_node",
	        title = "提示",
	        content = "请先选择队长",
		} )
		return
	end
	--设置上次选中的按钮为: 未选中
	self:getCurSelectedPos():setSelected(false)
	--更新当前选中位置
	self._curSelectedPos = posIdx
	self._controlerMap.poses[posIdx]:setSelected(true)
	self:_doEventCallBack(self, "curSelectedPosChange")
end


function controler_team_possetting_node:_doEventCallBack( sender, eventName )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName)
	end
end


function controler_team_possetting_node:_updateView()
	local battleHeroManager = self._team:getBattleHeroManager()
	local view_posContainer = self._posContainer
	local controlerPoses = self._controlerMap.poses
	local heroManager = MAIN_PLAYER:getHeroManager()

	for i=1, view_posContainer:getChildrenCount() do
		local battlePos = battleHeroManager:getPos(i)
		local heroGUID = battlePos:getHeroGUID()
		local hero = heroManager:getHero(heroGUID)
		controlerPoses[i]:updateIcon(hero)
	end

	if battleHeroManager:getLeaderPos():getHeroGUID() == NULL_GUID then
		self:_setCurSelectedPos(1)
	end
end


return controler_team_possetting_node








