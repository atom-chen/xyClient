--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 道具界面

local UI_Wujiangup = class("UI_Wujiangup", cc.load("mvc").ViewBase)

local class_wujiangup_listview = import("app.views.gameWorld.wujiangup.wujiangup_listview.lua")
local class_wujiang_panel = import("app.views.gameWorld.wujiangup.wujiang_panel.lua")
local class_skill_item = import("app.views.gameWorld.wujiangup.skill_item.lua")

UI_Wujiangup.RESOURCE_FILENAME = "ui_instance/wujiangup/wujiangup_layer.csb"

UI_Wujiangup.list = {
	{
		name = "武将",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "觉醒",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "强化",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "技能",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Wujiangup:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()


	self:_createControlerForUI()
	self:_initDynamicResConfig()

	self:_registButtonEvent()

	local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode()
    rootNode:setContentSize(size)
    ccui.Helper:doLayout(rootNode)
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360))

    local shadow_layout = rootNode:getChildByName("shadow_layout")
    shadow_layout:setContentSize(size)
    ccui.Helper:doLayout(shadow_layout)

    self.skillitemModel = cc.CSLoader:createNode("ui_instance/wujiangup/skill_view_item.csb")
    self.skillitemModel:retain()


	self:updateDisplay(1)
    
end

--注册节点事件
function UI_Wujiangup:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function UI_Wujiangup:updateTo(hero)
	-- body
	local data = {}
	data._usedata = {}
	data._usedata.data = hero
	self._controlerMap.wujiangpanel:update(data)
	self:updateInfo(data)

	self._controlerMap.listview:updateChoose(hero.guid)
end

function UI_Wujiangup:_createControlerForUI()
	self._controlerMap = {}

	self._controlerMap.listview = class_wujiangup_listview.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_45"):getChildByName("ProjectNode_1")
		)
	self._controlerMap.listview:update(true)

	self._controlerMap.wujiangpanel = class_wujiang_panel.new(
			self.resourceNode_:getChildByName("main_layout"):getChildByName("main_layout_0")
		)
	-- 信息面板更新为第一个武将
	-- self._controlerMap.wujiangpanel:update(self._controlerMap.listview:getFirst())

	
	-- ******************** 一般信息面板 ********************
	self._controlerMap.info = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_45"):getChildByName("Panel_52"):getChildByName("ProjectNode_5")
	-- 详细属性按钮
	local button_attr = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Button_1")
	local function button_attrClicked(sender)
		self._controlerMap.info:setVisible(false)
		self._controlerMap.skillupgrade:setVisible(false)
		self._controlerMap.juexing:setVisible(false)
		self._controlerMap.upgrade:setVisible(false)
		self._controlerMap.details:setVisible(true)
		self._controlerMap.skillinfo:setVisible(false)
	end
	button_attr:addClickEventListener(button_attrClicked)
	-- 详细技能按钮
	local button_skill = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Button_1_0")
	local function button_skillClicked(sender)
		self._controlerMap.info:setVisible(false)
		self._controlerMap.skillupgrade:setVisible(false)
		self._controlerMap.juexing:setVisible(false)
		self._controlerMap.upgrade:setVisible(false)
		self._controlerMap.details:setVisible(false)
		self._controlerMap.skillinfo:setVisible(true)
	end
	button_skill:addClickEventListener(button_skillClicked)




	-- ******************** 技能升级面板 ********************
	self._controlerMap.skillupgrade = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_45"):getChildByName("Panel_52"):getChildByName("ProjectNode_2")
	-- 技能升级按钮
	local button_skill_upgrade = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Button_3")
	local function button_skill_upgradeClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_HERO_UPGRADE_SKILL, {self.data.guid})
	end
	button_skill_upgrade:addClickEventListener(button_skill_upgradeClicked)



	-- ******************** 觉醒面板 ********************
	self._controlerMap.juexing = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_45"):getChildByName("Panel_52"):getChildByName("ProjectNode_3")
	-- 觉醒按钮
	local button_skill_juexing = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Button_3")
	local function button_skill_juexingClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_SEND_HERO_EVOLUTION, {self.data.guid})
	end
	button_skill_juexing:addClickEventListener(button_skill_juexingClicked)



	-- ******************** 强化面板 ********************
	self._controlerMap.upgrade = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_45"):getChildByName("Panel_52"):getChildByName("ProjectNode_4")
	-- 强化按钮
	local button_skill_juexing = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Button_3")
	local function button_skill_juexingClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_HERO_OCCU_UPGRADE, {self.data.guid})
	end
	button_skill_juexing:addClickEventListener(button_skill_juexingClicked)



	-- ******************** 详细属性面板 ********************
	self._controlerMap.details = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_45"):getChildByName("Panel_52"):getChildByName("ProjectNode_6")
	-- 返回按钮
	local button_fanhui_1 = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Button_1_0")
	local function button_fanhui_1Clicked(sender)
		self._controlerMap.info:setVisible(true)
		self._controlerMap.skillupgrade:setVisible(false)
		self._controlerMap.juexing:setVisible(false)
		self._controlerMap.upgrade:setVisible(false)
		self._controlerMap.details:setVisible(false)
		self._controlerMap.skillinfo:setVisible(false)
	end
	button_fanhui_1:addClickEventListener(button_fanhui_1Clicked)


	-- ******************** 详细技能面板 ********************
	self._controlerMap.skillinfo = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_45"):getChildByName("Panel_52"):getChildByName("ProjectNode_7")
	-- 返回按钮
	local button_fanhui_2 = self._controlerMap.skillinfo:getChildByName("Panel_1"):getChildByName("Button_1")
	local function button_fanhui_2Clicked(sender)
		self._controlerMap.info:setVisible(true)
		self._controlerMap.skillupgrade:setVisible(false)
		self._controlerMap.juexing:setVisible(false)
		self._controlerMap.upgrade:setVisible(false)
		self._controlerMap.details:setVisible(false)
		self._controlerMap.skillinfo:setVisible(false)
	end
	button_fanhui_2:addClickEventListener(button_fanhui_2Clicked)


	self._controlerMap.info:setVisible(true)
	self._controlerMap.skillupgrade:setVisible(false)
	self._controlerMap.juexing:setVisible(false)
	self._controlerMap.upgrade:setVisible(false)
	self._controlerMap.details:setVisible(false)
	self._controlerMap.skillinfo:setVisible(false)

