--
-- Author: Wu Hengmin
-- Date: 2015-08-10 10:35:40
-- 招募


local heros_zhaomu_view = class("heros_zhaomu_view")

function heros_zhaomu_view:ctor(node)
	self:_initData()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
	self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self._rootNode:setVisible(false)

end

--初始化数据
function heros_zhaomu_view:_initData()
	-- body

end

--注册节点事件
function heros_zhaomu_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function heros_zhaomu_view:_registUIEvent()
	-- body
	
	local button1 = self._rootNode:getChildByName("main_layout"):getChildByName("Button_2")
	local function clicked1(sender)
        UIManager:createZhaomuDialog({1,1,1,1,1})
        -- gameTcp:SendMessage(MSG_C2MS_DRAW_HERO, {2})
    end
    button1:addClickEventListener(clicked1)
	
	local button2 = self._rootNode:getChildByName("main_layout"):getChildByName("Button_2_0")
	local function clicked2(sender)
        UIManager:createZhaomuDialog({1,1,1,1,1,1,1,1})
        -- gameTcp:SendMessage(MSG_C2MS_DRAW_HERO, {3})
    end
    button2:addClickEventListener(clicked2)
end

--注册全局事件监听器
function heros_zhaomu_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "heros_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
		-- {modelName = "model_heroManager", eventName = "suipian", callBack=handler(self, self.updateScroll)},
		-- {modelName = "model_heroManager", eventName = "hecheng", callBack=handler(self, self.updateDisplay)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--移除全局事件监听器
function heros_zhaomu_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function heros_zhaomu_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function heros_zhaomu_view:display()
	-- body
	self._rootNode:setVisible(true)
end

return heros_zhaomu_view
