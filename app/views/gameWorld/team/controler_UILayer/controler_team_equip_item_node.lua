--
-- Author: lipeng
-- Date: 2015-07-13 14:24:41
-- 控制器: 单个装备node


local controler_team_equip_item_node = class("controler_team_equip_item_node")


function controler_team_equip_item_node:ctor(equipItemNode, idx)
	self:_initModels()

	self._equipItemNode = equipItemNode
	self._idx = idx

	self._checkBox = self._equipItemNode:getChildByName("checkBox")
	self._img_pos_selected = self._equipItemNode:getChildByName("img_pos_selected")

	self:_createControlerForUI()
	self:_registUIEvent()
end

function controler_team_equip_item_node:getIdx()
	return self._idx
end

function controler_team_equip_item_node:getEquipType()
	return self._idx - 1
end

function controler_team_equip_item_node:setEquip(equip)
	self._equip = equip
	self:_updateView()
end

function controler_team_equip_item_node:getEquip()
	return self._equip
end

function controler_team_equip_item_node:setSelected(enabled)
	self._isSelected = enabled
	self._checkBox:setSelected(enabled)
	self._img_pos_selected:setVisible(enabled)
end

function controler_team_equip_item_node:getSelected()
	return self._isSelected
end

function controler_team_equip_item_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_team_equip_item_node:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._equip = nil
    self._isSelected = false
end

function controler_team_equip_item_node:_createControlerForUI()
	self._controlerMap.equipIcon = UIManager:CreateEquipAvatarPart(
			0, 
			{resourceNode = self._equipItemNode:getChildByName("icon")}
		)
end

function controler_team_equip_item_node:_registUIEvent()
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


function controler_team_equip_item_node:_updateView()
	if self._equip ~= nil then
		self._equipItemNode:getChildByName("text_name"):setString(self._equip:getName())

		-- 更新属性
		local equipManager = MAIN_PLAYER.equipManager
		local equipTeampleateID = self._equip:getTeampleateID()
		local equipGUID = self._equip:getGUID()

		local node_zhu_attr = self._equipItemNode:getChildByName("node_zhu_attr")
		node_zhu_attr:getChildByName("text"):setString(equipManager:getMainType(equipTeampleateID)..":")
		node_zhu_attr:getChildByName("baseValue"):setString(equipManager:getMainAttr(equipGUID))
		
		local node_fu_attr = self._equipItemNode:getChildByName("node_fu_attr")
		node_fu_attr:getChildByName("text"):setString(equipManager:getOffType(equipTeampleateID)..":")
		node_fu_attr:getChildByName("baseValue"):setString(equipManager:getOffAttr(equipGUID))


		self._controlerMap.equipIcon:setAvatarByID(equipTeampleateID)
		self._controlerMap.equipIcon:getRootNode():setVisible(true)
	else
		self._equipItemNode:getChildByName("text_name"):setString("装备名")

		-- 更新属性
		local node_zhu_attr = self._equipItemNode:getChildByName("node_zhu_attr")
		node_zhu_attr:getChildByName("text"):setString("主属性:")
		node_zhu_attr:getChildByName("baseValue"):setString(0)
		
		local node_fu_attr = self._equipItemNode:getChildByName("node_fu_attr")
		node_fu_attr:getChildByName("text"):setString("副属性:")
		node_fu_attr:getChildByName("baseValue"):setString(0)

		self._controlerMap.equipIcon:getRootNode():setVisible(false)
	end
	
end


return controler_team_equip_item_node
