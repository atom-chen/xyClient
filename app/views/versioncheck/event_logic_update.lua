--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 更新逻辑

local event_logic_update = class("event_logic_update")

function event_logic_update:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"models_update","check_version",1},--检查版本
		{"models_update","handler_check_result",1},--处理检查结果
		-- {"models_update","fail",1},--更新失败
		{"models_update","succee",1},--更新失败
		{"models_update","restart_game",1},--注册重启游戏
		{"models_update","downProgress",1},--下载进度
		{"models_update","closeUpdateprompt",1},--关闭更新提示
	}
	-- 0 版本检查提示 1 下载 2 更新完成
	-- self.executeState = 0;
end

--注册事件
function event_logic_update:register_event(  )
	local defaultCallbacks = {
        models_update_check_version = handler(self, self.register_check_version),
        models_update_handler_check_result = handler(self, self.register_handler_check_result),
        models_update_restart_game = handler(self, self.register_restart_game),
        models_update_downProgress = handler(self, self.register_event_downProgress),
        models_update_succee = handler(self, self.register_event_succee),
        -- models_update_fail = handler(self, self.register_event_fail),
        models_update_closeUpdateprompt = handler(self, self.register_event_closeUpdateprompt),
    }
    self.eventlisen = {};
    --createGlobalEventListener( modelName, eventName, callBack, fixedPriority )
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		if defaultCallbacks[eventname] then
			self.eventlisen[eventname] = createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function event_logic_update:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--关闭事件
function event_logic_update:register_event_close(  )
	printInfo("register_event_close %s", "event")
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
	--执行完成回调
	if self.target_.ShowData.fininshCallBack then
		self.target_.ShowData.fininshCallBack();
	end
	
	self.target_:removeFromParent();
end

--[[检查结果处理
	0 更新失败
	1 更新成功
	2 下载进度提示
	3 更新文件大小
]]
function event_logic_update:register_handler_check_result( resultinfo )
	local result = resultinfo._usedata[1];--更新结果
	local currentschedule = resultinfo._usedata[2];--当前进度
	local currentUpdateType = resultinfo._usedata[3];--更新的类型
	local fileSize = resultinfo._usedata[4];--文件大小
	print( "register_handler_check_result",result , currentschedule ,currentUpdateType)
	--下载失败
	if result == 0 then
		--更新失败
		--关闭等待界面
		dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "models_update"})
		--关闭下载进度界面
		dispatchGlobaleEvent( "downprogress" ,"close" ,nil)
		--开启描述错误描述界面
		UIManager:CreatePrompt_Operate( {
			mark = "updateErrorInfo",
	        title = "更新提示",
	        content = "更新失败，请检查下网络状况?",
	        -- eventlogic = "",--绑定逻辑
	        -- eventlist = "",注册事件列表
	        buttonName1 = "关闭",--button名称
        	buttonName2 = "重试",
	        listenButton = function ( result )
				-- 1 表示选择1按钮 2表示选择按钮
				if result == 1 then
					cc.Director:getInstance():endToLua();
				elseif result == 2 then
					
					self:register_check_version();
				end
			end
			} )
	elseif result == 2 then
		--执行更新进度提示
		--关闭等待界面
		dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "models_update"})
		local desion = "发现新版本，需要下载更新后才可以继续游戏。本次下载更新包大小"..fileSize.."，建议使用WIFI网络下载!";
		--开启描述错误描述界面
		UIManager:CreatePrompt_Operate( {
			mark = "updatePromptInfo",
	        title = "更新提示",
	        content = desion,
	        -- eventlogic = "",--绑定逻辑
	        -- eventlist = "",注册事件列表
	        buttonName1 = "确定",--button名称
        	buttonName2 = "取消",
	        listenButton = function ( result )
				-- 1 表示选择1按钮 2表示选择按钮
				if result == 2 then
					cc.Director:getInstance():endToLua();
				elseif result == 1 then
					--开启更新提示
					self:ShowDownProgressView();
					--执行更新操作
					ManageResUpdate:executeDownLogic();
				end
			end
			} )
	elseif result == 1 then
		--更新完成
		--加载配置文件
		dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "models_update"})
        ManageResUpdate:LoadingScripte(  );
		self:register_event_succee(  );
	elseif result == 6 then
		--更新关闭
		--关闭等待界面
		dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "models_update"})
		self:register_event_closeUpdateprompt();
	end
end

--注册检查版本
function event_logic_update:register_check_version(  )
	--开启检查提示
	UIManager:CreatePrompt_Wait( {
		mark = "models_update",
		content = "检查更新中请稍等",
		-- eventlogic = "",--绑定逻辑
		-- eventlist = "",
		-- islistenclick = ,--是否监听按键事件
		-- timer = ,--计时器
		-- fininshCallBack = nil;--完成回调函数
		} )

	--初始化更新工具
	ManageResUpdate:InviData(  );
	--得到当前版本信息
	ManageResUpdate:getCurrentVersion( )
	-- --得到当前更新信息
	ManageResUpdate:getServerUpDateCofig(  )
end

--显示下载进度界面
function event_logic_update:ShowDownProgressView(  )
	local view = require("app.views.versioncheck.UI_downProgress.lua").new();
	self.target_:addChildToLayer(LAYER_ID_POPUP, view);
	view:setData({

		});
	view:setPosition(cc.p(display.cx,display.cy));
end

--注册更新成功
function event_logic_update:register_event_succee(  )
	self.executeState = 2;
	APP:toScene(SCENE_ID_LOGIN)
end


--注册重启游戏
function event_logic_update:register_restart_game(  )
	--关闭等待界面
	dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "models_update"})
	--关闭下载进度界面
	dispatchGlobaleEvent( "downprogress" ,"close" ,nil)
	UIManager:CreatePrompt_Operate( {
			mark = "updaterestartgame",
	        title = "更新提示",
	        content = "更新完成，需要重新启动游戏!",
	        -- eventlogic = "",--绑定逻辑
	        -- eventlist = "",注册事件列表
	        buttonName1 = "确定",--button名称
        	buttonName2 = "取消",
	        listenButton = function ( result )
				-- 1 表示选择1按钮 2表示选择按钮
				cc.Director:getInstance():endToLua();
			end
	} )
end

--注册关闭更新提示
function event_logic_update:register_event_closeUpdateprompt()
	UIManager:CreatePrompt_Operate( {
			mark = "updaterestartgame",
	        title = "更新提示",
	        content = "游戏正在维护中,请稍后登陆。",
	        -- eventlogic = "",--绑定逻辑
	        -- eventlist = "",注册事件列表
	        buttonName1 = "确定",--button名称
        	buttonName2 = "取消",
	        listenButton = function ( result )
				-- 1 表示选择1按钮 2表示选择按钮
				cc.Director:getInstance():endToLua();
			end
	} )
end


return event_logic_update;
