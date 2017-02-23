--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:48:30
--

local goods_scrollview = class("goods_scrollview")

local class_goods_item = import("app.views.gameWorld.goods.goods_item.lua")
local class_goods_sale_item = import("app.views.gameWorld.goods.goods_sale_item.lua")

function goods_scrollview:ctor(node)

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
    self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initScrollView()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
    self.itemModel = cc.CSLoader:createNode("ui_instance/goods/goods_item.csb")
    self.itemModel:retain()
    self.saleitemModel = cc.CSLoader:createNode("ui_instance/goods/goods_sale_item.csb")
    self.saleitemModel:retain()
end

--初始化数据
function goods_scrollview:initData()
	-- body
    -- MAIN_PLAYER.goodsManager.data
    -- 生成显示数据和可出售数据
    self.listData = {}
    for i=1,#MAIN_PLAYER.goodsManager.data do
        self.listData[i] = MAIN_PLAYER.goodsManager.data[i]
    end

    self.saleData = {}
    local tmp = 1
    for i=1,#MAIN_PLAYER.goodsManager.data do
        if ItemsConfig[MAIN_PLAYER.goodsManager.data[i].id].price > 0 then
            self.saleData[tmp] = MAIN_PLAYER.goodsManager.data[i]
            tmp = tmp + 1
        end
    end
end

function goods_scrollview:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
end

--注册节点事件
function goods_scrollview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function goods_scrollview:_registUIEvent()
	-- body
end

--注册全局事件监听器
function goods_scrollview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_goodsManager", eventName = "refreshgoods", callBack=handler(self, self.updateScrollview)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function goods_scrollview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function goods_scrollview:updateScrollview(mode)
    -- body
    self:initData()
    if self.displaymode == mode then
        return
    end
    if type(mode) == "userdata" then
        mode = nil
    end
    self.displaymode = mode or self.displaymode

    self.scrollview:removeAllChildren()
    if self.displaymode == 1 then -- 道具列表
        self.displayData = self.listData
    elseif self.displaymode == 2 then -- 出售列表
        self.displayData = self.saleData
    end
    local offy = math.ceil(#self.displayData/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4 then
        offy2 = 4
    end


    print("#self.displayData="..#self.displayData)
    for i=1,#self.displayData do
        local viewitem = nil
        if self.displaymode == 1 then
            viewitem = class_goods_item.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )
        else
            viewitem = class_goods_sale_item.new(
                    self.saleitemModel:getChildByName("main_layout"):clone()
                )
        end

        viewitem:getResourceNode():setPosition(cc.p(8+445*((i-1)%2), 10+130* (offy2 - math.ceil(i/2))))

        viewitem:update(self.displayData[i])
        self.scrollview:addChild(viewitem:getResourceNode())
    end
    local size = cc.size(0, 130*offy+50)
    self.scrollview:setInnerContainerSize(size)

    -- self.scrollview:jumpToBottom()
    -- self.scrollview:scrollToTop(0.5, true)

    if mode then
        self.scrollview:jumpToTop()
    end

end


return goods_scrollview
