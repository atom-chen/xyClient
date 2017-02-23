--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 战斗资源加载逻辑事件

local PromptEvent_logic_loadbattleres = class("PromptEvent_logic_loadbattleres")

function PromptEvent_logic_loadbattleres:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"prompt_loadbattleres","close",1},--关闭
		{"prompt_loadbattleres","start",1},--开始加载资源
		{"prompt_loadbattleres","finish",1},--加载资源完成
		-- {"prompt_loadbattleres","wait_timeout",1},--等待超时
	}
end

--注册事件
function PromptEvent_logic_loadbattleres:register_event(  )
	local defaultCallbacks = {
        prompt_loadbattleres_close = handler(self, self.register_event_close),
        prompt_loadbattleres_start = handler(self, self.register_loadbattleres_start),
        prompt_loadbattleres_finish = handler(self, self.register_loadbattleres_finish),
        -- prompt_loadbattleres_wait_timeout = handler(self, self.register_wait_timeout),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		if defaultCallbacks[eventname] then
			-- print("注册事件:",eventname)
			self.eventlisen[eventname] = createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function PromptEvent_logic_loadbattleres:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--[[注册关闭事件
	参数 
		markType 传回为判断标示
]]
function PromptEvent_logic_loadbattleres:register_event_close( event )
	local markType = event._usedata.markType;
	printInfo("prompt_wait_close %s , %s",self.target_.markType ,markType)
	if markType ~= self.target_.markType then
		return;
	end
	--执行完成回调
	if self.target_.ShowData.fininshCallBack then
		self.target_.ShowData.fininshCallBack();
	end
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
	
	self.target_:removeFromParent();
end

--开始加载战斗资源事件
function PromptEvent_logic_loadbattleres:register_loadbattleres_start( event )
	printInfo("register_loadbattleres_start")
	local data = event._usedata[1];
	ManagerBattleRes:InitBattleUseRes( data, 1);
end

--资源加载完成
function PromptEvent_logic_loadbattleres:register_loadbattleres_finish( event )
	self:register_event_close();
end

------------------------------------一些逻辑函数-----------------------------------------
--超时逻辑
function PromptEvent_logic_loadbattleres:wait_timeout_logic( event )
	--类型
end

--点击事件逻辑
function PromptEvent_logic_loadbattleres:click_logic( event )
	
end

return PromptEvent_logic_loadbattleres;
