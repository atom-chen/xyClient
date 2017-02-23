--
-- Author: lipeng
-- Date: 2015-08-21 14:49:52
-- 控制器: 军团地图

local class_controler_guild_battle_city_node = import(".controler_guild_battle_city_node")


local controler_guild_battle_map_layer = class("controler_guild_battle_map_layer")

function controler_guild_battle_map_layer:ctor( guild_battle_map_layer )
	self:_initModels()

	self._guild_battle_map_layer = guild_battle_map_layer

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._guild_battle_map_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._guild_battle_map_layer)

    self._scrollView = self._guild_battle_map_layer:getChildByName("ScrollView")
    self._cityLayer = self._scrollView:getChildByName("cityLayer")


    self:_createControlerForUI()
end


function controler_guild_battle_map_layer:getView()
	return self._guild_battle_map_layer
end

function controler_guild_battle_map_layer:addEventListener(callBack)
	self._controlerEventCallBack = callBack
end

function controler_guild_battle_map_layer:_initModels()
	self._controlerMap = {}
end

function controler_guild_battle_map_layer:_createControlerForUI()
	local cityViews = self._cityLayer:getChildren()
	local cityViewNum = table.nums(cityViews)
	self._controlerMap.cityList = {}
	for i=1, cityViewNum do
		self._controlerMap.cityList[i] = class_controler_guild_battle_city_node.new(
			cityViews[i]
		)
		local controler_city = self._controlerMap.cityList[i]
		controler_city:setConfigID(cityViews[i]:getTag())

		controler_city:updateViews()

		controler_city:addEventListener(handler(self, self._onEvent_city))
	end
	
end


function controler_guild_battle_map_layer:_onEvent_city( sender, eventName, data )
	if eventName == "btn_iconTouched" then
		self:_doEventCallBack(sender, "cityTouched")
	end
end


function controler_guild_battle_map_layer:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end

return controler_guild_battle_map_layer


