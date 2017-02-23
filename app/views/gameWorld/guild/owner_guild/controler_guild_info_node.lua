--
-- Author: lipeng
-- Date: 2015-08-12 20:00:43
-- 控制器: 公会信息面板
local classRichTextListView = require(FILE_PATH.PATH_VIEWS_BASE..".RichTextListView")


local controler_guild_info_node = class("controler_guild_info_node")

function controler_guild_info_node:ctor( guild_info_node )
	self:_initModels()

	self._guild_info_node = guild_info_node

	self._panel1 = self._guild_info_node:getChildByName("Panel_1")
	self._xuanYan = self._panel1:getChildByName("tf_xuanYan")
	self._gongGao = self._panel1:getChildByName("tf_gongGao")

	self:_initView_NeiZhengView()
	self:_initView_JunShi()
	self:_registNodeEvent()
	self:_registUIEvent()

	self:_registGlobalEventListeners()
end

function controler_guild_info_node:getView()
	return self._guild_info_node
end


function controler_guild_info_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end


function controler_guild_info_node:_initModels()
	self._controlerEventCallBack = nil
end

function controler_guild_info_node:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "net", eventName = tostring(MSG_MS2C_GUILD_GETINFO), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_GETINFO)},
		{modelName = "net", eventName = tostring(MSG_MS2C_SET_XUANYAN), callBack=handler(self, self._onNetEvent_MSG_MS2C_SET_XUANYAN)},
		{modelName = "net", eventName = tostring(MSG_MS2C_SET_GONGGAO), callBack=handler(self, self._onNetEvent_MSG_MS2C_SET_GONGGAO)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function controler_guild_info_node:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end


function controler_guild_info_node:_initView_NeiZhengView()
	self._neiZhengListView = classRichTextListView.new(
		{
			width = 480, 
			height = 215,
			backgroundColorType = ccui.LayoutBackGroundColorType.solid
		}
	)
	local neiZhengPosNode = self._panel1:getChildByName("neiZhengPos")
	neiZhengPosNode:addChild(self._neiZhengListView)
end


function controler_guild_info_node:_initView_JunShi()
	self._junShiListView = classRichTextListView.new(
		{
			width = 480, 
			height = 215,
			backgroundColorType = ccui.LayoutBackGroundColorType.solid
		}
	)
	local junShiPosNode = self._panel1:getChildByName("junShiPos")
	junShiPosNode:addChild(self._junShiListView)
end


function controler_guild_info_node:_registNodeEvent()
	local function onNodeEvent(tag)
        if tag == "exit" then
            self:_removeAllGlobalEventListeners()
        end
    end

    self._guild_info_node:registerScriptHandler(onNodeEvent)
end


function controler_guild_info_node:_registUIEvent()
	--军团展示
	-- local btn_zhanshi = self._panel1:getChildByName("btn_zhanshi")
	-- local function btn_zhanshiTouched( sender,eventType )
	-- 	if eventType == ccui.TouchEventType.ended then
	-- 		self:_doEventCallBack(sender, "btn_zhanshiTouched")
 --        end
	-- end
	-- btn_zhanshi:addTouchEventListener(btn_zhanshiTouched)


	--军团宣言编辑完成
	local btn_xy_editFinish = self._panel1:getChildByName("btn_xy_editFinish")
	local function btn_xy_editFinishTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local text = self._panel1:getChildByName("tf_xuanYan"):getString()

            if string.utf8len(text) > 16 then
            	UIManager:CreateSamplePrompt("字符数过多, 最多输入16个字")
                return
            end

            printLog("网络日志", "发送编辑军团宣言消息(MSG_C2MS_SET_XUANYAN)")
            gameTcp:SendMessage(MSG_C2MS_SET_XUANYAN,
                {text}
            )
        end
	end
	btn_xy_editFinish:addTouchEventListener(btn_xy_editFinishTouched)

	--军团公告编辑完成
	local btn_gg_editFinish = self._panel1:getChildByName("btn_gg_editFinish")
	local function btn_gg_editFinishTouched( sender,eventType )
		if eventType == ccui.TouchEventType.ended then
			local text = self._panel1:getChildByName("tf_gongGao"):getString()

            if string.utf8len(text) > 45 then
            	UIManager:CreateSamplePrompt("字符数过多, 最多输入45个字")
                return
            end

            printLog("网络日志", "发送编辑军团公告消息(MSG_C2MS_SET_GONGGAO)")
            gameTcp:SendMessage(MSG_C2MS_SET_GONGGAO,
                {text}
            )
        end
	end
	btn_gg_editFinish:addTouchEventListener(btn_gg_editFinishTouched)

end


function controler_guild_info_node:_updateViews()
	local UIContainer = self._panel1
	local guildData = MAIN_PLAYER:getGuild()

	--icon
	widgetHelper:loadTextureWithPlist(
		UIContainer:getChildByName("icon"),
		Guild_getImageName(guildData:getLv())
	)

	--发展度
	UIContainer:getChildByName("faZhanDu_value"):setString(guildData:getLv())
	
	--成员数量
	UIContainer:getChildByName("memberNum_value"):setString(
		guildData:getMemberCurNum().."/"..guildData:getMaxMemberNum()
	)


	--军团宣言
	self._xuanYan:setString(guildData:getDeclarationContent())
	
	--军团公告
	self._gongGao:setString(guildData:getAnnouncementContent())
	
	--内政消息
	local neiZhengMsgList = guildData:getSystemMsgList()
	self._neiZhengListView:clear()

	for i,v in ipairs(neiZhengMsgList) do
		self._neiZhengListView:pushString("[d=1][/]"..v.."\n")
	end

	self._neiZhengListView:refreshView()
end


function controler_guild_info_node:_onNetEvent_MSG_MS2C_GUILD_GETINFO(event)
	local useData = event._usedata
	local msgData = useData.msgData

	if eGUILD_FindSucced == msgData.result then
		self:_updateViews()
	end
end

function controler_guild_info_node:_onNetEvent_MSG_MS2C_SET_XUANYAN(event)
	local useData = event._usedata
	local msgData = useData.msgData

	if eGUILD_SetXuanyan_Succed == msgData.result then
		self._xuanYan:setString(msgData.xuanYan)
	end
end

function controler_guild_info_node:_onNetEvent_MSG_MS2C_SET_GONGGAO(event)
	local useData = event._usedata
	local msgData = useData.msgData

	if eGUILD_SetGonggao_Succed == msgData.result then
		self._gongGao:setString(msgData.gongGao)
	end
end



function controler_guild_info_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end




return controler_guild_info_node


