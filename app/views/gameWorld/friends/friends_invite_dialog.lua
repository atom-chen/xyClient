--
-- Author: Wu Hengmin
-- Date: 2015-07-28 19:49:13
--
local friends_invite_dialog = class("friends_invite_dialog", cc.load("mvc").ViewBase)

friends_invite_dialog.RESOURCE_FILENAME = "ui_instance/friends/friends_invite_dialog.csb"

function friends_invite_dialog:onCreate()
	-- body
	local button_allow = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_allow")
	local function allowclickEvent(sender, eventType)
		-- body
		print("点击通过:"..self.data.GUID)
		gameTcp:SendMessage(MSG_C2MS_FRIEND_AGREE, {self.data.GUID, 1})
		self:close()
		
	end
	button_allow:addClickEventListener(allowclickEvent)

	local button_refuse = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_refuse")
	local function refuseclickEvent(sender, eventType)
		-- body
		print("点击拒绝")
		gameTcp:SendMessage(MSG_C2MS_FRIEND_AGREE, {self.data.GUID, 0})
		self:close()
	end
	button_refuse:addClickEventListener(refuseclickEvent)

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

function friends_invite_dialog:update(data)
	-- body
	self.data = data
	self.resourceNode_:getChildByName("main_layout"):getChildByName("name"):setString(data.Name)
end

function friends_invite_dialog:close()
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

return friends_invite_dialog
