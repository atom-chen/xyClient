--
-- Author: Wu Hengmin
-- Date: 2015-07-01 19:20:08
-- 默认显示部分

local heros_conventional_view = class("heros_conventional_view")

local class_heros_item_node = import("app.views.gameWorld.heros.heros_item_node.lua")
local class_heros_info_view = import("app.views.gameWorld.heros.views.scrolls.heros_info_view.lua")
local class_heros_fenjie_view = import("app.views.gameWorld.heros.views.scrolls.heros_fenjie_view.lua")
local class_heros_upgrade_view = import("app.views.gameWorld.heros.views.scrolls.heros_upgrade_view.lua")
local class_heros_juexing_view = import("app.views.gameWorld.heros.views.scrolls.heros_juexing_view.lua")
local class_heros_zhiye_view = import("app.views.gameWorld.heros.views.scrolls.heros_zhiye_view.lua")
local class_heros_skill_view = import("app.views.gameWorld.heros.views.scrolls.heros_skill_view.lua")
local class_heros_chongsheng_view = import("app.views.gameWorld.heros.views.scrolls.heros_chongsheng_view.lua")

function heros_conventional_view:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self.herolistitem = {}
end

--初始化数据
function heros_conventional_view:_initData()
	-- body
	-- 默认情况下列表数据
	self.defaultListData = {}
	local tmp = 1
	for k,v in pairs(MAIN_PLAYER.heroManager.heros) do
		self.defaultListData[tmp] = v
		tmp = tmp + 1
	end
	-- 武将觉醒列表数据
	self.wakeListData = self.defaultListData
	-- 武将技能列表数据
	self.skillListData = self.defaultListData
	-- 武将重生列表数据
	self.rerollListData = self.defaultListData
	-- 武将碎化列表数据
	self.disintegrationListData = self.defaultListData



	-- 指定首选武将

	if guid then



	end

	self.itemModel = cc.CSLoader:createNode("ui_instance/heros/heros_item_node.csb")
	self.itemModel:retain()
end