end


function UI_Wujiangup:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	-- 跳到招募
	local zhaomu = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_17_0")
	local function zhaomuClicked(sender)
		self:close(self._dynamicResConfigIDs)
		-- 打开招募
		dispatchGlobaleEvent("mainpage_popup_buttons2", "shangcheng_touched")
	end
	zhaomu:addClickEventListener(zhaomuClicked)

	-- 筛选
    local screen = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_17")
    local function screenClicked(sender)
		print("筛选")
		UIManager:createWujiangScreenDialog()
	end
	screen:addClickEventListener(screenClicked)


	local function onClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 改变按钮状态
	            self:updateButton(sender.index)
	            self:updateDisplay(sender.index)
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end

	self.tabs = {}
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_wujiang")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_juexing")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)
	
	self.tabs[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_qianghua")
	self.tabs[3].index = 3
	self.tabs[3]:addTouchEventListener(onClicked)
	
	self.tabs[4] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_jineng")
	self.tabs[4].index = 4
	self.tabs[4]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Wujiangup:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "wujiang_ctrl", eventName = "updatePanel", callBack=handler(self, self.updateInfo)},
		{modelName = "model_heroManager", eventName = "skill", callBack=handler(self, self.updateskill)},
		{modelName = "model_heroManager", eventName = "zhiye", callBack=handler(self, self.updatezhiye)},
		{modelName = "model_heroManager", eventName = "juexing", callBack=handler(self, self.updatejuexing)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Wujiangup:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
	print("释放武将强化面板广播监听")
end


function UI_Wujiangup:close(res)
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				self:removeFromParent(true)
				release_res(res)
			end
		})
end


