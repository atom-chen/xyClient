--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 道具界面

local UI_Wujiang = class("UI_Wujiang", cc.load("mvc").ViewBase)

local class_wujiang_pageview = import("app.views.gameWorld.wujiang.wujiang_pageview.lua")
local class_wujiang_wujiang = import("app.views.gameWorld.wujiang.wujiang_wujiang.lua")
local class_wujiang_fragment = import("app.views.gameWorld.wujiang.wujiang_fragment.lua")
local class_wujiang_atlas = import("app.views.gameWorld.wujiang.wujiang_atlas.lua")

UI_Wujiang.RESOURCE_FILENAME = "ui_instance/wujiang/wujiang_layer.csb"

UI_Wujiang.list = {
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

function UI_Wujiang:onCreate()
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

    self.wujiangitemModel = cc.CSLoader:createNode("ui_instance/wujiang/wujiang_wujiang.csb")
    self.wujiangitemModel:retain()

    self.fragmentitemModel = cc.CSLoader:createNode("ui_instance/wujiang/wujiang_fragment.csb")
    self.fragmentitemModel:retain()

    self.atlasitemModel = cc.CSLoader:createNode("ui_instance/wujiang/wujiang_atlas.csb")
    self.atlasitemModel:retain()



	self:updateDisplay(1)
    
end

--注册节点事件
function UI_Wujiang:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Wujiang:_createControlerForUI()
	self._controlerMap = {}

	self._controlerMap.pageview = class_wujiang_pageview.new(
		self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("pageview")
	)

	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        	self:updatePage(sender:getCurPageIndex()+1)
        end
    end
    self._controlerMap.pageview:getResourceNode():addEventListener(pageViewEvent)





end

function UI_Wujiang:updatePage(page)
	-- body
	if page == nil then
		page = 1
	end
	self.page = page

	
	self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("page"):setString("页数:"..page.."/"..self.maxpage)
	
	local targetpage = page + 1
	if self.maxpage > page and #self._controlerMap.pageview:getResourceNode():getPages() < targetpage then
		if self.displayMode == 1 then
			self.pages[targetpage] = class_wujiang_wujiang.new(
                    self.wujiangitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[targetpage]:update(self.rightData, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
			
		elseif self.displayMode == 2 then
			self.pages[targetpage] = class_wujiang_fragment.new(
                    self.fragmentitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[targetpage]:update(self.rightData, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		elseif self.displayMode == 3 then
			self.pages[targetpage] = class_wujiang_atlas.new(
                    self.atlasitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[targetpage]:update(self.rightData, targetpage)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[targetpage]:getResourceNode())
		end

	end

end

function UI_Wujiang:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	-- 筛选
    local screen = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_1_0")
    local function screenClicked(sender)
		print("筛选")
		UIManager:createWujiangScreenDialog()
	end
	screen:addClickEventListener(screenClicked)

	-- 招募
    local zhaomu = self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("Button_1")
    local function zhaomuClicked(sender)
		self:close(self._dynamicResConfigIDs)
		-- 打开招募
		dispatchGlobaleEvent("mainpage_popup_buttons2", "shangcheng_touched")
	end
	zhaomu:addClickEventListener(zhaomuClicked)

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

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_suipian")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)
	
	self.tabs[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_tujian")
	self.tabs[3].index = 3
	self.tabs[3]:addTouchEventListener(onClicked)

	self:updateButton(1)
	
end

function UI_Wujiang:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "wujiang_ctrl", eventName = "updateScreen", callBack=handler(self, self.updateScreen)},
		{modelName = "wujiangup_ctrl", eventName = "open", callBack=handler(self, self.close)},
		{modelName = "model_heroManager", eventName = "hecheng", callBack=handler(self, self.updateFragment)},
		{modelName = "model_heroManager", eventName = "fenjie", callBack=handler(self, self.updateFragment)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

-- 通过筛选结果刷新显示数据
function UI_Wujiang:updateScreen(params)
	-- body
	self.screen = params._usedata.screen

	self._controlerMap.pageview:getResourceNode():removeAllPages()
	self.pages = {}
	if self.displayMode == 1 then
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
		self.pages[1] = class_wujiang_wujiang.new(
                self.wujiangitemModel:getChildByName("main_layout"):clone()
            )
		
	elseif self.displayMode == 2 then
		if self.screen == 1 then -- 魏
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsWei()
		elseif self.screen == 2 then -- 蜀
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsShu()
		elseif self.screen == 3 then -- 吴
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsWu()
		elseif self.screen == 4 then -- 群
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsQun()
		elseif self.screen == 5 then -- 副
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsFu()
		elseif self.screen == 6 then -- 名
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsMing()
		elseif self.screen == 7 then -- 神
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsShen()
		elseif self.screen == 0 then -- 全
			self.rightData = MAIN_PLAYER.heroManager:getFragmentsQuan()
		end
		self.maxpage = math.ceil(#self.rightData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		self.pages[1] = class_wujiang_fragment.new(
                self.fragmentitemModel:getChildByName("main_layout"):clone()
            )
	elseif self.displayMode == 3 then
		if self.screen == 1 then -- 魏
			self.rightData = MAIN_PLAYER.heroManager:getAtlasWei()
		elseif self.screen == 2 then -- 蜀
			self.rightData = MAIN_PLAYER.heroManager:getAtlasShu()
		elseif self.screen == 3 then -- 吴
			self.rightData = MAIN_PLAYER.heroManager:getAtlasWu()
		elseif self.screen == 4 then -- 群
			self.rightData = MAIN_PLAYER.heroManager:getAtlasQun()
		elseif self.screen == 5 then -- 副
			self.rightData = MAIN_PLAYER.heroManager:getAtlasFu()
		elseif self.screen == 6 then -- 名
			self.rightData = MAIN_PLAYER.heroManager:getAtlasMing()
		elseif self.screen == 7 then -- 神
			self.rightData = MAIN_PLAYER.heroManager:getAtlasShen()
		elseif self.screen == 0 then -- 全
			self.rightData = MAIN_PLAYER.heroManager:getAtlasQuan()
		end
		self.maxpage = math.ceil(#self.rightData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		self.pages[1] = class_wujiang_atlas.new(
                self.atlasitemModel:getChildByName("main_layout"):clone()
            )
	end

	self.pages[1]:update(self.rightData, 1)
	self._controlerMap.pageview:getResourceNode():addPage(self.pages[1]:getResourceNode())

	self._controlerMap.pageview:getResourceNode():scrollToPage(0)
	self:updatePage()
end

-- 在合成或者分解碎片后刷新碎片的显示
function UI_Wujiang:updateFragment()
	if self.screen == 1 then -- 魏
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsWei()
	elseif self.screen == 2 then -- 蜀
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsShu()
	elseif self.screen == 3 then -- 吴
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsWu()
	elseif self.screen == 4 then -- 群
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsQun()
	elseif self.screen == 5 then -- 副
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsFu()
	elseif self.screen == 6 then -- 名
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsMing()
	elseif self.screen == 7 then -- 神
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsShen()
	elseif self.screen == 0 then -- 全
		self.rightData = MAIN_PLAYER.heroManager:getFragmentsQuan()
	end
	self.maxpage = math.ceil(#self.rightData/8)
	if self.maxpage == 0 then
		self.maxpage = 1
	end
	if self.page > self.maxpage then
		self._controlerMap.pageview:getResourceNode():removePageAtIndex(self.page-1)
		self.pages[self.page] = nil
		self.page = self.maxpage
	end
	
	self._controlerMap.pageview:getResourceNode():scrollToPage(self.page)
	
	self.pages[self.page]:update(self.rightData, self.page)
	self:updatePage(self.page)
end

function UI_Wujiang:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Wujiang:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Wujiang:close(res)
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


function UI_Wujiang:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Wujiang:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Wujiang:updateData()
	-- body
	self.heroData = MAIN_PLAYER.heroManager:getHerosQuan()


	self.atlasData = MAIN_PLAYER.heroManager:getFragmentsQuan()
end

function UI_Wujiang:updateDisplay(index)
	-- body
	self:updateData()
	self._controlerMap.pageview:getResourceNode():removeAllPages()
	self.pages = {}
	if index == nil then
		index = self.displayMode
	else
		self.displayMode = index
	end
	
	if index == 1 then -- 武将
		print("武将")
		self.rightData = self.heroData
		self.maxpage = math.ceil(#self.heroData/4)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_wujiang_wujiang.new(
                    self.wujiangitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[i]:update(self.rightData, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	elseif index == 2 then -- 碎片
		print("碎片")
		self.rightData = MAIN_PLAYER.heroManager.fragments
		self.maxpage = math.ceil(#self.rightData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_wujiang_fragment.new(
                    self.fragmentitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[i]:update(self.rightData, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	elseif index == 3 then -- 图鉴
		print("图鉴")
		self.rightData = self.atlasData
		self.maxpage = math.ceil(#self.rightData/8)
		if self.maxpage == 0 then
			self.maxpage = 1
		end
		for i=1,1 do
			self.pages[i] = class_wujiang_atlas.new(
                    self.atlasitemModel:getChildByName("main_layout"):clone()
                )
			self.pages[i]:update(self.rightData, i)
			self._controlerMap.pageview:getResourceNode():addPage(self.pages[i]:getResourceNode())
		end
		self:updatePage()
	end
end

return UI_Wujiang
