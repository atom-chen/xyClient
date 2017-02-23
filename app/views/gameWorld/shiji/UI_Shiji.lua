--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:40:57
--


local UI_Shiji = class("UI_Shiji", cc.load("mvc").ViewBase)

local class_shiji_navigation_node = import(".shiji_navigation_node")
local class_shiji_view = import(".shiji_scrollview")

UI_Shiji.RESOURCE_FILENAME = "ui_instance/shiji/shiji_layer.csb"

function UI_Shiji:onCreate()
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
function UI_Shiji:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Shiji:_createControlerForUI()
	self._controlerMap = {}

	-- 导航按钮
	self._controlerMap.navigation = class_shiji_navigation_node.new(
		self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
	)

	-- -- 滚动框
	self._controlerMap.view = class_shiji_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("scrollview")
	)


	-- self.rootNode:getChildByName("guide"):setSwallowTouches(false)
	self._controlerMap.view:updateScrollview(1)
end

function UI_Shiji:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)
end

function UI_Shiji:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "shiji_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
        {modelName = "model_playerBaseAttr", eventName = "goldChange", callBack=handler(self, self.updateYinliang)},
        {modelName = "model_playerBaseAttr", eventName = "yuanBaoChange", callBack=handler(self, self.updateYuanbao)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Shiji:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Shiji:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Shiji:close(res)
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				self:removeFromParent(true)
				shijiSystemInstance.display = false
				release_res(res)
			end
		})
end

function UI_Shiji:_initDynamicResConfig()
	ResConfig["ui_image/shiji/shiji"] = {
		restype = "plist",
		respath = "ui_image/shiji/",
		res = {"shiji"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/shiji/shiji",
	}
end

function UI_Shiji:updateYuanbao()
    -- body
    self.rootNode:getChildByName("guide"):getChildByName("yuanbao"):getChildByName("count"):setString(MAIN_PLAYER.baseAttr._yuanBao)
end

function UI_Shiji:updateYinliang()
    -- body
    self.rootNode:getChildByName("guide"):getChildByName("yinliang"):getChildByName("count"):setString(MAIN_PLAYER.baseAttr._gold)
end

return UI_Shiji
