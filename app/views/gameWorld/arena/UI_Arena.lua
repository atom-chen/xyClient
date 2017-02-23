--
-- Author: Wu Hengmin
-- Date: 2015-07-03 10:19:02
-- 竞技场界面

local UI_Arena = class("UI_Arena", cc.load("mvc").ViewBase)

-- local class_goods_navigation_node = import("app.views.gameWorld.goods.goods_navigation_node.lua")
-- local class_goods_view = import("app.views.gameWorld.goods.goods_scrollview.lua")
local class_arena_view_1 = import("app.views.gameWorld.arena.arena_view_1")
local class_arena_view_2 = import("app.views.gameWorld.arena.arena_view_2")
local class_arena_view_3 = import("app.views.gameWorld.arena.arena_view_3")
local class_arena_view_4 = import("app.views.gameWorld.arena.arena_view_4")

UI_Arena.RESOURCE_FILENAME = "ui_instance/arena/arena_layer.csb"

function UI_Arena:onCreate()
	-- body
	self:_registNodeEvent()
	self:_registGlobalEventListeners()

	self.rootNode = self.resourceNode_:getChildByName("main_layout")

	self:_createControlerForUI()

	self:_registButtonEvent()

	local size= cc.Director:getInstance():getVisibleSize()
    local rootNode = self:getResourceNode()
    rootNode:setContentSize(size)
    ccui.Helper:doLayout(rootNode)
    rootNode:setPosition(cc.p(display.cx - 640 ,display.cy - 360))

    self:updateDisplay()
    self:subtitleClicked(1)
end

--注册节点事件
function UI_Arena:_registNodeEvent()
	local function onNodeEvent(event)
		if "exit" == event then
			self:_removeAllGlobalEventListeners()
		end
	end
	self.resourceNode_:registerScriptHandler(onNodeEvent)
end


function UI_Arena:_createControlerForUI()
	self._controlerMap = {}
	self._controlerMap.view = {}

	self._controlerMap.view[1] = class_arena_view_1:new()
	self.resourceNode_:getChildByName("main_layout"):getChildByName("general_layout"):getChildByName("display_layout"):addChild(self._controlerMap.view[1])

	self._controlerMap.view[2] = class_arena_view_2:new()
	self.resourceNode_:getChildByName("main_layout"):getChildByName("general_layout"):getChildByName("display_layout"):addChild(self._controlerMap.view[2])

	self._controlerMap.view[3] = class_arena_view_3:new()
	self.resourceNode_:getChildByName("main_layout"):getChildByName("general_layout"):getChildByName("display_layout"):addChild(self._controlerMap.view[3])

	self._controlerMap.view[4] = class_arena_view_4:new()
	self.resourceNode_:getChildByName("main_layout"):getChildByName("general_layout"):getChildByName("display_layout"):addChild(self._controlerMap.view[4])

end

function UI_Arena:_registButtonEvent()
	-- body
	local exit = self.rootNode:getChildByName("general_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close()
	end
	exit:addClickEventListener(exitClicked)

	local buy = self.rootNode:getChildByName("name_layout"):getChildByName("buy")
	local function buyClicked(sender)
		-- 发送购买次数消息
		-- gameTcp:SendMessage(MSG_C2MS_PVP_BUY_PLAY_NUM)
	end
	buy:addClickEventListener(buyClicked)

	local button1 = self.rootNode:getChildByName("general_layout"):getChildByName("button_1")
	local function b1Clicked(sender)
		
	end
	button1:addClickEventListener(b1Clicked)

	local button2 = self.rootNode:getChildByName("general_layout"):getChildByName("button_2")
	local function b2Clicked(sender)
		self:subtitleClicked(2)
	end
	button2:addClickEventListener(b2Clicked)

	local button3 = self.rootNode:getChildByName("general_layout"):getChildByName("button_3")
	local function b3Clicked(sender)
		gameTcp:SendMessage(MSG_C2MS_PVP_GET_RANK_INFO, {1})
	end
	button3:addClickEventListener(b3Clicked)

	local button4 = self.rootNode:getChildByName("general_layout"):getChildByName("button_4")
	local function b4Clicked(sender)
		self:subtitleClicked(4)
	end
	button4:addClickEventListener(b4Clicked)

end

function UI_Arena:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_JJCManager", eventName = "rank", callBack=handler(self, self.jumpToRank)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function UI_Arena:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function UI_Arena:close()
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			callback = function ()
				-- body
				self:removeFromParent(true)
			end
		})
end

function UI_Arena:subtitleClicked(dex)
	-- body
	for i=1,#self._controlerMap.view do
		self._controlerMap.view[i]:disable()
	end
	self._controlerMap.view[dex]:updateDisplay()
end

function UI_Arena:updateDisplay()
	-- body
	local node = self.resourceNode_:getChildByName("main_layout"):getChildByName("name_layout")
	local rank = node:getChildByName("rank")
	rank:setString(MAIN_PLAYER.rank)
	local juewei = node:getChildByName("juewei")
	-- juewei:setString()
	local shengyu = node:getChildByName("shengyu")
	-- shengyu:setString()

end

function UI_Arena:jumpToRank()
	-- body
	self:subtitleClicked(3)
end


return UI_Arena
