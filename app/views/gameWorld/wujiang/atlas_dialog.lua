--
-- Author: Wu Hengmin
-- Date: 2015-08-26 15:00:05
--


local atlas_dialog = class("atlas_dialog", cc.load("mvc").ViewBase)
local class_skill_item = import(".atlas_dialog_item")

atlas_dialog.RESOURCE_FILENAME = "ui_instance/wujiang/atlas_dialog.csb"

function atlas_dialog:onCreate()
	-- body

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})

	-- 退出按钮
	local exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_2")
	local function exitClicked(sender)
		self:close()
	end
	exit:addClickEventListener(exitClicked)


	-- 详细属性按钮
	local button_attr = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_0"):getChildByName("Button_1")
	local function button_attrClicked(sender)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_0"):setVisible(false)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_1"):setVisible(true)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5"):setVisible(false)
	end
	button_attr:addClickEventListener(button_attrClicked)

	-- 技能按钮
	local button_skill = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_0"):getChildByName("Button_1_0")
	local function button_skillClicked(sender)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_0"):setVisible(false)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_1"):setVisible(false)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5"):setVisible(true)
	end
	button_skill:addClickEventListener(button_skillClicked)

	-- 返回按钮
	local button_back1 = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5"):getChildByName("Button_8")
	local button_back2 = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_1"):getChildByName("Button_1_0")
	local function backClicked(sender)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_0"):setVisible(true)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_1"):setVisible(false)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5"):setVisible(false)
	end
	button_back1:addClickEventListener(backClicked)
	button_back2:addClickEventListener(backClicked)

	self.skillitemModel = cc.CSLoader:createNode("ui_instance/wujiang/atlas_dialog_item.csb")
    self.skillitemModel:retain()
end


