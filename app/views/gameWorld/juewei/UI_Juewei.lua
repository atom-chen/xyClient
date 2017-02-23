--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 爵位界面

local UI_Juewei = class("UI_Juewei", cc.load("mvc").ViewBase)


UI_Juewei.RESOURCE_FILENAME = "ui_instance/juewei/juewei_layer.csb"

function UI_Juewei:onCreate()
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

    self:updateDisplay()

end

--注册节点事件
function UI_Juewei:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Juewei:_createControlerForUI()
	self._controlerMap = {}


end

function UI_Juewei:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)


	local upgrade = self.resourceNode_:getChildByName("main_layout"):getChildByName("Button_1")
	local function upgradeClicked(sender)
		gameTcp:SendMessage(MSG_C2MS_PEERAGE_UPGRADE)
	end
	upgrade:addClickEventListener(upgradeClicked)

end

function UI_Juewei:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_ROLE_UPDATA_PEERAGE_INFO), callBack=handler(self, self.updateDisplay)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function UI_Juewei:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end


function UI_Juewei:close(res)
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				self:removeFromParent(true)
				-- release_res(res)
			end
		})
end


function UI_Juewei:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Juewei:updateDisplay()
	-- body
	-- 爵位
	local juewei = self.resourceNode_:getChildByName("main_layout"):getChildByName("Image_9")
	juewei:loadTexture("icon/juewei/jw"..MAIN_PLAYER.baseAttr._Title..".png", ccui.TextureResType.plistType)


	-- 爵位经验
	local exp = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_0")
	if MAIN_PLAYER.baseAttr._Title > #PeerageCfg then -- 爵位已满
		exp:setString("0")
	else
		exp:setString(MAIN_PLAYER.baseAttr._TitleExp.."/"..PeerageCfg[MAIN_PLAYER.baseAttr._Title+1].exp)
	end
	-- 今日经验
	local expt = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_0_0")
	expt:setString(MAIN_PLAYER.baseAttr._TitleExp_today.."/"..VipConfig[MAIN_PLAYER.baseAttr._vipLv].every_day.peerage_exp)
	-- 爵位加成
	local attr = {}
	attr[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0")
	attr[1]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].atk)
	attr[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0_0")
	attr[2]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].hp)
	attr[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0_1")
	attr[3]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].pdef)
	attr[4] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0_0_0")
	attr[4]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].mdef)
	-- 下一级爵位加成
	if MAIN_PLAYER.baseAttr._Title < #PeerageCfg then
		--下一级爵位
		local nextj = self.resourceNode_:getChildByName("main_layout"):getChildByName("Image_9_0")
		nextj:loadTexture("icon/juewei/jw"..(MAIN_PLAYER.baseAttr._Title+1)..".png", ccui.TextureResType.plistType)

		-- 升级小号银两
		local price = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_0_1_0")
		price:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title].yinliang)

		attr[5] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0_2")
		attr[5]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title+1].atk)
		attr[6] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0_0_1")
		attr[6]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title+1].hp)
		attr[7] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0_1_0")
		attr[7]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title+1].pdef)
		attr[8] = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_2_0_0_0_0")
		attr[8]:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title+1].mdef)

		-- 下一级的经验
		nextexp = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Panel_7"):getChildByName("Text_8_0_0_1")
		nextexp:setString(PeerageCfg[MAIN_PLAYER.baseAttr._Title+1].exp)
	else




	end








end


return UI_Juewei
