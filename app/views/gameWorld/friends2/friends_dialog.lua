--
-- Author: Wu Hengmin
-- Date: 2015-08-28 16:43:36
--


local friends_dialog = class("friends_dialog", cc.load("mvc").ViewBase)

friends_dialog.RESOURCE_FILENAME = "ui_instance/friends2/friends_dialog.csb"

function friends_dialog:onCreate()
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
		UIManager:createFriendsMailDialog(self.data)
	end
	button_mail:addClickEventListener(mailclickEvent)

	local button_info = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_info")
	local function infoclickEvent(sender, eventType)
		-- body
		print("点击信息")
		-- gameTcp:SendMessage(MSG_C2MS_FRIEND_TEAM_INFO, {self.data.guid})
		UIManager:createFriendTeamDialog(self.data)
	end
	button_info:addClickEventListener(infoclickEvent)

	local button_qie = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_qie")
	local function qieclickEvent(sender, eventType)
		-- body
		print("点击切磋")
		-- gameTcp:SendMessage(MSG_C2MS_ITEMS_SELL, {1, self.data.id, self.count})
	end
	button_qie:addClickEventListener(qieclickEvent)

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

function friends_dialog:update(data)
	-- body
	self.data = data
	self.resourceNode_:getChildByName("main_layout"):getChildByName("name"):setString(data.Name)

	local level = self.resourceNode_:getChildByName("main_layout"):getChildByName("name_0")
	level:setString(data.grade)
	local zhanli = self.resourceNode_:getChildByName("main_layout"):getChildByName("name_1_0")
	zhanli:setString(data.strength)
	local vipg = self.resourceNode_:getChildByName("main_layout"):getChildByName("name_0_1")
	vipg:setString(data.vipgrade)

	-- 头像
	if data.captainhero then
		local iconNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("Panel_5")
		iconNode:removeAllChildren()
		iconNode:setCascadeOpacityEnabled(true)
		local icon = UIManager:CreateDropOutFrame(
			"卡片",
			data.captainhero.templeateID
		):getResourceNode()
		if icon then
			icon:setSwallowTouches(false)
			icon:setCascadeOpacityEnabled(true)
			icon:setPosition(50, 50)
			iconNode:addChild(icon)
		end
	end
end

function friends_dialog:close()
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

return friends_dialog
