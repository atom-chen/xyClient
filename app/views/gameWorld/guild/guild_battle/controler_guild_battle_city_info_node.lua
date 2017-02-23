--
-- Author: lipeng
-- Date: 2015-08-22 17:03:36
--

local class_controler_guild_battle_city_player_list = import(".controler_guild_battle_city_player_list")


local controler_guild_battle_city_info_node = class("controler_guild_battle_city_info_node")


function controler_guild_battle_city_info_node:ctor( guild_battle_city_info_node )
	self:_initModels()

	self._guild_battle_city_info_node = guild_battle_city_info_node

	self._panel1 = self._guild_battle_city_info_node:getChildByName("Panel_1")

	self:_createControlerForUI()

	self:_registUIEvent()

	self:_onNetEvent_getCityInfo()
end


function controler_guild_battle_city_info_node:getView()
	return self._guild_battle_city_info_node
end

function controler_guild_battle_city_info_node:addEventListener(callBack)
	self._controlerEventCallBack = callBack
end


function controler_guild_battle_city_info_node:_initModels()
	self._controlerMap = {}
	self._controlerEventCallBack = nil
end


function controler_guild_battle_city_info_node:_createControlerForUI()

	self._controlerMap.playerList = class_controler_guild_battle_city_player_list.new(
		self._panel1:getChildByName("playerList")
	)
end


function controler_guild_battle_city_info_node:_registUIEvent()
	local UIContainer = self._panel1

	--关闭
	local button_exit = UIContainer:getChildByName("button_exit")
	local function button_exitTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self:_doEventCallBack(self, "button_exitTouched")
        end
	end
	button_exit:addTouchEventListener(button_exitTouched)

end



function controler_guild_battle_city_info_node:_updateView_cityLv()
	local lv = 5
	local lvViews = self._panel1:getChildByName("cityLevel"):getChildren()
	for i=1, lv do
		lvViews[i]:setVisible(true)
	end

	for i=lv+1, 5 do
		lvViews[i]:setVisible(false)
	end
end


function controler_guild_battle_city_info_node:_updateView_produce()
	local text_produce = self._panel1:getChildByName("produce")
	text_produce:setString(
		string.format("每%d分钟产出：%d物资  %d功勋",
			11,
			5,
			10
		)
	)
end


function controler_guild_battle_city_info_node:_onNetEvent_getCityInfo( event )
	local UIContainer = self._panel1
	UIContainer:getChildByName("name"):setString("测试")

	self:_updateView_cityLv()
	
	UIContainer:getChildByName("holdGuildName"):setString("测试军团")
	
	self:_updateView_produce()

	self._controlerMap.playerList:setPlayerList()
end


function controler_guild_battle_city_info_node:_doEventCallBack( sender, eventName, data )
    if self._controlerEventCallBack ~= nil then
        self._controlerEventCallBack(sender, eventName, data)
    end
end

return controler_guild_battle_city_info_node
