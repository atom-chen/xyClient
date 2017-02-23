--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 提示逻辑事件

local PromptEvent_logic = class("PromptEvent_logic")

function PromptEvent_logic:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"prompt","wait_close",1},--重连关闭
	}
end


--注册事件
function PromptEvent_logic:register_event(  )
	local defaultCallbacks = {
        prompt_wait_close = handler(self, self.register_event_close),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		if defaultCallbacks[eventname] then
			print("注册事件:",eventname)
			self.eventlisen[eventname] = createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function PromptEvent_logic:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--注册关闭事件
function PromptEvent_logic:register_event_close( event )
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

------------------------------------一些逻辑函数-----------------------------------------
--超时逻辑
function PromptEvent_logic:wait_timeout_logic( event )
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

--点击事件逻辑
function PromptEvent_logic:click_logic( event )
	
end

return PromptEvent_logic;