function UI_Wujiangup:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Wujiangup:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Wujiangup:updateData()
	-- body
	self.heroData = {}
	local tmp = 1
	for k,v in pairs(MAIN_PLAYER.heroManager.heros) do
		self.heroData[tmp] = v
		tmp = tmp + 1
	end


	self.atlasData = {}
	for i=1,4 do
		for j=1,#MAIN_PLAYER.heroManager.country[i] do
			table.insert(self.atlasData, MAIN_PLAYER.heroManager.country[i][j])
		end
	end
end

function UI_Wujiangup:updateDisplay(index)
	-- body
	self.displayMode = index
	if index == 1 then
		self._controlerMap.info:setVisible(true)
		self._controlerMap.skillupgrade:setVisible(false)
		self._controlerMap.juexing:setVisible(false)
		self._controlerMap.upgrade:setVisible(false)
		self._controlerMap.details:setVisible(false)
		self._controlerMap.skillinfo:setVisible(false)
	elseif index == 2 then
		self._controlerMap.info:setVisible(false)
		self._controlerMap.skillupgrade:setVisible(false)
		self._controlerMap.juexing:setVisible(true)
		self._controlerMap.upgrade:setVisible(false)
		self._controlerMap.details:setVisible(false)
		self._controlerMap.skillinfo:setVisible(false)
	elseif index == 3 then
		self._controlerMap.info:setVisible(false)
		self._controlerMap.skillupgrade:setVisible(false)
		self._controlerMap.juexing:setVisible(false)
		self._controlerMap.upgrade:setVisible(true)
		self._controlerMap.details:setVisible(false)
		self._controlerMap.skillinfo:setVisible(false)
	elseif index == 4 then
		self._controlerMap.info:setVisible(false)
		self._controlerMap.skillupgrade:setVisible(true)
		self._controlerMap.juexing:setVisible(false)
		self._controlerMap.upgrade:setVisible(false)
		self._controlerMap.details:setVisible(false)
		self._controlerMap.skillinfo:setVisible(false)
	end

end

