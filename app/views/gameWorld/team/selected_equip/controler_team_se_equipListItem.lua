--
-- Author: lipeng
-- Date: 2015-07-17 10:23:32
-- 选择装备列表item

local controler_team_se_equipListItem = class("controler_team_se_equipListItem")

local RESOURCE_FILENAME = "ui_instance/team/selected_equip/team_se_equipListItem.csb"

function controler_team_se_equipListItem:ctor()
	-- body
	self._itemView = createListViewItemWithNodeCSB(RESOURCE_FILENAME, "main_layout")
	self._icon = UIManager:CreateEquipAvatarPart(
			0,
			{resourceNode=self._itemView:getChildByName("icon_node")}
		)

	self:_registUIEvent()
end

function controler_team_se_equipListItem:getEquip()
	return self._equip
end


function controler_team_se_equipListItem:getView()
	return self._itemView
end


function controler_team_se_equipListItem:update(equip)
	self._equip = equip
	self._itemView:getChildByName("name"):setString(self._equip:getName())
	self._itemView:getChildByName("lv"):setString(self._equip:getMainLevel())

	-- 更新属性
	local equipManager = MAIN_PLAYER.equipManager
	local equipTeampleateID = self._equip:getTeampleateID()
	local equipGUID = self._equip:getGUID()

	local attr = self._itemView:getChildByName("attr_layout")
	attr:getChildByName("main_attr"):setString(equipManager:getMainType(equipTeampleateID)..":")
	attr:getChildByName("main_attr_count"):setString(equipManager:getMainAttr(equipGUID))

	attr:getChildByName("off_attr"):setString(equipManager:getOffType(equipTeampleateID)..":")
	attr:getChildByName("off_attr_count"):setString(equipManager:getOffAttr(equipGUID))

	-- 更新装备icon
	self._icon:setAvatarByID(equipTeampleateID)

end


function controler_team_se_equipListItem:_registUIEvent()
	--穿戴
	local function btn_chuandaiCallback( sender, eventType )
		if eventType == ccui.TouchEventType.ended then
			TeamSystemInstance:sendNetMsg_curSelMemberTakeEquip(self._equip:getGUID())
		end
	end
	local btn_chuandai = self._itemView:getChildByName("btn_chuandai")
    btn_chuandai:addTouchEventListener(btn_chuandaiCallback)
end


return controler_team_se_equipListItem
