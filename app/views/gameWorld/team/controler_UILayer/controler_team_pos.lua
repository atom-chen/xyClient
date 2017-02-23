--
-- Author: lipeng
-- Date: 2015-07-10 17:17:54
-- 控制器: 队伍单个位置

local controler_team_pos = class("controler_team_pos")


function controler_team_pos:ctor(posNode, posIdx)
	self:_initModels()

	self._posNode = posNode
	self._posIdx = posIdx

	self._checkBox = self._posNode:getChildByName("checkBox")
	self._img_pos_selected = self._posNode:getChildByName("img_pos_selected")

	self:_createControlerForUI()
	self:_registUIEvent()
end

function controler_team_pos:getView()
	return self._posNode
end

function controler_team_pos:setSelected(enabled)
	self._isSelected = enabled
	self._checkBox:setSelected(enabled)
	self._img_pos_selected:setVisible(enabled)
end

function controler_team_pos:getSelected()
	return self._isSelected
end

function controler_team_pos:getIdx()
	return self._posIdx
end


function controler_team_pos:updateIcon(hero)
	if hero ~= nil then
		self._controlerMap.heroIcon:setAvatarByHeroID(hero:getTempleateID())
		self._controlerMap.heroIcon:getRootNode():setVisible(true)
	else
		self._controlerMap.heroIcon:getRootNode():setVisible(false)
	end
	
end

function controler_team_pos:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team_pos:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._isSelected = false
end

function controler_team_pos:_createControlerForUI()
	self._controlerMap.heroIcon = UIManager:CreateAvatarPart(
		0, 
		{resourceNode = self._posNode:getChildByName("heroIcon")}
	)
end

function controler_team_pos:_registUIEvent()
	local posButton = self._posNode:getChildByName("btn")

	local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	if self._controlerEventCallBack ~= nil then
        		self._controlerEventCallBack(self, "posTouchEnded")
        	end
        end
    end

	posButton:addTouchEventListener(touchEvent)  
end



return controler_team_pos