function atlas_dialog:update(data)
	-- body

	local hero = MAIN_PLAYER.heroManager:CreateHero(data)
	local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_1")
	name:setString(heroConfig[data.id].name)

	local zhanli = self.resourceNode_:getChildByName("main_layout"):getChildByName("Text_1_0")
	zhanli:setString(hero:getPower(MAIN_PLAYER:getBaseAttr():getLv()))

	local iconNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_4")
	iconNode:removeAllChildren()
	iconNode:setCascadeOpacityEnabled(true)

	local icon = UIManager:CreateDropOutFrame(
		"大卡片",
		data.id
	):getResourceNode()
	icon:setSwallowTouches(false)
	icon:setCascadeOpacityEnabled(true)
	icon:setPosition(74, 115)
	iconNode:addChild(icon)


	-- 基本属性面板
	local baseNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_0")
	baseNode:getChildByName("Text_1_0_3"):setString(hero:getAttackTotal())
	baseNode:getChildByName("Text_1_0_3_1"):setString(hero:getHPTotal())
	baseNode:getChildByName("Text_1_0_3_1_0"):setString(hero:getWuFangTotal())
	baseNode:getChildByName("Text_1_0_3_1_0_0"):setString(hero:getMoFangTotal())

	-- 技能图标
	local info_icon_1 = baseNode:getChildByName("Image_1")
	if heroConfig[data.id].skill_set.order[1] then
		info_icon_1:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[data.id].skill_set.active[heroConfig[data.id].skill_set.order[1]]].icon).icon, ccui.TextureResType.plistType)
		info_icon_1:setVisible(true)
	else
		info_icon_1:setVisible(false)
	end

	local info_icon_2 = baseNode:getChildByName("Image_1_0")
	if heroConfig[data.id].skill_set.active[2] then
		info_icon_2:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[data.id].skill_set.active[heroConfig[data.id].skill_set.order[2]]].icon).icon, ccui.TextureResType.plistType)
		info_icon_2:setVisible(true)
	else
		info_icon_2:setVisible(false)
	end

	local info_icon_3 = baseNode:getChildByName("Image_1_1")
	if heroConfig[data.id].skill_set.active[3] then
		info_icon_3:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[data.id].skill_set.active[heroConfig[data.id].skill_set.order[3]]].icon).icon, ccui.TextureResType.plistType)
		info_icon_3:setVisible(true)
	else
		info_icon_3:setVisible(false)
	end


	-- 详细属性面板
	local attrNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5_1")
	attrNode:setVisible(false)

	-- 主物攻
	local details_phatk_mian = attrNode:getChildByName("Text_1_0_3")
	details_phatk_mian:setString(hero:getAttackTotal())

	-- 主法攻
	local details_matk_mian = attrNode:getChildByName("Text_1_0_3_1")
	-- details_matk_mian:setString(hero:getHPTotal())

	-- 主生命
	local details_hp_mian = attrNode:getChildByName("Text_1_0_3_1_0")
	details_hp_mian:setString(hero:getHPTotal())

	-- 主物防
	local details_wf_mian = attrNode:getChildByName("Text_1_0_3_1_0_0")
	details_wf_mian:setString(hero:getWuFangTotal())

	-- 主法防
	local details_ff_mian = attrNode:getChildByName("Text_1_0_3_2")
	details_ff_mian:setString(hero:getMoFangTotal())

	-- 主命中
	local details_hit_mian = attrNode:getChildByName("Text_1_0_3_1_1")
	details_hit_mian:setString(hero:getMingZhong().."%")

	-- 主闪避
	local details_shanbi_mian = attrNode:getChildByName("Text_1_0_3_1_0_1")
	details_shanbi_mian:setString(hero:getShanBi().."%")

	-- 主暴击
	local details_crit_mian = attrNode:getChildByName("Text_1_0_3_1_0_0_0")
	details_crit_mian:setString(hero:getBaoJi().."%")

	-- 主暴伤
	local details_critdm_mian = attrNode:getChildByName("Text_1_0_3_1_0_0_0_0")
	details_critdm_mian:setString(hero:getBaoShang().."%")







	-- 技能面板
	local skillNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5")
	skillNode:setVisible(false)

	-- 技能顺序
	local skillicon1 = skillNode:getChildByName("Panel_5"):getChildByName("Image_1")
	if heroConfig[data.id].skill_set.active[1] then
		skillicon1:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[data.id].skill_set.active[1]].icon).icon, ccui.TextureResType.plistType)
		skillicon1:setVisible(true)
	else
		skillicon1:setVisible(false)
	end

	local skillicon2 = skillNode:getChildByName("Panel_5_0"):getChildByName("Image_2")
	if heroConfig[data.id].skill_set.active[2] then
		skillicon2:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[data.id].skill_set.active[2]].icon).icon, ccui.TextureResType.plistType)
		skillicon2:setVisible(true)
	else
		skillicon2:setVisible(false)
	end

	local skillicon3 = skillNode:getChildByName("Panel_5_1"):getChildByName("Image_4")
	if heroConfig[data.id].skill_set.active[3] then
		skillicon3:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[data.id].skill_set.active[3]].icon).icon, ccui.TextureResType.plistType)
		skillicon3:setVisible(true)
	else
		skillicon3:setVisible(false)
	end

	-- 技能信息
	local skillinfo_list = skillNode:getChildByName("ListView_1")
	local skills = {}
	for i=1,#heroConfig[data.id].skill_set.active do
		print("技能"..i)
		local item = class_skill_item.new(
				self.skillitemModel:getChildByName("Panel_1"):clone()
			)
		item:update(heroConfig[data.id].skill_set.active[i])
		skillinfo_list:pushBackCustomItem(item:getResourceNode())
	end
	skillinfo_list:refreshView()

end

function atlas_dialog:close()
	-- body
    GLOBAL_COMMON_ACTION:popupBack({
            node = self.resourceNode_:getChildByName("main_layout"),
            shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
            callback = function ()
                -- body
                self:removeFromParent(true)
            end
        })
end

return atlas_dialog