-- 更新属性面板
function UI_Wujiangup:updateInfo(params)
	-- body
	print("****更新属性面板")
	if params._usedata.data then
		self.data = params._usedata.data
	end
	-- ******************** 一般信息面板 ********************
	-- 主攻击
	local info_atk_mian = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Text_1_0_3")
	info_atk_mian:setString(self.data:getAttackTotal())

	-- 主生命
	local info_hp_mian = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1")
	info_hp_mian:setString(self.data:getHPTotal())

	-- 主物防
	local info_wf_mian = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_0")
	info_wf_mian:setString(self.data:getWuFangTotal())

	-- 主法防
	local info_ff_mian = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_0_0")
	info_ff_mian:setString(self.data:getMoFangTotal())


	-- 技能图标

	local info_icon_1 = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Image_1")
	if heroConfig[self.data.id].skill_set.order[1] then
		info_icon_1:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[heroConfig[self.data.id].skill_set.order[1]]].icon).icon, ccui.TextureResType.plistType)
		info_icon_1:setVisible(true)
	else
		info_icon_1:setVisible(false)
	end

	local info_icon_2 = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Image_1_0")
	if heroConfig[self.data.id].skill_set.active[2] then
		info_icon_2:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[heroConfig[self.data.id].skill_set.order[2]]].icon).icon, ccui.TextureResType.plistType)
		info_icon_2:setVisible(true)
	else
		info_icon_2:setVisible(false)
	end

	local info_icon_3 = self._controlerMap.info:getChildByName("Panel_1"):getChildByName("Image_1_1")
	if heroConfig[self.data.id].skill_set.active[3] then
		info_icon_3:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[heroConfig[self.data.id].skill_set.order[3]]].icon).icon, ccui.TextureResType.plistType)
		info_icon_3:setVisible(true)
	else
		info_icon_3:setVisible(false)
	end
	



	self:updateskill()

	self:updatejuexing()

	self:updatezhiye()



	

	-- ******************** 详细属性面板 ********************
	-- self._controlerMap.details

	-- 主物攻
	local details_phatk_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3")
	details_phatk_mian:setString(self.data:getAttackTotal())

	-- 主法攻
	local details_matk_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1")
	-- details_matk_mian:setString(self.data:getHPTotal())

	-- 主生命
	local details_hp_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_0")
	details_hp_mian:setString(self.data:getHPTotal())

	-- 主物防
	local details_wf_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_0_0")
	details_wf_mian:setString(self.data:getWuFangTotal())

	-- 主法防
	local details_ff_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_2")
	details_ff_mian:setString(self.data:getMoFangTotal())

	-- 主命中
	local details_hit_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_1")
	details_hit_mian:setString(self.data:getMingZhong().."%")

	-- 主闪避
	local details_shanbi_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_0_1")
	details_shanbi_mian:setString(self.data:getShanBi().."%")

	-- 主暴击
	local details_crit_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_0_0_0")
	details_crit_mian:setString(self.data:getBaoJi().."%")

	-- 主暴伤
	local details_critdm_mian = self._controlerMap.details:getChildByName("Panel_1"):getChildByName("Text_1_0_3_1_0_0_0_0")
	details_critdm_mian:setString(self.data:getBaoShang().."%")


	-- ******************** 详细技能面板 ********************
	-- 技能图标
	print("详细技能面板")
	local skillinfo_icon_1 = self._controlerMap.skillinfo:getChildByName("Panel_1"):getChildByName("Image_4")
	if heroConfig[self.data.id].skill_set.order[1] then
		skillinfo_icon_1:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[heroConfig[self.data.id].skill_set.order[1]]].icon).icon, ccui.TextureResType.plistType)
		skillinfo_icon_1:setVisible(true)
	else
		skillinfo_icon_1:setVisible(false)
	end
	local skillinfo_icon_2 = self._controlerMap.skillinfo:getChildByName("Panel_1"):getChildByName("Image_4_0")
	if heroConfig[self.data.id].skill_set.active[2] then
		skillinfo_icon_2:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[heroConfig[self.data.id].skill_set.order[2]]].icon).icon, ccui.TextureResType.plistType)
		skillinfo_icon_2:setVisible(true)
	else
		skillinfo_icon_2:setVisible(false)
	end
	local skillinfo_icon_3 = self._controlerMap.skillinfo:getChildByName("Panel_1"):getChildByName("Image_4_1")
	if heroConfig[self.data.id].skill_set.active[3] then
		skillinfo_icon_3:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[heroConfig[self.data.id].skill_set.order[3]]].icon).icon, ccui.TextureResType.plistType)
		skillinfo_icon_3:setVisible(true)
	else
		skillinfo_icon_3:setVisible(false)
	end

	-- 技能信息列表
	local skillinfo_list = self._controlerMap.skillinfo:getChildByName("Panel_1"):getChildByName("ListView_1")
	skillinfo_list:removeAllItems()
	for i=1,#heroConfig[self.data.id].skill_set.active do
		local item = class_skill_item.new(
				self.skillitemModel:getChildByName("Panel_1"):clone()
			)
		item:update(heroConfig[self.data.id].skill_set.active[i])
		skillinfo_list:pushBackCustomItem(item:getResourceNode())

	end
	if #heroConfig[self.data.id].skill_set.passive > 0 then
		local item = class_skill_item.new(
				self.skillitemModel:getChildByName("Panel_1"):clone()
			)
		item:update(heroConfig[self.data.id].skill_set.passive[1])
		skillinfo_list:pushBackCustomItem(item:getResourceNode())

	end
	skillinfo_list:refreshView()


end


