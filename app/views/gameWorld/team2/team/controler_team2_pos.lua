--
-- Author: lipeng
-- Date: 2015-08-27 10:58:34
-- 控制器: 队伍单个位置


local controler_team2_pos = class("controler_team2_pos")


function controler_team2_pos:ctor(posNode, posIdx)
	self:_initModels()

	self._posNode = posNode
	self._posIdx = posIdx

	self._checkBox = self._posNode:getChildByName("checkBox")
	self._img_pos_selected = self._posNode:getChildByName("img_pos_selected")
	self._lock = self._posNode:getChildByName("img_lock")

	self:_createControlerForUI()
	self:_registUIEvent()
end

function controler_team2_pos:getView()
	return self._posNode
end

function controler_team2_pos:setEnabled(enabled)
	self._enable = enabled
	if self._enable then
		self._lock:setVisible(false)
	else
		self._lock:setVisible(true)
	end
end

function controler_team2_pos:isEnable()
	return self._enable
end

function controler_team2_pos:setSelected(enabled)
	self._isSelected = enabled
	self._checkBox:setSelected(enabled)
	self._img_pos_selected:setVisible(enabled)
end

function controler_team2_pos:getSelected()
	return self._isSelected
end

function controler_team2_pos:getIdx()
	return self._posIdx
end


function controler_team2_pos:updateIcon(hero)
	if hero ~= nil then
		self._controlerMap.heroIcon:setAvatarByHeroID(hero:getTempleateID())
		self._controlerMap.heroIcon:getRootNode():setVisible(true)
	else
		self._controlerMap.heroIcon:getRootNode():setVisible(false)
	end
	
end

function controler_team2_pos:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_pos:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._isSelected = false
    self._enable = true
end

function controler_team2_pos:_createControlerForUI()
	self._controlerMap.heroIcon = UIManager:CreateAvatarPart(
		0, 
		{resourceNode = self._posNode:getChildByName("heroIcon")}
	)
	--self._controlerMap.heroIcon:getRootNode():setScale(0.75)
end

function controler_team2_pos:_registUIEvent()
	local posButton = self._posNode:getChildByName("btn")

	local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	if not self:isEnable() then
        		return
        	end
        	if self._controlerEventCallBack ~= nil then
        		self._controlerEventCallBack(self, "posTouchEnded")
        	end
        end
    end

	posButton:addTouchEventListener(touchEvent)  
end



return controler_team2_pos
