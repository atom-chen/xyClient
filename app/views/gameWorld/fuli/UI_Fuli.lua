--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:40:57
--


local UI_Fuli = class("UI_Fuli", cc.load("mvc").ViewBase)

local class_vip_view = import(".views.fuli_vip_view")
local class_monthy_view = import(".views.fuli_monthy_view")
local class_buji_view = import(".views.fuli_buji_view")

UI_Fuli.RESOURCE_FILENAME = "ui_instance/fuli/fuli_layer.csb"

UI_Fuli.list = {
	{
		name = "礼包",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "月卡",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
	{
		name = "补给",
		textures = {
			"ui_image/common/image/tab_0.png",
			"ui_image/common/image/tab_1.png",
			"ui_image/common/image/tab_0.png",
		},
	},
}

function UI_Fuli:onCreate()
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

    self:updateDisplay(1)

end

--注册节点事件
function UI_Fuli:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Fuli:_createControlerForUI()
	self._controlerMap = {}

	-- 导航按钮
	-- self._controlerMap.navigation = class_fuli_navigation_node.new(
	-- 	self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
	-- )

	self._controlerMap.view = {}
	-- vip礼包
	self._controlerMap.view.vip = class_vip_view.new(
		self.rootNode:getChildByName("ProjectNode_3")
	)

	-- 月卡
	self._controlerMap.view.monthy = class_monthy_view.new(
		self.rootNode:getChildByName("ProjectNode_4")
	)

	-- 补给
	self._controlerMap.view.buji = class_buji_view.new(
		self.rootNode:getChildByName("ProjectNode_5")
	)


	local function onClicked(sender, eventType)
		-- body
		if eventType == ccui.TouchEventType.began then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.moved then
	        globalTouchEvent(sender,eventType)
	    elseif eventType == ccui.TouchEventType.ended then
	        if globalTouchEvent(sender,eventType) then
	            -- 改变按钮状态
	            if sender.index == 2 then
	            	gameTcp:SendMessage(MSG_C2MS_OPEN_YUEKA)
	            	-- self:openFuchou()
	        	else
		            self:updateButton(sender.index)
		            self:updateDisplay(sender.index)
		        end
	        end
	    elseif eventType == ccui.TouchEventType.canceled then

	    end
	end

	self.tabs = {}
	self.tabs[1] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_1")
	self.tabs[1].index = 1
	self.tabs[1]:addTouchEventListener(onClicked)

	self.tabs[2] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_2")
	self.tabs[2].index = 2
	self.tabs[2]:addTouchEventListener(onClicked)

	self.tabs[3] = self.resourceNode_:getChildByName("main_layout"):getChildByName("tab_3")
	self.tabs[3].index = 3
	self.tabs[3]:addTouchEventListener(onClicked)

	self:updateButton(1)
end

function UI_Fuli:updateButton(index)
	-- body
	for i=1,#self.tabs do
		if index == i then
			self.tabs[i]:loadTexture(self.list[i].textures[2], ccui.TextureResType.plistType)
		else
			self.tabs[i]:loadTexture(self.list[i].textures[1], ccui.TextureResType.plistType)
		end
	end
end

function UI_Fuli:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)
end

function UI_Fuli:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_OPEN_YUEKA), callBack=handler(self, self.swicthToY)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Fuli:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- function UI_Fuli:switchDisplay(target)
-- 	-- body
--     if self.target == target then
--         return
--     else
--         self.target = target
--     end
-- 	if target == "VIP礼包" then
--         self:gotoDisplay()
-- 	elseif target == "月卡" then
--         gameTcp:SendMessage(MSG_C2MS_OPEN_YUEKA)
-- 	elseif target == "补给" then
--         self:gotoDisplay()
-- 	else

-- 	end
-- end

function UI_Fuli:swicthToY()
	-- body
	self:updateDisplay(2)
	self:updateButton(2)
end

function UI_Fuli:updateDisplay(index)
	-- body
	if index and type(index) == "number" then
		self.index = index
	end

	if self.index == 1 then
        self._controlerMap.view.vip:getResourceNode():setVisible(true)
        self._controlerMap.view.monthy:getResourceNode():setVisible(false)
        self._controlerMap.view.buji:getResourceNode():setVisible(false)
        self._controlerMap.view.vip:updateScrollview(true)
	elseif self.index == 2 then
        self._controlerMap.view.monthy:getResourceNode():setVisible(true)
        self._controlerMap.view.buji:getResourceNode():setVisible(false)
        self._controlerMap.view.vip:getResourceNode():setVisible(false)
        self._controlerMap.view.monthy:updateMainNode()
	elseif self.index == 3 then
        self._controlerMap.view.buji:getResourceNode():setVisible(true)
        self._controlerMap.view.monthy:getResourceNode():setVisible(false)
        self._controlerMap.view.vip:getResourceNode():setVisible(false)
        self._controlerMap.view.buji:updateMainNode()
	else

	end
end

function UI_Fuli:close(res)
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

function UI_Fuli:_initDynamicResConfig()
	ResConfig["ui_image/fuli/fuli"] = {
		restype = "plist",
		respath = "ui_image/fuli/",
		res = {"fuli"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/fuli/fuli",
	}
end

return UI_Fuli
