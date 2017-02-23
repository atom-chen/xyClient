--
-- Author: Wu Hengmin
-- Date: 2015-07-08 11:05:29
--

local UI_Huodong = class("UI_Huodong", cc.load("mvc").ViewBase)

local class_huodong_navigation_node = import(".huodong_navigation_node")
local class_huodong_view = import(".huodong_scrollview")

UI_Huodong.RESOURCE_FILENAME = "ui_instance/huodong/huodong_layer.csb"

function UI_Huodong:onCreate()
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

end

--注册节点事件
function UI_Huodong:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Huodong:_createControlerForUI()
	self._controlerMap = {}

	-- 导航按钮
	self._controlerMap.navigation = class_huodong_navigation_node.new(
		self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
	)

	-- 滚动框
	self._controlerMap.view = class_huodong_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("scrollview")
	)


	-- -- self.rootNode:getChildByName("guide"):setSwallowTouches(false)
	self._controlerMap.view:updateScrollview(1)
end

function UI_Huodong:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)
end

function UI_Huodong:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "huodong_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Huodong:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Huodong:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Huodong:close(res)
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

function UI_Huodong:_initDynamicResConfig()
	ResConfig["ui_image/huodong/huodong"] = {
		restype = "plist",
		respath = "ui_image/huodong/",
		res = {"huodong"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/huodong/huodong",
	}
end

return UI_Huodong