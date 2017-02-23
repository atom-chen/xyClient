--
-- Author: Wu Hengmin
-- Date: 2015-08-13 10:39:57
--


local wujiang_pageview = class("wujiang_pageview")

function wujiang_pageview:ctor(node)
	-- body
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	
	self._rootNode = node
	-- self._rootNode:setContentSize(visibleSize)
    -- ccui.Helper:doLayout(self._rootNode)

    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()
end

--初始化数据
function wujiang_pageview:_initData()
	-- body
end

function wujiang_pageview:getResourceNode()
	-- body
	return self._rootNode
end

--注册节点事件
function wujiang_pageview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function wujiang_pageview:_registUIEvent()
	-- body
end

--注册全局事件监听器
function wujiang_pageview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		-- {modelName = "equip_ctrl", eventName = "clickSubTitleList", callBack=handler(self, self.onClicked)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function wujiang_pageview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

return wujiang_pageview
