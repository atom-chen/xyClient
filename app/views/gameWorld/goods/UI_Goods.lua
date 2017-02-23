--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 道具界面

local UI_Goods = class("UI_Goods", cc.load("mvc").ViewBase)

local class_goods_navigation_node = import("app.views.gameWorld.goods.goods_navigation_node.lua")
local class_goods_view = import("app.views.gameWorld.goods.goods_scrollview.lua")

UI_Goods.RESOURCE_FILENAME = "ui_instance/goods/goods_layer.csb"

function UI_Goods:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()

	self.rootNode = self.resourceNode_:getChildByName("main_layout")

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

    self:updateYinliang()
    self:updateYuanbao()
end

--注册节点事件
function UI_Goods:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Goods:_createControlerForUI()
	self._controlerMap = {}

	-- 导航按钮
	self._controlerMap.navigation = class_goods_navigation_node.new(
		self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
	)

	-- 滚动框
	self._controlerMap.view = class_goods_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("scrollview")
	)


	self.rootNode:getChildByName("guide"):setSwallowTouches(false)
	self._controlerMap.view:updateScrollview(1)
end

function UI_Goods:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)
end

function UI_Goods:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "goods_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
        {modelName = "model_playerBaseAttr", eventName = "goldChange", callBack=handler(self, self.updateYinliang)},
        {modelName = "model_playerBaseAttr", eventName = "yuanBaoChange", callBack=handler(self, self.updateYuanbao)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Goods:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Goods:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Goods:close(res)
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

function UI_Goods:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function UI_Goods:updateYuanbao()
	-- body
	self.rootNode:getChildByName("guide"):getChildByName("yuanbao_count"):setString(MAIN_PLAYER.baseAttr._yuanBao)
end

function UI_Goods:updateYinliang()
	-- body
	self.rootNode:getChildByName("guide"):getChildByName("yinliang_count"):setString(MAIN_PLAYER.baseAttr._gold)
	print(MAIN_PLAYER.baseAttr._gold)
end


return UI_Goods
