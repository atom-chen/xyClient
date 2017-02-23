--
-- Author: lipeng
-- Date: 2015-08-27 14:24:59
-- 控制器: 单个装备node

local controler_team2_equip_item_node = class("controler_team2_equip_item_node")


function controler_team2_equip_item_node:ctor(equipItemNode, idx)
	self:_initModels()
	self._equipItemNode = equipItemNode
	self._idx = idx

	self._checkBox = self._equipItemNode:getChildByName("checkBox")
	self._img_pos_selected = self._equipItemNode:getChildByName("img_pos_selected")

	self:_createControlerForUI()
	self:_registUIEvent()
end

function controler_team2_equip_item_node:getIdx()
	return self._idx
end

function controler_team2_equip_item_node:getEquipType()
	return self._idx - 1
end

function controler_team2_equip_item_node:setEquip(equip)
	self._equip = equip
	self:_updateView()
end

function controler_team2_equip_item_node:getEquip()
	return self._equip
end

function controler_team2_equip_item_node:setSelected(enabled)
	self._isSelected = enabled
	self._checkBox:setSelected(enabled)
	self._img_pos_selected:setVisible(enabled)
end

function controler_team2_equip_item_node:getSelected()
	return self._isSelected
end

function controler_team2_equip_item_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team2_equip_item_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._equip = nil
    self._isSelected = false
end

function controler_team2_equip_item_node:_createControlerForUI()
	self._controlerMap.equipIcon = UIManager:CreateEquipAvatarPart(
			0, 
			{resourceNode = self._equipItemNode:getChildByName("icon")}
		)
	self._controlerMap.equipIcon:getRootNode():setScale(0.75)
end

function controler_team2_equip_item_node:_registUIEvent()
	local btn_equip = self._equipItemNode:getChildByName("btn_equip")

	local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
        	if self._controlerEventCallBack ~= nil then
        		self._controlerEventCallBack(self, "equipBtnTouchEnded")
        	end
        end
    end

	btn_equip:addTouchEventListener(touchEvent)  
end


function controler_team2_equip_item_node:_updateView()
	if self._equip ~= nil then
		self._equipItemNode:getChildByName("als_lvValue"):setString(self._equip:getLv())
		
		local equipTeampleateID = self._equip:getTeampleateID()

		self._controlerMap.equipIcon:setAvatarByID(equipTeampleateID)
		self._controlerMap.equipIcon:getRootNode():setVisible(true)
	else
		self._equipItemNode:getChildByName("als_lvValue"):setString("0")

		self._controlerMap.equipIcon:getRootNode():setVisible(false)
	end
	
end


return controler_team2_equip_item_node
