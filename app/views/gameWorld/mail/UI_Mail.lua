--
-- Author: Wu Hengmin
-- Date: 2015-07-08 11:05:29
--

local UI_Mail = class("UI_Mail", cc.load("mvc").ViewBase)

local class_mail_navigation_node = import(".mail_navigation_node")
local class_mail_view = import("app.views.gameWorld.mail.mail_scrollview.lua")

UI_Mail.RESOURCE_FILENAME = "ui_instance/mail/mail_layer.csb"

function UI_Mail:onCreate()
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
function UI_Mail:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Mail:_createControlerForUI()
	self._controlerMap = {}

	-- 导航按钮
	self._controlerMap.navigation = class_mail_navigation_node.new(
		self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
	)

	-- 滚动框
	self._controlerMap.view = class_mail_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("scrollview")
	)

	self.rootNode:getChildByName("guide"):setSwallowTouches(false)
	self._controlerMap.view:updateScrollview(1, true)
end

function UI_Mail:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)
end

function UI_Mail:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "mail_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Mail:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Mail:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self._controlerMap.view:updateScrollview(sender.index, true)
end

function UI_Mail:close(res)
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


function UI_Mail:_initDynamicResConfig()
	ResConfig["ui_image/mail/mail"] = {
		restype = "plist",
		respath = "ui_image/mail/",
		res = {"mail"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/mail/mail",
	}
end

return UI_Mail
