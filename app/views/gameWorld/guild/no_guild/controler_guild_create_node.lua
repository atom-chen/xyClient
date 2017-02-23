--
-- Author: lipeng
-- Date: 2015-08-17 11:30:48
-- 控制器: 创建公会

local controler_guild_create_node = class("controler_guild_create_node")


function controler_guild_create_node:ctor( guild_create_node )
	self:_initModels()

	self._guild_create_node = guild_create_node

	self._panel = self._guild_create_node

	self:_registUIEvent()
    self:_updateViews()
end


function controler_guild_create_node:getView()
	return self._guild_create_node
end

function controler_guild_create_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end


function controler_guild_create_node:_initModels()
	self._controlerEventCallBack = nil
end

function controler_guild_create_node:_registUIEvent()
	local function button_exitCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:_doEventCallBack(self, "exit")
        end
    end

    local button_exit = self._panel:getChildByName("button_exit")
    button_exit:addTouchEventListener(button_exitCallback)

    
    local function btn_createCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
        	local guildName = self._panel:getChildByName("TextField_1"):getString()
        	local errorTip = "" -- 错误提示

        	if guildName == "" then
        		errorTip = "请输入军团名称"
            elseif MAIN_PLAYER:getBaseAttr():getGold() < Guild_NeedGold then
            	errorTip = "银两不足"
            elseif MAIN_PLAYER:getBaseAttr():getYuanBao() < Guild_NeedYuanBao then
            	errorTip = "元宝不足"
            elseif string.utf8len(guildName) > 6 then
                errorTip = "军团名字最长6个字"
        	end

        	if errorTip ~= "" then
                UIManager:CreatePrompt_Operate( {
			        title = "提示",
			        content = errorTip,
				} )
        	else
        		--发送创建公会请求
                printLog("网络日志"," 发送创建公会请求: "..MSG_C2MS_GUILD_CREATE.."  "..guildName)
                gameTcp:SendMessage(MSG_C2MS_GUILD_CREATE, {guildName})
        	end
        end
    end

    local btn_create = self._panel:getChildByName("btn_create")
    btn_create:addTouchEventListener(btn_createCallback)
end

function controler_guild_create_node:_updateViews()
    self._panel:getChildByName("text_yuanBaoValue"):setString(Guild_NeedYuanBao)
end


function controler_guild_create_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guild_create_node
