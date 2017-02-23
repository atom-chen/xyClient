--
-- Author: Wu Hengmin
-- Date: 2015-07-10 15:28:40
--

local fuli_buji_view = class("fuli_buji_view")

function fuli_buji_view:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initScrollView()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
end

--初始化数据
function fuli_buji_view:_initData()
	-- body
end

function fuli_buji_view:initScrollView()
	-- body
    self.mainNode = self._rootNode:getChildByName("main_node")
end

--注册节点事件
function fuli_buji_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function fuli_buji_view:_registUIEvent()
	-- body
	local get = self.mainNode:getChildByName("button_get")
	local function getClicked(sender)
		-- 领取福利
		gameTcp:SendMessage(MSG_C2MS_GETBUJI_EVERYDAY)
	end
	get:addClickEventListener(getClicked)
end

--注册全局事件监听器
function fuli_buji_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "fuli_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function fuli_buji_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function fuli_buji_view:getResourceNode()
    -- body
    return self._rootNode
end

function fuli_buji_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function fuli_buji_view:display(target)
	-- body
	self._rootNode:setVisible(true)
	self:updateMainNode()
end

function fuli_buji_view:updateMainNode()
    -- body
    -- self.mainNode

end

return fuli_buji_view
