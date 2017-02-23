--
-- Author: Wu Hengmin
-- Date: 2015-07-28 19:49:13
--
local friends_click_dialog = class("friends_click_dialog", cc.load("mvc").ViewBase)

friends_click_dialog.RESOURCE_FILENAME = "ui_instance/friends/friends_dialog.csb"

function friends_click_dialog:onCreate()
	-- body
	local button_del = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_del")
	local function delclickEvent(sender, eventType)
		-- body
		print("点击删除:"..self.data.GUID)
		gameTcp:SendMessage(MSG_C2MS_FRIEND_DEL, {self.data.GUID})
		self:close()
	end
	button_del:addClickEventListener(delclickEvent)

	local button_mail = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_mail")
	local function mailclickEvent(sender, eventType)
		-- body
		print("点击邮件")
		-- gameTcp:SendMessage(MSG_C2MS_ITEMS_SELL, {1, self.data.id, self.count})
	end
	button_mail:addClickEventListener(mailclickEvent)

	local button_info = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_info")
	local function infoclickEvent(sender, eventType)
		-- body
		print("点击信息")
		-- gameTcp:SendMessage(MSG_C2MS_ITEMS_SELL, {1, self.data.id, self.count})
	end
	button_info:addClickEventListener(infoclickEvent)

	local button_exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitclickEvent(sender, eventType)
		-- body
		self:close()
	end
	button_exit:addClickEventListener(exitclickEvent)

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})
end

function friends_click_dialog:update(data)
	-- body
	self.data = data
	self.resourceNode_:getChildByName("main_layout"):getChildByName("name"):setString(data.Name)
end

function friends_click_dialog:close()
	-- body
    GLOBAL_COMMON_ACTION:popupBack({
            node = self.resourceNode_:getChildByName("main_layout"),
            shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
            callback = function ()
                -- body
                self:removeFromParent(true)
            end
        })
end

return friends_click_dialog
