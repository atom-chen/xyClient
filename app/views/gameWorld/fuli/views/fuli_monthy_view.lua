--
-- Author: Wu Hengmin
-- Date: 2015-07-10 15:28:29
--

local fuli_monthy_view = class("fuli_monthy_view")

function fuli_monthy_view:ctor(node)
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
function fuli_monthy_view:_initData()
	-- body
end

function fuli_monthy_view:initScrollView()
	-- body
    self.mainNode = self._rootNode:getChildByName("main_node")
end

--注册节点事件
function fuli_monthy_view:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function fuli_monthy_view:_registUIEvent()
	-- body
	local get1 = self.mainNode:getChildByName("monthy_node"):getChildByName("button_get")
	local function get1Clicked(sender)
		-- 领取月卡
		gameTcp:SendMessage(MSG_C2MS_LINGQU_YUEKA, {1})
	end
	get1:addClickEventListener(get1Clicked)


	local get2 = self.mainNode:getChildByName("monthy_pro_node"):getChildByName("button_get")
	local function get2Clicked(sender)
		-- 领取高级月卡
		gameTcp:SendMessage(MSG_C2MS_LINGQU_YUEKA, {2})
	end
	get2:addClickEventListener(get2Clicked)

end

--注册全局事件监听器
function fuli_monthy_view:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "fuli_ctrl", eventName = "disableAll", callBack=handler(self, self.disable)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function fuli_monthy_view:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function fuli_monthy_view:getResourceNode()
    -- body
    return self._rootNode
end

function fuli_monthy_view:disable()
	-- body
	self._rootNode:setVisible(false)
end

function fuli_monthy_view:display(target)
	-- body
	self._rootNode:setVisible(true)
	self:updateMainNode()
end

function fuli_monthy_view:updateMainNode()
    -- body
    local count1 = self.mainNode:getChildByName("monthy_node"):getChildByName("shengyu")
    count1:setString(MAIN_PLAYER.fuliManager.monthly.count)

    local count2 = self.mainNode:getChildByName("monthy_pro_node"):getChildByName("shengyu")
    count2:setString(MAIN_PLAYER.fuliManager.monthly.count_pro)


end

return fuli_monthy_view
