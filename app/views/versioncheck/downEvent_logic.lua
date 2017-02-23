--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 下载进度条逻辑

local downEvent_logic = class("downEvent_logic")

function downEvent_logic:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"downprogress","close",1},--关闭
		{"downprogress","update_progress",1},--更新进度
	}
end


--注册事件
function downEvent_logic:register_event(  )
	local defaultCallbacks = {
        downprogress_close = handler(self, self.register_event_close),
        downprogress_update_progress = handler(self, self.register_event_update_progress),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		if defaultCallbacks[eventname] then
			self.eventlisen[eventname] = createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end
end

function downEvent_logic:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
	
end

--注册关闭事件
function downEvent_logic:register_event_close(  )
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

--注册进度更新事件
function downEvent_logic:register_event_update_progress( event )
	local showData = event._usedata;
	print(showData[1] , showData[2]);
	self.target_:upDateShow(showData[1] , showData[2]);
end


return downEvent_logic;
