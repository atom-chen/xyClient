--
-- Author: Wu Hengmin
-- Date: 2015-08-11 15:40:39
--


local backpack_equip_dialog = class("backpack_equip_dialog", cc.load("mvc").ViewBase)

backpack_equip_dialog.RESOURCE_FILENAME = "ui_instance/backpack/backpack_equip_dialog.csb"

function backpack_equip_dialog:onCreate()
	-- body

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})

	-- 退出按钮
	local exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_5")
	local function exitClicked(sender)
		self:close()
	end
	exit:addClickEventListener(exitClicked)

	-- 返回按钮
	local back = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_5_0")


	-- 主名字面板
	self.main_name_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_3_0")

	-- 洗炼名字面板
	self.xilian_name_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_3_0_0")
	self.xilian_name_node:setVisible(false)

	-- 主属性面板
	self.attr_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_5")
	self.attr_node:setVisible(true)

	-- 洗炼属性面板
	self.attr_xilian_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_5_0")
	self.attr_xilian_node:setVisible(false)

	-- 主操作面板
	self.ctrl_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_8")
	self.ctrl_node:setVisible(true)

	-- 强化操作面板
	self.ctrl_qianghua_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_8_0")
	self.ctrl_qianghua_node:setVisible(false)
	-- 强化面板强化石
	local qianghua_store = self.ctrl_qianghua_node:getChildByName("Panel_10")
	local icon = UIManager:CreateDropOutFrame(
		"道具",
		eSTID_Euip_SS
	):getResourceNode()
	icon:setSwallowTouches(false)
	icon:setCascadeOpacityEnabled(true)
	icon:setPosition(50, 50)
	qianghua_store:addChild(icon)

	-- 洗炼操作面板
	self.ctrl_xilian_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_8_1")
	self.ctrl_xilian_node:setVisible(false)

	-- 升阶操作面板
	self.ctrl_shengjie_node = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_8_0_0")
	self.ctrl_shengjie_node:setVisible(false)
	-- 强化面板强化石
	local shengjie_store = self.ctrl_shengjie_node:getChildByName("Panel_10")
	local icon2 = UIManager:CreateDropOutFrame(
		"道具",
		eSTID_Euip_US
	):getResourceNode()
	icon2:setSwallowTouches(false)
	icon2:setCascadeOpacityEnabled(true)
	icon2:setPosition(50, 50)
	shengjie_store:addChild(icon2)


	-- 主控制面板洗练按钮
	local button_xilian = self.ctrl_node:getChildByName("Button_1")
	local function xilianClicked(sender)
		self.attr_node:setVisible(false)
		self.attr_xilian_node:setVisible(true)

		self.ctrl_node:setVisible(false)
		self.ctrl_qianghua_node:setVisible(false)
		self.ctrl_xilian_node:setVisible(true)
		self.ctrl_shengjie_node:setVisible(false)

		self.main_name_node:setVisible(false)
		self.xilian_name_node:setVisible(true)

		back:setVisible(true)
	end
	button_xilian:addClickEventListener(xilianClicked)

	-- 主控制面板强化按钮
	local button_qianghua = self.ctrl_node:getChildByName("Button_1_1")
	local function qianghuaClicked(sender)
		self.attr_node:setVisible(true)
		self.attr_xilian_node:setVisible(false)

		self.ctrl_node:setVisible(false)
		self.ctrl_qianghua_node:setVisible(true)
		self.ctrl_xilian_node:setVisible(false)
		self.ctrl_shengjie_node:setVisible(false)

		self.main_name_node:setVisible(true)
		self.xilian_name_node:setVisible(false)

		back:setVisible(true)
	end
	button_qianghua:addClickEventListener(qianghuaClicked)

	-- 主控制面板升阶按钮
	local button_shengjie = self.ctrl_node:getChildByName("Button_1_0")
	local function shengjieClicked(sender)
		self.attr_node:setVisible(true)
		self.attr_xilian_node:setVisible(false)

		self.ctrl_node:setVisible(false)
		self.ctrl_qianghua_node:setVisible(false)
		self.ctrl_xilian_node:setVisible(false)
		self.ctrl_shengjie_node:setVisible(true)

		self.main_name_node:setVisible(true)
		self.xilian_name_node:setVisible(false)

		back:setVisible(true)
	end
	button_shengjie:addClickEventListener(shengjieClicked)

	-- 主控制面板更换按钮
	local button_genghuan = self.ctrl_node:getChildByName("Button_1_2")
	local function genghuanClicked(sender)
		self:_doEventCallBack(self, "button_genghuanClicked")
	end
	button_genghuan:addClickEventListener(genghuanClicked)


	local function backClicked(sender)
		self.attr_node:setVisible(true)
		self.attr_xilian_node:setVisible(false)

		self.ctrl_node:setVisible(true)
		self.ctrl_qianghua_node:setVisible(false)
		self.ctrl_xilian_node:setVisible(false)
		self.ctrl_shengjie_node:setVisible(false)

		self.main_name_node:setVisible(true)
		self.xilian_name_node:setVisible(false)

		back:setVisible(false)
	end
	back:addClickEventListener(backClicked)
	back:setVisible(false)


	-- 物法互换按钮
	local pmc = self.xilian_name_node:getChildByName("Button_4")
	local function pmcClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_EQUIPS_SWAP, {self.data.guid})
	end
	pmc:addClickEventListener(pmcClicked)

	-- 强化按钮
	local ctr_button_qianghua = self.ctrl_qianghua_node:getChildByName("Button_10")
	local function qianghuaClicked(sender)
		if self.data.mainlevel < #EquipStrengthenCfg then
			gameTcp:SendMessage(MSG_C2MS_EQUIPS_STRENGTHEN, {self.data.guid})
		else
			UIManager:CreatePrompt_Bar({content = "已达到最高强化等级"})
		end
	end
	ctr_button_qianghua:addClickEventListener(qianghuaClicked)

