--
-- Author: lipeng
-- Date: 2015-08-05 16:11:24
-- 控制器: 拥有公会时的入口层

local class_controler_owner_guild_tab_list = import(".controler_owner_guild_tab_list")
local class_controler_guild_info_node = import(".controler_guild_info_node")
local class_controler_guild_member_list_node = import(".controler_guild_member_list_node")
local class_controler_guild_member_verify_list = import(".controler_guild_member_verify_list")
local class_controler_guild_look_member_node = import(".controler_guild_look_member_node")
local class_controler_guild_keji_list_node = import(".controler_guild_keji_list_node")
local class_controler_guild_zhengba_node = import(".controler_guild_zhengba_node")
local class_controler_guild_gongxian_node = import(".controler_guild_gongxian_node")
local class_controler_guild_guild_rank_node = import(".controler_guild_guild_rank_node")
local class_controler_owner_guild_juntuan_zhanshi_node = import(".controler_owner_guild_juntuan_zhanshi_node")
local class_controler_guild_bidding_node = import(".controler_guild_bidding_node")



local controler_owner_guild_main_layer = class("controler_owner_guild_main_layer")


function controler_owner_guild_main_layer:ctor(owner_guild_main_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--根层
	self._owner_guild_main_layer = owner_guild_main_layer
    self._owner_guild_main_layer:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._owner_guild_main_layer)


    self._shadowLayout = self._owner_guild_main_layer:getChildByName("shadow_layout")
    self._shadowLayout:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._shadowLayout)

    --弹窗遮罩层
    self._popup_mask = self._owner_guild_main_layer:getChildByName("popup_mask")
    self._popup_mask:setContentSize(visibleSize)
    ccui.Helper:doLayout(self._popup_mask)


    -- local guildShowPosNode = self._owner_guild_main_layer:getChildByName("guildShow")
    -- ccui.Helper:doLayout(self.guildShowPosNode)

    self._background = self._owner_guild_main_layer:getChildByName("background")

    self:_createControlerForUI()

    self:_registNodeEvent()

    self:_registUIEvent()

    self:_registGlobalEventListeners()

    self:_updateView()
end


function controler_owner_guild_main_layer:getView()
    return self._owner_guild_main_layer
end

function controler_owner_guild_main_layer:addEventListener( callBack )
    self._controlerEventCallBack = callBack
end

function controler_owner_guild_main_layer:_initModels()
    self._controlerMap = {}
    self._controlerEventCallBack = nil
    self._curShowPanleControler = nil
end

function controler_owner_guild_main_layer:_registGlobalEventListeners()
    self._globalEventListeners = {}

    local configs = {
        {modelName = "net", eventName = tostring(MSG_MS2C_YUANBAO_JINGBIAO), callBack=handler(self, self._onNetEvent_MSG_MS2C_YUANBAO_JINGBIAO)},
        {modelName = "net", eventName = tostring(MSG_MS2C_GUILD_GETINFO), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_GETINFO)},
        {modelName = "net", eventName = tostring(MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD), callBack=handler(self, self._onNetEvent_MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD)},
    }
    self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end


--注册节点事件
function controler_owner_guild_main_layer:_registNodeEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            self:_removeAllGlobalEventListeners()
        end
    end
    self._owner_guild_main_layer:registerScriptHandler(onNodeEvent)
end


function controler_owner_guild_main_layer:_removeAllGlobalEventListeners()
    for k,v in pairs(self._globalEventListeners) do
        GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
    end
end

--创建控制器: UI
function controler_owner_guild_main_layer:_createControlerForUI()
    self._controlerMap.tabList = class_controler_owner_guild_tab_list.new(
        self._background:getChildByName("tabs")
    )

    self._controlerMap.tabList:addEventListener(handler(self, self._onEvent_tabList))
    self._controlerMap.tabList:setSelectedTab("信息")
end


function controler_owner_guild_main_layer:_registUIEvent()
    local function button_exitCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "exit")
        end
    end
    local button_exit = self._background:getChildByName("button_exit")
    button_exit:addTouchEventListener(button_exitCallback)
end


function controler_owner_guild_main_layer:_updateView()
    