--注册节点事件
function heros_conventional_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function heros_conventional_view:_registUIEvent()
	-- body
	local countryNode = self._rootNode:getChildByName("main_layout"):getChildByName("country_node")
	self.countrys = {}
	local function selectedEvent1(sender,eventType)
		self.countrys[1]:setTouchEnabled(false)

		self.countrys[2]:setSelected(false)
		self.countrys[2]:setTouchEnabled(true)
		self.countrys[3]:setSelected(false)
		self.countrys[3]:setTouchEnabled(true)
		self.countrys[4]:setSelected(false)
		self.countrys[4]:setTouchEnabled(true)
		self.countrys[5]:setSelected(false)
		self.countrys[5]:setTouchEnabled(true)
        self:refreshList()
        self.viewhero = self._currentListData[1] --需要重置选择的英雄
        self:updateScrollview(self.viewhero)
    end
	local function selectedEvent2(sender,eventType)
		self.countrys[2]:setTouchEnabled(false)
		
		self.countrys[1]:setSelected(false)
		self.countrys[1]:setTouchEnabled(true)
		self.countrys[3]:setSelected(false)
		self.countrys[3]:setTouchEnabled(true)
		self.countrys[4]:setSelected(false)
		self.countrys[4]:setTouchEnabled(true)
		self.countrys[5]:setSelected(false)
		self.countrys[5]:setTouchEnabled(true)
        self:refreshList()
        self.viewhero = self._currentListData[1]
        self:updateScrollview(self.viewhero)
    end
	local function selectedEvent3(sender,eventType)
		self.countrys[3]:setTouchEnabled(false)
		
		self.countrys[2]:setSelected(false)
		self.countrys[2]:setTouchEnabled(true)
		self.countrys[1]:setSelected(false)
		self.countrys[1]:setTouchEnabled(true)
		self.countrys[4]:setSelected(false)
		self.countrys[4]:setTouchEnabled(true)
		self.countrys[5]:setSelected(false)
		self.countrys[5]:setTouchEnabled(true)
        self:refreshList()
        self.viewhero = self._currentListData[1]
        self:updateScrollview(self.viewhero)
    end
	local function selectedEvent4(sender,eventType)
		self.countrys[4]:setTouchEnabled(false)
		
		self.countrys[2]:setSelected(false)
		self.countrys[2]:setTouchEnabled(true)
		self.countrys[3]:setSelected(false)
		self.countrys[3]:setTouchEnabled(true)
		self.countrys[1]:setSelected(false)
		self.countrys[1]:setTouchEnabled(true)
		self.countrys[5]:setSelected(false)
		self.countrys[5]:setTouchEnabled(true)
        self:refreshList()
        self.viewhero = self._currentListData[1]
        self:updateScrollview(self.viewhero)
    end
	local function selectedEvent5(sender,eventType)
		self.countrys[5]:setTouchEnabled(false)
		
		self.countrys[2]:setSelected(false)
		self.countrys[2]:setTouchEnabled(true)
		self.countrys[3]:setSelected(false)
		self.countrys[3]:setTouchEnabled(true)
		self.countrys[4]:setSelected(false)
		self.countrys[4]:setTouchEnabled(true)
		self.countrys[1]:setSelected(false)
		self.countrys[1]:setTouchEnabled(true)
        self:refreshList()
        self.viewhero = self._currentListData[1]
        self:updateScrollview(self.viewhero)
    end
	-- 魏国
	self.countrys[1] = countryNode:getChildByName("country_1")
	self.countrys[1]:addEventListener(selectedEvent1)

	self.countrys[2] = countryNode:getChildByName("country_2")
	self.countrys[2]:addEventListener(selectedEvent2)

	self.countrys[3] = countryNode:getChildByName("country_3")
	self.countrys[3]:addEventListener(selectedEvent3)

	self.countrys[4] = countryNode:getChildByName("country_4")
	self.countrys[4]:addEventListener(selectedEvent4)

	self.countrys[5] = countryNode:getChildByName("country_5")
	self.countrys[5]:addEventListener(selectedEvent5)


	self.countrys[1]:setSelected(true)
	print("自动按下")
end


--注册全局事件监听器
function heros_conventional_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "heros_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
		{modelName = "heros_ctrl", eventName = "upgrade", callBack=handler(self, self.onUpgrade)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function heros_conventional_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_conventional_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function heros_conventional_view:display(target, guid)
	-- body
	self._rootNode:setVisible(true)
	self:updateListview(target, guid)
end

function heros_conventional_view:updateListview(target, guid)
	-- body
	self:_initData()
	self.listview = self._rootNode:getChildByName("main_layout"):getChildByName("listview")
 	
	self.target = target

	self:refreshList()

	if self.viewhero then
	else
		if guid then
			self.viewhero = MAIN_PLAYER.heroManager:getHero(guid)
			for i=1,#self._currentListData do
				if self._currentListData[i].guid == guid then
					table.insert(self._currentListData, 1, self._currentListData[i])
					table.remove(self._currentListData, i+1)
					break
				end
			end
		else
			self.viewhero = self._currentListData[1]
		end
	    
	end
	self:updateScrollview(self.viewhero)
end

function heros_conventional_view:createItems(dex)
    -- body
    local item = class_heros_item_node.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )

    local function touchEvent(sender,eventType)
        -- body
        if eventType == ccui.TouchEventType.began then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.moved then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.ended then
            if globalTouchEvent(sender,eventType) then
                self:updateScrollview(self._currentListData[dex])
                self.viewhero = self._currentListData[dex]
            end
        end
    end
    --[[
		不知道什么鬼,直接监听item:getResourceNode()就会错位
    ]]
    item:getResourceNode():getChildByName("bg"):addTouchEventListener(touchEvent)

    return item
end

