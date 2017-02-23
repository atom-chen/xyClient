--
-- Author: lipeng
-- Date: 2015-08-12 20:00:43
-- 控制器: 公会科技列表面板

local controler_guild_keji_list_node = class("controler_guild_keji_list_node")

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10


function controler_guild_keji_list_node:ctor( guild_keji_list_node )
	self:_initModels()

	self._guild_keji_list_node = guild_keji_list_node

	self:_initListView()
	self:_registUIEvent()
	self:_registNodeEvent()

	self:_registGlobalEventListeners()
end


function controler_guild_keji_list_node:getView()
	return self._guild_keji_list_node
end


function controler_guild_keji_list_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_guild_keji_list_node:_initModels()
	self._controlerEventCallBack = nil
	self._keJiList = {}
end

function controler_guild_keji_list_node:_registGlobalEventListeners()
    self._globalEventListeners = {}
    
    local configs = {
        {modelName = "net", eventName = tostring(MSG_MS2C_OPEN_KEJI_LIST), callBack=handler(self, self._onNetEvent_MSG_MS2C_OPEN_KEJI_LIST)},
        {modelName = "net", eventName = tostring(MSG_MS2C_LVUP_KEJI), callBack=handler(self, self._onNetEvent_MSG_MS2C_LVUP_KEJI)},
   
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--注册节点事件
function controler_guild_keji_list_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._guild_keji_list_node:registerScriptHandler(onNodeEvent)
end


function controler_guild_keji_list_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_guild_keji_list_node:_registUIEvent()
	local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            self:_pushItems()
        end
    end

    self._listView:addScrollViewEventListener(scrollViewEvent)
end


function controler_guild_keji_list_node:_initListView()
	self._listView = self._guild_keji_list_node:getChildByName("ListView")

	local listItemTempleate = self._guild_keji_list_node:getChildByName("ListView_itemTempleate")
	
	--查看
	local btn_lvUp = listItemTempleate:getChildByName("btn_lvUp")
	local function btn_lvUpTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local keJiInfo = self._keJiList[sender:getTag()]

		    if keJiInfo.lv >= Guild_GetKeji_Maxlv(keJiInfo.id) then
		    	UIManager:CreateSamplePrompt("科技已升至最高等级")
		        return
		    end

		    local needRenQi = Guild_GetKeji_LvupneedRenqi(keJiInfo.id, keJiInfo.lv+1)
		    local curRenQi = MAIN_PLAYER:getGuild():getCurPopularValue()
		    if curRenQi < needRenQi then
		    	UIManager:CreateSamplePrompt("军团资源不够")
		        return
		    end

		    --发送消息
		    printNetLog("发送公会升级科技请求")

		    gameTcp:SendMessage(MSG_C2MS_LVUP_KEJI , {
		        keJiInfo.id
		    })
        end
	end
	btn_lvUp:addTouchEventListener(btn_lvUpTouched)

	self._listView:setItemModel(
		listItemTempleate:clone()
	)
end


function controler_guild_keji_list_node:_pushItems()
	local addItemNum = LIST_VIEW_PER_PAGE_ITEM_NUM
	local curListItemNum = table.nums(self._listView:getItems())
	local dataTotal = #self._keJiList

	if curListItemNum >= dataTotal then
		return
	end

	if addItemNum + curListItemNum > dataTotal then
		addItemNum = dataTotal - curListItemNum
	end

	for i=1, addItemNum do
		self._listView:pushBackDefaultItem()
		local dataIdx = curListItemNum + i

		local newItem = self._listView:getItem(curListItemNum+i-1)
		newItem:setTag(dataIdx)
		newItem:setVisible(true)

		local data = self._keJiList[dataIdx]

		newItem:setVisible(true)
		--[[
		设置item数据
		]]
		--升级button
		newItem:getChildByName("btn_lvUp"):setTag(dataIdx)

		--科技名字
		newItem:getChildByName("name"):setString(Guild_GetKeji_name(data.id))

		--科技等级
		newItem:getChildByName("lv_value"):setString(data.lv)

		--科技效果描述
		newItem:getChildByName("skillDec"):setString(Guild_GetKeji_miaoshu(data.id, data.lv))

		--icon
		widgetHelper:loadTextureWithPlist(
			newItem:getChildByName("icon"),
			Guild_GetKeji_icon(data.id)
		)

		--消耗资源
		local useRes_text = newItem:getChildByName("useRes_value")
		if data.lv >= Guild_GetKeji_Maxlv(data.id) then
			useRes_text:setString("--")
        else
        	local needRenQi = Guild_GetKeji_LvupneedRenqi(data.id, data.lv+1)
        	useRes_text:setString(needRenQi)
        end
	end
end


function controler_guild_keji_list_node:_onNetEvent_MSG_MS2C_OPEN_KEJI_LIST( event )
	local eventUseData = event._usedata
    local msgData = eventUseData.msgData

    self._keJiList = clone(msgData.keJiList)

    self._listView:removeAllChildren()
    self:_pushItems()
end


function controler_guild_keji_list_node:_onNetEvent_MSG_MS2C_LVUP_KEJI( event )
	local eventUseData = event._usedata
    local msgData = eventUseData.msgData

    local listItemIdx = -1
    for i=1, #self._keJiList do
        if self._keJiList[i].id == msgData.id then
            self._keJiList[i].lv = msgData.lv
            listItemIdx = i
            break
        end
    end

    local itemUI = self._listView:getItem(listItemIdx)

    itemUI:getChildByName("lv_value"):setString(msgData.lv)
    itemUI:getChildByName("skillDec"):setString(Guild_GetKeji_miaoshu(msgData.id, msgData.lv))

    local useRes_text = itemUI:getChildByName("useRes_text")
    if msgData.lv >= Guild_GetKeji_Maxlv(msgData.id) then
        useRes_text:setString("--")
    else
        local needRenQi = Guild_GetKeji_LvupneedRenqi(msgData.id, msgData.lv+1)
        useRes_text:setString("消耗"..needRenQi.."资源")
    end
end



function controler_guild_keji_list_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guild_keji_list_node


