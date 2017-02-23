--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 道具界面

local UI_Choose = class("UI_Choose", cc.load("mvc").ViewBase)

local class_choose_pageview = import("app.views.gameWorld.choose.choose_pageview.lua")
-- local class_choose_choose = import("app.views.gameWorld.choose.choose_choose.lua")
-- local class_choose_fragment = import("app.views.gameWorld.choose.choose_fragment.lua")
-- local class_choose_atlas = import("app.views.gameWorld.choose.choose_atlas.lua")
local class_choose_hero = import("app.views.gameWorld.choose.choose_hero.lua")
local class_choose_equip = import("app.views.gameWorld.choose.choose_equip.lua")

UI_Choose.RESOURCE_FILENAME = "ui_instance/choose/choose_layer.csb"

UI_Choose.list = {
	{
		name = "装备",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "武将",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Choose:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()


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

    self.heroModel = cc.CSLoader:createNode("ui_instance/choose/choose_hero.csb")
    self.heroModel:retain()

    self.equipModel = cc.CSLoader:createNode("ui_instance/choose/choose_equip.csb")
    self.equipModel:retain()
	self:_createControlerForUI()

	
    
end

function UI_Choose:setMax(count)
	-- body
	self.max = count
	self:updateDisplay(1)
end

--注册节点事件
function UI_Choose:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Choose:_createControlerForUI()
	self._controlerMap = {}
	self._controlerMap.pageview = class_choose_pageview.new(
		self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("PageView_1")
	)

	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        	self:updatePage(sender:getCurPageIndex()+1)
        end
    end
    self._controlerMap.pageview:getResourceNode():addEventListener(pageViewEvent)





end

function UI_Choose:updatePage(page)
	-- body
	if page == nil then
		page = 1
	end

	
	self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("page"):setString("当前页:"..page.."/"..self.maxpage)
	
	local targetpage = page + 1
	if self.maxpage > page and #self._controlerMap.pageview:getResourceNode():getPages() < targetpage then
		if self.displayMode == 1 then
			self.pages[targetpage] = class_choose_equip.new(
                    self.equipModel:getChildByName("main_layout"):clone(),
                    self.max
                )
			self.pages[targetpage]:update(self.rightData, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
			
		elseif self.displayMode == 2 then
			self.pages[targetpage] = class_choose_hero.new(
                    self.heroModel:getChildByName("main_layout"):clone(),
                    self.max
                )
			self.pages[targetpage]:update(self.rightData, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		end

	end

	self.page = page

end

function UI_Choose:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		dispatchGlobaleEvent("choose", "updatedata", {mode = self.displayMode, data = self:getChooseData()})
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	-- 筛选
    local screen = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_3")
    local function screenClicked(sender)
		print("筛选")
		if self.displayMode == 1 then
			UIManager:createEquipScreenDialog()
		elseif self.displayMode == 2 then
			UIManager:createChooseScreenDialog()
		end
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
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_1")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_2")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Choose:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "chooseup_ctrl", eventName = "updateChoose", callBack=handler(self, self.updateScreen)},
		{modelName = "chooseup_ctrl", eventName = "updateCheck", callBack=handler(self, self.updateCheck)},
		{modelName = "backpack_ctrl", eventName = "updateScreen", callBack=handler(self, self.updateEquipScreen)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

-- 通过筛选结果刷新显示数据
function UI_Choose:updateScreen(params)
	-- body
	self.screen = params._usedata.screen

	self._controlerMap.pageview:getResourceNode():removeAllPages()
	self.pages = {}
	if self.screen == 1 then -- 魏
		self.rightData = MAIN_PLAYER.heroManager:getHerosWei()
	elseif self.screen == 2 then -- 蜀
		self.rightData = MAIN_PLAYER.heroManager:getHerosShu()
	elseif self.screen == 3 then -- 吴
		self.rightData = MAIN_PLAYER.heroManager:getHerosWu()
	elseif self.screen == 4 then -- 群
		self.rightData = MAIN_PLAYER.heroManager:getHerosQun()
	elseif self.screen == 5 then -- 副
		self.rightData = MAIN_PLAYER.heroManager:getHerosFu()
	elseif self.screen == 6 then -- 名
		self.rightData = MAIN_PLAYER.heroManager:getHerosMing()
	elseif self.screen == 7 then -- 神
		self.rightData = MAIN_PLAYER.heroManager:getHerosShen()
	elseif self.screen == 0 then -- 全
		self.rightData = MAIN_PLAYER.heroManager:getHerosQuan()
	end
	self.maxpage = math.ceil(#self.rightData/4)
	if self.maxpage == 0 then
		self.maxpage = 1
	end
	self.pages[1] = class_choose_hero.new(
            self.heroModel:getChildByName("main_layout"):clone(),
            self.max
        )
		

	self.pages[1]:update(self.rightData, 1)
	self._controlerMap.pageview:getResourceNode():addPage(self.pages[1]:getResourceNode())

	self._controlerMap.pageview:getResourceNode():scrollToPage(0)
	self:updatePage()
	self.checkData = {}
	for i=1,#self.rightData do
		self.checkData[i] = 0
	end
end

function UI_Choose:updateEquipScreen(params)
	-- body
	self.screen = params._usedata.screen

	self._controlerMap.pageview:getResourceNode():removeAllPages()
	self.pages = {}
	self.rightData = {}
	if self.screen == 1 then -- 武器
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id]._type==0 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 2 then -- 头盔
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id]._type==1 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 3 then -- 防具
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id]._type==2 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 4 then -- 鞋子
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id]._type==3 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 5 then -- 白
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id].quality==1 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 6 then -- 绿
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id].quality==2 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 7 then -- 蓝
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id].quality==3 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 8 then -- 紫
		for i=1,#MAIN_PLAYER.equipManager.data do
			if EquipConfig[MAIN_PLAYER.equipManager.data[i].id].quality==4 then
				table.insert(self.rightData, MAIN_PLAYER.equipManager.data[i])
			end
		end
	elseif self.screen == 0 then -- 全
		self.rightData = MAIN_PLAYER.equipManager.data
	end
	print("数量"..#self.rightData)
	self.maxpage = math.ceil(#self.rightData/3)
	if self.maxpage == 0 then
		self.maxpage = 1
	end
	self.pages[1] = class_choose_equip.new(
            self.equipModel:getChildByName("main_layout"):clone(),
            self.max
        )
		

	self.pages[1]:update(self.rightData, 1)
	self._controlerMap.pageview:getResourceNode():addPage(self.pages[1]:getResourceNode())

	self._controlerMap.pageview:getResourceNode():scrollToPage(0)
	self:updatePage()
	self.checkData = {}
	for i=1,#self.rightData do
		self.checkData[i] = 0
	end
end

function UI_Choose:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Choose:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Choose:close(res)
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


function UI_Choose:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Choose:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Choose:updateData()
	-- body
	self.heroData = {}
	local tmp = 1
	for k,v in pairs(MAIN_PLAYER.heroManager.heros) do
		self.heroData[tmp] = v
		tmp = tmp + 1
	end

end

function UI_Choose:updateDisplay(index)
	-- body
	self:updateData()
	self._controlerMap.pageview:getResourceNode():removeAllPages()
	self.pages = {}
	if index == nil then
		index = self.displayMode
	else
		self.displayMode = index
	end
	
	if index == 1 then -- 装备
		print("装备")
		self.rightData = MAIN_PLAYER.equipManager.data
		self.maxpage = math.ceil(#self.rightData/4)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_choose_equip.new(
                    self.equipModel:getChildByName("main_layout"):clone(),
                    self.max
                )
			self.pages[i]:update(self.rightData, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	elseif index == 2 then -- 武将
		print("武将")
		self.rightData = self.heroData
		self.maxpage = math.ceil(#self.rightData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_choose_hero.new(
                    self.heroModel:getChildByName("main_layout"):clone(),
                    self.max
                )
			self.pages[i]:update(self.rightData, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	end

	self.checkData = {}
	for i=1,#self.rightData do
		self.checkData[i] = 0
	end

end

function UI_Choose:updateCheck(params)
	-- body
	if self:getCountWithChoose() < self.max or params._usedata.value == 0 then
		local index = params._usedata.index
		local value = params._usedata.value
		self.checkData[index] = value
	else
		UIManager:CreatePrompt_Bar( {content = "已达到可选上限"})
	end
end

function UI_Choose:getCountWithChoose()
	-- body
	local tmp = 0
	for i=1,#self.checkData do
		if self.checkData[i] == 1 then
			tmp = tmp + 1
		end
	end
	return tmp
end

function UI_Choose:getChooseData()
	-- body
	local data = {}
	for i=1,#self.checkData do
		if self.checkData[i] == 1 then
			table.insert(data, self.rightData[i].guid)
		end
	end
	return data
end

return UI_Choose
