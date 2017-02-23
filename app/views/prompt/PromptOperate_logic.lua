--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 提示操作界面逻辑事件

local PromptOperate_logic = class("PromptOperate_logic")

function PromptOperate_logic:ctor(target)
	self.target_ = target;

	self.registerConfig = {
		{"PromptOperate","close",1},--关闭
		{"PromptOperate","button_click",1},--按钮点击
	}
end


--注册事件
function PromptOperate_logic:register_event(  )
	local defaultCallbacks = {
        PromptOperate_close = handler(self, self.register_event_close),--关闭事件
        --按键1按下事件
        PromptOperate_button_click = handler(self, self.register_event_button_click),
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

function PromptOperate_logic:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
end

--注册关闭事件
function PromptOperate_logic:register_event_close(  )
	printInfo("PromptOperate")
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
	
	
	self.target_:removeFromParent();
end

--注册测试事件
function PromptOperate_logic:register_event_button_click( event )
	printInfo("register_event_button_click")
	--执行完成回调
	print("register_event_button_click",self.target_.ShowData)
	if self.target_.ShowData.listenButton then
		self.target_.ShowData.listenButton(event._usedata);
	end
	--关闭界面
	self:register_event_close();

end


return PromptOperate_logic;
