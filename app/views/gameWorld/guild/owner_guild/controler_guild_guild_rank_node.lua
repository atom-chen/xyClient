--
-- Author: lipeng
-- Date: 2015-08-12 20:00:43
-- 控制器: 公会排行面板

local controler_guild_guild_rank_node = class("controler_guild_guild_rank_node")

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10


function controler_guild_guild_rank_node:ctor( guild_guild_rank_node )
	self:_initModels()

	self._guild_guild_rank_node = guild_guild_rank_node

	self._panle = self._guild_guild_rank_node:getChildByName("Panel")

	self:_initListView()
	self:_registUIEvent()
	self:_registNodeEvent()

	self:_registGlobalEventListeners()
	self:_pushItems()
end


function controler_guild_guild_rank_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_guild_guild_rank_node:getView()
	return self._guild_guild_rank_node
end

function controler_guild_guild_rank_node:_initModels()
	self._controlerEventCallBack = nil
end

function controler_guild_guild_rank_node:_registGlobalEventListeners()
    self._globalEventListeners = {}
end

--注册节点事件
function controler_guild_guild_rank_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._guild_guild_rank_node:registerScriptHandler(onNodeEvent)
end


function controler_guild_guild_rank_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_guild_guild_rank_node:_registUIEvent()
	local function button_exitCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "exit")
        end
    end
    local button_exit = self._panle:getChildByName("button_exit")
    button_exit:addTouchEventListener(button_exitCallback)

	--2015-8-14 lipeng 暂时不需要滑动, 固定只显示10个
	-- local function scrollViewEvent(sender, evenType)
 --        if evenType == ccui.ScrollviewEventType.scrollToBottom then
 --            self:_pushItems()
 --        end
 --    end

 --    self._listView:addScrollViewEventListener(scrollViewEvent)
end


function controler_guild_guild_rank_node:_initListView()
	self._listView = self._panle:getChildByName("ListView")

	local listItemTempleate = self._guild_guild_rank_node:getChildByName("ListView_itemTempleate")
	
	self._listView:setItemModel(
		listItemTempleate:clone()
	)
end


function controler_guild_guild_rank_node:_pushItems()
	local addItemNum = LIST_VIEW_PER_PAGE_ITEM_NUM
	local curListItemNum = table.nums(self._listView:getItems())
	-- local dataTotal = #self._zhanShiList

	-- if curListItemNum >= dataTotal then
	-- 	return
	-- end

	-- if addItemNum + curListItemNum > dataTotal then
	-- 	addItemNum = dataTotal - curListItemNum
	-- end

	for i=1, addItemNum do
		self._listView:pushBackDefaultItem()
		local newItem = self._listView:getItem(curListItemNum+i-1)
		newItem:setTag(curListItemNum+i)
		newItem:setVisible(true)

		-- local dataIdx = curListItemNum + i
		-- local data = self._zhanShiList[dataIdx]

		-- local newItem = self._listView:getItem(dataIdx-1)
		-- newItem:setVisible(true)
		-- --[[
		-- 设置item数据
		-- ]]
		-- --公会名字
		-- newItem:getChildByName("name"):setString(data.name)

		-- --申请加入按钮
		-- local btn_join = newItem:getChildByName("btn_join")
		-- btn_join:setTag(dataIdx)
		-- if data.isApply then
		-- 	btn_join:setTitleText("取消申请")
		-- else
		-- 	btn_join:setTitleText("申请加入")
		-- end
		
		-- --军团长名
		-- newItem:getChildByName("junTuanZhang_value"):setString(data.managerName)

		-- --发展度
		-- newItem:getChildByName("faZhanDu_value"):setString(data.faZhanDu)
		
		-- --成员
		-- newItem:getChildByName("memberNum_value"):setString(data.memberCurNum.."/"..data.memberMaxNum)

		-- --军团宣言
		-- newItem:getChildByName("xuanYan_value"):setString(data.declaration)
	end
end


function controler_guild_guild_rank_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guild_guild_rank_node


