--
-- Author: Wu Hengmin
-- Date: 2015-07-09 15:38:03
-- 装备默认显示区域

local equip_conventional_view = class("equip_conventional_view")

local class_equip_item_node = import("app.views.gameWorld.equip.equip_item.lua")
local class_equip_info_view = import(".scrolls.equip_info_view")
local class_equip_up_view = import(".scrolls.equip_up_view")
local class_equip_xilian_view = import(".scrolls.equip_xilian_view")

function equip_conventional_view:ctor(node)
	self:initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self.equiplistitem = {}
    self.itemModel = cc.CSLoader:createNode("ui_instance/equip/equip_item.csb")
    self.itemModel:retain()
end

--初始化数据
function equip_conventional_view:initData()
	-- body
	-- 默认情况下列表数据
	self.defaultListData = {}
	local tmp = 1
	for k,v in pairs(MAIN_PLAYER.equipManager.data) do
		self.defaultListData[tmp] = v
		tmp = tmp + 1
	end
	-- 强化列表数据
	self.qianghuaListData = self.defaultListData
	-- 洗炼列表数据
	self.xilianListData = self.defaultListData
	-- 分解列表数据
	self.fenjieListData = self.defaultListData
end

--注册节点事件
function equip_conventional_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function equip_conventional_view:_registUIEvent()
	-- body
end

--注册全局事件监听器
function equip_conventional_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "equip_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
		{modelName = "equip_ctrl", eventName = "shengjiORactive", callBack=handler(self, self.upgradeOrActive)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function equip_conventional_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function equip_conventional_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function equip_conventional_view:display(target)
	-- body
	self._rootNode:setVisible(true)
	self:updateListview(target)
end

function equip_conventional_view:updateListview(target, jumpToTop, guid)
	-- body
	self:initData()
	if target == "装备列表" then
		self.currentListData = self.defaultListData
	elseif target == "装备强化" then
		self.currentListData = self.qianghuaListData
	elseif target == "装备洗炼" then
		self.currentListData = self.xilianListData
	elseif target == "装备分解" then
		self.currentListData = self.fenjieListData
	else
		print("target错误")
		return
	end
	self.target = target

	self.listview = self._rootNode:getChildByName("main_layout"):getChildByName("listview")
	self:refreshList()

	if #self.currentListData > 0 then
		-- if guid then
		-- 	self.viewhero = MAIN_PLAYER.heroManager:getHero(guid)
		-- 	for i=1,#self.currentListData do
		-- 		if self.currentListData[i].guid == guid then
		-- 			table.insert(self.currentListData, 1, self.currentListData[i])
		-- 			table.remove(self.currentListData, i+1)
		-- 			break
		-- 		end
		-- 	end
		-- else
		-- 	self.viewhero = self._currentListData[1]
		-- end
	    self:updateScrollview(guid or self.currentListData[1].guid)
	else
		self:updateScrollview()
	end
end

function equip_conventional_view:createItems(dex)
    -- body
    local item = class_equip_item_node.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )
    -- item:setCascadeOpacityEnabled(true)
    -- item.resourceNode_:getChildByName("main_layout"):setSwallowTouches(false)
    local function touchEvent(sender,eventType)
        -- body
        if eventType == ccui.TouchEventType.began then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.moved then
            globalTouchEvent(sender,eventType)
        elseif eventType == ccui.TouchEventType.ended then
            if globalTouchEvent(sender,eventType) then
                self:updateScrollview(self.currentListData[dex].guid)
            end
        end
    end
    item:getResourceNode():getChildByName("bg"):addTouchEventListener(touchEvent)
    return item
end


function equip_conventional_view:refreshList(jumpToTop)
	-- local tmp = {}
	-- local dex = 1
	-- for i=1,#self.countrys do
	-- 	if self.countrys[i]:isSelected() then
	-- 		for k,v in pairs(self.currentListData) do
	-- 			if heroConfig[v.id].country == i then
	-- 				tmp[dex] = v
	-- 				dex = dex + 1
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- 排序

	local tmp = self.currentListData

	local offy = #tmp
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.075 then
        offy2 = 4.075
    end
	if #tmp == 0 then
        for i=1,#self.equiplistitem do
            self.equiplistitem[i]:getResourceNode():setVisible(false)
        end
    elseif #tmp > #self.equiplistitem then
        for i=#self.equiplistitem+1,#tmp do
            self.equiplistitem[i] = self:createItems(i)
			self.listview:addChild(self.equiplistitem[i]:getResourceNode())
        end
    else
        for i=#tmp,#self.equiplistitem do
            self.equiplistitem[i]:getResourceNode():setVisible(false)
        end
    end

    -- 重置位置,加入数据
    for i=1,#tmp do
        self.equiplistitem[i]:getResourceNode():setPosition(cc.p(12, 10+126*(offy2-i)))
        self.equiplistitem[i]:update(tmp[i])
        self.equiplistitem[i]:getResourceNode():setVisible(true)
    end

    local size = cc.size(0, 126*#tmp)
    self.listview:setInnerContainerSize(size)

    if jumpToTop then
        self.listview:jumpToTop()
    end

end

function equip_conventional_view:updateScrollview(guid)
	-- body
	self.scrollview = self._rootNode:getChildByName("main_layout"):getChildByName("scrollnode"):getChildByName("scrollview")
	self.scrollview:removeAllChildren()
	if self.target == "装备列表" then
		local infoview = class_equip_info_view:new()
		infoview:update(guid)
		self.scrollview:addChild(infoview)
		infoview:setCascadeOpacityEnabled(true)
		local size = infoview.resourceNode_:getChildByName("main_node"):getContentSize()

		self.scrollview:setInnerContainerSize(size)
		-- self.scrollview:jumpToBottom()
		-- self.scrollview:scrollToTop(0.5, true)
		self.scrollview:jumpToTop()
	elseif self.target == "装备强化" then
		local infoview = class_equip_up_view:new()
		infoview:update(guid)
		self.scrollview:addChild(infoview)
		infoview:setCascadeOpacityEnabled(true)
		local size = infoview.resourceNode_:getChildByName("main_node"):getContentSize()

		self.scrollview:setInnerContainerSize(size)
		-- self.scrollview:jumpToBottom()
		-- self.scrollview:scrollToTop(0.5, true)
		self.scrollview:jumpToTop()
	elseif self.target == "装备洗炼" then
		local infoview = class_equip_xilian_view:new()
		infoview:update(guid)
		self.scrollview:addChild(infoview)
		infoview:setCascadeOpacityEnabled(true)
		local size = infoview.resourceNode_:getChildByName("main_node"):getContentSize()

		self.scrollview:setInnerContainerSize(size)
		-- self.scrollview:jumpToBottom()
		-- self.scrollview:scrollToTop(0.5, true)
		self.scrollview:jumpToTop()
	elseif self.target == "装备分解" then
		
	else
		print("target错误")
	end
	
end

-- 升级或者激活后更新列表显示
function equip_conventional_view:upgradeOrActive()
	-- body
	print("upgradeOrActive")
	for i=1,#self.equiplistitem do
		self.equiplistitem[i]:update(self.currentListData[i])
	end
end

return equip_conventional_view
