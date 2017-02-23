--
-- Author: Wu Hengmin
-- Date: 2015-07-09 16:36:52
--

local equip_info_view = class("equip_info_view", cc.load("mvc").ViewBase)

equip_info_view.RESOURCE_FILENAME = "ui_instance/equip/equip_info/equip_info_view.csb"

function equip_info_view:onCreate()
	-- body
end

function equip_info_view:update(guid)
	-- body
	print("更新infoview")
	if guid then
		local equip = MAIN_PLAYER.equipManager:getEquipByGuid(guid)
		----------------- 更新武将名描述 -----------------
		local name = self.resourceNode_:getChildByName("main_node"):getChildByName("name")
		name:setString(EquipConfig[MAIN_PLAYER.equipManager:getEquipByGuid(guid).id].name)
		local descrip = self.resourceNode_:getChildByName("main_node"):getChildByName("descrip")
		descrip:setString(EquipConfig[MAIN_PLAYER.equipManager:getEquipByGuid(guid).id].explain)

		----------------- 更新属性 -----------------
		local attr = self.resourceNode_:getChildByName("main_node"):getChildByName("attr_node")
		attr:getChildByName("main_attr"):setString(MAIN_PLAYER.equipManager:getMainTypeByGuid(guid)..":")
		attr:getChildByName("off_attr"):setString(MAIN_PLAYER.equipManager:getOffTypeByGuid(guid)..":")
		attr:getChildByName("main_attr"):getChildByName("count"):setString(MAIN_PLAYER.equipManager:getMainAttr(guid))
		attr:getChildByName("off_attr"):getChildByName("count"):setString(MAIN_PLAYER.equipManager:getOffAttr(guid))
		-- attr:getChildByName("off_attr"):getChildByName("max"):setString("/"..MAIN_PLAYER.equipManager:getMaxOffAttr(MAIN_PLAYER.equipManager:getEquipByGuid(guid).id))
		attr:getChildByName("lv"):getChildByName("count"):setString(MAIN_PLAYER.equipManager:getEquipByGuid(guid).mainlevel)

		---------------- icon --------------------
		local iconbg = self.resourceNode_:getChildByName("main_node"):getChildByName("icon_node"):getChildByName("bg")
		iconbg:removeAllChildren()
		local icon = UIManager:CreateDropOutFrame("装备", MAIN_PLAYER.equipManager:getEquipByGuid(guid).id):getResourceNode()
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(112, 111)
		iconbg:addChild(icon)

	else

	end
end

return equip_info_view