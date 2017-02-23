--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:40:57
--


local UI_Trial = class("UI_Trial", cc.load("mvc").ViewBase)


UI_Trial.RESOURCE_FILENAME = "ui_instance/trial/trial_layer.csb"

function UI_Trial:onCreate()
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

end

--注册节点事件
function UI_Trial:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Trial:_createControlerForUI()
	self._controlerMap = {}

end

function UI_Trial:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)


	local boss_node_1 = self.rootNode:getChildByName("boss_node_1")
	local function clicked1(sender)
		print("boss_1")
		
		gameTcp:SendMessage(MSG_C2MS_CAMPAIGN_BOSS_INFO, {101})
	end
	boss_node_1:addClickEventListener(clicked1)

	local boss_node_2 = self.rootNode:getChildByName("boss_node_2")
	local function clicked2(sender)
		print("boss_2")
	end
	boss_node_2:addClickEventListener(clicked2)

	local boss_node_3 = self.rootNode:getChildByName("boss_node_3")
	local function clicked3(sender)
		print("boss_3")
	end
	boss_node_3:addClickEventListener(clicked3)

	local boss_node_4 = self.rootNode:getChildByName("boss_node_4")
	local function clicked4(sender)
		print("boss_4")
	end
	boss_node_4:addClickEventListener(clicked4)
end

function UI_Trial:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "shiji_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
        
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Trial:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function UI_Trial:close(res)
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

function UI_Trial:_initDynamicResConfig()
	ResConfig["ui_image/trial/trial"] = {
		restype = "plist",
		respath = "ui_image/trial/",
		res = {"trial"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/trial/trial",
	}
end

return UI_Trial
