--
-- Author: lipeng
-- Date: 2015-06-29 09:37:19
-- 控制器: 聊天节点

local controler_mainpage_chat_node = class("controler_mainpage_chat_node")

--[[发送全局事件名预览
eventModleName: netMsg
eventName: 
	tostring(MSG_MS2C_SEND_WORLD_CHAT)
]]

--[[监听全局事件名预览
eventModleName: model_chatSystem
eventName:
	chatChannel_zonghe_addContent
	chatChannel_zonghe_updateAllContent
]]

function controler_mainpage_chat_node:ctor(mainpage_chat_node)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._mainpage_chat_node = mainpage_chat_node:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._mainpage_chat_node)


    self._containerNode = self._mainpage_chat_node:getChildByName("Node_1")
    self._textField_chat = self._containerNode:getChildByName("textField_chat")
    self._listView_zonghe_channel = self._containerNode:getChildByName("ListView_1")
    self._listView_zonghe_channel:setItemsMargin(10)

    --用于显示最新的一条聊天内容
    self._newChatContentNode = self._mainpage_chat_node:getChildByName("newChatContentNode")
    self._newChatContentNode:setVisible(false)

    self:_registUIEvent()
    self:_registGlobalEventListeners()

    self._listView_zonghe_channel:setVisible(false)
    self._newChatContentNode:setVisible(true)
    --self:_runAction({nameID="animation_init"})
end

function controler_mainpage_chat_node:getView()
	return self._mainpage_chat_node
end


--初始化数据
function controler_mainpage_chat_node:_initModels()
	self._models = {}
	self._models.chatList = {}
	self._models.chatMaxNum = 30
	self._models.isShow = false --是否处于显示状态
end


--注册UI事件
function controler_mainpage_chat_node:_registUIEvent()
	local UIContainer = self._containerNode

	--发送聊天消息
    local function btn_sendMsgCallback( sender, eventType )
    	if eventType == ccui.TouchEventType.ended then
    		--G_onCommand["cmd_test_chat"]["MSG_MS2C_INSAID_CHAT_ROOM"]()
    		G_onCommand["cmd_test_chat"]["MSG_MS2C_SEND_WORLD_CHAT"]({sendContent = self._textField_chat:getString()})
    		-- local text = self._textField_chat:getString()
      --   	gameTcp:SendMessage(MSG_C2MS_SEND_WORLD_CHAT, {text})
        end
    end
    local btn_sendMsg = UIContainer:getChildByName("btn_sendMsg")
    btn_sendMsg:addTouchEventListener(btn_sendMsgCallback)

    --关闭/开启聊天窗口
    local function btn_showControlCallback( sender, eventType )
    	if eventType == ccui.TouchEventType.ended then
    		if self._models.isShow then
    			self._models.isShow = false
    			self:_runAction({nameID="animation_close"})
    		else
    			self._models.isShow = true
    			self:_runAction({nameID="animation_open"})
    		end
        end
    end
    local btn_showControl = UIContainer:getChildByName("btn_showControl")
    btn_showControl:addTouchEventListener(btn_showControlCallback)
end


--注册全局事件监听器
function controler_mainpage_chat_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_chatSystem", eventName = "chatChannel_zonghe_addContent", callBack=handler(self, self._onChatChannel_zonghe_addContent)},
		{modelName = "model_chatSystem", eventName = "chatChannel_zonghe_updateAllContent", callBack=handler(self, self._onChatChannel_zonghe_updateAllContent)}
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function controler_mainpage_chat_node:_onChatChannel_zonghe_addContent( event )
	local eventUsedata = event._usedata
	local newContent = eventUsedata.newContent
	local chatChannel_zonghe_instance = eventUsedata.chatChannel_zonghe_instance

	local channel_listView = self._listView_zonghe_channel

	local items = channel_listView:getItems()
    local items_count = table.getn(items)

	if items_count >= chatChannel_zonghe_instance:getContentMaxNum() then
		channel_listView:removeItem(0)
	end

	local item = self:_chatContentToListItem(newContent)
    channel_listView:addChild(item)

	channel_listView:refreshView()
	channel_listView:jumpToBottom()

	--放入用于显示最新消息的节点中
	local item2 = self:_chatContentToListItem(newContent)
	self._newChatContentNode:removeAllChildren()
	self._newChatContentNode:addChild(item2)
end


