--
-- Author: lipeng
-- Date: 2015-08-22 15:18:30
-- 控制器: 军团战的城市

local controler_guild_battle_city_node = class("controler_guild_battle_city_node")

local cityImagePath = "ui_image/guild/guild_battle/guild_battle_citys/"

function controler_guild_battle_city_node:ctor( guild_battle_city_node )
	self:_initModels()

	self._guild_battle_city_node = guild_battle_city_node

	self:_registUIEvent()
end


function controler_guild_battle_city_node:getView()
	return self._guild_battle_city_node
end

function controler_guild_battle_city_node:addEventListener(callBack)
	self._controlerEventCallBack = callBack
end

function controler_guild_battle_city_node:updateViews()
	self:_updateView_cityName()
	self:_updateView_dynamicText()
	self:_updateView_icon()
end

function controler_guild_battle_city_node:setConfigID( id )
	self._configID = id
end

function controler_guild_battle_city_node:_initModels()
	self._configID = 0
end


function controler_guild_battle_city_node:_registUIEvent()
	--城市icon
	local btn_icon = self._guild_battle_city_node:getChildByName("btn_icon")
	local function btn_iconTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self:_doEventCallBack(sender, "btn_iconTouched")
        end
	end
	btn_icon:addTouchEventListener(btn_iconTouched)
	
end


function controler_guild_battle_city_node:_updateView_icon()
	local btn_icon = self._guild_battle_city_node:getChildByName("btn_icon")

	btn_icon:loadTextures(
		cityImagePath..string.format("guild_battle_city%d_n.png", 2), 
		cityImagePath..string.format("guild_battle_city%d_p.png", 2), 
		cityImagePath..string.format("guild_battle_city%d_p.png", 2)
	)
end

function controler_guild_battle_city_node:_updateView_cityName()
	local cityName = self._guild_battle_city_node:getChildByName("cityName")

	cityName:setString("测试")
end

function controler_guild_battle_city_node:_updateView_dynamicText()
	local dynamicText = self._guild_battle_city_node:getChildByName("dynamicText")

	dynamicText:setString("争夺中")
	dynamicText:setColor(cc.c3b(255, 0, 0))
end


function controler_guild_battle_city_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end

return controler_guild_battle_city_node
