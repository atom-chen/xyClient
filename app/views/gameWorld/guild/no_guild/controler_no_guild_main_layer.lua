--
-- Author: lipeng
-- Date: 2015-08-05 16:10:40
-- 控制器: 没有公会时的入口层

local class_controler_no_guild_juntuan_zhanshi = import(".controler_no_guild_juntuan_zhanshi")
local class_controler_guild_create_node = import(".controler_guild_create_node")

local controler_no_guild_main_layer = class("controler_no_guild_main_layer")


function controler_no_guild_main_layer:ctor(no_guild_main_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._no_guild_main_layer = no_guild_main_layer
    self._no_guild_main_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._no_guild_main_layer)

    self._shadowLayout = self._no_guild_main_layer:getChildByName("shadow_layout")
    self._shadowLayout:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._shadowLayout)

    --弹窗遮罩层
    self._popup_mask = self._no_guild_main_layer:getChildByName("popup_mask")
    self._popup_mask:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._popup_mask)

    --背景层
    self._background = self._no_guild_main_layer:getChildByName("background")
    
    self:_createControlerForUI()
    self:_registNodeEvent()
    self:_registUIEvent()
    self:_registGlobalEventListeners()
end


function controler_no_guild_main_layer:getView()
    return self._no_guild_main_layer
end

function controler_no_guild_main_layer:addEventListener( callBack )
    self._controlerEventCallBack = callBack
end

function controler_no_guild_main_layer:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
end

function controler_no_guild_main_layer:_registGlobalEventListeners()
    self._globalEventListeners = {}
    local configs = {
        {modelName = "net", eventName = tostring(MSG_MS2C_GET_GUILD_LIST), callBack=handler(self, self._onNetEvent_MSG_MS2C_GET_GUILD_LIST)},
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--注册节点事件
function controler_no_guild_main_layer:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._no_guild_main_layer:registerScriptHandler(onNodeEvent)
end


function controler_no_guild_main_layer:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

--创建控制器: UI
function controler_no_guild_main_layer:_createControlerForUI()
    --军团展示层
    self._controlerMap.juntuan_zhanshi = class_controler_no_guild_juntuan_zhanshi.new(
        self._background:getChildByName("juntuan_zhanshi")
    )
end


function controler_no_guild_main_layer:_registUIEvent()
    local function button_exitCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "exit")
        end
    end
    local button_exit = self._background:getChildByName("button_exit")
    button_exit:addTouchEventListener(button_exitCallback)

    local function createGuildButtonCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            if self._controlerMap.createGuild == nil then
                self._controlerMap.createGuild = class_controler_guild_create_node.new(
                    self:_createView_createGuild()
                )

                self._no_guild_main_layer:getChildByName("createGuildPanlePos"):addChild(
                    self._controlerMap.createGuild:getView()
                )
                
                self._controlerMap.createGuild:addEventListener(handler(self, self._onEvent_createGuild))

                self._popup_mask:setVisible(true)
            end
        end
    end
    local createGuildButton = self._background:getChildByName("createGuildButton")
    createGuildButton:addTouchEventListener(createGuildButtonCallback)
end


function controler_no_guild_main_layer:_updateView()

end


function controler_no_guild_main_layer:_createView_createGuild()
    return cc.CSLoader:createNode("ui_instance/guild/no_guild/guild_create_node.csb")
end


function controler_no_guild_main_layer:_onEvent_createGuild( sender, eventName, data )
    if eventName == "exit" then
        self._controlerMap.createGuild:getView():removeFromParent()
        self._controlerMap.createGuild = nil
        self._popup_mask:setVisible(false)
    end
end


function controler_no_guild_main_layer:_onNetEvent_MSG_MS2C_GET_GUILD_LIST(event)
    local useData = event._usedata
    local msgData = useData.msgData

    for i=1, msgData.num do
        print(i)
    end
end



function controler_no_guild_main_layer:_doEventCallBack( sender, eventName, data )
    if self._controlerEventCallBack ~= nil then
        self._controlerEventCallBack(sender, eventName, data)
    end
end

return controler_no_guild_main_layer