--[[ 装备洗炼
*	string 装备GUID
*	int 0=使用道具 1=使用元宝
*	int 锁定属性条数
*	{
*		锁定属性序号
*	}
]]
	-- 洗炼按钮
	local ctr_button_xilian = self.ctrl_xilian_node:getChildByName("Button_15")
	local function xilianClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_EQUIPS_WASH, self:getLocks(0))
	end
	ctr_button_xilian:addClickEventListener(xilianClicked)


	-- 高级洗炼按钮
	local ctr_button_xilian_pro = self.ctrl_xilian_node:getChildByName("Button_15_0")
	local function xilianproClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_EQUIPS_WASH, self:getLocks(1))
	end
	ctr_button_xilian_pro:addClickEventListener(xilianproClicked)


	-- 升阶
	local ctr_button_shengjie = self.ctrl_shengjie_node:getChildByName("Button_10")
	local function shengjieClicked(sender)
		print("up_stairs_item_num:"..EquipConfig[self.data.id].up_stairs_item_num)
		if EquipConfig[self.data.id].up_stairs_item_num ~= 0 then
			gameTcp:SendMessage(MSG_C2MS_EQUIPS_UPGRADE, {self.data.guid})
		else
			print("不能进阶")
		end
	end
	ctr_button_shengjie:addClickEventListener(shengjieClicked)


	-- 洗炼锁
	self.locks = {}
	self.locks[1] = self.attr_xilian_node:getChildByName("CheckBox_1")
	self.locks[2] = self.attr_xilian_node:getChildByName("CheckBox_2")
	self.locks[3] = self.attr_xilian_node:getChildByName("CheckBox_3")
	self.locks[4] = self.attr_xilian_node:getChildByName("CheckBox_4")
	self.locks[5] = self.attr_xilian_node:getChildByName("CheckBox_5")


	self:_registNodeEvent()
	self:_registGlobalEventListeners()

