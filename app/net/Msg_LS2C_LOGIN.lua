--
-- Author: Li Yang
-- Date: 2014-01-15 15:31:45
-- 登陆Ls消息

-- 登陆错误处理逻辑
-- Msg_Logic[MSG_LS2C_LOGIN_ValidateError] = function (tcp , msg)
-- 	local result = msg:ReadIntData()
-- 	--断开登陆服务器
-- 	tcp:Disconnect( );
-- 	if result ~= eLET_LoginNoError then
-- 		logPrint("网络日志","收到LS账号验证结果-->"..result)
-- 		Uniquify_LoginScene:UpDataLoginAccount_ErrorShow( getErrorDescribe( result ))
-- 		--开启点击事件
-- 		TounchContrlScheduler(0);
-- 	end
-- end

-- 服务器发送登陆信息给客户端
Msg_Logic[MSG_LS2C_LOGIN_TOKEN] = function ( tcp , msg )
	-- 结果
	local result = msg:ReadIntData();
	--关闭登陆超时验证
	tcp:CloseMsgTimeOutCheck( );
	print("=============:"..MSG_LS2C_LOGIN_TOKEN ,result,eLET_LoginNoError)
	if result == eLET_LoginNoError then
		-- 验证码token
		Data_Login.token = msg:ReadString();
		--账号
		Data_Login.userID = msg:ReadString();
		if Data_Login.login_type == 6 then
			Data_Login.qihuID = msg:ReadString()
			printInfo("网络日志 %s","user.qihuID:"..Data_Login.qihuID)

			printInfo("网络日志 %s","发起实名验证")
			Lua2J_isChildren()
		elseif Data_Login.login_type == 7 then
			Data_Login.account = msg:ReadString()
			Uniquify_LoginScene.topView:UpDataAccount(user.account)
			Uniquify_LoginScene.topView:setShowType( 1 )
			Uniquify_LoginScene.bottomView:SetIntobuttonVisible(true)
		end

		printInfo("网络日志 %s","登陆LS服务器成功Token："..Data_Login.token..
			",userID："..Data_Login.userID)
		if Data_Login.Logic_Operation == 1 then
			--连接游戏服务器
			--断开登陆服务器
			tcp:Disconnect(5);
		else
			--断开登陆服务器
			tcp:Disconnect(2);--手动断开登陆服务器
			--关闭账号输入界面
			dispatchGlobaleEvent( "login" ,"event_loginAccountsucceed");
			--开启点击事件
			GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
		end
	else
		--断开登陆服务器
		tcp:Disconnect( );
		-- result = msg:ReadIntData();
		printInfo("网络日志 %s","登陆LS服务器失败，错误码："..result..getErrorDescribe( result ))
		UIManager:CreatePrompt_Bar( {
			content = getErrorDescribe( result ),
		} )
		--关闭连接等待界面
		dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "loginwait"})
		--开启点击事件
		GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
	end
end

-- 服务器发送注册结果
Msg_Logic[MSG_LS2C_LOGIN_Register] = function ( tcp , msg )
	-- 结果
	local result = msg:ReadIntData();
	--关闭登陆超时验证
	tcp:CloseMsgTimeOutCheck( );
	printInfo("网络日志 %s","收到账号注册结果 MSG_LS2C_LOGIN_Register -->"..result)
	if result ~= eLET_LoginNoError then
		
		--登陆状态处理使用的登陆错误提示
		UIManager:CreatePrompt_Bar( {
			content = getErrorDescribe( result ),
		} )
	else
		Logic_Operation = 1;
		printInfo("网络日志 %s","注册成功")
		-- 关闭注册界面
		dispatchGlobaleEvent( "login" ,"event_registersucceed");

	end
	--开启点击事件
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);

end