function UI_Wujiangup:updateskill()
	-- body
	-- ******************** 技能升级面板 ********************
	print("updateskill")
	-- 升级材料icon
	local skillupgrade_icon_1 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Panel_5")
	skillupgrade_icon_1:removeAllChildren()
	skillupgrade_icon_1:setCascadeOpacityEnabled(true)
	local skillupgrade_icon_1_id = nil
	if self.data:getSkillLv() < 3 then
		skillupgrade_icon_1_id = eSTID_SkillBook1
	elseif self.data:getSkillLv() < 6 then
		skillupgrade_icon_1_id = eSTID_SkillBook2
	else
		skillupgrade_icon_1_id = eSTID_SkillBook3
	end
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			skillupgrade_icon_1_id
		):getResourceNode()

	icon:setCascadeOpacityEnabled(true)
	icon:setPosition(50, 50)
	skillupgrade_icon_1:addChild(icon)

	-- 升级需要银两
	local skillupgrade_price_1 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Text_34")
	if self.data:getSkillLv() < self.data:getMaxSkillLv() then
		skillupgrade_price_1:setString(skillLvUpConfig[self.data:getSkillLv()+1].UseGold)
	else
		skillupgrade_price_1:setString(0)
	end

	-- 当前技能
	local skillcount = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Text_34_0")
	skillcount:setString(self.data:getSkillLv().."/"..self.data:getMaxSkillLv())

	-- 技能图标
	local skillupgrade_icon_1 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Image_5")
	if heroConfig[self.data.id].skill_set.active[1] then
		skillupgrade_icon_1:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[1]].icon).icon, ccui.TextureResType.plistType)
		skillupgrade_icon_1:setVisible(true)
	else
		skillupgrade_icon_1:setVisible(false)
	end

	local skillupgrade_icon_2 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Image_5_0")
	if heroConfig[self.data.id].skill_set.active[2] then
		skillupgrade_icon_2:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[2]].icon).icon, ccui.TextureResType.plistType)
		skillupgrade_icon_2:setVisible(true)
	else
		skillupgrade_icon_2:setVisible(false)
	end
	
	local skillupgrade_icon_3 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Image_5_1")
	if heroConfig[self.data.id].skill_set.active[3] then
		skillupgrade_icon_3:loadTexture(ResIDConfig:getConfig_bufframe(SkillConfig[heroConfig[self.data.id].skill_set.active[3]].icon).icon, ccui.TextureResType.plistType)
		skillupgrade_icon_3:setVisible(true)
	else
		skillupgrade_icon_3:setVisible(false)
	end

	-- 技能名
	local name1 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Text_20")
	if heroConfig[self.data.id].skill_set.active[1] then
		name1:setString(SkillConfig[heroConfig[self.data.id].skill_set.active[1]].name)
		name1:setVisible(true)
	else
		name1:setVisible(false)
	end

	local name2 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Text_20_0")
	if heroConfig[self.data.id].skill_set.active[2] then
		name2:setString(SkillConfig[heroConfig[self.data.id].skill_set.active[2]].name)
		name2:setVisible(true)
	else
		name2:setVisible(false)
	end

	local name3 = self._controlerMap.skillupgrade:getChildByName("Panel_1"):getChildByName("Text_20_0_0")
	if heroConfig[self.data.id].skill_set.active[3] then
		name3:setString(SkillConfig[heroConfig[self.data.id].skill_set.active[3]].name)
		name3:setVisible(true)
	else
		name3:setVisible(false)
	end

end