end

function backpack_equip_dialog:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function backpack_equip_dialog:getLocks(mode)
	-- body
	local data = {}
	data[1] = self.data.guid
	data[2] = mode
	data[3] = 0

	for i=1,#self.locks do
		if self.locks[i]:isSelected() then
			table.insert(data, i)
			data[3] = data[3] + 1
		end
	end

	return data
end

function backpack_equip_dialog:duiwu(duiwu)
	-- body
	if duiwu then
		-- 主控制面板升阶按钮
		self.ctrl_node:getChildByName("Button_1_0"):setPositionX(74)
		self.ctrl_node:getChildByName("Button_1_2"):setVisible(true)
	else
		self.ctrl_node:getChildByName("Button_1_0"):setPositionX(230)
		self.ctrl_node:getChildByName("Button_1_2"):setVisible(false)
	end
end

function backpack_equip_dialog:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "backpack_ctrl", eventName = "updatePanel", callBack=handler(self, self.update)},
		
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function backpack_equip_dialog:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end

function backpack_equip_dialog:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function backpack_equip_dialog:update(data)
	-- body
	if data._usedata then
		data = self.data
		print("广播更新")
	else
		print("更新")
		self.data = data
	end

	-- icon
	local iconNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_3")
	local icon = UIManager:CreateDropOutFrame(
		"装备",
		data.id
	):getResourceNode()
	if icon then
		icon:setSwallowTouches(false)
		icon:setCascadeOpacityEnabled(true)
		icon:setPosition(70, 70)
		iconNode:addChild(icon)
	end


	-- 等级
	local lv = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Text_2")
	lv:setString(data.mainlevel)

	-- 名字
	local name = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_3_0"):getChildByName("Text_3")
	name:setString(EquipConfig[data.id].name)

	-- 部位
	local buwei = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_3_0"):getChildByName("Text_3_0")
	if EquipConfig[data.id].equipmentType == 0 then
		buwei:setString("武器")
	elseif EquipConfig[data.id].equipmentType == 1 then
		buwei:setString("头盔")
	elseif EquipConfig[data.id].equipmentType == 2 then
		buwei:setString("护甲")
	elseif EquipConfig[data.id].equipmentType == 3 then
		buwei:setString("靴子")
	end

	-- 评分
	local pingfen1 = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_3_0"):getChildByName("Text_6")
	pingfen1:setString(data:getZhanDouLiMain())
	local pingfen2 = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_2"):getChildByName("Panel_3_0"):getChildByName("Text_6_0")
	pingfen2:setString("("..data:getZhanDouLiOff()..")")

	-- 主属性
	local main_attr = self.attr_node:getChildByName("Text_8_0")
	main_attr:setString(math.floor(EquipConfig[data.id].main_attr_value*(1+data.mainlevel/10)))
	
	-- 主属性面板
	local attr_node_attr1 = self.attr_node:getChildByName("Text_10_5")
	attr_node_attr1:setString(data.off_attr_1)
	local attr_node_attr2 = self.attr_node:getChildByName("Text_10_5_0")
	attr_node_attr2:setString(data.off_attr_2)
	local attr_node_attr3 = self.attr_node:getChildByName("Text_10_5_0_0")
	attr_node_attr3:setString(data.off_attr_3)
	local attr_node_attr4 = self.attr_node:getChildByName("Text_10_2_1")
	attr_node_attr4:setString(data.off_attr_4)
	local attr_node_attr5 = self.attr_node:getChildByName("Text_10_2_1_0")
	attr_node_attr5:setString(data.off_attr_5)

	-- 附加属性
	local attr_node_crit = self.attr_node:getChildByName("Text_10_4_0")
	attr_node_crit:setString("0%")
	local attr_node_shanbi = self.attr_node:getChildByName("Text_10_4_0_0")
	attr_node_shanbi:setString("0%")
	local attr_node_critdm = self.attr_node:getChildByName("Text_10_4_0_0_0")
	attr_node_critdm:setString("0%")
	local attr_node_hit = self.attr_node:getChildByName("Text_10_4_0_0_0_0")
	attr_node_hit:setString("0%")
	for i=1,#data.other_attr do
		if AttrType[data.other_attr[i].type_] == "闪避" then
			attr_node_shanbi:setString(data.other_attr[i].attr.."%")
		elseif AttrType[data.other_attr[i].type_] == "命中" then
			attr_node_hit:setString(data.other_attr[i].attr.."%")
		elseif AttrType[data.other_attr[i].type_] == "韧性" then

		elseif AttrType[data.other_attr[i].type_] == "暴击" then
			attr_node_crit:setString(data.other_attr[i].attr.."%")
		elseif AttrType[data.other_attr[i].type_] == "暴伤" then
			attr_node_critdm:setString(data.other_attr[i].attr.."%")
		end
	end

	-- 升阶石
	local shengjie = self.ctrl_shengjie_node:getChildByName("Text_49_0")
	if #EquipConfig[data.id].up_stairs_target > 0 then
		shengjie:setString(MAIN_PLAYER.goodsManager:getCount(eSTID_Euip_US).."/"..EquipConfig[data.id].up_stairs_item_num)
	else
		shengjie:setString(MAIN_PLAYER.goodsManager:getCount(eSTID_Euip_US).."/0")
	end
	-- 升阶价格
	local shengjieprice = self.ctrl_shengjie_node:getChildByName("Text_49_0_0")
	shengjieprice:setString(EquipConfig[data.id].lv*10000)


	-- 强化石
	local qianghuashi = self.ctrl_qianghua_node:getChildByName("Text_49_0")
	if data.mainlevel < #EquipStrengthenCfg then
		qianghuashi:setString(MAIN_PLAYER.goodsManager:getCount(eSTID_Euip_SS).."/"..EquipStrengthenCfg[data.mainlevel+1].num)
	else
		qianghuashi:setString(MAIN_PLAYER.goodsManager:getCount(eSTID_Euip_SS).."/0")
	end
	-- 强化价格
	local shengjieprice = self.ctrl_qianghua_node:getChildByName("Text_49_0_0")
	shengjieprice:setString(EquipConfig[data.id].strengthen_price)

	-- 洗炼价格
	local xilian_price = self.ctrl_xilian_node:getChildByName("Text_53")
	xilian_price:setString(MAIN_PLAYER.baseAttr._lv*1000)

	local xilian_price2 = self.ctrl_xilian_node:getChildByName("Text_53_0")
	xilian_price2:setString(10)

	-- 洗练属性
	local xilian_attr = {}
	xilian_attr[1] = self.attr_xilian_node:getChildByName("Text_10_5")
	xilian_attr[1]:setString(data.off_attr_1)
	xilian_attr[2] = self.attr_xilian_node:getChildByName("Text_10_5_0")
	xilian_attr[2]:setString(data.off_attr_2)
	xilian_attr[3] = self.attr_xilian_node:getChildByName("Text_10_5_0_0")
	xilian_attr[3]:setString(data.off_attr_3)
	xilian_attr[4] = self.attr_xilian_node:getChildByName("Text_10_2_1")
	xilian_attr[4]:setString(data.off_attr_4)
	xilian_attr[5] = self.attr_xilian_node:getChildByName("Text_10_2_1_0")
	xilian_attr[5]:setString(data.off_attr_5)

	-- 物法互换价格
	local huhuanprice = self.xilian_name_node:getChildByName("Text_3_0_0")
	huhuanprice:setString(EquipConfig[data.id].lv*10000)


end

function backpack_equip_dialog:close()
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


function backpack_equip_dialog:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return backpack_equip_dialog
