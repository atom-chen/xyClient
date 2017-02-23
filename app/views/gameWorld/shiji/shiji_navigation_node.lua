--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:06:51
--

local shiji_navigation_node = class("shiji_navigation_node")


function shiji_navigation_node:ctor(node)
	-- body
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initNavigation()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

end

function shiji_navigation_node:initNavigation()
	-- body
	
end

--初始化数据
function shiji_navigation_node:_initData()
	-- body
end

--注册节点事件
function shiji_navigation_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function shiji_navigation_node:_registUIEvent()
	-- body
end

--注册全局事件监听器
function shiji_navigation_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "shiji_ctrl", eventName = "clickSubTitleList", callBack=handler(self, self.onClicked)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function shiji_navigation_node:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end


return shiji_navigation_node
