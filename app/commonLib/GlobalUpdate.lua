--
-- Author: LiYang
-- Date: 2015-07-21 14:16:18
-- 游戏数据更新逻辑
local GlobalUpdate = class("GlobalUpdate");

-------------心跳包更新逻辑参数-------------------
GlobalUpdate.CONST_UPDATA_TYPE_HEARTBEAT = 1; --类型
GlobalUpdate.CONST_TIME_HEARTBEAT = 20; --时间

function GlobalUpdate:ctor()
	self.GAME_UPDATA_INTERVAL_TIME = 1;
	self.GAME_UPDATA_Scheduler = nil;
	self.GAME_UPDATA_Logic = {};
end

function GlobalUpdate.getInstance()
	if GlobalUpdate.instance == nil then
		GlobalUpdate.instance = GlobalUpdate.new()
	end
	return GlobalUpdate.instance;
end

function GlobalUpdate:startCheck(  )
	self:ClearGameTimer(  );
	self.GAME_UPDATA_Scheduler = GLOBAL_SCHEDULER:scheduleScriptFunc(
            handler(self, self.registerScheduleListen),
            self.GAME_UPDATA_INTERVAL_TIME, 
            false
    )
end

function GlobalUpdate:registerScheduleListen(  )
	for k,v in pairs(self.GAME_UPDATA_Logic) do
		if v then
			local result = self:UpDataHandleLogic( v );
			if result == 0 then
				self.GAME_UPDATA_Logic[k] = nil;
			end
		end
	end
end

--数据更新逻辑
function GlobalUpdate:UpDataHandleLogic( params )
	-- print(params,params.time,params.dataType)
	params.time = params.time - 1;
	if params.time <= 0 then
	 	if params.dataType == self.CONST_UPDATA_TYPE_HEARTBEAT then
			--发送心跳包
			if HeartBeatLogic < 2 then
				printInfo("数据更新日志 %s","发送心跳包:MSG_C2MS_HEARTBEAT")
				gameTcp:SendMessage(MSG_C2MS_HEARTBEAT )
				HeartBeatLogic = HeartBeatLogic + 1;
				--英雄释放逻辑
				-- HeroResReleasePeak_Logic(  );
				--数据重置逻辑
				-- ResetGameDataLogic(  );
				params.time = self.CONST_TIME_HEARTBEAT; --循环发射心跳包
				--设置一个心跳包计时
				return 1;
			else
				--启动重连操作
				--连接断开
				-- scheduler.unscheduleGlobal(gameTcp.connectTimeTickScheduler);
				printInfo("网络日志 %s","心跳检查的断开连接")
				Msg_Logic.eDisconnect_logic(gameTcp , msg );
			end
			
	 	end
	 	return 0;
	end
	return 1;
end

--[[关闭游戏计数
	datatype 计数的类型
]]
function GlobalUpdate:CloseGameTimer( datatype )
	if self.GAME_UPDATA_Logic[datatype] then
		self.GAME_UPDATA_Logic[datatype] = nil;
	end
end

--清空游戏更新计时
function GlobalUpdate:ClearGameTimer(  )
	if self.GAME_UPDATA_Scheduler then
		GLOBAL_SCHEDULER:unscheduleScriptEntry(self.GAME_UPDATA_Scheduler);
		self.GAME_UPDATA_Scheduler = nil;
	end
	for k,v in pairs(self.GAME_UPDATA_Logic) do
		if v then
			self.GAME_UPDATA_Logic[k] = nil;
		end
	end
end

--[[设置游戏数据更新
	type 数据更新类型
	return 0 更新间隔时间内 1 更新重置
]]
function GlobalUpdate:SetGameUpData( datatype , time)
	if self.GAME_UPDATA_Logic[datatype] then
		print(self.GAME_UPDATA_Logic[datatype].time)
		return 0;
	end
	print("数据更新类型：",datatype)
	local params = {};
	params.dataType = datatype;
	
	if params.dataType == self.CONST_UPDATA_TYPE_HEARTBEAT then
		--心跳包
		params.time = self.CONST_TIME_HEARTBEAT;
		HeartBeatLogic = 0;
	else
		--todo 
	end
	self.GAME_UPDATA_Logic[datatype] = params;
	return 1;
end

GlobalDataUpdate = GlobalUpdate.getInstance();

return GlobalUpdate
