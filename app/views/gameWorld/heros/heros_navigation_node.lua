--
-- Author: Wu Hengmin
-- Date: 2015-07-01 19:17:55
-- 导航栏

local heros_navigation_node = class("heros_navigation_node")

local class_heros_navigation_item_node = import(".heros_navigation_item_node")

heros_navigation_node.list = {
	{
		name = "武将列表",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_0_0.png",
			"ui_image/heros/buttons/heros_navigation_button_0_1.png",
			"ui_image/heros/buttons/heros_navigation_button_0_1.png",
		},
	},
	{
		name = "武将升级",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_1_0.png",
			"ui_image/heros/buttons/heros_navigation_button_1_1.png",
			"ui_image/heros/buttons/heros_navigation_button_1_1.png",
		},
	},
	{
		name = "武将觉醒",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_2_0.png",
			"ui_image/heros/buttons/heros_navigation_button_2_1.png",
			"ui_image/heros/buttons/heros_navigation_button_2_1.png",
		},
	},
	{
		name = "职业强化",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_9_0.png",
			"ui_image/heros/buttons/heros_navigation_button_9_1.png",
			"ui_image/heros/buttons/heros_navigation_button_9_1.png",
		},
	},
	{
		name = "武将技能",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_3_0.png",
			"ui_image/heros/buttons/heros_navigation_button_3_1.png",
			"ui_image/heros/buttons/heros_navigation_button_3_1.png",
		},
	},
	{
		name = "武将重生",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_4_0.png",
			"ui_image/heros/buttons/heros_navigation_button_4_1.png",
			"ui_image/heros/buttons/heros_navigation_button_4_1.png",
		},
	},
	{
		name = "武将碎化",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_6_0.png",
			"ui_image/heros/buttons/heros_navigation_button_6_1.png",
			"ui_image/heros/buttons/heros_navigation_button_6_1.png",
		},
	},
	{
		name = "碎片列表",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_5_0.png",
			"ui_image/heros/buttons/heros_navigation_button_5_1.png",
			"ui_image/heros/buttons/heros_navigation_button_5_1.png",
		},
	},
	{
		name = "武将招募",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_8_0.png",
			"ui_image/heros/buttons/heros_navigation_button_8_1.png",
			"ui_image/heros/buttons/heros_navigation_button_8_1.png",
		},
	},
	{
		name = "武将图鉴",
		textures = {
			"ui_image/heros/buttons/heros_navigation_button_7_0.png",
			"ui_image/heros/buttons/heros_navigation_button_7_1.png",
			"ui_image/heros/buttons/heros_navigation_button_7_1.png",
		},
	},
}

function heros_navigation_node:ctor(node)
	-- body
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)


    self:initNavigation()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self:updateButton(1)
end

function heros_navigation_node:initNavigation()
	-- body
	self.navigation = self._rootNode:getChildByName("navigation_list")
	
	local subTitleModel = class_heros_navigation_item_node:new()

	local itemModel = subTitleModel:getModelNode()
	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	        	self:updateButton(sender.index)
	            dispatchGlobaleEvent("heros_ctrl", "clickSubTitleButtom", {sender=sender})
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
    end
    itemModel:addTouchEventListener(touchEvent)

    self.navigation:setItemModel(itemModel)

    for i=1,#self.list do
		self.navigation:pushBackDefaultItem()
		self.navigation:getItems()[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		self.navigation:getItems()[i].index = i


    end
    -- local node = ccui.Layout:create()
    -- node:setContentSize(cc.size(0, 200))
    -- self.navigation:pushBackCustomItem(node)

end

--初始化数据
function heros_navigation_node:_initData()
	-- body
end

--注册节点事件
function heros_navigation_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function heros_navigation_node:_registUIEvent()
	-- body
end

--注册全局事件监听器
function heros_navigation_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "heros_ctrl", eventName = "clickSubTitleList", callBack=handler(self, self.onClicked)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function heros_navigation_node:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_navigation_node:updateButton(index)
	-- body
	print("updateButton:"..index)
	local navigation_items = self.navigation:getItems()
	for i=1,#navigation_items do
		if index == i then
			navigation_items[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			navigation_items[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end

end


return heros_navigation_node