function controler_mainpage_chat_node:_onChatChannel_zonghe_updateAllContent( event )
	local eventUsedata = event._usedata
	local chatChannel_zonghe_instance = eventUsedata.chatChannel_zonghe_instance
	self:_updateChatListViewWithChannel(chatChannel_zonghe_instance)
end

--[[
聊天内容转listItem
]]
--将聊天内容转换为listItem
function controler_mainpage_chat_node:_chatContentToListItem( content )
	local listItem = nil

	if content.__cname == "model_chatContent_world" then
		listItem = self:_chatContent_worldToListItem(content)

	elseif content.__cname == "model_chatContent_laBa" then
		listItem = self:_chatContent_laBaToListItem(content)

	elseif content.__cname == "model_chatContent_gongGao" then
		listItem = self:_chatContent_gongGaoToListItem(content)
	end

	return listItem
end

--将世界聊天内容转换为listItem
function controler_mainpage_chat_node:_chatContent_worldToListItem( content )    
	local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(460, 10))

    local re1 = ccui.RichElementText:create(1, cc.c3b(255, 0, 0), 255, "[世界]", DEFAULT_FONT, 25)
    local vipImageFile = "ui_image/mainpage/head/image_vip2.png"
    if content:getSenderVIPLv() > 0 then
    	vipImageFile = "ui_image/mainpage/head/image_vip1.png"
    end
    local vipSprite = cc.Sprite:createWithSpriteFrameName(vipImageFile)
    local re2 = ccui.RichElementCustomNode:create(3, cc.c3b(255, 255, 255), 255, vipSprite)
    local re3 = ccui.RichElementText:create(2, cc.c3b(255, 255, 255), 255, content:getSenderName(), DEFAULT_FONT, 25)
    local re4 = ccui.RichElementText:create(4, cc.c3b(255, 255, 255), 255, content:getSendContent(), DEFAULT_FONT, 25)
    richText:pushBackElement(re1)
    richText:pushBackElement(re2)
    richText:pushBackElement(re3)
    richText:pushBackElement(re4)
	printInfo("%s, %s, %s", content:getSenderName(), content:getSendContent(), content:getSenderVIPLv())


	richText:formatText()

	return richText
end

--将喇叭聊天内容转换为listItem
function controler_mainpage_chat_node:_chatContent_laBaToListItem( content )
	printInfo("_chatContent_laBaToListItem")
end

--将公告聊天内容转换为listItem
function controler_mainpage_chat_node:_chatContent_gongGaoToListItem( content )
	printInfo("_chatContent_gongGaoToListItem")
end



--[[
通过聊天频道数据更新聊天列表视图
]]
function controler_mainpage_chat_node:_updateChatListViewWithChannel( chatChannel )
	local channel_listView = self._listView_zonghe_channel
	channel_listView:removeAllChildren()

	chatChannel:forEachContentDoSomething(function ( i, v )
		local item = self:_chatContentToListItem(v)
    	channel_listView:addChild(item)
	end)

	channel_listView:refreshView()
	channel_listView:jumpToBottom()
end



function controler_mainpage_chat_node:_runAction(parmas)
	if parmas.nameID == "animation_close" then
		self:_runCCSAction_animation_close(parmas)
	elseif parmas.nameID == "animation_open" then
		self:_runCCSAction_animation_open(parmas)
	end
end

function controler_mainpage_chat_node:_createTimeline()
	return cc.CSLoader:createTimeline("ui_instance/mainPage/top_layer/mainpage_chat_node.csb")
end

--关闭聊天窗动画
function controler_mainpage_chat_node:_runCCSAction_animation_close( parmas )
	self._mainpage_chat_node:stopAllActions()

	local action = self:_createTimeline()

	local function onFrameEvent(frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "closeFinish" then
            self._listView_zonghe_channel:setVisible(false)
            self._newChatContentNode:setVisible(true)
        end
    end

    action:setFrameEventCallFunc(onFrameEvent)

	self._mainpage_chat_node:runAction(action)
    action:play("animation_close", false)
    self._containerNode:getChildByName("btn_showControl_1"):
    	setFlippedY(true)
    
end


--打开聊天窗动画
function controler_mainpage_chat_node:_runCCSAction_animation_open( parmas )
	self._mainpage_chat_node:stopAllActions()

	self._listView_zonghe_channel:setVisible(true)
    self._newChatContentNode:setVisible(false)

	local action = self:_createTimeline()
	self._mainpage_chat_node:runAction(action)
    action:play("animation_open", false)

    self._containerNode:getChildByName("btn_showControl_1"):
    	setFlippedY(false)
end


return controler_mainpage_chat_node