function heros_conventional_view:refreshList(jumpToTop)
	self.currentListData = {}
	if self.target == "武将列表" then
		self.currentListData = self.defaultListData
	elseif self.target == "武将升级" then
		self.currentListData = self.defaultListData
	elseif self.target == "武将觉醒" then
		self.currentListData = self.wakeListData
	elseif self.target == "职业强化" then
		self.currentListData = self.defaultListData
	elseif self.target == "武将技能" then
		self.currentListData = self.skillListData
	elseif self.target == "武将重生" then
		self.currentListData = self.rerollListData
	elseif self.target == "武将碎化" then
		self.currentListData = self.disintegrationListData
	else
		print("target错误")
	end
	self._currentListData = {}
	local dex = 1
	for i=1,#self.countrys do
		if self.countrys[i]:isSelected() then
			for k,v in pairs(self.currentListData) do
				if heroConfig[v.id].country == i or i == 5 then
					self._currentListData[dex] = v
					-- print(heroConfig[self._currentListData[dex].id].name)
					dex = dex + 1
				end
			end
		end
	end

	-- 排序
	local offy = #self._currentListData
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.075 then
        offy2 = 4.075
    end
    print("武将显示长度:"..#self._currentListData)
	if #self._currentListData == 0 then
        for i=1,#self.herolistitem do
            self.herolistitem[i]:getResourceNode():setVisible(false)
        end
    elseif #self._currentListData > #self.herolistitem then
        for i=#self.herolistitem+1,#self._currentListData do
            self.herolistitem[i] = self:createItems(i)
			self.listview:addChild(self.herolistitem[i]:getResourceNode())
        end
    else
        for i=#self._currentListData,#self.herolistitem do
            self.herolistitem[i]:getResourceNode():setVisible(false)
        end
    end

    -- 重置位置,加入数据
    for i=1,#self._currentListData do
        self.herolistitem[i]:getResourceNode():setPosition(cc.p(12, 10+126*(offy2-i)))
        self.herolistitem[i]:update(self._currentListData[i])
        self.herolistitem[i]:getResourceNode():setVisible(true)
    end

    local size = cc.size(0, 126*offy2+72)
    self.listview:setInnerContainerSize(size)

    if jumpToTop then
        self.listview:jumpToTop()
    end

end

function heros_conventional_view:updateScrollview(hero)
	-- body
	self.scrollview = self._rootNode:getChildByName("main_layout"):getChildByName("scrollnode"):getChildByName("scrollview")
	if self.infoview and self.infoview._removeAllGlobalEventListeners then
		self.infoview:_removeAllGlobalEventListeners()
	end
	self.scrollview:removeAllChildren()
	self.infoview = nil
	if self.target == "武将列表" then
		self.infoview = class_heros_info_view:new()
	elseif self.target == "武将升级" then
		self.infoview = class_heros_upgrade_view:new()
	elseif self.target == "武将觉醒" then
		self.infoview = class_heros_juexing_view:new()
	elseif self.target == "职业强化" then
		self.infoview = class_heros_zhiye_view:new()
	elseif self.target == "武将技能" then
		self.infoview = class_heros_skill_view:new()
	elseif self.target == "武将重生" then
		self.infoview = class_heros_chongsheng_view:new()
	elseif self.target == "武将碎化" then
		self.infoview = class_heros_fenjie_view:new()
	else
		print("target错误")
	end

	self.infoview:updateDisplay(hero)
	self.infoview:setCascadeOpacityEnabled(true)
	self.scrollview:addChild(self.infoview)
	local size = self.infoview.resourceNode_:getChildByName("main_node"):getContentSize()
	self.scrollview:setInnerContainerSize(size)
	self.scrollview:jumpToTop()
	
end

-- 强化后更新列表显示
function heros_conventional_view:onUpgrade()
	-- body
	self:_initData()
	self:refreshList()
	self.infoview:updateDisplay(self.infoview.hero)
end

return heros_conventional_view
