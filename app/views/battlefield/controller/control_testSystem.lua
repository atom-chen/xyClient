--
-- Author: LiYang
-- Date: 2015-06-26 17:28:09
-- 测试战场

--[[发送全局事件名预览
eventModleName: onhook -- 战役界面内部控制
eventName: 
	choose_zhanyi 选择战役
	zhanyi_ctrl_choose_zhanyilevel 选择战役关卡
	zhanyi_ctrl_zhanyilevel_refresh 战役关卡刷新
]]

--[[监听全局事件名预览
eventModleName: battlefield
eventName:
	ui_initialize --战斗初始化界面
	create_result -- 创建战斗结果

]]


local control_testSystem = class("control_testSystem")

control_testSystem.CONST_STATE_INVI = "CONST_STATE_INVI";   -- 初始化

function control_testSystem:ctor()

	self.registerConfig = {
		--初始化数据
		{"testbattlefield","initialize",1},--
		{"testbattlefield","create",1},--创建挑战boss战场
		{"testbattlefield","over",1},--boss 挑战结束
	}
	self:register_event();

	self.challengLevel = nil;

	--逻辑状态 0 暂停 1 执行
	self.LogicState = 0;
end

function control_testSystem:getInstance(  )
    if control_testSystem.instance == nil then
        control_testSystem.instance = control_testSystem.new()
    end
    return control_testSystem.instance
end

--注册事件
function control_testSystem:register_event(  )
	local defaultCallbacks = {
		testbattlefield_initialize = handler(self, self.register_event_initialize),
		testbattlefield_create = handler(self, self.register_event_create),
		testbattlefield_over = handler(self, self.register_event_over),
    }
    self.eventlisen = {};
	for i,v in ipairs(self.registerConfig) do
		local eventname = createGlobaleEventName( v[1], v[2] )
		print("注册事件",eventname);
		if defaultCallbacks[eventname] then
			createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
		end
	end

end

function control_testSystem:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
end

--初始化数据
function control_testSystem:register_event_initialize( event )
	--逻辑状态为执行中
	self.LogicState = 1;
	--挑战的关卡数据
	-- local levelkey = event._usedata[1];
	-- self.challengLevel = WarConfig[levelkey];
	-- print("control_testSystem:register_event_initialize",levelkey,self.challengLevel)
	--战场类型切换
	-- dispatchGlobaleEvent( "battlefield" ,"cut" ,{"挑战boss"});

	--创建挑战bossUi
	self.boss_CloseButton = createViewWithCSB("ui_instance/battlefield/battle_ui_close.csb");
	-- self.info_des = self.ui_fightInfo:getChildByName("back"):getChildByName("Text_1");
	self.boss_CloseButton:setPosition(cc.p( display.width / 2 - 50, -display.height / 2 + 50));
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.boss_CloseButton, 4 ,1});

	--注册事件 close
	local buttonclose = self.boss_CloseButton:getChildByName("close");
	local function exitClicked(sender)
        print("退出战斗 隐藏战斗")
        dispatchGlobaleEvent( "battleshowlayer" ,"event_hide" );
    end
    buttonclose:addClickEventListener(exitClicked)
    self.boss_CloseButton:setVisible(false);
    --请求数据
    self:requestBoss_Msg(  );
end

function control_testSystem:requestBoss_Msg(  )
	--显示挂机结果
	--暂停挂机
	print("请求测试数据")
	Data_Battle_Msg:setTestData(Data_Battle.CONST_BATTLE_TYPE_test,"测试战场数据");
	-- printInfo("网络日志 请求挑战boss战斗数据 MSG_C2MS_WAR_BOSS_BEGIN key = %s", self.challengLevel.Key);
	-- gameTcp:SendMessage(MSG_C2MS_WAR_BOSS_BEGIN,{
	-- 	self.challengLevel.Key,
	-- 	1
	-- 	})
end

--创建战场
function control_testSystem:register_event_create( event )
	--创建战场
	Data_Battle:setBattlefieldType( Data_Battle.CONST_BATTLE_TYPE_test );--设置战斗类型
	--更新数据
	Data_Battle_Msg:updateExecuteData();
	-- --清理战场
 --    control_Combat:doEvent("event_exit_battle");
    --显示ui
    self.boss_CloseButton:setVisible(true);
    --战场切换效果
    dispatchGlobaleEvent( "battleshowlayer" ,"event_cut" ,{2});
	--执行数据
	control_Combat:doEvent("event_initialize","control_testSystem");
    local delay_1 = cc.DelayTime:create(1);
    local callfun = cc.CallFunc:create(function (  )
        control_Combat:doEvent("event_entrance");
    end)
    self.boss_CloseButton:runAction(cc.Sequence:create(delay_1,callfun));
end

--boss挑战结束
function control_testSystem:register_event_over( event )
	if self.LogicState == 0 then
		return;
	end
	self.LogicState = 0;
	--清空ui
	self.boss_CloseButton:removeFromParent();
	self.boss_CloseButton = nil；
	--直接执行挂机
	dispatchGlobaleEvent( "onhook" ,"recover" );
end


--注册关闭事件
function control_testSystem:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end

control_testSystem= control_testSystem.getInstance( );

return control_testSystem;
