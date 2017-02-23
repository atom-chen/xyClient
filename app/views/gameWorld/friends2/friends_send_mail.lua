--
-- Author: Wu Hengmin
-- Date: 2015-09-14 10:34:09
--


local friends_send_mail = class("friends_send_mail", cc.load("mvc").ViewBase)

friends_send_mail.RESOURCE_FILENAME = "ui_instance/friends2/friends_send_mail.csb"

function friends_send_mail:onCreate()
	-- body

	self.textfield = self.resourceNode_:getChildByName("main_layout"):getChildByName("TextField_2")

	local button_exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitclickEvent(sender, eventType)
		-- body
		self:close()
	end
	button_exit:addClickEventListener(exitclickEvent)

	local button_del = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_mail")
	local function delclickEvent(sender, eventType)
		-- body
		print("点击发送,内容:"..self.textfield:getString())
		-- gameTcp:SendMessage(MSG_C2MS_FRIEND_DEL, {self.data.GUID})
		gameTcp:SendMessage(MSG_C2MS_MAIL_SEND , {
                    self.data.GUID,
                    1,
                    self.textfield:getString(),
                })
		self:close()
	end
	button_del:addClickEventListener(delclickEvent)


	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})
end

function friends_send_mail:update(data)
	-- body
	self.data = data
	-- self.resourceNode_:getChildByName("main_layout"):getChildByName("name"):setString(data.Name)
end

function friends_send_mail:close()
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

return friends_send_mail
