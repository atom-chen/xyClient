--
-- Author: Wu Hengmin
-- Date: 2015-07-06 17:41:14
-- 碎片列表

local heros_fragments_view = class("heros_fragments_view")

local class_heros_fragments_item = import("app.views.gameWorld.heros.heros_fragments_item_node.lua")

function heros_fragments_view:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self.listitems = {}
    self:updateScroll(true)
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self._rootNode:setVisible(false)

end

--初始化数据
function heros_fragments_view:_initData()
	-- body
    self.itemModel = cc.CSLoader:createNode("ui_instance/heros/heros_fragments_item_node.csb")
end

function heros_fragments_view:updateScroll(scroll)
	-- body
	-- MAIN_PLAYER.heroManager.fragments
	local offy = math.ceil(#MAIN_PLAYER.heroManager.fragments/2)
    local offy2 = offy
    -- 不足一屏的时候列表置顶
    if offy2 < 4.4 then
        offy2 = 4.4
    end
    self.scrollview = self._rootNode:getChildByName("scrollview")
    if #MAIN_PLAYER.heroManager.fragments == 0 then
        for i=1,#self.listitems do
            self.listitems[i]:getResourceNode():setVisible(false)
        end
    elseif #MAIN_PLAYER.heroManager.fragments > #self.listitems then
        for i=#self.listitems+1,#MAIN_PLAYER.heroManager.fragments do
            self.listitems[i] = self:createItems(i)
            self.scrollview:addChild(self.listitems[i]:getResourceNode())
        end
    else
        for i=#MAIN_PLAYER.heroManager.fragments,#self.listitems do
            self.listitems[i]:getResourceNode():setVisible(false)
        end
    end

    -- 重置位置,加入数据
    for i=1,#MAIN_PLAYER.heroManager.fragments do
        self.listitems[i]:getResourceNode():setPosition(cc.p(445*((i-1)%2), 10+120* (offy2 - math.ceil(i/2))))
        self.listitems[i]:update(MAIN_PLAYER.heroManager.fragments[i])
        self.listitems[i]:getResourceNode():setVisible(true)
    end

    local size = cc.size(16, 120*offy+10)
    self.scrollview:setInnerContainerSize(size)

    if scroll then
	    self.scrollview:jumpToTop()
	end
end

function heros_fragments_view:createItems(dex)
	local item = class_heros_fragments_item.new(
                    self.itemModel:getChildByName("main_layout"):clone()
                )
    return item
end


--注册节点事件
function heros_fragments_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function heros_fragments_view:_registUIEvent()
	-- body
end

--注册全局事件监听器
function heros_fragments_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "heros_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
		-- {modelName = "model_heroManager", eventName = "suipian", callBack=handler(self, self.updateScroll)},
		{modelName = "model_heroManager", eventName = "hecheng", callBack=handler(self, self.updateDisplay)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function heros_fragments_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_fragments_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function heros_fragments_view:updateDisplay()
	-- body
	self:updateScroll()
end

function heros_fragments_view:display()
	-- body
	self._rootNode:setVisible(true)
	self:updateScroll()
end

return heros_fragments_view
