--
-- Author: lipeng
-- Date: 2015-08-22 17:27:24
--

local controler_guild_battle_city_player_list = class("controler_guild_battle_city_player_list")

--listView每页item数量
--(即每次到达listView底部时, 最多创建的item数量)
local LIST_VIEW_PER_PAGE_ITEM_NUM = 10

function controler_guild_battle_city_player_list:ctor( guild_battle_city_player_list )
	self:_initModels()

	self._guild_battle_city_player_list = guild_battle_city_player_list

	self:_initListView()

	self:_registUIEvent()
end


function controler_guild_battle_city_player_list:setPlayerList( list )
	
end

function controler_guild_battle_city_player_list:_initModels()
	self._playerList = {}
end

function controler_guild_battle_city_player_list:_initListView()
	self._listView1 = self._guild_battle_city_player_list:getChildByName("ListView_1")

	local listItemTempleate = self._guild_battle_city_player_list:getChildByName("ListView_itemTempleate")
	
	--查看
	local btn_look = listItemTempleate:getChildByName("btn_look")
	local function btn_lookTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			print("查看")
        end
	end
	btn_look:addTouchEventListener(btn_lookTouched)

	self._listView1:setItemModel(
		listItemTempleate:clone()
	)
end


function controler_guild_battle_city_player_list:_registUIEvent()
	local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            self:_pushItems()
        end
    end

    self._listView1:addScrollViewEventListener(scrollViewEvent)
end


function controler_guild_battle_city_player_list:_pushItems()
	local addItemNum = LIST_VIEW_PER_PAGE_ITEM_NUM
	local curListItemNum = table.nums(self._listView1:getItems())
	local dataTotal = #self._playerList

	-- if curListItemNum >= dataTotal then
	-- 	return
	-- end

	-- if addItemNum + curListItemNum > dataTotal then
	-- 	addItemNum = dataTotal - curListItemNum
	-- end

	for i=1, addItemNum do
		self._listView1:pushBackDefaultItem()
		local newItem = self._listView1:getItem(curListItemNum+i-1)
		local dataIdx = curListItemNum + i

		newItem:setTag(dataIdx)
		newItem:setVisible(true)

		-- local data = self._playerList[dataIdx]

		-- --[[
		-- 设置item数据
		-- ]]
		-- newItem:getChildByName("btn_look"):setTag(dataIdx)

		-- --公会名字
		-- newItem:getChildByName("name"):setString(data.playerName)

		-- --icon
		-- HERO_ICON_HELPER:updateIcon(
		-- 	{
		-- 		bgImg = newItem:getChildByName("heroIconBg"),
		-- 		iconImg = newItem:getChildByName("heroIcon"),
		-- 		heroTempleateID = data.leaderTempleateID
		-- 	}
		-- )

		-- --玩家等级
		-- newItem:getChildByName("lv_value"):setString(data.playerLv)

		-- --职位
		-- local postName = guildOfficialConfig[data.post].OffName
		-- newItem:getChildByName("text_post"):setString(postName)

		-- --上线状态
  --       -- local surplusTime = clientTimeToServerTime(os.time()) - memberInfo.lastLoginTime
  --       -- local day , hour ,minute = TimeBySecond( surplusTime )
  --       -- local timeStr = ""
  --       -- if day > 0 then
  --       --     timeStr = day.."天"
  --       -- elseif hour > 0 then
  --       --     timeStr = hour.."小时"
  --       -- elseif minute > 0 then
  --       --     timeStr = minute.."分钟"
  --       -- else
  --       --     --最小上线时间间隔为1分钟
  --       --     timeStr = "1分钟"
  --       -- end

  --       -- itemOfRootNode.lastLoginTime:setString("登陆: "..timeStr.."前")
  --       if data.onlineState == 1 then
  --           newItem:getChildByName("onlineState"):setString("在线")
  --       else
  --           newItem:getChildByName("onlineState"):setString("离线")
  --       end

  --       --战斗力
  --       newItem:getChildByName("power_value"):setString(data.power)

  --       --总贡献
  --       newItem:getChildByName("zgx_value"):setString(data.dkp)
		
	end
end



return controler_guild_battle_city_player_list
