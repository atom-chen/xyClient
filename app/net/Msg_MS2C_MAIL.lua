--
-- Author: li Yang
-- Date: 2014-04-18 13:49:38
-- 邮件消息


-- 服务器回应邮件数据
Msg_Logic[MSG_MS2C_MAIL_DATA] = function ( tcp , msg )
	-- 邮件数量
	local mailNum = msg:ReadIntData()
	MAIN_PLAYER.mailManager:CleanMail()
	printLog("网络日志","--------收到邮件信息消息:"..mailNum)
	for i=1,mailNum do
		local maildata = require("app.models.player.mail").new()
		-- 邮件GUID
		maildata.guid = msg:ReadString()
		-- 读取标记读取时间 0 表示没读 >1 表示读取时间
		maildata.Read_Time = msg:ReadIntData()
		-- 发件人GUID
		maildata.SendGUID = msg:ReadString()
		-- 发件人名字
		maildata.SendName = msg:ReadString()
		
		maildata.Title = maildata.SendName
		if maildata.SendGUID == "{00000000-0000-0000-0000-000000000000}" then
			maildata.Type = 1
		else
			maildata.Type = 2
		end
		-- 附件icon
		maildata.IconID = msg:ReadIntData()
		-- 附件类型
		maildata.adjunctType = msg:ReadIntData()
		-- 附件ID
		maildata.adjunctID = msg:ReadIntData()
		-- 附件等级
		maildata.adjunctGrade = msg:ReadIntData()
		-- 附件数量
		maildata.adjunctNum = msg:ReadIntData()
		-- 发件时间
		maildata.Sendtime = msg:ReadIntData()
		
		-- 邮件正文
		maildata.Content = msg:ReadString()
		printLog("网络日志","            收到邮件信息:"..i..",GIUD:"..maildata.guid..",读取时间："..maildata.Read_Time
			.."，发件人GUID:"..maildata.SendGUID..",发件人名字："..maildata.SendName..",邮件类型:"..maildata.IconID..",附件ID："..maildata.adjunctID
			..",附件类型："..maildata.adjunctType..",附件数量："..maildata.adjunctNum..",发件时间："..maildata.Sendtime
			..",正文："..maildata.Content)
		--添加进邮件
		MAIN_PLAYER.mailManager:addMail( maildata )
	end
	--刷新邮件显示
	-- dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_MAIL_DATA))
end

-- 服务器回应取得邮件附件数据
Msg_Logic[MSG_MS2C_MAIL_TAKE_ATTACHMENT_RE] = function ( tcp , msg )
	local result = msg:ReadIntData();
	printLog("网络日志","--------收到取得邮件附件结果:"..result)
	if result == eMail_Success then
		local guid = msg:ReadString()


		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_MAIL_TAKE_ATTACHMENT_RE), {guid = guid})

	else
		--收取邮件附件失败
		print(getErrorDescribe( result ))
	end
end

-- 服务器回应取得删除邮件结果
Msg_Logic[MSG_MS2C_MAIL_DEL_RE] = function ( tcp , msg )
	local  result = msg:ReadIntData()
	printLog("网络日志","--------收到删除邮件结果:"..result)
	if result == eMail_Success then
		local guid = msg:ReadString()

		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_MAIL_DEL_RE), {guid = guid})
	else
		--删除邮件失败
		print("删除邮件失败")
		print(getErrorDescribe( result ))
	end
end

--发送邮件返回结果
Msg_Logic[MSG_MS2C_MAIL_SEND_RE] = function ( tcp , msg )
	local  result = msg:ReadIntData()
	printLog("网络日志","--------发送邮件结果:"..result)
	if result == eMail_Success then
		UIManager:CreatePrompt_Bar( {content = "发送成功"})
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end
end
