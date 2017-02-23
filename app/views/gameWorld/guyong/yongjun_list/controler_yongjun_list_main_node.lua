--
-- Author: lipeng
-- Date: 2015-09-06 20:46:48
-- 佣军列表面板入口节点

local class_controler_yongjun_hero_list = import(".controler_yongjun_hero_list")


local controler_yongjun_list_main_node = class("controler_yongjun_list_main_node")


function controler_yongjun_list_main_node:ctor(yongjun_list_main_node)
	self:_initModels()

	self._yongjun_list_main_node = yongjun_list_main_node

	self:_registUIEvent()
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
	self:_createControlerForUI()
end


function controler_yongjun_list_main_node:getView()
	return self._yongjun_list_main_node
end

function controler_yongjun_list_main_node:getCurPageIdx()
	return self._controlerMap.yongJunList:getCurPageIdx()
end


function controler_yongjun_list_main_node:_initModels()
	self._controlerMap = {}
end

function controler_yongjun_list_main_node:_registUIEvent()
	--刷新
	local btn_shuaxin = self._yongjun_list_main_node:getChildByName("btn_shuaxin")
	local function btn_shuaxinTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local sendData = {}
            sendData[1] = self:getCurPageIdx()
            gameTcp:SendMessage(MSG_C2MS_HIRESYS_HIRELING_INFO, sendData)
            printNetLog("发送消息 MSG_C2MS_HIRESYS_HIRELING_INFO")
        end
	end
	btn_shuaxin:addTouchEventListener(btn_shuaxinTouched)

	--关闭
	local btn_close = self._yongjun_list_main_node:getChildByName("btn_close")
	local function btn_closeTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			guyongSystemInstance:closeGuYongView()
        end
	end
	btn_close:addTouchEventListener(btn_closeTouched)
end


--注册节点事件
function controler_yongjun_list_main_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._yongjun_list_main_node:registerScriptHandler(onNodeEvent)
end

function controler_yongjun_list_main_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_yongjun_list_main_node:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_HIRESYS_HIRELING_INFO), callBack=handler(self, self._onNetEvent_MSG_MS2C_HIRESYS_HIRELING_INFO)},
		{modelName = "net", eventName = tostring(MSG_MS2C_HIRESYS_HIRE_RESULT), callBack=handler(self, self._onNetEvent_MSG_MS2C_HIRESYS_HIRE_RESULT)},
		

	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--创建控制器: UI
function controler_yongjun_list_main_node:_createControlerForUI()
    --佣军列表
    self._controlerMap.yongJunList = class_controler_yongjun_hero_list.new(
        self._yongjun_list_main_node:getChildByName("heroList")
    )
end


function controler_yongjun_list_main_node:_onNetEvent_MSG_MS2C_HIRESYS_HIRELING_INFO( event )
	local msgData = event._usedata

	if self:getCurPageIdx() == msgData.pageIdx then
		local maxPageNum = math.floor(msgData.infoTotalNum / msgData.infoNum)
		self._yongjun_list_main_node:
			getChildByName("text_pageValue"):
			setString(string.format("%d/%d", msgData.pageIdx, maxPageNum))
	end
end


function controler_yongjun_list_main_node:_onNetEvent_MSG_MS2C_HIRESYS_HIRE_RESULT( event )
	local msgData = event._usedata

	if msgData.result == eHS_BuySecced then
		local sendData = {}
        sendData[1] = self:getCurPageIdx()
        gameTcp:SendMessage(MSG_C2MS_HIRESYS_HIRELING_INFO, sendData)
        printNetLog("发送消息 MSG_C2MS_HIRESYS_HIRELING_INFO")
	end
end


return controler_yongjun_list_main_node
