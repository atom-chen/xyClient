--
-- Author: Li Yang
-- Date: 2014-01-10 17:14:08
-- 消息逻辑


Msg_Logic = {};

-- 请求数据
Msg_Logic.requestData = function ()
	-- 得到其他数据
	-- 武将数据
	gameTcp:SendMessage(MSG_C2MS_GET_BACKPACK)
	-- 道具数据
	gameTcp:SendMessage(MSG_C2MS_ITEMS_GET)
	-- 得到副本关卡数据
	gameTcp:SendMessage(MSG_C2MS_GET_WAR_DATA)
	--请求队伍数据
	gameTcp:SendMessage(MSG_C2MS_GET_TEAM_DATA)
	-- 邮件数据
	gameTcp:SendMessage(MSG_C2MS_MAIL_GET)
	-- VIP数据
	gameTcp:SendMessage(MSG_C2MS_VIP_GET_INFO)
	-- 好友数据
	gameTcp:SendMessage(MSG_C2MS_GET_FRIENDS_DATA)
	-- 装备数据
	gameTcp:SendMessage(MSG_C2MS_EQUIPS_GETLIST)
	-- 获取时间差
	gameTcp:SendMessage(MSG_C2MS_LOGIN_GET_TIME, {os.time()})
	
	

	--数据请求结束标示
	gameTcp:SendMessage(MSG_C2MS_INIT_END)
end


-- 进入登陆服务
Msg_Logic.ConnectLS_Logic =function ()
	--关闭按键事件
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
	--连接登陆服务器
	gameTcp:connect(Data_Login.LS_IP, Data_Login.LS_PORT);
end

-- 进入游戏服务器
Msg_Logic.ConnectMS_Logic = function ()
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(0);
	--关闭按键事件
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
	--连接游戏服务器
	gameTcp:connect(Data_Login:getChooseServerData());
end

--断开逻辑
Msg_Logic.eDisconnect_logic = function ( tcp , msg )
	print("断开连接",tcp.ConnectState);
	if tcp.ConnectState == 1 or tcp.ConnectState == 3 then
		--后端主动断开
		-- 判断是否重连
		print(APP:IsCanResumeConnect(),(not Data_Login.ResumeConnect))
		if APP:IsCanResumeConnect() and (not Data_Login.ResumeConnect) then
			--进入重连界面
			-- UIManager:CreatePrompt_ResumeConnect();
			--创建重连
			dispatchGlobaleEvent( "resumeconnect", "create" )
		else
			-- TounchContrlScheduler(0);
			--登陆状态处理使用的登陆错误提示
			-- if Uniquify_LoginScene then
			-- 	Uniquify_LoginScene:UpDataLoginAccount_ErrorShow( "服务器断开连接" );
			-- else
			-- 	UIManager:CreatePrompt_1( display.getRunningScene() ,"服务器断开连接" );
			-- end
		end
	elseif tcp.ConnectState == 2 then
		--手动断开登陆服务器
	elseif tcp.ConnectState == 4 then
		--手动断开游戏服务器
	elseif tcp.ConnectState == 5 then
		--执行连接游戏服务器操作
		--连接游戏服务器
		-- tcp:connect(GAME_SERVER_LIST[user.chooseserver].IP, GAME_SERVER_LIST[user.chooseserver].Port);
		Msg_Logic.ConnectMS_Logic();
	end
	tcp.ConnectState = 0;
end

