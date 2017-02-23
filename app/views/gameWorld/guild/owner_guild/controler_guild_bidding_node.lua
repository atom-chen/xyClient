--
-- Author: lipeng
-- Date: 2015-08-18 14:31:23
-- 控制器: 公会竞价对话框


local controler_guild_bidding_node = class("controler_guild_bidding_node")


function controler_guild_bidding_node:ctor( guild_bidding_node )
	self:_initModels()

	self._guild_bidding_node = guild_bidding_node

	self._panel = self._guild_bidding_node

	self:_registUIEvent()
end


function controler_guild_bidding_node:getView()
	return self._guild_bidding_node
end

function controler_guild_bidding_node:addEventListener( callBack )
	self._controlerEventCallBack = callBack
end


function controler_guild_bidding_node:_initModels()
	self._controlerEventCallBack = nil
end

function controler_guild_bidding_node:_registUIEvent()
	local function button_exitCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
        	print("button_exitCallback")
            self:_doEventCallBack(self, "exit")
        end
    end

    local button_exit = self._panel:getChildByName("button_exit")
    button_exit:addTouchEventListener(button_exitCallback)

    
    local function btn_okCallback( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
        	local priceStr = self._panel:getChildByName("TextField_1"):getString()
        	local price = tonumber(priceStr)

        	local errorTip = "" -- 错误提示

        	if price == nil then
        		errorTip = "只能输入数字"
            elseif price == 0 then
            	errorTip = "请输入竞价金额"
            elseif MAIN_PLAYER:getBaseAttr():getYuanBao() < price then
            	errorTip = "元宝不足"
        	end

        	if errorTip ~= "" then
        		UIManager:CreateSamplePrompt(errorTip)
        	else
                printNetLog("发送消息 公会出价[MSG_C2MS_YUANBAO_JINGBIAO]")
                gameTcp:SendMessage(MSG_C2MS_YUANBAO_JINGBIAO, {price})
        	end
        end
    end

    local btn_ok = self._panel:getChildByName("btn_ok")
    btn_ok:addTouchEventListener(btn_okCallback)
end


function controler_guild_bidding_node:_doEventCallBack( sender, eventName, data )
	if self._controlerEventCallBack ~= nil then
		self._controlerEventCallBack(sender, eventName, data)
	end
end


return controler_guild_bidding_node

