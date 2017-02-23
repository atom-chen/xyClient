--
-- Author: Wu Hengmin
-- Date: 2015-07-07 17:40:57
--


local UI_Equip = class("UI_Equip", cc.load("mvc").ViewBase)

local class_equip_navigation_node = import(".equip_navigation_node")
local class_equip_view = import(".views.equip_conventional_view")
local class_equip_fenjie_view = import(".views.equip_fenjie_view")
local class_equip_fragment_view = import(".views.equip_fragment_view")

UI_Equip.RESOURCE_FILENAME = "ui_instance/equip/equip_layer.csb"

function UI_Equip:onCreate()
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
function UI_Equip:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Equip:_createControlerForUI()
	self._controlerMap = {}

	-- 导航按钮
	self._controlerMap.navigation = class_equip_navigation_node.new(
		self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
	)

	self._controlerMap.view = {}
	-- 常规视图
	self._controlerMap.view.convantional = class_equip_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("conventional_node")
	)

	-- 分解视图
	self._controlerMap.view.fenjie = class_equip_fenjie_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("fenjie_node")
	)

	-- 碎片视图
	self._controlerMap.view.fragment = class_equip_fragment_view.new(
		self.rootNode:getChildByName("shadow_image"):getChildByName("fragment_node")
	)


	-- self.rootNode:getChildByName("guide"):setSwallowTouches(false)
	-- self._controlerMap.view:updateScrollview(1)
end

function UI_Equip:_registButtonEvent()
	-- body
	local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close(self._dynamicResConfigIDs)
	end
	button:addClickEventListener(exitClicked)
end

function UI_Equip:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "equip_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
        {modelName = "model_playerBaseAttr", eventName = "goldChange", callBack=handler(self, self.updateYinliang)},
        {modelName = "model_playerBaseAttr", eventName = "yuanBaoChange", callBack=handler(self, self.updateYuanbao)},
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Equip:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Equip:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	-- self._controlerMap.view:updateScrollview(sender.index)

	-- sender:setCascadeOpacityEnabled(true)
	-- sender:runAction(cc.FadeOut:create(3))
	self:switchDisplay(class_equip_navigation_node.list[sender.index].name)
end

function UI_Equip:switchDisplay(target, jumpToTop, guid)
	-- body
	print(target)
    if self.target == target then
        return
    else
        self.target = target
    end
	dispatchGlobaleEvent("equip_ctrl", "disableAll", {})
	if target == "装备列表" then
        self._controlerMap.view.convantional:display(target, jumpToTop, guid)
        if guid then
            self._controlerMap.navigation:updateButton(1)
        end
	elseif target == "装备强化" then
		print("进入装备强化")
        self._controlerMap.view.convantional:display(target, jumpToTop, guid)
        if guid then
            self._controlerMap.navigation:updateButton(2)
        end
	elseif target == "装备洗炼" then
        self._controlerMap.view.convantional:display(target, jumpToTop, guid)
        if guid then
            self._controlerMap.navigation:updateButton(3)
        end
    elseif target == "装备分解" then
        self._controlerMap.view.fenjie:display(target)
    elseif target == "装备碎片" then
        self._controlerMap.view.fragment:display(target)
	else

	end
end

function UI_Equip:close(res)
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

function UI_Equip:_initDynamicResConfig()
	ResConfig["ui_image/equip/equip"] = {
		restype = "plist",
		respath = "ui_image/equip/",
		res = {"equip"}
	}


	self._dynamicResConfigIDs = {
		"ui_image/equip/equip",
	}
end

function UI_Equip:updateYuanbao()
    -- body
    self.rootNode:getChildByName("guide"):getChildByName("yuanbao_count"):setString(MAIN_PLAYER.baseAttr._yuanBao)
end

function UI_Equip:updateYinliang()
    -- body
    self.rootNode:getChildByName("guide"):getChildByName("yinliang_count"):setString(MAIN_PLAYER.baseAttr._gold)
end

return UI_Equip