-- 连接逻辑处理
Msg_Logic.eNetMsg_Connect_logic = function (tcp , msg )
	local tcpConnectResult = msg:ReadIntData()

	if 0 == tcpConnectResult then --连接成功
		local _ip = msg:GetStringIP()
		local _socket = msg:GetPort()
		local chooseServerData = Data_Login:getChooseServerDescribe()
		tcp.isConnected = true;
		if Data_Login.LS_IP == _ip and Data_Login.LS_PORT == _socket then

			tcp.ConnectState = 1;--连接到登陆服务器
			printInfo("网络日志 %s","连接Ls ip= ".._ip..",port= ".._socket.."  成功".."，状态 = "..tcp.ConnectState);

			-- 注册消息
			if Data_Login.Logic_Operation == 3 then
				printInfo("网络日志 %s","发送注册消息-->MSG_C2LS_LOGIN_Register="..MSG_C2LS_LOGIN_Register .."帐号:".. Data_Login.account .."帐号:"..  Data_Login.password)
				tcp:SendMessage(MSG_C2LS_LOGIN_Register ,{
				Data_Login.account,
				Data_Login.password
				} )
			else
				-- 发送登陆验证
				printInfo("网络日志 %s","发送登陆服务器消息-->MSG_C2LS_LOGIN_ValidateInfo="..MSG_C2LS_LOGIN_ValidateInfo)
				if Data_Login.login_type == 0 then
					--账号登陆方式(登陆方式要处理)
					tcp:SendMessage(MSG_C2LS_LOGIN_ValidateInfo ,{
						Data_Login.login_type,
						10006, --ManageResUpdate.GAME_NOW_VERSION 等待处理
						10000,
						-- user.login_aim,
						Data_Login.account,
						Data_Login.password
					} )
				elseif Data_Login.login_type == 6 or Data_Login.login_type == 7 then
					--360登陆方式
					tcp:SendMessage(MSG_C2LS_LOGIN_ValidateInfo ,{
						Data_Login.login_type,
						ManageResUpdate.GAME_NOW_VERSION,
						10000,
						-- user.login_aim,
						Data_Login.token,
					} )
				elseif Data_Login.login_type == 4 then
					--当乐登陆方式

					tcp:SendMessage(MSG_C2LS_LOGIN_ValidateInfo ,{
						Data_Login.login_type,
						ManageResUpdate.GAME_NOW_VERSION,
						10000,
						-- user.login_aim,
						Data_Login.menberid,
						Data_Login.token,
					} )
				else
					--手机登陆方式
					tcp:SendMessage(MSG_C2LS_LOGIN_ValidateInfo ,{
						Data_Login.login_type,
						ManageResUpdate.GAME_NOW_VERSION,
						10000,
						-- user.login_aim,
						PHONE_GUID
					} )
				end
			end
			--启动登录超时判断
			if not Data_Login.ResumeConnect then
				--发送登陆超时检查
				tcp:OpenMsgTimeOutCheck( function (  )
					printInfo("登陆或注册超时 判断启动计时");
					GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
					--登陆状态处理使用的登陆错误提示
					UIManager:CreatePrompt_Bar( {
						content = "登陆超时,请检查下网络状况",
					} )
					tcp:CloseMsgTimeOutCheck( );
					--关闭连接等待界面
					dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "loginwait"})
				end );
			end
		elseif chooseServerData.IP == _ip and chooseServerData.Port == _socket then
			--todoMS服务器
			tcp.ConnectState = 3;--连接到登陆服务器
			printInfo("网络日志 %s","连接Ms ip= ".._ip..",port= ".._socket.."  成功 状态 = "..tcp.ConnectState)
			--发送账号验证请求 账号 toke version
			if Data_Login.login_type == 4 then
				tcp:SendMessage(MSG_C2MS_LOGIN_ValidateInfo ,{
					Data_Login.userID,
					Data_Login.token,
					Data_Login.CurrentVersion,
					} )
			else
				tcp:SendMessage(MSG_C2MS_LOGIN_ValidateInfo ,{
					Data_Login.userID,
					Data_Login.token,
					Data_Login.CurrentVersion,
					} )
			end

			printInfo("网络日志 %s %s %s",Data_Login.account,Data_Login.token,Data_Login.CurrentVersion)

			if not Data_Login.ResumeConnect then
				--发送登陆超时检查
				tcp:OpenMsgTimeOutCheck( function (  )
					print("登陆Ms超时");
					GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-10,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
					--登陆状态处理使用的登陆错误提示
					UIManager:CreatePrompt_Bar( {
						content = "登陆超时,请检查下网络状况",
					} )
					tcp:CloseMsgTimeOutCheck( );
					--关闭连接等待界面
					dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "loginwait"})
				end );
			end
		end
	else --连接失败
		--关闭连接计时器
		tcp:CloseMsgTimeOutCheck( );
		tcp.isConnected = false;
		tcp.ConnectState = 0;
		printInfo("网络日志 %s","连接失败 状态 = "..tcp.ConnectState)
		-- 判断重连界面是否打开
		if Data_Login.ResumeConnect then
			--关闭重新链接界面
			--重连失败
			dispatchGlobaleEvent( "prompt" ,"resumeconnect_fail" ,nil)
		else
			UIManager:CreatePrompt_Bar( {
				content = "连接服务器失败,请检查下网络状况",
			} )
			GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-10,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
			--关闭连接等待界面
			dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "loginwait"})
		end
	end
end
