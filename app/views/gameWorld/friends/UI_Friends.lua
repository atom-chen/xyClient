--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 好友界面

local UI_Friends = class("UI_Friends", cc.load("mvc").ViewBase)

local class_friends_navigation_node = import("app.views.gameWorld.friends.friends_navigation_node.lua")
local class_friends_view = import("app.views.gameWorld.friends.friends_scrollview.lua")

UI_Friends.RESOURCE_FILENAME = "ui_instance/friends/friends_layer.csb"

function UI_Friends:onCreate()
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
function UI_Friends:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Friends:_createControlerForUI()
	self._controlerMap = {}

	-- 导航按钮
	self._controlerMap.navigation = class_friends_navigation_node.new(
		self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
	)

	-- 滚动框
	self._controlerMap.view = class_friends_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("scrollview")
	)


	self.rootNode:getChildByName("guide"):setSwallowTouches(false)
	self._controlerMap.view:updateScrollview(1)
end

function UI_Friends:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)
end

function UI_Friends:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "friends_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Friends:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Friends:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index)
end

function UI_Friends:close(res)
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

function UI_Friends:_initDynamicResConfig()
	ResConfig["ui_image/friends/friends"] = {
		restype = "plist",
		respath = "ui_image/friends/",
		res = {"friends"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/friends/friends",
	}
end

return UI_Friends