end

--[[
onNetEvent
]]
function controler_owner_guild_main_layer:_onNetEvent_MSG_MS2C_YUANBAO_JINGBIAO(event)
    local eventUseData = event._usedata
    local msgData = eventUseData.msgData

    if msgData.result == eGUILD_Jingbiaochenggong then
        if self._controlerMap.guildBiddingDialog ~= nil then
            self._controlerMap.guildBiddingDialog:getView():removeFromParent()
            self._controlerMap.guildBiddingDialog = nil
            self._popup_mask:setVisible(false)
        end
    end

end

function controler_owner_guild_main_layer:_onNetEvent_MSG_MS2C_GUILD_GETINFO(event)
    self._background:getChildByName("guildName"):setString(MAIN_PLAYER:getGuild():getName())
end

function controler_owner_guild_main_layer:_onNetEvent_MSG_MS2C_GUILD_MAKEMEMBER_QUITGUILD(event)
    local useData = event._usedata
    local msgData = useData.msgData

    if eGUILD_QuitSucced == msgData.result then
        self:closeUI_lookMemberInfo()
    end
end


--[[
onEvent
]]

function controler_owner_guild_main_layer:_onEvent_tabList( sender, eventName, data )
    if eventName == "selectedTabChange" then
        if self._curShowPanleControler ~= nil then
            self._curShowPanleControler:getView():setVisible(false)
        end

        --军团争霸需要边框隐藏
        self._background:getChildByName("Image_47"):setVisible(true)

        if data.curSelTabName == "信息" then
            if self._controlerMap.info == nil then
                self._controlerMap.info = class_controler_guild_info_node.new(
                    self:createView_info()
                )

                self._background:getChildByName("panlePos_info"):addChild(
                    self._controlerMap.info:getView()
                )

                self._controlerMap.info:addEventListener(handler(self, self._onEvent_info))
            end

            self._curShowPanleControler = self._controlerMap.info

        elseif data.curSelTabName == "成员" then
            if self._controlerMap.memberList == nil then
                self._controlerMap.memberList = class_controler_guild_member_list_node.new(
                    self:createView_memberList()
                )

                self._background:getChildByName("memberList"):addChild(
                    self._controlerMap.memberList:getView()
                )

                self._controlerMap.memberList:addEventListener(handler(self, self._onEvent_memberList))
                
            end
            self._controlerMap.memberList:setCurState("showMemberList")

            printNetLog("发送获取公会成员列表请求(MSG_C2MS_GUILD_GET_MEMBER)")
            gameTcp:SendMessage(MSG_C2MS_GUILD_GET_MEMBER)
            self._curShowPanleControler = self._controlerMap.memberList
            
        elseif data.curSelTabName == "科技" then
            if self._controlerMap.keJiList == nil then
                self._controlerMap.keJiList = class_controler_guild_keji_list_node.new(
                    self:createView_keJiList()
                )

                self._background:getChildByName("keJiList"):addChild(
                    self._controlerMap.keJiList:getView()
                )
            end

            printNetLog("发送打开公会科技请求(MSG_C2MS_OPEN_KEJI_LIST)")
            gameTcp:SendMessage(MSG_C2MS_OPEN_KEJI_LIST)

            self._curShowPanleControler = self._controlerMap.keJiList
            
            
        elseif data.curSelTabName == "争霸" then
            if self._controlerMap.zhengBa == nil then
                self._controlerMap.zhengBa = class_controler_guild_zhengba_node.new(
                    self:createView_zhengBa()
                )

                self._background:getChildByName("zhengba"):addChild(
                    self._controlerMap.zhengBa:getView()
                )

                self._controlerMap.zhengBa:addEventListener(handler(self, self._onEvent_zhengBa))
            end

            self._curShowPanleControler = self._controlerMap.zhengBa

            self._background:getChildByName("Image_47"):setVisible(false)
        end
        

        self._curShowPanleControler:getView():setVisible(true)

        --tab改变时, 如果军团展示存在
        if self._controlerMap.guildShow ~= nil then
            --则销毁军团展示面板
            self._controlerMap.guildShow:getView():removeFromParent()
            self._controlerMap.guildShow = nil
        end

        --tab改变时, 如果审核列表存在
        if self._controlerMap.verifyList ~= nil then
            --则销毁审核列表面板
            self._controlerMap.verifyList:getView():removeFromParent()
            self._controlerMap.verifyList = nil
        end
    end
