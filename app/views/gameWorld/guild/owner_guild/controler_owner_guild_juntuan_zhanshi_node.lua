--
-- Author: lipeng
-- Date: 2015-08-12 20:00:43
-- 控制器: 军团展示面板

local controler_owner_guild_juntuan_zhanshi_node = class("controler_owner_guild_juntuan_zhanshi_node")

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10


function controler_owner_guild_juntuan_zhanshi_node:ctor( owner_guild_juntuan_zhanshi_node )
	self:_initModels()

	self._owner_guild_juntuan_zhanshi_node = owner_guild_juntuan_zhanshi_node

	self._panle = self._owner_guild_juntuan_zhanshi_node

	self:_initListView()
	self:_registUIEvent()
	self:_registNodeEvent()

	self:_registGlobalEventListeners()
end


function controler_owner_guild_juntuan_zhanshi_node:getView()
	return self._owner_guild_juntuan_zhanshi_node
end

function controler_owner_guild_juntuan_zhanshi_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_owner_guild_juntuan_zhanshi_node:_initModels()
	self._controlerEventCallBack = nil

	self._zhanShiList = {}
end

function controler_owner_guild_juntuan_zhanshi_node:_registGlobalEventListeners()
    self._globalEventListeners = {}

    local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_GET_ZHANSHI_LIST), callBack=handler(self, self._onNetEvent_MSG_MS2C_GET_ZHANSHI_LIST)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

--注册节点事件
function controler_owner_guild_juntuan_zhanshi_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._owner_guild_juntuan_zhanshi_node:registerScriptHandler(onNodeEvent)
end


function controler_owner_guild_juntuan_zhanshi_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_owner_guild_juntuan_zhanshi_node:_registUIEvent()
	--2015-8-14 lipeng 暂时不需要滑动, 固定只显示10个
	-- local function scrollViewEvent(sender, evenType)
 --        if evenType == ccui.ScrollviewEventType.scrollToBottom then
 --            self:_pushItems()
 --        end
 --    end

 --    self._listView:addScrollViewEventListener(scrollViewEvent)

 	--竞价
	-- local btn_biding = self._panle:getChildByName("btn_biding")
	-- local function btn_bidingTouched( sender,eventType )
	-- 	if eventType == ccui.TouchEventType.ended then
	-- 		self:_doEventCallBack(sender, "btn_bidingTouched")
 --        end
	-- end
	-- btn_biding:addTouchEventListener(btn_bidingTouched)


 	--退出
	local button_exit = self._panle:getChildByName("button_exit")
	local function button_exitTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self:_doEventCallBack(sender, "button_exitTouched")
        end
	end
	button_exit:addTouchEventListener(button_exitTouched)
end


function controler_owner_guild_juntuan_zhanshi_node:_initListView()
	self._listView = self._panle:getChildByName("ListView")

	local listItemTempleate = self._owner_guild_juntuan_zhanshi_node:getChildByName("ListView_itemTempleate")

	self._listView:setItemModel(
		listItemTempleate:clone()
	)
end


function controler_owner_guild_juntuan_zhanshi_node:_pushItems()
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
		local newItem = self._listView:getItem(curListItemNum+i-1)

		local dataIdx = curListItemNum + i

		newItem:setTag(dataIdx)
		newItem:setVisible(true)

		local data = self._zhanShiList[dataIdx]

		local newItem = self._listView:getItem(dataIdx-1)
		newItem:setVisible(true)
		--[[
		设置item数据
		]]
		--icon
		widgetHelper:loadTextureWithPlist(
			newItem:getChildByName("icon"),
			Guild_getImageName(data.lv)
		)

		--公会名字
		newItem:getChildByName("name"):setString(data.name)
		
		--军团长名
		newItem:getChildByName("junTuanZhang_value"):setString(data.guildManagerName)

		--发展度
		newItem:getChildByName("faZhanDu_value"):setString(data.lv)
		
		--成员
		newItem:getChildByName("memberNum_value"):setString(data.memberCurNum.."/"..data.memberMaxNum)

		--军团宣言
		newItem:getChildByName("xuanYan_value"):setString(data.declaration)
	end
end


function controler_owner_guild_juntuan_zhanshi_node:_onNetEvent_MSG_MS2C_GET_ZHANSHI_LIST(event)
	local useData = event._usedata
	local msgData = useData.msgData

	self._zhanShiList = clone(msgData.guildList)

	self._listView:removeAllChildren()
	self:_pushItems()
end



function controler_owner_guild_juntuan_zhanshi_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_owner_guild_juntuan_zhanshi_node


