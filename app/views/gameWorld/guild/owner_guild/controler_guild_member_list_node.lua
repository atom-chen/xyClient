--
-- Author: lipeng
-- Date: 2015-08-12 20:00:43
-- 控制器: 公会成员列表面板

require(FILE_PATH.PATH_VIEWS_UI_TEMPLEATE..".hero_icon")
local controler_guild_member_list_node = class("controler_guild_member_list_node")

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10


function controler_guild_member_list_node:ctor( guild_member_node )
	self:_initModels()

	self._guild_member_node = guild_member_node

	self:_initListView()
	self:_registUIEvent()
	self:_registNodeEvent()

	self:_registGlobalEventListeners()
end


function controler_guild_member_list_node:getView()
	return self._guild_member_node
end

function controler_guild_member_list_node:setCurState( strState )
	self._curState = strState

	if self._curState == "showShenHe" then
		self._guild_member_node:getChildByName("ListView"):setVisible(false)
	else
		self._guild_member_node:getChildByName("ListView"):setVisible(true)
	end
end


function controler_guild_member_list_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end

function controler_guild_member_list_node:_initModels()
	self._controlerEventCallBack = nil
	self._memberList = {}
	self._curState = "showMemberList"
end

function controler_guild_member_list_node:_registGlobalEventListeners()
    self._globalEventListeners = {}

    local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_GET_MEMBER), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_GET_MEMBER)},
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD)},
	
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
    
end

--注册节点事件
function controler_guild_member_list_node:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._guild_member_node:registerScriptHandler(onNodeEvent)
end


function controler_guild_member_list_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_guild_member_list_node:_registUIEvent()
	local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            self:_pushItems()
        end
    end

    self._listView:addScrollViewEventListener(scrollViewEvent)

    --成员审核
	local btn_shenHe = self._guild_member_node:getChildByName("btn_shenHe")
	local function btn_shenHeTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self._guild_member_node:getChildByName("btn_memberlist"):setVisible(true)
			sender:setVisible(false)
			self:_doEventCallBack(sender, "btn_shenHeTouched")
			self:setCurState("showShenHe")
        end
	end
	btn_shenHe:addTouchEventListener(btn_shenHeTouched)

	--成员列表
	local btn_memberlist = self._guild_member_node:getChildByName("btn_memberlist")
	local function btn_memberlistTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self._guild_member_node:getChildByName("btn_shenHe"):setVisible(true)
			sender:setVisible(false)
			self:_doEventCallBack(sender, "btn_memberlistTouched")
			self:setCurState("showMemberList")
        end
	end
	btn_memberlist:addTouchEventListener(btn_memberlistTouched)
end


function controler_guild_member_list_node:_initListView()
	self._listView = self._guild_member_node:getChildByName("ListView")

	local listItemTempleate = self._guild_member_node:getChildByName("ListView_itemTempleate")
	
	--查看
	local btn_look = listItemTempleate:getChildByName("btn_look")
	local function btn_lookTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local member = self._memberList[sender:getTag()]
			self:_doEventCallBack(sender, "btn_lookTouched", {member=member})
        end
	end
	btn_look:addTouchEventListener(btn_lookTouched)

	self._listView:setItemModel(
		listItemTempleate:clone()
	)
end


function controler_guild_member_list_node:_pushItems()
	local addItemNum = LIST_VIEW_PER_PAGE_ITEM_NUM
	local curListItemNum = table.nums(self._listView:getItems())
	local dataTotal = #self._memberList

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

		local data = self._memberList[dataIdx]

		--[[
		设置item数据
		]]
		newItem:getChildByName("btn_look"):setTag(dataIdx)

		--公会名字
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

		--职位
		local postName = guildOfficialConfig[data.post].OffName
		newItem:getChildByName("text_post"):setString(postName)

		--上线状态
        -- local surplusTime = clientTimeToServerTime(os.time()) - memberInfo.lastLoginTime
        -- local day , hour ,minute = TimeBySecond( surplusTime )
        -- local timeStr = ""
        -- if day > 0 then
        --     timeStr = day.."天"
        -- elseif hour > 0 then
        --     timeStr = hour.."小时"
        -- elseif minute > 0 then
        --     timeStr = minute.."分钟"
        -- else
        --     --最小上线时间间隔为1分钟
        --     timeStr = "1分钟"
        -- end

        -- itemOfRootNode.lastLoginTime:setString("登陆: "..timeStr.."前")
        if data.onlineState == 1 then
        	newItem:getChildByName("onlineState"):setColor(cc.c3b(0, 128, 0))
            newItem:getChildByName("onlineState"):setString("在线")
        else
        	local surplusTime = clientTimeToServerTime(os.time()) - memberInfo.lastLoginTime
	        local day , hour ,minute = TimeBySecond( surplusTime )
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

	        newItem:getChildByName("onlineState"):setColor(cc.c3b(255, 0, 0))
            newItem:getChildByName("onlineState"):setString("离线"..timeStr)
        end

        --战斗力
        newItem:getChildByName("power_value"):setString(data.power)

        --总贡献
        newItem:getChildByName("zgx_value"):setString(data.dkp)
		
	end
end


function controler_guild_member_list_node:_onNetEvent_MSG_MS2C_GUILD_GET_MEMBER( event )
	local useData = event._usedata
	local msgData = useData.msgData

	self._memberList = clone(msgData.memberList)

	self._listView:removeAllChildren()
	self:_pushItems()
end


function controler_guild_member_list_node:_onNetEvent_MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD( event )
	local useData = event._usedata
	local msgData = useData.msgData

	if eGUILD_QuitSucced == msgData.result then
		printNetLog("发送获取公会成员列表请求(MSG_C2MS_GUILD_GET_MEMBER)")
        gameTcp:SendMessage(MSG_C2MS_GUILD_GET_MEMBER)
	end
end


function controler_guild_member_list_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guild_member_list_node


