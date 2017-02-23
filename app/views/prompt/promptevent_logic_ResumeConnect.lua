--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 提示框事件重连逻辑

local promptevent_logic_ResumeConnect = class("promptevent_logic_ResumeConnect")

function promptevent_logic_ResumeConnect:ctor()
	-- {"prompt","resumeconnect_close",1},--重连关闭
	-- 	{"prompt","resumeconnect_close",1},--重连关闭
	-- 	{"prompt","resumeconnect_start",1},--重连开始
	-- 	{"prompt","resumeconnect_succes",1},--重连成功
	-- 	{"prompt","resumeconnect_fail",1},--重连失败
	-- 	{"prompt","click",1},--提示点击事件
	self.registerConfig = {
		{"resumeconnect","create",1},--创建重连
		{"resumeconnect","close",1},--重连关闭
		{"resumeconnect","start",1},--重连开始
		{"resumeconnect","succes",1},--重连成功
		{"resumeconnect","fail",1},--重连失败
		{"resumeconnect","click",1},--提示点击事件
	}
	self:register_event(  );
	-- 1 重连状态 0 重连失败状态 2 成功
	self.RunState = 1;
	self.FAIL_TIMEOUT = 10;
	--开启重连
	-- self:register_event_resumeconnect_start();
end

--注册事件
function promptevent_logic_ResumeConnect:register_event(  )
	local defaultCallbacks = {
		resumeconnect_create = handler(self, self.register_event_create),
        resumeconnect_close = handler(self, self.register_event_close),
        resumeconnect_start = handler(self, self.register_event_resumeconnect_start),
        resumeconnect_click = handler(self, self.register_event_click),
        resumeconnect_succes = handler(self, self.register_event_resumeconnect_succes),
        resumeconnect_fail = handler(self, self.register_event_resumeconnect_fail),
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

function promptevent_logic_ResumeConnect:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--注册关闭事件
function promptevent_logic_ResumeConnect:register_event_close(  )
	printInfo("register_event_close %s", "event")
	Data_Login.ResumeConnect = false;
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
	--执行完成回调
	-- if self.target_.ShowData.fininshCallBack then
	-- 	self.target_.ShowData.fininshCallBack();
	-- end
	
	self.target_:removeFromParent();
end

--创建重连
function promptevent_logic_ResumeConnect:register_event_create( event )
	--创建重连提示
	self.target_ = UIManager:CreatePrompt_Wait_0( {
			mark = "ResumeConnect",
			content = "请稍等正在拼命连接服务器",
			event_click = handler(self, self.register_event_click),
			event_show = function (  )
				self:register_event_resumeconnect_start(  );
			end
		} )
	--暂停战场
	dispatchGlobaleEvent( "battlefield" ,"pause" );
end



--注册重连开始事件
function promptevent_logic_ResumeConnect:register_event_resumeconnect_start(  )
	print("promptevent_logic_ResumeConnect:register_event_resumeconnect_start")
	--关闭心跳包
	-- CloseGameTimer( CONST_UPDATA_TYPE_HEARTBEAT )
	--重置状态
	self.RunState = 1;
	Data_Login.ResumeConnect = true;

	self.target_:setVisible(true);
	self.target_.loadStateNode:setVisible(true);
	self.target_.errorStateNode:setVisible(false);

    --连接游戏服务器
	Msg_Logic.ConnectMS_Logic();

	local action_delayTime_0 = cc.DelayTime:create(self.FAIL_TIMEOUT);
	local action_callfun_0 = cc.CallFunc:create(function (  )
		--执行重连失败事件
		print("重连超时")
		self:register_event_resumeconnect_fail(  );
	end)
	self.target_:runAction(cc.Sequence:create(action_delayTime_0,action_callfun_0));
end

--注册重连失败事件
function promptevent_logic_ResumeConnect:register_event_resumeconnect_fail(  )
	printInfo("register_event_resumeconnect_fail")
	self.target_:stopAllActions();
	self.target_:ShowErrorInfo("连接失败,请检查网络状况");
	local action_delayTime_0 = cc.DelayTime:create(1);
	local action_callfun_0 = cc.CallFunc:create(function (  )
		self.RunState = 0;
	end)
	local action_delayTime = cc.DelayTime:create(3);
	local action_callfun = cc.CallFunc:create(function (  )
		self.target_:setVisible(false);
	end)
	local execute_action = cc.Sequence:create(action_delayTime_0,action_callfun_0,action_delayTime, action_callfun);
	self.target_:runAction(execute_action);
end

--注册重连成功事件
function promptevent_logic_ResumeConnect:register_event_resumeconnect_succes(  )
	
	--停止动作
	-- self.target_:stopAllActions();
	-- --执行一个最小等待显示
	-- local delay_1 = cc.DelayTime:create(2);
	-- local callfun_1 = cc.CallFunc:create(function (  )
	-- 	self:register_event_close( );
	-- 	self.RunState = 2;
	-- 	-- SetGameUpData( CONST_UPDATA_TYPE_HEARTBEAT );
	-- 	--发送重连成功消息
	-- 	dispatchGlobaleEvent( "resumeconnect", "resumeconnect_succes" )
	-- 	self:removeFromParentAndCleanup(true);
	-- end);
	-- self.target_:runAction(cc.Sequence:create(delay_1,callfun_1));
	
	self.target_:stopAllActions();
	self:register_event_close( );
	self.RunState = 2;
	--恢复战场
	dispatchGlobaleEvent( "battlefield" ,"recover" );
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(0);
	--关闭按键事件
	GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-100,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);
end

--注册提示点击事件
function promptevent_logic_ResumeConnect:register_event_click(  )
	if self.RunState == 0 then
		--重新启动重连
		self:register_event_resumeconnect_start( );
	end
end

return promptevent_logic_ResumeConnect;
