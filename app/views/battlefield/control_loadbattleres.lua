--
-- Author: Liyang
-- Date: 2015-06-26 17:28:09
-- 战斗资源加载逻辑事件

local control_loadbattleres = class("control_loadbattleres")

function control_loadbattleres:ctor()

	self.registerConfig = {
		{"loadbattleres","wait_open",1},--战斗资源加载等待界面开启
		{"loadbattleres","wait_close",1},
		{"loadbattleres","loadbattleres_start",1},--开始加载资源
		{"loadbattleres","loadbattleres_finish",1},--加载资源完成
	};

	--标示配置
	self.MarkType = marktype or "loadbattleres";

	self.Timeout = 0.3;
	self:register_event();
	
end

--注册事件
function control_loadbattleres:register_event(  )
	local defaultCallbacks = {
		loadbattleres_wait_open = handler(self, self.register_wait_open),
        loadbattleres_wait_close = handler(self, self.register_event_close),
        loadbattleres_loadbattleres_start = handler(self, self.register_loadbattleres_start),
        loadbattleres_loadbattleres_finish = handler(self, self.register_loadbattleres_finish),
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

--去除所有事件监听
function control_loadbattleres:removeAllEvent(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end

function control_loadbattleres:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
end

function control_loadbattleres:setData( data )
	self.LoadData = data;
	self:register_wait_open();
end

--注册等待界面开启
function control_loadbattleres:register_wait_open( event )
	
	self.loadView = UIManager:CreatePrompt_BattleResLoad();
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.loadView, 4 ,3});
	--开启等待时间
	self.scheduleTimer = GLOBAL_SCHEDULER:scheduleScriptFunc(
	    handler(self, self.wait_Delay_logic),
	    self.Timeout, false
	)
end

--[[注册关闭事件
	参数 
		markType 传回为判断标示
]]
function control_loadbattleres:register_event_close( event )
	--关闭等待界面
	self.loadView:removeFromParent();
	--关闭此次事件的监听
	self:removeAllEvent();
end

--开始加载战斗资源事件
function control_loadbattleres:register_loadbattleres_start( event )
	printInfo("register_loadbattleres_start")
	
	ManagerBattleRes:InitBattleUseRes( self.LoadData, 1);
end

--资源加载完成
function control_loadbattleres:register_loadbattleres_finish( event )
	--关闭等待界面
	self.loadView:removeFromParent();
	--关闭此次事件的监听
	self:removeAllEvent();

	--切入战场界面
	-- print("control_loadbattleres:register_loadbattleres_finish")
	-- APP:toScene(SCENE_ID_BATTLE) 
end

------------------------------------一些逻辑函数-----------------------------------------
--超时逻辑
function control_loadbattleres:wait_Delay_logic()
	self:register_loadbattleres_start(  );
	GLOBAL_SCHEDULER:unscheduleScriptEntry(self.scheduleTimer);
	-- --关闭等待界面
	-- dispatchGlobaleEvent( "prompt" ,"wait_close" ,{markType = "loadbattleres"});
	-- -- --关闭此次事件的监听
	-- -- self:removeAllEvent();
end



return control_loadbattleres;
