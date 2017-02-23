--
-- Author: Wu Hengmin
-- Date: 2015-07-24 10:03:59
--

local model_mailManager = class("model_mailManager")

--[[发送全局事件名预览
eventModleName: model_mailManager
eventName: 
	refreshdialog -- 获得附件后刷新弹窗
	refreshlist -- 删除邮件或获得附件后刷新列表
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_MAIL_DEL_RE) -- 删除邮件
	tostring(MSG_MS2C_MAIL_TAKE_ATTACHMENT_RE) -- 获得附件
]]

function model_mailManager:ctor()
	-- body
	self.data = {}

	self:_registGlobalEventListeners()
end

--添加邮件
function model_mailManager:addMail(mail)
	self.data[mail.guid] = mail
end

--去除邮件
function model_mailManager:removeMail(guid)
	self.data[guid] = nil
end

function model_mailManager:CleanMail()
	-- body
	self.data = {}
end

--改变邮件读取标示
function model_mailManager:SetReadMark(guid, time, isget)
	if self.data[guid] then
		self.data[guid].Read_Time = time;
		if isget then
			self.data[guid].adjunctNum = 0;
			self.data[guid].adjunctType = 0;
		end
	end
end

function model_mailManager:_registGlobalEventListeners()
	-- body
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_MAIL_DEL_RE), callBack=handler(self, self._onMSG_MS2C_MAIL_DEL_RE)},
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_MAIL_TAKE_ATTACHMENT_RE), callBack=handler(self, self._onMSG_MS2C_MAIL_TAKE_ATTACHMENT_RE)},
		
	}

	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function model_mailManager:_onMSG_MS2C_MAIL_TAKE_ATTACHMENT_RE(params)
	-- body
	local guid = params._usedata.guid
	self:SetReadMark(guid, os.time(), true)
	dispatchGlobaleEvent("model_mailManager", "refreshlist")
	dispatchGlobaleEvent("model_mailManager", "refreshdialog")
end

function model_mailManager:_onMSG_MS2C_MAIL_DEL_RE(params)
	-- body
	local guid = params._usedata.guid
	self:removeMail(guid)
	
	dispatchGlobaleEvent("model_mailManager", "refreshlist")
end

return model_mailManager
