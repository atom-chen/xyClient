--
-- Author: lipeng
-- Date: 2015-08-30 15:02:09
-- 控制器: 替补序号(队伍替补)


local controler_team2_formation_order_node = class("controler_team2_formation_order_node")


function controler_team2_formation_order_node:ctor(formation_order_node, posIdx)
	self:_initModels()

	self._formation_order_node = formation_order_node
	self._posIdx = posIdx

	self._btn = self._formation_order_node:getChildByName("btn")
	self._checkBox = self._formation_order_node:getChildByName("checkBox")
	self._img_pos_selected = self._formation_order_node:getChildByName("img_pos_selected")

	self:_createControlerForUI()
	self:_registUIEvent()
end

function controler_team2_formation_order_node:getView()
	return self._formation_order_node
end

--获取英雄icon视图
function controler_team2_formation_order_node:getHeroIconView()
	return self._controlerMap.heroIcon:getResourceNode()
end

function controler_team2_formation_order_node:setEnable( isEnable )
	 self._isEnable = isEnable
end

function controler_team2_formation_order_node:isEnable()
	return self._isEnable
end

--目标位置是否在节点范围内
function controler_team2_formation_order_node:containsPoint(pos)
	local posView_localCoording = self._formation_order_node:convertToNodeSpace(pos)
	local btnBox = self._btn:getBoundingBox()
	return cc.rectContainsPoint(btnBox, posView_localCoording)
end

function controler_team2_formation_order_node:getTouchBeginPos()
	return self._btn:getTouchBeganPosition()
end

function controler_team2_formation_order_node:getTouchMovePos()
	return self._btn:getTouchMovePosition()
end

function controler_team2_formation_order_node:getTouchEndPos()
	return self._btn:getTouchEndPosition()
end

function controler_team2_formation_order_node:setSelected(enabled)
	self._isSelected = enabled
	self._checkBox:setSelected(enabled)
	--self._img_pos_selected:setVisible(enabled)
end

function controler_team2_formation_order_node:getSelected()
	return self._isSelected
end

function controler_team2_formation_order_node:getIdx()
	return self._posIdx
end

--设置关联的上阵位置
function controler_team2_formation_order_node:setBattlePos(battlePos)
	self._battlePos = battlePos

	if self._battlePos ~= nil  then
		self._hero = MAIN_PLAYER:getHeroManager():getHero(self._battlePos:getHeroGUID())
	else
		self._hero = nil
	end
	
	self:_updateView()
end

--获取关联上阵位置
function controler_team2_formation_order_node:getBattlePos()
	return self._battlePos
end


function controler_team2_formation_order_node:getHero()
	return self._hero
end

function controler_team2_formation_order_node:getPosOnWar()
	--关联的战斗位置, 因为posIdx起始索引为1
	return TIBU_START_IDX + self._posIdx - 1
end


function controler_team2_formation_order_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_formation_order_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._isSelected = false
    self._hero = nil
    self._battlePos = nil
    self._isEnable = true
end

function controler_team2_formation_order_node:_createControlerForUI()
	self._controlerMap.heroIcon = UIManager:CreateAvatarPart(
		0, 
		{resourceNode = self._formation_order_node:getChildByName("heroIcon")}
	)
end

function controler_team2_formation_order_node:_registUIEvent()

	local function touchEvent(sender,eventType)
		--如果位置不可用, 则不传递事件
		if not self._isEnable then
			return
		end
		local eventName = ""

		if eventType == ccui.TouchEventType.began then
			eventName = "posTouchBegan"

		elseif eventType == ccui.TouchEventType.moved then
			eventName = "posTouchMoved"

		elseif eventType == ccui.TouchEventType.ended then
			eventName = "posTouchEnded"

		elseif eventType == ccui.TouchEventType.canceled then
			eventName = "posTouchCanceled"
		end
		if self._controlerEventCallBack ~= nil then
    		self._controlerEventCallBack(self, eventName)
    	end
    end

	self._btn:addTouchEventListener(touchEvent)  
end


function controler_team2_formation_order_node:_updateView()
	if self._hero ~= nil and 
		self._hero:isValidTempleateID() and 
		self:isEnable() then
		
		self._controlerMap.heroIcon:getResourceNode():setVisible(true)
		self._controlerMap.heroIcon:setAvatarByHeroID(self._hero.id)
	else
		self._controlerMap.heroIcon:getResourceNode():setVisible(false)
	end

	if self:isEnable() then
		self._formation_order_node:getChildByName("name"):
			setString("顺序"..self:getIdx())

		self._formation_order_node:getChildByName("img_lock"):
			setVisible(false)
	else
		self._formation_order_node:getChildByName("name"):
			setString("未开放")

		self._formation_order_node:getChildByName("img_lock"):
			setVisible(true)
	end
end



return controler_team2_formation_order_node

