--
-- Author: lipeng
-- Date: 2015-08-06 10:33:53
-- 控制器: 军团展示

local controler_no_guild_juntuan_zhanshi = class("controler_no_guild_juntuan_zhanshi")

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10


function controler_no_guild_juntuan_zhanshi:ctor(no_guild_juntuan_zhanshi)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._no_guild_juntuan_zhanshi = no_guild_juntuan_zhanshi

	self:_initListView()
	self:_registUIEvent()
	self:_registNodeEvent()

	self:_createControlerForUI()

	self:_registGlobalEventListeners()
end


function controler_no_guild_juntuan_zhanshi:getView()
    return self._no_guild_juntuan_zhanshi
end

function controler_no_guild_juntuan_zhanshi:_initModels()
    self._controlerMap = {}
    self._zhanShiList = {}
end

function controler_no_guild_juntuan_zhanshi:_initListView()
	self._listView = self._no_guild_juntuan_zhanshi:getChildByName("ListView")

	local listItemTempleate = self._no_guild_juntuan_zhanshi:getChildByName("ListView_itemTempleate")
	
	--申请加入
	local btn_join = listItemTempleate:getChildByName("btn_join")
	local function btn_joinTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local data = self._zhanShiList[sender:getTag()]
        	local sendData = {}
        	sendData[1] = data.name
        	printNetLog("发送消息 MSG_C2MS_GUILD_JOIN")
        	gameTcp:SendMessage(MSG_C2MS_GUILD_JOIN, sendData)

        end
	end
	btn_join:addTouchEventListener(btn_joinTouched)


	--取消申请
	local btn_cancel_join = listItemTempleate:getChildByName("btn_cancel_join")
	local function btn_cancel_joinTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local data = self._zhanShiList[sender:getTag()]
        	local sendData = {}
        	sendData[1] = data.id
        	printNetLog("发送消息 MSG_C2MS_QUXIAO_SHENQING")
        	gameTcp:SendMessage(MSG_C2MS_QUXIAO_SHENQING, sendData)
        end
	end
	btn_cancel_join:addTouchEventListener(btn_cancel_joinTouched)
	

	self._listView:setItemModel(
		listItemTempleate:clone()
	)
end


function controler_no_guild_juntuan_zhanshi:_registGlobalEventListeners()
    self._globalEventListeners = {}

    local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_GET_GUILD_LIST), callBack=handler(self, self._onMSG_MSG_MS2C_GET_GUILD_LIST)},
		{modelName = "net", eventName = tostring(MSG_MS2C_QUXIAO_SHENQING), callBack=handler(self, self._onMSG_MSG_MS2C_QUXIAO_SHENQING)},
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_JOIN), callBack=handler(self, self._onMSG_MSG_MS2C_GUILD_JOIN)},
	
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--注册节点事件
function controler_no_guild_juntuan_zhanshi:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._no_guild_juntuan_zhanshi:registerScriptHandler(onNodeEvent)
end


function controler_no_guild_juntuan_zhanshi:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

--创建控制器: UI
function controler_no_guild_juntuan_zhanshi:_createControlerForUI()

end


function controler_no_guild_juntuan_zhanshi:_registUIEvent()
	local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            self:_pushItems()
        end
    end

    self._listView:addScrollViewEventListener(scrollViewEvent)
end


function controler_no_guild_juntuan_zhanshi:_updateView()
	
end


function controler_no_guild_juntuan_zhanshi:_onMSG_MSG_MS2C_GET_GUILD_LIST( event )
	local eventUseData = event._usedata
	local msgData = eventUseData.msgData

    self._zhanShiList = clone(msgData.guildList)

    self._listView:removeAllChildren()
    self._listView:refreshView()

    self:_pushItems()
end


function controler_no_guild_juntuan_zhanshi:_onMSG_MSG_MS2C_QUXIAO_SHENQING( event )
	local eventUseData = event._usedata
	local msgData = eventUseData.msgData

    if eGUILD_QuxiaoSucced == msgData.result then
    	for i,v in ipairs(self._zhanShiList) do
    		if v.id == msgData.guid then
    			v.isApply = 0
    			local item = self:getItemByDataIdx(i)
    			self:_updateView_btnJoinApplyState(
    				item,
    				v.isApply
    			)
    			break
    		end
    	end
    end
end


function controler_no_guild_juntuan_zhanshi:_onMSG_MSG_MS2C_GUILD_JOIN( event )
	local eventUseData = event._usedata
	local msgData = eventUseData.msgData

    if eGUILD_ApplySucced == msgData.result then
    	for i,v in ipairs(self._zhanShiList) do
    		if v.id == msgData.guid then
    			v.isApply = 1
    			local item = self:getItemByDataIdx(i)
    			self:_updateView_btnJoinApplyState(
    				item,
    				v.isApply
    			)
    			break
    		end
    	end
    end
end



function controler_no_guild_juntuan_zhanshi:_pushItems()
	local addItemNum = LIST_VIEW_PER_PAGE_ITEM_NUM
	local curListItemNum = table.nums(self._listView:getItems())
	local dataTotal = #self._zhanShiList

	if curListItemNum >= dataTotal then
		return
	end

	if addItemNum + curListItemNum > dataTotal then
		addItemNum = dataTotal - curListItemNum
	end

	for i=1, addItemNum do
		self._listView:pushBackDefaultItem()

		local dataIdx = curListItemNum + i
		local data = self._zhanShiList[dataIdx]

		local newItem = self:getItemByDataIdx(dataIdx)
		newItem:setVisible(true)
		--[[
		设置item数据
		]]
		--公会名字
		newItem:getChildByName("name"):setString(data.name)

		--申请加入按钮
		local btn_join = newItem:getChildByName("btn_join")
		btn_join:setTag(dataIdx)
		local btn_cancel_join = newItem:getChildByName("btn_cancel_join")
		btn_cancel_join:setTag(dataIdx)
		self:_updateView_btnJoinApplyState(newItem, data.isApply)
		
		--军团长名
		newItem:getChildByName("junTuanZhang_value"):setString(data.managerName)

		--发展度
		newItem:getChildByName("faZhanDu_value"):setString(data.faZhanDu)
		
		--成员
		newItem:getChildByName("memberNum_value"):setString(data.memberCurNum.."/"..data.memberMaxNum)

		--军团宣言
		newItem:getChildByName("xuanYan_value"):setString(data.declaration)
	end
end


function controler_no_guild_juntuan_zhanshi:_updateView_btnJoinApplyState(item, applyState)
	if applyState ~= 0 then
		item:getChildByName("btn_join"):setVisible(false)
		item:getChildByName("btn_cancel_join"):setVisible(true)
	else
		item:getChildByName("btn_join"):setVisible(true)
		item:getChildByName("btn_cancel_join"):setVisible(false)
	end
end


function controler_no_guild_juntuan_zhanshi:getItemByDataIdx( dataIdx )
	return self._listView:getItem(dataIdx-1)
end


return controler_no_guild_juntuan_zhanshi





