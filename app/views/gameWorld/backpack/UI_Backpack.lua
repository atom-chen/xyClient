--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 道具界面

local UI_Backpack = class("UI_Backpack", cc.load("mvc").ViewBase)

local class_backpack_pageview = import("app.views.gameWorld.backpack.backpack_pageview.lua")
local class_backpack_equip = import("app.views.gameWorld.backpack.backpack_equip.lua")
local class_backpack_goods = import("app.views.gameWorld.backpack.backpack_goods.lua")
local class_backpack_fragment = import("app.views.gameWorld.backpack.backpack_fragment.lua")

UI_Backpack.RESOURCE_FILENAME = "ui_instance/backpack/backpack_layer.csb"

UI_Backpack.list = {
	{
		name = "装备",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "道具",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "神器碎片",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Backpack:onCreate()
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

    self.equipitemModel = cc.CSLoader:createNode("ui_instance/backpack/backpack_equip.csb")
    self.equipitemModel:retain()

    self.goodsitemModel = cc.CSLoader:createNode("ui_instance/backpack/backpack_goods.csb")
    self.goodsitemModel:retain()

    self.fragmentitemModel = cc.CSLoader:createNode("ui_instance/backpack/backpack_fragment.csb")
    self.fragmentitemModel:retain()

	self:updateDisplay(1)
    
end

--注册节点事件
function UI_Backpack:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Backpack:_createControlerForUI()
	self._controlerMap = {}

	self._controlerMap.pageview = class_backpack_pageview.new(
		self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("pageview")
	)


	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        	self:updatePage(sender:getCurPageIndex()+1)
        end
    end 

    self._controlerMap.pageview:getResourceNode():addEventListener(pageViewEvent)
end

function UI_Backpack:updatePage(page)
	-- body
	if page == nil then
		page = 1
		
	end
	self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("page"):setString("当前页:"..page.."/"..self.maxpage)

	local targetpage = page + 1
	if self.maxpage > page and #self._controlerMap.pageview:getResourceNode():getPages() < targetpage then
		if self.displayMode == 1 then
			self.pages[targetpage] = class_backpack_equip.new(
                    self.equipitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[targetpage]:update(self.rightData, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		elseif self.displayMode == 2 then
			self.pages[targetpage] = class_backpack_goods.new(
                    self.goodsitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[targetpage]:update(MAIN_PLAYER.goodsManager.data, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		elseif self.displayMode == 3 then
			self.pages[targetpage] = class_backpack_fragment.new(
                    self.fragmentitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[targetpage]:update(MAIN_PLAYER.equipManager.fragment, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		end

	end
	self.page = page
end

function UI_Backpack:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

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
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_equip")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_goods")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)
	
	self.tabs[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_shenqi")
	self.tabs[3].index = 3
	self.tabs[3]:addTouchEventListener(onClicked)



	self.screenbutton = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_1")
	local function screenClicked(sender)
		print("筛选")
		UIManager:createEquipScreenDialog()
	end
	self.screenbutton:addClickEventListener(screenClicked)

	self.kuochong = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_1_0")
	local function kuochongClicked(sender)
		print("扩充")
		-- UIManager:createEquipScreenDialog()
	end
	self.kuochong:addClickEventListener(kuochongClicked)

	self:updateButton(1)
	
end

function UI_Backpack:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "backpack_ctrl", eventName = "updatePanel", callBack=handler(self, self.updatePageView)},
		{modelName = "backpack_ctrl", eventName = "updateScreen", callBack=handler(self, self.updateScreen)},
		{modelName = "model_goodsManager", eventName = "refreshgoods", callBack=handler(self, self.updateGoods)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

-- 更新当前页面上的数据显示
function UI_Backpack:updatePageView()
	-- body
	if self.displayMode == 1 then
		self.pages[self.page]:update(self.rightData, self.page)
	elseif self.displayMode == 2 then
		self.pages[self.page]:update(MAIN_PLAYER.goodsManager.data, self.page)
	elseif self.displayMode == 3 then
		self.pages[self.page]:update(MAIN_PLAYER.equipManager.fragment, self.page)
	end
	

end

-- 通过筛选结果刷新显示数据
function UI_Backpack:updateScreen(params)
	-- body
	self.screen = params._usedata.screen

	self._controlerMap.pageview:getResourceNode():removeAllPages()
	self.pages = {}

	self.rightData = {}
	if self.screen == 1 then -- 武器
		self.rightData = MAIN_PLAYER.equipManager:getWuqi()
	elseif self.screen == 2 then -- 头盔
		self.rightData = MAIN_PLAYER.equipManager:getToukui()
	elseif self.screen == 3 then -- 防具
		self.rightData = MAIN_PLAYER.equipManager:getFangju()
	elseif self.screen == 4 then -- 鞋子
		self.rightData = MAIN_PLAYER.equipManager:getXiezi()
	elseif self.screen == 5 then -- 白
		self.rightData = MAIN_PLAYER.equipManager:getBai()
	elseif self.screen == 6 then -- 绿
		self.rightData = MAIN_PLAYER.equipManager:getLv()
	elseif self.screen == 7 then -- 蓝
		self.rightData = MAIN_PLAYER.equipManager:getLan()
	elseif self.screen == 8 then -- 紫
		self.rightData = MAIN_PLAYER.equipManager:getZi()
	elseif self.screen == 9 then -- 橙
		self.rightData = MAIN_PLAYER.equipManager:getCheng()
	elseif self.screen == 10 then -- 红
		self.rightData = MAIN_PLAYER.equipManager:getHong()
	elseif self.screen == 0 then -- 全
		self.rightData = MAIN_PLAYER.equipManager:getQuan()
	end

	local function mysort(a, b)
		-- body
		if EquipConfig[a.id].quality ~= EquipConfig[b.id].quality then
			return EquipConfig[a.id].quality > EquipConfig[b.id].quality
		elseif EquipConfig[a.id].lv ~= EquipConfig[b.id].lv then
			return EquipConfig[a.id].lv > EquipConfig[b.id].lv
		elseif a.mainlevel ~= b.mainlevel then
			return a.mainlevel > b.mainlevel
		else
			return a.id > b.id
		end
	end

	table.sort(self.rightData, mysort)

	self.maxpage = math.ceil(#self.rightData/21)
	if self.maxpage == 0 then
		self.maxpage = 1
	end
	self.pages[1] = class_backpack_equip.new(
            self.equipitemModel:getChildByName("main_layout"):clone()
        )
		

	self.pages[1]:update(self.rightData, 1)
	self._controlerMap.pageview:getResourceNode():addPage(self.pages[1]:getResourceNode())

	self._controlerMap.pageview:getResourceNode():scrollToPage(0)
	self:updatePage()
end

function UI_Backpack:createRightData()
	-- body
	self.rightData = MAIN_PLAYER.equipManager.data
	local function mysort(a, b)
		-- body
		if EquipConfig[a.id].quality ~= EquipConfig[b.id].quality then
			return EquipConfig[a.id].quality > EquipConfig[b.id].quality
		elseif EquipConfig[a.id].lv ~= EquipConfig[b.id].lv then
			return EquipConfig[a.id].lv > EquipConfig[b.id].lv
		elseif a.mainlevel ~= b.mainlevel then
			return a.mainlevel > b.mainlevel
		else
			return a.id > b.id
		end
	end

	table.sort(self.rightData, mysort)
end

-- 刷新道具显示
function UI_Backpack:updateGoods()
	-- body
	if self.displayMode ~= 2 then
		return
	end

	print("刷新道具显示")
	self.maxpage = math.ceil(#MAIN_PLAYER.goodsManager.data/21)
	if self.maxpage == 0 then
		self.maxpage = 1
	end

	if self.page > self.maxpage then
		self._controlerMap.pageview:getResourceNode():removePageAtIndex(self.page-1)
		self.pages[self.page] = nil
		self.page = self.maxpage
	end

	self._controlerMap.pageview:getResourceNode():scrollToPage(self.page-1)

	self.pages[self.page]:update(MAIN_PLAYER.goodsManager.data, self.page)
	self:updatePage(self.page)
end


function UI_Backpack:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Backpack:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Backpack:close(res)
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


function UI_Backpack:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Backpack:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Backpack:updateDisplay(index)
	-- body
	self._controlerMap.pageview:getResourceNode():removeAllPages()
	self.pages = {}
	self.displayMode = index
	if index == 1 then -- 装备
		print("装备")
		print("数量:"..#MAIN_PLAYER.equipManager.data)
		-- self.rightData = MAIN_PLAYER.equipManager.data
		self:createRightData()
		self.maxpage = math.ceil(#self.rightData/21)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_backpack_equip.new(
                    self.equipitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[i]:update(self.rightData, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
		self.screenbutton:setVisible(true)
		self.kuochong:setVisible(false)
	elseif index == 2 then -- 道具
		print("道具")
		self.maxpage = math.ceil(#MAIN_PLAYER.goodsManager.data/21)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_backpack_goods.new(
                    self.goodsitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[i]:update(MAIN_PLAYER.goodsManager.data, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
		self.screenbutton:setVisible(false)
		self.kuochong:setVisible(false)
	elseif index == 3 then -- 神器碎片
		print("神器碎片")
		self.maxpage = math.ceil(#MAIN_PLAYER.equipManager.fragment/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_backpack_fragment.new(
                    self.fragmentitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[i]:update(MAIN_PLAYER.equipManager.fragment, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
		self.screenbutton:setVisible(false)
		self.kuochong:setVisible(false)
	end
end

return UI_Backpack
