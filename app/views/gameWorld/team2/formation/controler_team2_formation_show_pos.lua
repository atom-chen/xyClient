--
-- Author: lipeng
-- Date: 2015-08-30 11:21:38
-- 控制器: 展示位(队伍主力)


local controler_team2_formation_show_pos_node = class("controler_team2_formation_show_pos_node")

--[[----------------------
公有成员函数
-------------------------]]

--在组中的位置
function controler_team2_formation_show_pos_node:ctor(formation_show_pos_node, posIdxInGroup)
	self:_initModels()

	self._formation_show_pos_node = formation_show_pos_node
	self._posIdxInGroup = posIdxInGroup

	self._img_bottom = self._formation_show_pos_node:getChildByName("img_bottom")
	self._text_name = self._formation_show_pos_node:getChildByName("text_name")

	self:_registUIEvent()
end

--更新所有视图
function controler_team2_formation_show_pos_node:updateAllView()
	if self._hero ~= nil and self._hero:isValidTempleateID() then
		HERO_ICON_HELPER:updateIcon(
			{
				bgImg = self._formation_show_pos_node:getChildByName("bg"),
				iconImg = self._formation_show_pos_node:getChildByName("icon"),
				heroTempleateID = self._hero:getTempleateID(),
				guideImg = self._formation_show_pos_node:getChildByName("guide")
			}
		)

		self:showHeroIcon()
		self:setPosName(self._hero:getName())
	else
		self:hideHeroIcon()
		if self:isEnable() then
			self:setPosName("可放置")
		else
			self:setPosName("不可放置")
		end
	end
end

--设置所关联的主力索引
function controler_team2_formation_show_pos_node:setZhuLiIdx( zhuLiIdx )
	self._zhuLiIdx = zhuLiIdx
end

--获取所关联的主力索引
function controler_team2_formation_show_pos_node:getZhuLiIdX()
	return self._zhuLiIdx
end

function controler_team2_formation_show_pos_node:setEnable( isEnable )
	 self._isEnable = isEnable
end

function controler_team2_formation_show_pos_node:isEnable()
	return self._isEnable
end

function controler_team2_formation_show_pos_node:getView()
	return self._formation_show_pos_node
end

--显示武将Icon
function controler_team2_formation_show_pos_node:showHeroIcon()
	self._formation_show_pos_node:getChildByName("bg"):setVisible(true)
	self._formation_show_pos_node:getChildByName("icon"):setVisible(true)
	self._formation_show_pos_node:getChildByName("guide"):setVisible(true)
end

--隐藏武将Icon
function controler_team2_formation_show_pos_node:hideHeroIcon()
	self._formation_show_pos_node:getChildByName("bg"):setVisible(false)
	self._formation_show_pos_node:getChildByName("icon"):setVisible(false)
	self._formation_show_pos_node:getChildByName("guide"):setVisible(false)
end

--目标位置是否在节点范围内
function controler_team2_formation_show_pos_node:containsPoint(pos)
	local posView_localCoording = self._formation_show_pos_node:convertToNodeSpace(pos)
	local img_bottomBox = self._img_bottom:getBoundingBox()
	return cc.rectContainsPoint(img_bottomBox, posView_localCoording)
end

function controler_team2_formation_show_pos_node:getTouchBeginPos()
	return self._img_bottom:getTouchBeganPosition()
end

function controler_team2_formation_show_pos_node:getTouchMovePos()
	return self._img_bottom:getTouchMovePosition()
end

function controler_team2_formation_show_pos_node:getTouchEndPos()
	return self._img_bottom:getTouchEndPosition()
end

function controler_team2_formation_show_pos_node:setSelected(enabled)
	self._isSelected = enabled
end

function controler_team2_formation_show_pos_node:getSelected()
	return self._isSelected
end

function controler_team2_formation_show_pos_node:getIdxInGroup()
	return self._posIdxInGroup
end

--设置关联的上阵位置
function controler_team2_formation_show_pos_node:setBattlePos(battlePos)
	self._battlePos = battlePos
	if self._battlePos ~= nil  then
		self._hero = MAIN_PLAYER:getHeroManager():getHero(self._battlePos:getHeroGUID())
	else
		self._hero = nil
	end
end

function controler_team2_formation_show_pos_node:getBattlePos()
	return self._battlePos
end

--设置位置名
function controler_team2_formation_show_pos_node:setPosName(name)
	self._text_name:setString(name)
end


function controler_team2_formation_show_pos_node:getHero()
	return self._hero
end

function controler_team2_formation_show_pos_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end


--[[----------------------
私有成员函数
-------------------------]]

function controler_team2_formation_show_pos_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._isSelected = false
    self._hero = nil
    self._battlePos = nil
    self._isEnable = true
    --关联的主力索引
    self._zhuLiIdx = -1
end


function controler_team2_formation_show_pos_node:_registUIEvent()

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

	self._img_bottom:addTouchEventListener(touchEvent)  
end


return controler_team2_formation_show_pos_node