end

function controler_owner_guild_main_layer:_onEvent_info( sender, eventName, data )
    if eventName == "btn_zhanshiTouched" then
        if self._controlerMap.guildShow == nil then
            self._controlerMap.guildShow = class_controler_owner_guild_juntuan_zhanshi_node.new(
                self:createView_guildShow()
            )

            self._owner_guild_main_layer:getChildByName("guildShow"):addChild(
                self._controlerMap.guildShow:getView()
            )

            self._controlerMap.guildShow:addEventListener(handler(self, self._onEvent_guildShow))

            printNetLog("发送获取军团展示列表请求(MSG_C2MS_GET_ZHANSHI_LIST)")
            gameTcp:SendMessage(MSG_C2MS_GET_ZHANSHI_LIST)
        end
    end
end



function controler_owner_guild_main_layer:_onEvent_memberList( sender, eventName, data )
    if eventName == "btn_lookTouched" then
        if self._controlerMap.lookMemberInfo == nil then
            self._controlerMap.lookMemberInfo = class_controler_guild_look_member_node.new(
                self:createView_lookMemberInfo()
            )
            self._controlerMap.lookMemberInfo:setMember(data.member)
            self._controlerMap.lookMemberInfo:updateViews()

            self._owner_guild_main_layer:getChildByName("lookMemberInfo"):addChild(
                self._controlerMap.lookMemberInfo:getView()
            )

            self._controlerMap.lookMemberInfo:addEventListener(handler(self, self._onEvent_lookMemberInfo))
            self._popup_mask:setVisible(true)
        end

    elseif eventName == "btn_shenHeTouched" then
        if self._controlerMap.verifyList == nil then
            self._controlerMap.verifyList = class_controler_guild_member_verify_list.new(
                self:createView_verifyList()
            )

            self._owner_guild_main_layer:getChildByName("verifyList"):addChild(
                self._controlerMap.verifyList:getView()
            )
        end

        self._controlerMap.verifyList:getView():setVisible(true)
        printNetLog("发送获取审核列表请求(MSG_C2MS_GUILD_GET_APPLYMEMBER)")
        gameTcp:SendMessage(MSG_C2MS_GUILD_GET_APPLYMEMBER)

    elseif eventName == "btn_memberlistTouched" then
        if self._controlerMap.memberList ~= nil then
            if self._controlerMap.verifyList ~= nil then
                self._controlerMap.verifyList:getView():setVisible(false)
            end

            printNetLog("发送获取公会成员列表请求(MSG_C2MS_GUILD_GET_MEMBER)")
            gameTcp:SendMessage(MSG_C2MS_GUILD_GET_MEMBER)
        end

    end
end

function controler_owner_guild_main_layer:_onEvent_zhengBa( sender, eventName, data )
    if eventName == "btn_gongxian_rankTouched" then
        if self._controlerMap.gongXianRank == nil then
            self._controlerMap.gongXianRank = class_controler_guild_gongxian_node.new(
                self:createView_gongXianRank()
            )

            self._owner_guild_main_layer:getChildByName("gongXian"):addChild(
                self._controlerMap.gongXianRank:getView()
            )

            self._controlerMap.gongXianRank:addEventListener(handler(self, self._onEvent_gongXianRank))
            self._popup_mask:setVisible(true)
        end

    elseif eventName == "btn_guild_rankTouched" then
        if self._controlerMap.guildRank == nil then
            self._controlerMap.guildRank = class_controler_guild_guild_rank_node.new(
                self:createView_guildRank()
            )

            self._owner_guild_main_layer:getChildByName("guildRank"):addChild(
                self._controlerMap.guildRank:getView()
            )

            self._controlerMap.guildRank:addEventListener(handler(self, self._onEvent_guildRank))

            self._popup_mask:setVisible(true)
        end

    elseif eventName == "btn_battleTouched" then
        self:_doEventCallBack(self, "btn_battleTouched")
    end
