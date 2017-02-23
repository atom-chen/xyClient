--
-- Author: lipeng
-- Date: 2015-08-14 14:52:25
-- 控制器: 公会争霸

local controler_guild_zhengba_node = class("controler_guild_zhengba_node")


function controler_guild_zhengba_node:ctor( guild_zhengba_node )
	self:_initModels()

	self._guild_zhengba_node = guild_zhengba_node

	self._panle1 = self._guild_zhengba_node:getChildByName("Panel1")
	self._panle2 = self._guild_zhengba_node:getChildByName("Panel2")

	self:_registUIEvent()
	self:_registNodeEvent()
	self:_registGlobalEventListeners()
	self:_updateView()
end


function controler_guild_zhengba_node:getView()
	return self._guild_zhengba_node
end

function controler_guild_zhengba_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end


function controler_guild_zhengba_node:_initModels()
	self._controlerEventCallBack = nil
end

function controler_guild_zhengba_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_ROLE_UPDATE_MAPWAR_NUM), callBack=handler(self, self._onNetEvent_MSG_MS2C_ROLE_UPDATE_MAPWAR_NUM)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


function controler_guild_zhengba_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

function controler_guild_zhengba_node:_registUIEvent()
	--贡献排行
	local btn_gongxian_rank = self._panle1:getChildByName("btn_gongxian_rank")
	local function btn_gongxian_rankTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self:_doEventCallBack(sender, "btn_gongxian_rankTouched")
        end
	end
	btn_gongxian_rank:addTouchEventListener(btn_gongxian_rankTouched)


	--军团排行
	local btn_guild_rank = self._panle1:getChildByName("btn_guild_rank")
	local function btn_guild_rankTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self:_doEventCallBack(sender, "btn_guild_rankTouched")
        end
	end
	btn_guild_rank:addTouchEventListener(btn_guild_rankTouched)

	--购买次数
	local btn_buyCount = self._panle2:getChildByName("btn_buyCount")
	local function btn_buyCountTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			printNetLog("发送消息 购买攻城次数(MSG_C2MS_MAPWAR_BUY)")
			gameTcp:SendMessage(MSG_C2MS_MAPWAR_BUY)
        end
	end
	btn_buyCount:addTouchEventListener(btn_buyCountTouched)

	--出征
	local btn_battle = self._panle2:getChildByName("btn_battle")
	local function btn_battleTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			self:_doEventCallBack(sender, "btn_battleTouched")
        end
	end
	btn_battle:addTouchEventListener(btn_battleTouched)
end


function controler_guild_zhengba_node:_registNodeEvent()
	local function onNodeEvent(tag)
        if tag == "exit" then
            self:_removeAllGlobalEventListeners()
        end
    end

    self._guild_zhengba_node:registerScriptHandler(onNodeEvent)
end

function controler_guild_zhengba_node:_updateView()
	self:_updateView_attckCount()
end


function controler_guild_zhengba_node:_updateView_attckCount()
	self._panle2:
		getChildByName("text_attckCountValue"):
		setString(MAIN_PLAYER:getBaseAttr():getAtkRemainTime())
end


function controler_guild_zhengba_node:_onNetEvent_MSG_MS2C_ROLE_UPDATE_MAPWAR_NUM( event )
	print("11111")
	self:_updateView_attckCount()
end

function controler_guild_zhengba_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guild_zhengba_node
