--
-- Author: Wu Hengmin
-- Date: 2015-07-01 10:38:02
-- 武将界面

local UI_Hero = class("UI_Hero", cc.load("mvc").ViewBase)

local class_heros_item_node = import("app.views.gameWorld.heros.heros_item_node")
local class_heros_navigation_node = import("app.views.gameWorld.heros.heros_navigation_node")

local class_heros_conventional_view = import("app.views.gameWorld.heros.views.heros_conventional_view")
local class_heros_atlas_view = import("app.views.gameWorld.heros.views.heros_atlas_view")
local class_heros_fragments_view = import("app.views.gameWorld.heros.views.heros_fragments_view")
local class_heros_zhaomu_view = import("app.views.gameWorld.heros.views.heros_zhaomu_view")

UI_Hero.RESOURCE_FILENAME = "ui_instance/heros/heros_main_layer.csb"


function UI_Hero:onCreate()
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
    self:updateJingyan()
    self:updateJianghun()
end

--注册节点事件
function UI_Hero:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Hero:_createControlerForUI()
    self._controlerMap = {}

    -- 导航按钮
    self._controlerMap.navigation = class_heros_navigation_node.new(
        self.rootNode:getChildByName("guide"):getChildByName("navigation_node")
    )

    self._controlerMap.view = {}
    -- 常规部分
    self._controlerMap.view.default = class_heros_conventional_view.new(
    	self.rootNode:getChildByName("shadow_image"):getChildByName("conventional_view")
    )

    -- 图鉴部分
    self._controlerMap.view.atlas = class_heros_atlas_view.new(
    	self.rootNode:getChildByName("shadow_image"):getChildByName("atlas_view")
    )

    -- 碎片部分
    self._controlerMap.view.fragments = class_heros_fragments_view.new(
        self.rootNode:getChildByName("shadow_image"):getChildByName("fragments_view")
    )

    -- 招募部分
    self._controlerMap.view.zhaomu = class_heros_zhaomu_view.new(
        self.rootNode:getChildByName("shadow_image"):getChildByName("zhaomu_view")
    )

end

function UI_Hero:_registButtonEvent()
    -- body
    local button = self.rootNode:getChildByName("guide"):getChildByName("button_exit")
    local function exitClicked(sender)
        self:close(self._dynamicResConfigIDs)
    end
    button:addClickEventListener(exitClicked)
end

function UI_Hero:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
        {modelName = "heros_ctrl", eventName = "clickSubTitleButtom", callBack=handler(self, self.subtitleClicked)},
        
        {modelName = "model_playerBaseAttr", eventName = "goldChange", callBack=handler(self, self.updateYinliang)},
        {modelName = "model_playerBaseAttr", eventName = "yuanBaoChange", callBack=handler(self, self.updateYuanbao)},
        {modelName = "model_playerBaseAttr", eventName = "jingyanchiChange", callBack=handler(self, self.updateJingyan)},
        {modelName = "model_playerBaseAttr", eventName = "jianghunChange", callBack=handler(self, self.updateJianghun)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Hero:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

-- 响应点击导航按钮
function UI_Hero:subtitleClicked(event)
	-- body
	local sender = event._usedata.sender
	self:switchDisplay(class_heros_navigation_node.list[sender.index].name)
end

function UI_Hero:switchDisplay(target, guid)
	-- body
    if self.target == target then
        return
    else
        self.target = target
    end

	dispatchGlobaleEvent("heros_ctrl", "disableAll", {})
	if target == "武将列表" then
        self._controlerMap.view.default:display(target)
	elseif target == "武将升级" then
        if guid then
            self._controlerMap.navigation:updateButton(2)
        end
        self._controlerMap.view.default:display(target, guid)
    elseif target == "武将觉醒" then
        if guid then
            self._controlerMap.navigation:updateButton(3)
        end
        self._controlerMap.view.default:display(target, guid)
    elseif target == "职业强化" then
        if guid then
            self._controlerMap.navigation:updateButton(4)
        end
        self._controlerMap.view.default:display(target, guid)
    elseif target == "武将技能" then
        if guid then
            self._controlerMap.navigation:updateButton(5)
        end
        self._controlerMap.view.default:display(target, guid)
    elseif target == "武将重生" then
        if guid then
            self._controlerMap.navigation:updateButton(6)
        end
        self._controlerMap.view.default:display(target, guid)
    elseif target == "碎片列表" then
        self._controlerMap.view.fragments:display()
    elseif target == "武将碎化" then
        if guid then
            self._controlerMap.navigation:updateButton(7)
        end
        self._controlerMap.view.default:display(target, guid)
    elseif target == "武将图鉴" then
        self._controlerMap.view.atlas:display()
    elseif target == "武将招募" then
        self._controlerMap.view.zhaomu:display()
	end
end

function UI_Hero:close(res)
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

function UI_Hero:_initDynamicResConfig()
    ResConfig["ui_image/heros/heros"] = {
        restype = "plist",
        respath = "ui_image/heros/",
        res = {"heros"}
    }
    ResConfig["ui_image/heros/buttons/buttons"] = {
        restype = "plist",
        respath = "ui_image/heros/buttons/",
        res = {"buttons"}
    }


    self._dynamicResConfigIDs = {
        "ui_image/heros/heros",
        "ui_image/heros/buttons/buttons"
    }
end

function UI_Hero:updateYuanbao()
    -- body
    self.rootNode:getChildByName("yuanbao_count"):setString(MAIN_PLAYER.baseAttr._yuanBao)
end

function UI_Hero:updateYinliang()
    -- body
    self.rootNode:getChildByName("yinliang_count"):setString(MAIN_PLAYER.baseAttr._gold)
end

function UI_Hero:updateJingyan()
    -- body
    self.rootNode:getChildByName("jingyan_count"):setString(MAIN_PLAYER.baseAttr._jingyanchi)
end

function UI_Hero:updateJianghun()
    -- body
    self.rootNode:getChildByName("jianghun_count"):setString(MAIN_PLAYER.baseAttr._jianghun)
end


return UI_Hero
