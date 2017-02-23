--
-- Author: lipeng
-- Date: 2015-08-30 10:35:56
-- 控制器: 阵型类型单选按钮


local controler_team2_formation_type_node = class("controler_team2_formation_type_node")


function controler_team2_formation_type_node:ctor(formation_type_node, posIdx)
	self:_initModels()

	self._formation_type_node = formation_type_node
	self._posIdx = posIdx

	self._checkBox = self._formation_type_node:getChildByName("checkBox")
	self._img_pos_selected = self._formation_type_node:getChildByName("img_pos_selected")

	self:_createControlerForUI()
	self:_registUIEvent()
end

function controler_team2_formation_type_node:getView()
	return self._formation_type_node
end

function controler_team2_formation_type_node:setSelected(enabled)
	self._isSelected = enabled
	self._checkBox:setSelected(enabled)
	self._img_pos_selected:setVisible(enabled)
end

function controler_team2_formation_type_node:getSelected()
	return self._isSelected
end

function controler_team2_formation_type_node:getIdx()
	return self._posIdx
end


function controler_team2_formation_type_node:setFormationID(formationID)
	self._formationID = formationID
	self:_updateView()
end

function controler_team2_formation_type_node:getFormationID()
	return self._formationID
end

function controler_team2_formation_type_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_formation_type_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._isSelected = false
    self._formationID = 1
end

function controler_team2_formation_type_node:_createControlerForUI()
	self._controlerMap.icon = UIManager:createFormationIconControler()
	self._controlerMap.icon:setView(self._formation_type_node:getChildByName("icon"))
end

function controler_team2_formation_type_node:_registUIEvent()
	local posButton = self._formation_type_node:getChildByName("btn")

	local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	local formationID = self:getFormationID()
			teamSystem2Instance:sendNetMsg_changeFormation(formationID)
			
        	if self._controlerEventCallBack ~= nil then
        		self._controlerEventCallBack(self, "posTouchEnded")
        	end
        end
    end

	posButton:addTouchEventListener(touchEvent)  
end


function controler_team2_formation_type_node:_updateView()
	self._controlerMap.icon:setFormationID(self._formationID)
	local text_name = self._formation_type_node:getChildByName("name")
	text_name:setString(formationConfig_getFormationName(self._formationID))
end



return controler_team2_formation_type_node

