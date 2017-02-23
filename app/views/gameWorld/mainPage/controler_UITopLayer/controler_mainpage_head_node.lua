--
-- Author: lipeng
-- Date: 2015-06-29 09:37:00
-- 控制器: 头像UI


local controler_mainpage_head_node = class("controler_mainpage_head_node")

--[[监听全局事件名预览
eventModleName: model_playerBaseAttr
eventName: 
	nameChange 	--名字改变
	goldChange 	--银两改变
	tiLiChange 	--体力改变
	jingLiChange --精力改变
	expChange	--经验改变
	vipLvChange --VIP等级改变
	setUIVisible     --设置显示状态
]]


function controler_mainpage_head_node:ctor(headNode)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._headNode = headNode
	self._headNode:setContentSize(visibleSize)
 	ccui.Helper:doLayout(self._headNode)

 	self._expLoadingBar = self._headNode:getChildByName("exp")

    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()
end


function controler_mainpage_head_node:getView()
	return self._headNode
end


--初始化数据
function controler_mainpage_head_node:_initModels()
	-- body
end

function controler_mainpage_head_node:updateAllView(player)
	local baseAttr = player:getBaseAttr()
	self:_updateView_name(baseAttr:getName())
	self:_updateView_gold(baseAttr:getGold())
	self:_updateView_exp(baseAttr:getExp(), baseAttr:getLvUpNeedExp())
	self:_updateView_yuanBao(baseAttr:getYuanBao())
	self:_updateView_VIPLv(baseAttr:getVIPLv())
	self:_updateView_Lv(baseAttr:getLv())
	self:_updateView_juewei(baseAttr:getTitle())
end

--注册节点事件
function controler_mainpage_head_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
        	self:_removeAllGlobalEventListeners()
        end
    end
    self._headNode:registerScriptHandler(onNodeEvent)
end


--注册UI事件
function controler_mainpage_head_node:_registUIEvent()
	--背景
    local function btn_touxiang_frameCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            dispatchGlobaleEvent("controler_mainpage_head_node", "btn_touxiang_frame_touched", {sender=sender, eventType=eventType})
        end
    end
    local btn_touxiang_frame = self._headNode:getChildByName("btn_touxiang_frame")
    btn_touxiang_frame:addTouchEventListener(btn_touxiang_frameCallback)
	
	--爵位
    local function btn_jueweiCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            dispatchGlobaleEvent("controler_mainpage_head_node", "juewei_touched", {sender=sender, eventType=eventType})
        end
    end
    local btn_juewei = self._headNode:getChildByName("btn_juewei")
    btn_juewei:addTouchEventListener(btn_jueweiCallback)
end

