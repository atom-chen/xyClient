--
-- Author: lipeng
-- Date: 2015-07-08 10:43:18
-- 控制器: 选择队伍

local controler_team_selected_team_node = class("controler_team_selected_team_node")


function controler_team_selected_team_node:ctor(team_selected_team_node)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._team_selected_team_node = team_selected_team_node
	self._curTeamBtn = self._team_selected_team_node:getChildByName("btn_curTeam")

	self:_registGlobalEventListeners()
    self:_registUIEvent()
end


function controler_team_selected_team_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

--获取当前选中位置
function controler_team_selected_team_node:getCurSelectedPos()
	return self._controlerMap.poses[self._curSelectedPos]
end

--更新视图
function controler_team_selected_team_node:setTeamManager(teamManager)
	self._teamManager = teamManager
	self:_updateView()
end


function controler_team_selected_team_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil

    self._teamManager = nil
    self._lastPlayAnimName = "animation_init"
end



function controler_team_selected_team_node:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "controler_team_ui_layer", eventName = "selectedTeamMaskTouch", callBack=handler(self, self._onSelectedTeamMaskTouch)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function controler_team_selected_team_node:_registUIEvent()
	local function curTeamBtnTouchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	if self._lastPlayAnimName == "animation_init" or
        		self._lastPlayAnimName == "animation_back" then

        		self:_setTeamButtonsVisible(true)
        		self:_runAction({nameID="animation_pop"})
        		self._lastPlayAnimName = "animation_pop"

        	elseif self._lastPlayAnimName == "animation_pop" then

        		self:_runAction({nameID="animation_back"})
        		self._lastPlayAnimName = "animation_back"
        	end
        end
    end

	self._curTeamBtn:addTouchEventListener(curTeamBtnTouchEvent)


	for i=1, MaxPlayerTeamNum do
		local btn_team = self._team_selected_team_node:getChildByName("btn_team"..i)
		btn_team:addTouchEventListener(function ( sender,eventType )
			if eventType == ccui.TouchEventType.ended then
				self._teamManager:setCurSelTeam(i)
				self:_setTeamButtonsVisible(false)
				self:_updateView()
				self._lastPlayAnimName = "animation_back"
	        end
		end
		)
	end
	
end


function controler_team_selected_team_node:_updateView()
	--更新当前选中按钮
	local curSelTeamIdx = self._teamManager:getCurSelTeamIdx()
	self._curTeamBtn:loadTextures(
		string.format("ui_image/team/widget/btn_team_selecte%d_n.png", curSelTeamIdx),
		string.format("ui_image/team/widget/btn_team_selecte%d_p.png", curSelTeamIdx),
		string.format("ui_image/team/widget/btn_team_selecte%d_n.png", curSelTeamIdx),
		ccui.TextureResType.plistType
	)
end

function controler_team_selected_team_node:_setTeamButtonsVisible( visible )
	local btn_team = nil
	for i=1, MaxPlayerTeamNum do
		btn_team = self._team_selected_team_node:getChildByName("btn_team"..i)
		btn_team:setVisible(visible)
	end
end


function controler_team_selected_team_node:_onSelectedTeamMaskTouch()
	if self._lastPlayAnimName == "animation_pop" then
		self:_setTeamButtonsVisible(false)
		self._lastPlayAnimName = "animation_back"
	end
end



--parmas.nameID
function controler_team_selected_team_node:_runAction(parmas)
	if parmas.nameID == "animation_back" then
		self:_runCCSAction_animation_back(parmas)

	elseif parmas.nameID == "animation_pop" then
		self:_runCCSAction_animation_pop(parmas)
	end
end


function controler_team_selected_team_node:_createTimeline()
	return cc.CSLoader:createTimeline("ui_instance/team/team_selected_team_node.csb")
end


function controler_team_selected_team_node:_runCCSAction_animation_back( parmas )
	self._team_selected_team_node:stopAllActions()

	local action = self:_createTimeline()
	self._team_selected_team_node:runAction(action)
    action:play("animation_back", false)
end


function controler_team_selected_team_node:_runCCSAction_animation_pop( parmas )
	self._team_selected_team_node:stopAllActions()

	local action = self:_createTimeline()
	self._team_selected_team_node:runAction(action)
    action:play("animation_pop", false)
end


return controler_team_selected_team_node








