--
-- Author: lipeng
-- Date: 2015-08-12 20:00:43
-- 控制器: 公会成员列表面板

require(FILE_PATH.PATH_VIEWS_UI_TEMPLEATE..".hero_icon")
local controler_guild_member_verify_list = class("controler_guild_member_verify_list")

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10


function controler_guild_member_verify_list:ctor( guild_member_verify_list )
	self:_initModels()

	self._guild_member_verify_list = guild_member_verify_list

	self:_initListView()
	self:_registUIEvent()
	self:_registNodeEvent()

	self:_registGlobalEventListeners()
end


function controler_guild_member_verify_list:getView()
	return self._guild_member_verify_list
end


function controler_guild_member_verify_list:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_guild_member_verify_list:_initModels()
	self._controlerEventCallBack = nil
	self._verifyList = {}
end

function controler_guild_member_verify_list:_registGlobalEventListeners()
    self._globalEventListeners = {}

    local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_GET_APPLYMEMBER), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_GET_APPLYMEMBER)},
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_INSERT_MEMBER), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_INSERT_MEMBER)},
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_CANCEL_APPLY), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_CANCEL_APPLY)},

	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
    
end

--注册节点事件
function controler_guild_member_verify_list:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._guild_member_verify_list:registerScriptHandler(onNodeEvent)
end


function controler_guild_member_verify_list:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_guild_member_verify_list:_registUIEvent()
	local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            self:_pushItems()
        end
    end

    self._listView:addScrollViewEventListener(scrollViewEvent)
end


function controler_guild_member_verify_list:_initListView()
	self._listView = self._guild_member_verify_list:getChildByName("ListView")

	local listItemTempleate = self._guild_member_verify_list:getChildByName("ListView_itemTempleate")
	
	--同意
	local btn_agree = listItemTempleate:getChildByName("btn_agree")
	local function btn_agreeTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local verifyInfo = self._verifyList[sender:getTag()]
			local sendData = {}
			sendData[1] = verifyInfo.playerName
			printNetLog("发送 允许加入消息 MSG_C2MS_GUILD_INSERT_MEMBER")
			gameTcp:SendMessage(
				MSG_C2MS_GUILD_INSERT_MEMBER,
				sendData
			)
        end
	end
	btn_agree:addTouchEventListener(btn_agreeTouched)

	--取消
	local btn_cancel = listItemTempleate:getChildByName("btn_cancel")
	local function btn_cancelTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local verifyInfo = self._verifyList[sender:getTag()]
			local sendData = {}
			sendData[1] = verifyInfo.playerName
			printNetLog("发送 取消加入消息 MSG_C2MS_GUILD_CANCEL_APPLY")
			gameTcp:SendMessage(
				MSG_C2MS_GUILD_CANCEL_APPLY,
				sendData
			)
        end
	end
	btn_cancel:addTouchEventListener(btn_cancelTouched)

	self._listView:setItemModel(
		listItemTempleate:clone()
	)
end


function controler_guild_member_verify_list:_pushItems()
	local addItemNum = LIST_VIEW_PER_PAGE_ITEM_NUM
	local curListItemNum = table.nums(self._listView:getItems())
	local dataTotal = #self._verifyList

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

		local data = self._verifyList[dataIdx]

		--[[
		设置item数据
		]]
		newItem:getChildByName("btn_agree"):setTag(dataIdx)
		newItem:getChildByName("btn_cancel"):setTag(dataIdx)

		--玩家名字
		newItem:getChildByName("name"):setString(data.playerName)

		--icon
		local mainLayout = newItem:getChildByName("main_layout")
		HERO_ICON_HELPER:updateIcon(
			{
				bgImg = mainLayout:getChildByName("bg"),
				iconImg = mainLayout:getChildByName("icon"),
				guideImg = mainLayout:getChildByName("guide"),
				heroTempleateID = data.leaderTempleateID
			}
		)

		--玩家等级
		newItem:getChildByName("lv_value"):setString(data.playerLv)

		--上线状态
        local surplusTime = TIME_HELPER:clientTimeToServerTime(os.time()) - data.lastLoginTime
        local day , hour ,minute = TIME_HELPER:timeBySecond( surplusTime )
        local timeStr = ""
        if day > 0 then
            timeStr = day.."天"
        elseif hour > 0 then
            timeStr = hour.."小时"
        elseif minute > 0 then
            timeStr = minute.."分钟"
        else
            --最小上线时间间隔为1分钟
            timeStr = "1分钟"
        end

        newItem:getChildByName("onlineState"):setString("登陆: "..timeStr.."前")

        --战斗力
        newItem:getChildByName("power_value"):setString(data.power)

		
	end
end


function controler_guild_member_verify_list:_onNetEvent_MSG_MS2C_GUILD_GET_APPLYMEMBER( event )
	local useData = event._usedata
	local msgData = useData.msgData

	self._verifyList = clone(msgData.verifyList)

	self._listView:removeAllChildren()
	self:_pushItems()
end


function controler_guild_member_verify_list:_onNetEvent_MSG_MS2C_GUILD_INSERT_MEMBER( event )
	local useData = event._usedata
	local msgData = useData.msgData

	if eGUILD_InsertSuccess == msgData.result then
		for i,v in ipairs(self._verifyList) do
			if v.playerName == msgData.playerName then
				table.remove(self._verifyList, i)
				break
			end
		end

		self._listView:removeAllChildren()
		self:_pushItems()
	end
end


function controler_guild_member_verify_list:_onNetEvent_MSG_MS2C_GUILD_CANCEL_APPLY( event )
	local useData = event._usedata
	local msgData = useData.msgData

	if eGUILD_CancelSuccess == msgData.result then
		for i,v in ipairs(self._verifyList) do
			if v.playerName == msgData.playerName then
				table.remove(self._verifyList, i)
				break
			end
		end

		self._listView:removeAllChildren()
		self:_pushItems()
	end
end


function controler_guild_member_verify_list:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guild_member_verify_list


