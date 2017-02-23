--
-- Author: Wu Hengmin
-- Date: 2015-07-24 11:26:27
--
local mail_dialog = class("mail_dialog", cc.load("mvc").ViewBase)

mail_dialog.RESOURCE_FILENAME = "ui_instance/mail/mail_dialog.csb"


function mail_dialog:onCreate()
	-- body
	-- 更新标题
	self.resourceNode_:getChildByName("main_layout")


	self:registUIEvent()
	self:_registGlobalEventListeners()

	GLOBAL_COMMON_ACTION:popupOut({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
		})
end

function mail_dialog:update(data)
	-- body
	if type(data) == "userdata" then
		data = self.data
	else
		self.data = data
	end


	-- 附件
	local getNode = self.resourceNode_:getChildByName("main_layout"):getChildByName("get_node")
	if data.adjunctNum > 0 then
		getNode:setVisible(true)
		getNode.name = getNode:getChildByName("name"):setString(UIManager:createDropName(data.adjunctType, data.adjunctID))
		getNode.name = getNode:getChildByName("count"):setString("x"..data.adjunctNum)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("button_get"):setVisible(true)
	else
		getNode:setVisible(false)
		self.resourceNode_:getChildByName("main_layout"):getChildByName("button_get"):setVisible(false)
	end

	-- 标题和正文
	local title = self.resourceNode_:getChildByName("main_layout"):getChildByName("title")
	title:setString(data.SendName)
	local content = self.resourceNode_:getChildByName("main_layout"):getChildByName("content")
	content:setString(data.Content)

	gameTcp:SendMessage(MSG_C2MS_MAIL_OPEN ,{data.guid})
	data.Read_Time = os.time()

	dispatchGlobaleEvent("model_mailManager", "refreshlist")
end

function mail_dialog:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "model_mailManager", eventName = "refreshdialog", callBack=handler(self, self.update)},
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function mail_dialog:_removeAllGlobalEventListeners()
	for k,v in pairs(self._globalEventListeners) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v)
	end
end

function mail_dialog:registUIEvent()
	-- body

	-- 关闭按钮
	local button_exit = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_exit")
	local function exitClicked(sender)
		self:close()
	end
	button_exit:addClickEventListener(exitClicked)


	-- 收取按钮
	local button_get = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_get")
	local function getClicked(sender)
		-- 收取附件
		gameTcp:SendMessage(MSG_C2MS_MAIL_TAKE_ATTACHMENT ,{self.data.guid})
	end
	button_get:addClickEventListener(getClicked)


	-- 删除按钮
	local button_del = self.resourceNode_:getChildByName("main_layout"):getChildByName("button_del")
	local function delClicked(sender)
		-- 删除邮件
		gameTcp:SendMessage(MSG_C2MS_MAIL_DEL ,{1, self.data.guid})
		self:close()
	end
	button_del:addClickEventListener(delClicked)

end

function mail_dialog:close()
	-- body
	GLOBAL_COMMON_ACTION:popupBack({
			node = self.resourceNode_:getChildByName("main_layout"),
			shadowNode = self.resourceNode_:getChildByName("shadow_layout"),
			callback = function ()
				-- body
				self:_removeAllGlobalEventListeners()
				self:removeFromParent(true)
			end
		})
end

return mail_dialog