function UI_Wujiangup:updatejuexing()
	-- body
	-- ******************** 列表显示 ********************


	-- ******************** 觉醒面板 ********************
	-- 觉醒材料icon1 武将碎片
	local juexing_icon_1 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Panel_5")
	juexing_icon_1:removeAllChildren()
	juexing_icon_1:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"碎片",
			self.data.id
		):getResourceNode()

	icon:setCascadeOpacityEnabled(true)
	icon:setPosition(50, 50)
	juexing_icon_1:addChild(icon)

	-- 觉醒材料icon2 觉醒材料
	local juexing_icon_2 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Panel_5_0")
	juexing_icon_2:removeAllChildren()
	juexing_icon_2:setCascadeOpacityEnabled(true)
	local icon = UIManager:CreateDropOutFrame(
			"道具",
			90001
		):getResourceNode()

	icon:setCascadeOpacityEnabled(true)
	icon:setPosition(50, 50)
	juexing_icon_2:addChild(icon)

	-- 武将名1
	local juexing_name_1 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15")
	juexing_name_1:setString(heroConfig[self.data.id].name)
	-- 武将名2
	local juexing_name_2 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_1")
	if heroConfig[heroConfig[self.data.id].wake_des_id] then
		juexing_name_2:setString(heroConfig[heroConfig[self.data.id].wake_des_id].name)
	else
		juexing_name_2:setString("")
	end
	-- 攻击1
	local juexing_atk_1 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_3")
	juexing_atk_1:setString(self.data:getAttackTotal())
	-- 攻击2
	local juexing_atk_2 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_3_0")
	if heroConfig[heroConfig[self.data.id].wake_des_id] then
		juexing_atk_2:setString(self.data:getEvoFinshAttackTotal())
	else
		juexing_atk_2:setString("")
	end
	-- 生命1
	local juexing_hp_1 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_0_0")
	juexing_hp_1:setString(self.data:getHPTotal())
	-- 生命2
	local juexing_hp_2 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_0_0_0")
	if heroConfig[heroConfig[self.data.id].wake_des_id] then
		juexing_hp_2:setString(self.data:getEvoFinshHPTotal())
	else
		juexing_hp_2:setString("")
	end
	-- 物防1
	local juexing_wf_1 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_1_0")
	juexing_wf_1:setString(self.data:getWuFangTotal())
	-- 物防2
	local juexing_wf_2 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_1_0_0")
	if heroConfig[heroConfig[self.data.id].wake_des_id] then
		juexing_wf_2:setString(self.data:getEvoFinshWuFangTotal())
	else
		juexing_wf_2:setString("")
	end
	-- 法防1
	local juexing_ff_1 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_2_0")
	juexing_ff_1:setString(self.data:getMoFangTotal())
	-- 法防2
	local juexing_ff_2 = self._controlerMap.juexing:getChildByName("Panel_1"):getChildByName("Text_15_0_2_0_0")
	if heroConfig[heroConfig[self.data.id].wake_des_id] then
		juexing_ff_2:setString(self.data:getEvoFinshMoFangTotal())
	else
		juexing_ff_2:setString("")
	end

end

function UI_Wujiangup:updatezhiye()
	-- body
	-- ******************** 职业强化面板 ********************
	-- 强化材料icon1
	-- 得到需要的材料

	local upgrade_icon_1 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Panel_5")
	upgrade_icon_1:removeAllChildren()
	upgrade_icon_1:setCascadeOpacityEnabled(true)
	if self.data.occupatpower < #OccuCfg[heroConfig[self.data.id].profession].upgrade then
		local icon = UIManager:CreateDropOutFrame(
				"道具",
				OccuCfg[heroConfig[self.data.id].profession].upgrade[self.data.occupatpower+1].item_id
			):getResourceNode()
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(50, 50)
		upgrade_icon_1:addChild(icon)
	end

	-- 升级需要银两
	local upgrade_price_1 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_34")
	
	upgrade_price_1:setString(OccuCfg[heroConfig[self.data.id].profession].upgrade[self.data.occupatpower+1].gold)

	-- 武将名1
	local upgrade_name_1 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15")
	upgrade_name_1:setString(heroConfig[self.data.id].name)
	-- 攻击1
	local upgrade_atk_1 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_3")
	upgrade_atk_1:setString(self.data:getAttackTotal())
	-- 攻击2
	local upgrade_atk_2 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_3_0")
	upgrade_atk_2:setString(self.data:getAttackTotalWithNextOccupatpower())
	-- 生命1
	local upgrade_hp_1 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_0_0")
	upgrade_hp_1:setString(self.data:getHPTotal())
	-- 生命2
	local upgrade_hp_2 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_0_0_0")
	upgrade_hp_2:setString(self.data:getHPTotalWithNextOccupatpower())
	-- 物防1
	local upgrade_wf_1 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_1_0")
	upgrade_wf_1:setString(self.data:getWuFangTotal())
	-- 物防2
	local upgrade_wf_2 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_1_0_0")
	upgrade_wf_2:setString(self.data:getWuFangTotalWithNextOccupatpower())
	-- 法防1
	local upgrade_ff_1 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_2_0")
	upgrade_ff_1:setString(self.data:getMoFangTotal())
	-- 法防2
	local upgrade_ff_2 = self._controlerMap.upgrade:getChildByName("Panel_1"):getChildByName("Text_15_0_2_0_0")
	upgrade_ff_2:setString(self.data:getMoFangTotalWithNextOccupatpower())
end


return UI_Wujiangup