end

function controler_owner_guild_main_layer:_onEvent_gongXianRank( sender, eventName, data )
    if eventName == "exit" then
        self._controlerMap.gongXianRank:getView():removeFromParent()
        self._controlerMap.gongXianRank = nil
        self._popup_mask:setVisible(false)
    end
end

function controler_owner_guild_main_layer:_onEvent_guildRank( sender, eventName, data )
    if eventName == "exit" then
        self._controlerMap.guildRank:getView():removeFromParent()
        self._controlerMap.guildRank = nil
        self._popup_mask:setVisible(false)
    end
end


function controler_owner_guild_main_layer:_onEvent_guildShow( sender, eventName, data )
    if eventName == "button_exitTouched" then
        if self._controlerMap.guildShow ~= nil then
            self._controlerMap.guildShow:getView():removeFromParent()
            self._controlerMap.guildShow = nil
        end

    elseif eventName == "btn_bidingTouched" then
        if self._controlerMap.guildBiddingDialog == nil then
            self._controlerMap.guildBiddingDialog = class_controler_guild_bidding_node.new(
                self:createView_guildBiddingDialog()
            )

            self._owner_guild_main_layer:getChildByName("biddingDialog"):addChild(
                self._controlerMap.guildBiddingDialog:getView()
            )

            self._controlerMap.guildBiddingDialog:addEventListener(handler(self, self._onEvent_guildBiddingDialog))

            self._popup_mask:setVisible(true)
        end
    end
end


function controler_owner_guild_main_layer:_onEvent_guildBiddingDialog( sender, eventName, data )
    if eventName == "exit" then
        if self._controlerMap.guildBiddingDialog ~= nil then
            self._controlerMap.guildBiddingDialog:getView():removeFromParent()
            self._controlerMap.guildBiddingDialog = nil
            self._popup_mask:setVisible(false)
        end
    end
end


function controler_owner_guild_main_layer:_onEvent_lookMemberInfo( sender, eventName, data )
    if eventName == "button_exitTouched" then
        self:closeUI_lookMemberInfo()
    end
end

function controler_owner_guild_main_layer:closeUI_lookMemberInfo()
    if self._controlerMap.lookMemberInfo ~= nil then
        self._controlerMap.lookMemberInfo:getView():removeFromParent()
        self._controlerMap.lookMemberInfo = nil
        self._popup_mask:setVisible(false)
    end
end



--创建"信息"视图
function controler_owner_guild_main_layer:createView_info()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_info_node.csb")
end

--创建"军团展示"视图
function controler_owner_guild_main_layer:createView_guildShow()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/owner_guild_juntuan_zhanshi.csb")
end

--创建"军团竞价对话框"视图
function controler_owner_guild_main_layer:createView_guildBiddingDialog()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_bidding_node.csb")
end


--创建"成员列表"视图
function controler_owner_guild_main_layer:createView_memberList()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_member_list.csb")
end

--创建"成员信息"视图
function controler_owner_guild_main_layer:createView_lookMemberInfo()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_look_member_node.csb")
end

--创建"审核列表"视图
function controler_owner_guild_main_layer:createView_verifyList()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_member_verify_list.csb")
end


--创建"科技列表"视图
function controler_owner_guild_main_layer:createView_keJiList()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_keji_list.csb")
end


--创建"军团争霸"视图
function controler_owner_guild_main_layer:createView_zhengBa()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_zhengba_node.csb")
end


--创建"贡献排行"视图
function controler_owner_guild_main_layer:createView_gongXianRank()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_gongxian_node.csb")
end


--创建"公会排行"视图
function controler_owner_guild_main_layer:createView_guildRank()
    return cc.CSLoader:createNode("ui_instance/guild/owner_guild/guild_guild_rank_node.csb")
end


function controler_owner_guild_main_layer:_doEventCallBack( sender, eventName, data )
    if self._controlerEventCallBack ~= nil then
        self._controlerEventCallBack(sender, eventName, data)
    end
end

return controler_owner_guild_main_layer




