--
-- Author: Li Yang
-- Date: 2014-01-10 11:01:26
-- socket tcp 连接

local SOCKET_TICK_TIME = 0.01 			-- check socket data interval
local SOCKET_RECONNECT_TIME = 5			-- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 10	-- socket failure timeout


local  SocketTcp = class("SocketTcp");


function SocketTcp:ctor(_host ,_port)
	-- cc(self)
 --    	:addComponent("components.behavior.EventProtocol")
 --    	:exportMethods()

	-- 连接地址
	self.host = _host;
	-- 连接端口
	self.port = _port;
	-- 连接 timer for data
	self.tickScheduler = nil;
	-- timer for reconnect
	self.reconnectScheduler = nil	
	-- timer for connect timeout	
	self.connectTimeTickScheduler = nil	
	self.tcp = nil;
	self.name = "SocketTcp";
	self.isConnected = false;
	--游戏流量总大小(单位kb)
	self.SumSize = 0;

	--[[连接状态
		 * 0 没有连接
	     * 1 登陆服务器
	     * 2 玩家手动断开登陆服务器
	     * 3 游戏服务器
	     * 4 玩家主动关闭游戏服
	     * 5 连接游戏服务器断开登陆服务器
	]]
	self.ConnectState = 0;
end

function SocketTcp:setName( _name )
	self.name = _name;
end

function SocketTcp:setTickTime(__time)
	SOCKET_TICK_TIME = __time
end

function SocketTcp:addSumSize( size )
	self.SumSize = self.SumSize + size / 1024;
end

--[[ socket连接
	__host 地址
	__port 端口
]]
function SocketTcp:connect(__host, __port)
	if __host then self.host = __host end
	if __port then self.port = __port end
	-- if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
	assert(self.host or self.port, "Host and port are necessary!")
	--echoInfo("%s.connect(%s, %d)", self.name, self.host, self.port)
	printInfo("网络日志 创建连接: %s %s",self.host,self.port)
	-- 创建连接
	self.tcp = CTcpClient:createWithLua(self.host, self.port, "msgProcess_1")
	local data = self.tcp:ChangeToConnectState()
	local  __connectTimeTick = function (  )
		--监听是否有消息
		--如果有消息将调用: msgProcess
		self.tcp:ListnerMsgWithLua();
	end

	self.connectTimeTickScheduler = GLOBAL_SCHEDULER:scheduleScriptFunc(__connectTimeTick, SOCKET_TICK_TIME,false)
end

--启用超时检查
function SocketTcp:OpenMsgTimeOutCheck( callBack )
	self.TimeOutCheckScheduler = GLOBAL_SCHEDULER:scheduleScriptFunc(callBack, SOCKET_CONNECT_FAIL_TIMEOUT,false)
end

--关闭超时检查
function SocketTcp:CloseMsgTimeOutCheck( )
	if self.TimeOutCheckScheduler then
		GLOBAL_SCHEDULER:unscheduleScriptEntry(self.TimeOutCheckScheduler);
	end
	self.TimeOutCheckScheduler = nil;
end

--[[断开连接
	operationMark 操作标示
]]
function SocketTcp:Disconnect( operationMark )
	printInfo("网络日志 %s","断开网络连接");
	self.isConnected = false;
	--状态操作标示
	if operationMark then
		self.ConnectState = operationMark;
	end
	self.tcp:ChangeToDisconState();
	-- GLOBAL_SCHEDULER:unscheduleScriptEntry(self.connectTimeTickScheduler);
end

function SocketTcp:Disconnect_1(  )
	self.isConnected = false;
	self.tcp:ChangeToDisconState();
	-- GLOBAL_SCHEDULER:unscheduleScriptEntry(self.connectTimeTickScheduler);
end

--[[ 发送消息
	msgtype 消息类型
	params 消息内容
]]
function SocketTcp:SendMessage(msgtype ,params )
	 if not self.isConnected then
	 	printInfo("网络日志 %s","没有连接服务器无法发送消息");
	 end
	 local  msg = CSendMsg:create(msgtype);
	 if params then
	 	assert(type(params) == "table","SendMessage params not table");
	 	for i,v in ipairs(params) do
	 		print(v);
		 	if type(v) == "string" then
		 		msg:WriteString(v);
		 	elseif type(v) == "number" then
		 		-- 判断有点问题是（1.0的时候 尽量少用float）
		 		local num_0,num_1 = math.modf(v);
		 		if num_1 > 0 then
		 			msg:WriteFloat(v);
		 		else
		 			msg:WriteInt(v);
		 		end
		 	end
		 end
	 end
	 -- 发送消息
	 self.tcp:SendMsg(msg);
	 --销毁创建的消息
	 CSendMsg:destory(msg);
end


gameTcp = SocketTcp.new("123","556");


-- 消息回调
function msgProcess_1( pa_msg )
	-- 强制装换
	local msg = tolua.cast(pa_msg,"CRecvMsg");
	local msgType = msg:GetType()
	-- local msgLength = msg:GetDataSize();
	local msgLength = msg:GetSize();
	if gameTcp then
		gameTcp:addSumSize( msgLength );
	end
	
	-- gameTcp.tcp:ChangeToDisconState()
	print("网络日志","接收到新消息类型-->"..msgType.."，消息长度："..msgLength..",总流量："..gameTcp.SumSize.."K")
	if eNetMsg_Connect == msgType then
		--获取连接结果
		Msg_Logic.eNetMsg_Connect_logic(gameTcp , msg );

	elseif eNetMsg_Discon == msgType then
		--连接断开
		GLOBAL_SCHEDULER:unscheduleScriptEntry(gameTcp.connectTimeTickScheduler);
		printInfo("网络日志 %s","断开连接456")
		Msg_Logic.eDisconnect_logic(gameTcp , msg );

	else
		if Msg_Logic[msgType] then
			Msg_Logic[msgType](gameTcp , msg)
		else
			printInfo("网络日志 %s","收到的消息没有消息逻辑处理")
		end
		
	end

end





return SocketTcp;