--注册全局事件监听器
function controler_mainpage_head_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_playerBaseAttr", eventName = "nameChange", callBack=handler(self, self._onNameChange)},
		{modelName = "model_playerBaseAttr", eventName = "goldChange", callBack=handler(self, self._onGoldChange)},
		{modelName = "model_playerBaseAttr", eventName = "expChange", callBack=handler(self, self._onExpChange)},
		{modelName = "model_playerBaseAttr", eventName = "yuanBaoChange", callBack=handler(self, self._onYuanBaoChange)},
		{modelName = "model_playerBaseAttr", eventName = "vipLvChange", callBack=handler(self, self._onVIPLvChange)},
		{modelName = "model_playerBaseAttr", eventName = "levelChange", callBack=handler(self, self._onLvChange)},
		{modelName = "net", eventName = tostring(MSG_MS2C_ROLE_UPDATA_PEERAGE_INFO), callBack=handler(self, self._onMSG_MS2C_ROLE_UPDATA_PEERAGE_INFO)},
		{modelName = "model_playerBaseAttr", eventName = "setUIVisible", callBack=handler(self, self._onSetUIVisible)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--移除全局事件监听器
function controler_mainpage_head_node:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end


function controler_mainpage_head_node:_updateView_name( name )
	local text_playerName = self._headNode:getChildByName("text_playerName")
	text_playerName:setString(name)
end

function controler_mainpage_head_node:_updateView_gold( gold )
	local text_yinliang_value = self._headNode:getChildByName("text_yinliang_value")
	text_yinliang_value:setString(gold)
end



function controler_mainpage_head_node:_updateView_exp( curExp, maxExp )
	--当前经验占升级需要经验的百分比
	local expPercentage = curExp/maxExp
	printInfo("function controler_mainpage_head_node:_updateView_exp")
	print(expPercentage, curExp, maxExp)
	local percent = math.floor(expPercentage*100)
	self._expLoadingBar:setPercent(percent)
end


function controler_mainpage_head_node:_updateView_yuanBao( yuanBao )
	local text_yuanbao_value = self._headNode:getChildByName("text_yuanbao_value")
	text_yuanbao_value:setString(yuanBao)
end


function controler_mainpage_head_node:_updateView_VIPLv( vipLv )
	local text_vipValue = self._headNode:getChildByName("text_vipValue")
	text_vipValue:setString(vipLv)
end

function controler_mainpage_head_node:_updateView_Lv( Lv )
	local als_lv = self._headNode:getChildByName("als_lv")
	als_lv:setString(Lv)
end


function controler_mainpage_head_node:_updateView_juewei( jueweiLv )
	local btn_juewei = self._headNode:getChildByName("btn_juewei")
	local iconImg = MAIN_PLAYER:getBaseAttr():getTitleIcon()

	widgetHelper:loadTexturesWithPlistForBtn(
		btn_juewei, 
		iconImg, 
		iconImg, 
		iconImg)
end



--[[
全局事件响应
]]
--玩家名改变
function controler_mainpage_head_node:_onNameChange( event )
	local eventUseData = event._usedata
	
	self:_updateView_name(eventUseData.name)
end

--银两改变
function controler_mainpage_head_node:_onGoldChange( event )
	local eventUseData = event._usedata
	
	self:_updateView_gold(eventUseData.gold)
	
end


--体力改变
function controler_mainpage_head_node:_onTiLiChange( event )
	local eventUseData = event._usedata
	
	self:_updateView_tiLi(eventUseData.tiLi, eventUseData.maxTiLi)
end

--精力改变
function controler_mainpage_head_node:_onJingLiChange( event )
	local eventUseData = event._usedata

	self:_updateView_jingLi(eventUseData.jingLi, eventUseData.maxJingLi)
end

--经验改变
function controler_mainpage_head_node:_onExpChange( event )
	local eventUseData = event._usedata

	self:_updateView_exp(eventUseData.exp, eventUseData.lvUpNeedExp)
end


--元宝改变
function controler_mainpage_head_node:_onYuanBaoChange( event )
	local eventUseData = event._usedata
	self:_updateView_yuanBao(eventUseData.yuanBao)
end


--vip等级改变
function controler_mainpage_head_node:_onVIPLvChange( event )
	local eventUseData = event._usedata
	
	self:_updateView_VIPLv(eventUseData.vipLv)
end

--玩家等级改变
function controler_mainpage_head_node:_onLvChange( event )
	local eventUseData = event._usedata
	
	self:_updateView_Lv(eventUseData.lv)
end

function controler_mainpage_head_node:_onMSG_MS2C_ROLE_UPDATA_PEERAGE_INFO( event )
	self:_updateView_juewei(MAIN_PLAYER:getBaseAttr():getTitle())
end


--设置可见状态
function controler_mainpage_head_node:_onSetUIVisible( event )
	local eventUseData = event._usedata
    local visibleType = eventUseData.visibleType

    --隐藏所有
    if visibleType == "hideAll" then
        self._headNode:setVisible(false)

    --显示所有
    elseif visibleType == "showAll" then
        self._headNode:setVisible(true)
    end
end



return controler_mainpage_head_node

