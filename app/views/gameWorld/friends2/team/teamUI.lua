--
-- Author: Wu Hengmin
-- Date: 2015-09-14 14:22:25
--

local teamUI = class("teamUI", cc.load("mvc").ViewBase)

teamUI.RESOURCE_FILENAME = "ui_instance/friends2/team/team2_team_node.csb"

function teamUI:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()


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

    -- self.itemModel = cc.CSLoader:createNode("ui_instance/friends2/friends_view.csb")
    -- self.itemModel:retain()

	-- self:updateDisplay(1)
end

--注册节点事件
function teamUI:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function teamUI:_createControlerForUI()
	-- self.views = class_friends_pageview.new(
	-- 		self.resourceNode_:getChildByName("main_layout"):getChildByName("guide"):getChildByName("PageView_1")
	-- 	)

end

function teamUI:_registButtonEvent()
	-- body
	local button = self.resourceNode_:getChildByName("main_layout"):getChildByName("btn_close")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)

	
end

function teamUI:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "model_friendsManager", eventName = "refreshfriends", callBack=handler(self, self.refreshfriends)},
		-- {modelName = "model_marketManager", eventName = "refreshlist", callBack=handler(self, self.updateDisplay)},
		-- {modelName = "model_friendsManager", eventName = "refreshinvite", callBack=handler(self, self.refreshinvite)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function teamUI:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function teamUI:close(res)
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


function teamUI:_initDynamicResConfig()
	ResConfig["ui_image/goods/goods"] = {
		restype = "plist",
		respath = "ui_image/goods/",
		res = {"goods"}
	}

	self._dynamicResConfigIDs = {
		"ui_image/goods/goods",
	}
end

function teamUI:update(data)
	-- body

end


return teamUI
