--
-- Author: Li Yang
-- Date: 2014-01-15 15:35:06
-- 登陆Ms 消息片

-- 服务器回应基本验证结果
Msg_Logic[MSG_MS2C_LOGIN_ValidateInfo] = function ( tcp , msg )
	--关闭登陆超时验证
	tcp:CloseMsgTimeOutCheck( );
	local result = msg:ReadIntData()
	printInfo("网络日志 %s", "收到MS账号验证结果:"..result)
	if result == eLET_LoginNoError then
		-- 发送请求基本数据
		-- tcp:SendMessage(MSG_C2MS_GET_BASE_DATA )
	else
		-- 连接游戏服务器失败
		Data_Login.Logic_Operation = 1;
		-- 开启点击事件
		GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
		--关闭连接等待界面
		dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "loginwait"})
		if eLET_VersionErr == result then
			-- 创建错误提示
			UIManager:CreatePrompt_Operate( {
				mark = "banbentis",
		        title = "提示",
		        content = "检查到游戏版本错误，请重启游戏?",
		        listenButton = function ( result )
					if result == 1 then
						--todo
					end
				end
			} )
		else
			UIManager:CreatePrompt_Bar( {
				content = getErrorDescribe( result ),
			} )
		end
		--断开游戏服务器
		tcp:Disconnect( );
	end
end

--通知改名结果
Msg_Logic[MSG_MS2C_CHANGE_NAME_REPLY] = function (tcp , msg )
	
end


Msg_Logic[MSG_MS2C_INIT_RETURN] = function (tcp , msg )
	printInfo("网络日志 %s","初始化游戏数据完成")
	--重置数据
	-- if UIManager.ResetGameData.ConnectRun then
	-- 	UIManager.ResetGameData:ResultShow( UIManager.ResetGameData.CONNECT_SUCCEED);
	-- 	return;
	-- end
	-- --一些初始数据
	-- SetGameUpData( CONST_UPDATA_TYPE_HELPER );--助阵数据更新逻辑
	--心跳包发送计时
	GlobalDataUpdate:startCheck(  );--启动数据更新
	GlobalDataUpdate:SetGameUpData( GlobalDataUpdate.CONST_UPDATA_TYPE_HEARTBEAT );--添加心跳包检测
	--设置进度数据
	dispatchGlobaleEvent( "models_loadres" ,"update_logic_schedule",{50});--数据请求完成
	-- -- SceneManager:ToScene(SceneManager.IDs.gameMain)
	-- --开启点击事件
	-- TounchContrlScheduler(0,1);
	-- -- 开启游戏数据更新
	-- GameUpDataScheduler()
	--关闭提示界面
	dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "loginwait"})
	
end

-- 收到创建角色结果
Msg_Logic[MSG_MS2C_CREATE_ROLE_REPLY] = function (tcp , msg )
	local result = msg:ReadIntData()
	printInfo("网络日志 %s","收到创建角色结果："..result)

	if result == eRI_Success then
		--更新玩家名称
		MAIN_PLAYER:getBaseAttr():setName(InviHeroName)
		--进入加载界面
		APP:toScene(SCENE_ID_GAMEWORLD_RES_LOADING);
		--发送请求数据消息
		-- Msg_Logic.requestData();
		-- printInfo("网络日志","请求英雄列表消息："..MSG_C2MS_GET_BACKPACK);
		-- tcp:SendMessage(MSG_C2MS_GET_BACKPACK)
		--进入加载界面
		-- SceneManager:ToScene(SceneManager.IDs.loadScene);
		--开场剧情引导结束
		-- NewbieGuideManager:FinishStepLogic( "openStory" ,4);
	else
		-- 开启点击事件
		GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-10,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
		UIManager:CreatePrompt_Bar( {
			content = getErrorDescribe( result ),
		} )
	end
	-- TounchContrlScheduler(0 , 1);
end

-- 得到随机昵称结果
Msg_Logic[MSG_MS2C_RANDOM_NAME_REPLY] = function (tcp , msg )
	-- if display.getRunningScene().NameView then
	-- 	display.getRunningScene().NameView.names = {}
	-- end
	
	local count = msg:ReadIntData()
	printInfo("网络日志 %s","返回请求的随机名字"..count)
	local namelist = {};
	for i=1,count do
		local name = msg:ReadString()
		namelist[i] = name;
	end
	dispatchGlobaleEvent( "models_inithero" ,"updatename",{namelist});
	
end


-- 收到服务器基本配置
Msg_Logic[MSG_MS2C_GET_MSGAMECTRL_DATA] = function (tcp , msg )
	
end

-- 收到随机昵称数据
Msg_Logic[MSG_C2MS_ROLE_GET_RANDOM_NAME] = function ( tcp, msg )
	local count = msg:ReadIntData()
	logPrint("网络日志","收到随机昵称数量:"..count)
	for i=1,count do
		local count = msg:ReadString()
	end
end


--心跳包
Msg_Logic[MSG_MS2C_HEARTBEAT_RE] = function ( tcp , msg )
	printInfo("网络日志 收到心跳包")
	HeartBeatLogic = 0;
end

