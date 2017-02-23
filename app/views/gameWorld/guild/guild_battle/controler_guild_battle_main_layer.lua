--
-- Author: lipeng
-- Date: 2015-08-21 14:49:26
-- 控制器: 军团争霸入口

local class_controler_guild_battle_map_layer = import(".controler_guild_battle_map_layer")
local class_controler_guild_battle_player_info_node = import(".controler_guild_battle_player_info_node")
local class_controler_guild_battle_city_info_node = import(".controler_guild_battle_city_info_node")



local controler_guild_battle_main_layer = class("controler_guild_battle_main_layer")

function controler_guild_battle_main_layer:ctor( guild_battle_main_layer )
	self:_initModels()

	self._guild_battle_main_layer = guild_battle_main_layer

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._guild_battle_main_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._guild_battle_main_layer)

    --弹窗遮罩层
    self._popup_mask = self._guild_battle_main_layer:getChildByName("popup_mask")
    self._popup_mask:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._popup_mask)

	self:_createControlerForUI()

	self:_registUIEvent()
end


function controler_guild_battle_main_layer:getView()
	return self._guild_battle_main_layer
end

function controler_guild_battle_main_layer:addEventListener( callBack )
    self._controlerEventCallBack = callBack
end


function controler_guild_battle_main_layer:_initModels()
	self._controlerMap = {}
end


--创建控制器: UI
function controler_guild_battle_main_layer:_createControlerForUI()
    --地图
    self._controlerMap.map = class_controler_guild_battle_map_layer.new(
        self._guild_battle_main_layer:getChildByName("map")
    )
    self._controlerMap.map:addEventListener(handler(self, self._onEvent_map))

    --玩家信息
    self._controlerMap.playerInfo = class_controler_guild_battle_player_info_node.new(
        self._guild_battle_main_layer:getChildByName("playerInfo")
    )
end


function controler_guild_battle_main_layer:_registUIEvent()
	local function button_exitCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "exit")
        end
    end
    local button_exit = self._guild_battle_main_layer:getChildByName("button_exit")
    button_exit:addTouchEventListener(button_exitCallback)
end


function controler_guild_battle_main_layer:_onEvent_map( sender, eventName, data )
	if eventName == "cityTouched" then
		self._popup_mask:setVisible(true)

		if self._controlerMap.cityInfo == nil then
			self._controlerMap.cityInfo = class_controler_guild_battle_city_info_node.new(
		        self:_createView_cityInfo()
		    )

            self._controlerMap.cityInfo:addEventListener(handler(self, self._onEvent_cityInfo))

		    self._guild_battle_main_layer:
		    	getChildByName("cityInfo"):
		    	addChild(self._controlerMap.cityInfo:getView())

            GLOBAL_COMMON_ACTION:popupOut({node=self._controlerMap.cityInfo:getView()})
		end
	end
end


function controler_guild_battle_main_layer:_onEvent_cityInfo( sender, eventName, data )
    if eventName == "button_exitTouched" then
        if self._controlerMap.cityInfo ~= nil then
            local function popupBackActionCallBack()
                self._controlerMap.cityInfo:getView():removeFromParent()
                self._controlerMap.cityInfo = nil
                self._popup_mask:setVisible(false)
            end
            GLOBAL_COMMON_ACTION:popupBack({node=self._controlerMap.cityInfo:getView(), callback=popupBackActionCallBack})
        end
    end
end


function controler_guild_battle_main_layer:_createView_cityInfo()
	return cc.CSLoader:createNode("ui_instance/guild/guild_battle/guild_battle_city_info_node.csb")
end




function controler_guild_battle_main_layer:_doEventCallBack( sender, eventName, data )
    if self._controlerEventCallBack ~= nil then
        self._controlerEventCallBack(sender, eventName, data)
    end
end


return controler_guild_battle_main_layer
