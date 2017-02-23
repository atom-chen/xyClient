--
-- Author: Wu Hengmin
-- Date: 2015-07-03 11:48:30
--

local huodong_scrollview = class("huodong_scrollview")

local class_huodong_item = import(".huodong_item")
local calss_huodong_qiandao_item = import(".huodong_qiandao_item")

function huodong_scrollview:ctor(node)

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._rootNode = node
    self._rootNode:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._rootNode)

    self:initScrollView()
    self:_initData()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()

    -- self._rootNode:setVisible(false)
    self.qiandaoModel = cc.CSLoader:createNode("ui_instance/huodong/huodong_qiandao_item.csb")
    self.qiandaoModel:retain()
end

--初始化数据
function huodong_scrollview:_initData()
	-- body
    -- 签到控制面板
    self.ctrl_node = self._rootNode:getChildByName("ctrl_node")

    
end

function huodong_scrollview:initScrollView()
	-- body
    -- 滚动框
    self.scrollview = self._rootNode:getChildByName("scrollview")
end

--注册节点事件
function huodong_scrollview:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)
end

--注册UI事件
function huodong_scrollview:_registUIEvent()
	-- body
    local button_q = self.ctrl_node:getChildByName("button_qd")
    local function qClicked(sender)
        -- 签到
        gameTcp:SendMessage(MSG_C2MS_QIANDAO)
    end
    button_q:addClickEventListener(qClicked)

    local button_b = self.ctrl_node:getChildByName("button_bq")
    local function bClicked(sender)
        -- 补签
        gameTcp:SendMessage(MSG_C2MS_BUQIAN)
    end
    button_b:addClickEventListener(bClicked)

end

--注册全局事件监听器
function huodong_scrollview:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "huodong_ctrl", eventName = "refreshlist", callBack=handler(self, self.updateScrollview)}, 
		
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
	
end

--移除全局事件监听器
function huodong_scrollview:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function huodong_scrollview:updateScrollview(mode)
    -- body
    if self.displaymode == mode then
        return
    end
    if type(mode) == "userdata" then
        mode = nil
    end
    self.displaymode = mode or self.displaymode

    self.scrollview:removeAllChildren()
    self.items = {}

    if self.displaymode == 1 then -- 签到
        self.ctrl_node:setVisible(true)
        local offy = math.ceil(#qiandao_rewardCfg/8)
        local offy2 = offy
        -- 不足一屏的时候列表置顶
        if offy2 < 4.19 then
            offy2 = 4.19
        end
        for i=1,#qiandao_rewardCfg do
            self.items[i] = calss_huodong_qiandao_item.new(
                    self.qiandaoModel:getChildByName("main_layout"):clone()
                )
            self.items[i]:getResourceNode():setPosition(10 + 110*((i-1)%8), 10 + 110*(offy2-(math.ceil(i/8))))

            self.items[i]:update(qiandao_rewardCfg[i])
            if MAIN_PLAYER.qiandaoManager.leiji >= i then
                self.items[i]:getResourceNode():getChildByName("shadow"):setVisible(true)
            else
                self.items[i]:getResourceNode():getChildByName("shadow"):setVisible(false)
            end
            self.scrollview:addChild(self.items[i]:getResourceNode())
        end



        local size = cc.size(0, 110*offy+120)
        self.scrollview:setInnerContainerSize(size)
        self.scrollview:jumpToTop()

        -- 更新签到信息
        local count1 = self.ctrl_node:getChildByName("count1")
        count1:setString("已签到:"..MAIN_PLAYER.qiandaoManager.leiji.."次")

        local count2 = self.ctrl_node:getChildByName("count2")
        count2:setString("可补签:"..MAIN_PLAYER.qiandaoManager.kebuqian.."次")

    elseif self.displaymode == 2 then -- 充值活动
        self.ctrl_node:setVisible(false)
    elseif self.displaymode == 3 then -- 其他活动
        self.ctrl_node:setVisible(false)
    end


end

return huodong_scrollview
