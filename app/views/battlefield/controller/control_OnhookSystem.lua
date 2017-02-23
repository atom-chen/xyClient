--
-- Author: LiYang
-- Date: 2015-06-26 17:28:09
-- 挂机系统

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

local class_ui_bottom = import("..ui.UI_BattleOnhook_Bottom")

local class_levelitem = import("..ui.UI_OnhookLevel_item")

--挂机信息
local class_onhookinfo = import("..ui.UI_Onhook_Info")

local class_quickcombat = import("..ui.UI_Onhook_quickcombat")

local class_sell = import("..ui.UI_Onhook_sell")

local control_OnhookSystem = class("control_OnhookSystem")

control_OnhookSystem.CONST_STATE_INVI = "CONST_STATE_INVI";   -- 初始化

function control_OnhookSystem:ctor()

	self.registerConfig = {
		--初始化数据
		{"onhook","initialize",1},--初始化
		{"onhook","create",1},--创建挂机战场
		{"onhook","request_data",1},--请求挂机数据
		{"onhook","infoupdata",1},--挂机信息更新
		{"onhook","hide",1},--隐藏挂机显示
		{"onhook","show",1},--挂机显示
		{"onhook","watchonhook",1},--观看挂机
		{"onhook","closeonhook",1},--关闭挂机
		{"onhook","executeover",1},--挂机数据执行完成一个
		{"onhook","ui_operation_level",1},--操作UI关卡事件
		{"onhook","data_cut",1},--挂机操作切换
		{"onhook","recover",1},--恢复挂机
		{"onhook","getaward",1},--领取奖励
		{"onhook","getaward_result",1},--领取奖励
		{"onhook","addlevel",1},--添加关卡
		
		{"onhook","create_info",1},--创建挂机信息
		{"onhook","create_quickcombat",1},--创建快速战斗
		{"onhook","create_sell",1},--创建出售
		
		{"onhook","msg_quickcombat",1},--快速战斗
		{"onhook","msg_quickcombat_result",1},--快速战斗结果
		{"onhook","execute_request_msg",1},--挂机数据请求
		{"onhook","stop",1},--停止挂机系统
		
		{"controler_mainpage_zhanyi1_layer","zhanyi_touched",1},
		{"battlefield","exit",1},--监听战斗结束消息
		{"battlefield","cut",1},--战场切换
		{"battlefield","recover",1},--战场恢复
	};

	self:register_event();

	--挂机逻辑状态  0 空闲状态  1 执行 2 暂停 
	self.OnhookLogicState = 0;

	--挂机关卡
	self.OnhookLevelItem = nil;

	--挂机界面关卡显示状态 -1不显示 1显示
	self.OnhookLevelState = -1;

	--挂机状态
	self.OnhookState  = "initialize";

	self.ShowLevelList = {};

end

function control_OnhookSystem:getInstance(  )
    if control_OnhookSystem.instance == nil then
        control_OnhookSystem.instance = control_OnhookSystem.new()
    end
    return control_OnhookSystem.instance
end

--注册事件
function control_OnhookSystem:register_event(  )
	local defaultCallbacks = {
		controler_mainpage_zhanyi1_layer_zhanyi_touched = handler(self, self.event_watchonhook),
		onhook_initialize = handler(self, self.event_initialize),
		onhook_create = handler(self, self.event_create),
		onhook_request_data = handler(self, self.event_request_data),
		onhook_infoupdata = handler(self, self.event_infoupdata),
		onhook_hide = handler(self, self.event_hide),
		onhook_show = handler(self, self.event_show),
		onhook_data_cut = handler(self, self.event_data_cut),
		onhook_recover = handler(self, self.event_recover),
		-- onhook_watchonhook = handler(self, self.event_watchonhook),
		onhook_closeonhook = handler(self, self.event_closeonhook),
		onhook_getaward = handler(self, self.event_getaward),
		onhook_getaward_result = handler(self, self.event_getaward_result),--领取奖励结果
		onhook_addlevel = handler(self, self.event_addlevel),
		
		onhook_create_info = handler(self, self.event_create_info),
		onhook_create_quickcombat = handler(self, self.event_create_quickcombat),
		onhook_create_sell = handler(self, self.event_create_sell), --
		onhook_msg_quickcombat = handler(self, self.event_msg_quickcombat),
		onhook_msg_quickcombat_result = handler(self, self.event_msg_quickcombat_result),--
		onhook_execute_request_msg = handler(self, self.event_execute_request_msg),
		onhook_stop = handler(self, self.event_stop),

		onhook_ui_operation_level = handler(self, self.event_ui_operation_level),
		onhook_executeover = handler(self, self.event_executeover),
		battlefield_cut = handler(self, self.event_battlefield_cut),
		battlefield_recover = handler(self, self.event_battlefield_recover),
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

function control_OnhookSystem:addExecuteEvent( eventname )
	if not eventname then
		return;
	end
	for i,v in ipairs(eventname) do
		table.insert(self.registerConfig, 1, eventname)
	end
end

--初始化数据
function control_OnhookSystem:event_initialize( event )
	if self.UI_Bottom then
		--请求数据
		-- Data_Battle_Msg:requestOnhook_Msg(  );
		return;
	end
	--创建挂机Ui显示条
	self.UI_Bottom = require("app.views.battlefield.ui.UI_BattleOnhook_Bottom").new();
	self.UI_Bottom:setPosition(cc.p( 0, -display.height / 2));
	self:event_infoupdata(  );
	--更新关卡数据

	--添加对象
	print("==========>event_initialize:",Data_Battle_Onhook.LevelData,WarConfig[1])
	-- for i,v in ipairs(WarConfig) do
	-- 	local view = self.UI_Bottom:addLevelItem( v );
	-- 	if v.Key == Data_Battle_Onhook.LevelData.Key then
	-- 		self.OnhookLevelItem = view;
	-- 	end
	-- end
	for i=1,Data_Battle_Onhook.Open_Level do
		local view = self.UI_Bottom:addLevelItem( WarConfig[i] );
		if WarConfig[i] and WarConfig[i].Key == Data_Battle_Onhook.LevelData.Key then
			self.OnhookLevelItem = view;
		end
		self.ShowLevelList[i] = view ;
	end
	-- self.UI_Bottom:resetLevelListShowInfo(self.OnhookLevelItem);
	
	self.UI_Bottom:retain();
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.UI_Bottom, 4 ,1});

	self.UI_CutView = createViewWithCSB("ui_instance/battlefield/battle_onhookcut_info.csb");
	self.cutInfo = self.UI_CutView:getChildByName("Text_1");
	self.UI_CutView:setPosition(cc.p( 0, 100));
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.UI_CutView, 4 ,1});
	self.UI_CutView:setVisible(false);

	-- self:event_hide(  );

	--请求数据
	-- Data_Battle_Msg:setTestData(Data_Battle.CONST_BATTLE_TYPE_ONHOOK,Data_Battle_Onhook.LevelData.name);
	-- Data_Battle_Onhook:requestOnhook_Msg(  );
end


function control_OnhookSystem:requestOnhook_Msg(  )
	--请求数据
	Data_Battle_Msg:setTestData(Data_Battle.CONST_BATTLE_TYPE_ONHOOK,Data_Battle_Onhook.LevelData.name);
end

--挂机战斗数据请求
function control_OnhookSystem:event_execute_request_msg( event )
	--请求数据
	Data_Battle_Onhook:requestOnhook_Msg(  );
	-- Data_Battle_Msg:setTestData(Data_Battle.CONST_BATTLE_TYPE_ONHOOK,Data_Battle_Onhook.LevelData.name);
	--创建等待界面
	-- self.WaitTimeEffect = EffectManager.CreatePiece_Timer( 20 );
 --    self.WaitTimeEffect:setFinishCallback( function (  )
 --        print("挂机开始战斗 倒计时完成");
 --        -- control_Combat:doEvent("event_exit_battle");
 --    end );
 --    dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{self.WaitTimeEffect, 4 ,3});
end


function control_OnhookSystem:event_create( event )
	--执行状态
	self.OnhookLogicState = 1;
	--创建战场
	Data_Battle:setBattlefieldType( Data_Battle.CONST_BATTLE_TYPE_ONHOOK );--设置战斗类型
	--更新挂机数据
	Data_Battle_Msg:updateExecuteData();
	--设置挂机战斗数据
	Data_Battle_Onhook:setOnhookFightData( Data_Battle_Msg:getCurrentFightData() );
	--挂机数据处理逻辑
	self:onhookDataLogicHandle(  );
	--执行数据
	control_Combat:doEvent("event_initialize","testcjcj");
	--清除战斗等待
	-- if self.WaitTimeEffect then
	-- 	self.WaitTimeEffect:removeFromParent();
	-- 	self.WaitTimeEffect = nil;
	-- end
	--切换效果
	dispatchGlobaleEvent( "battleshowlayer" ,"event_cut" ,{2});
    local delay_1 = cc.DelayTime:create(1);
    local callfun = cc.CallFunc:create(function (  )
        control_Combat:doEvent("event_entrance");
    end)
    self.UI_Bottom:runAction(cc.Sequence:create(delay_1,callfun));

end


--更新显示
function control_OnhookSystem:event_infoupdata( event )
	if self.UI_Bottom then
		--胜率
		self.UI_Bottom:setWinFficiency( Data_Battle_Onhook.winfficiency );
		--boss挑战次数
		self.UI_Bottom:setBossChallenge( Data_Battle_Onhook:getBossChallengeNum(  ) );
		-- --更新回复时间
		-- self.UI_Bottom:setRevertTime( Data_Battle_Onhook:getRevertTimeDes(  ) )
	end
end

function control_OnhookSystem:event_watchonhook( event )
	print("control_OnhookSystem:event_watchonhook",self.OnhookLogicState)
	--判读挂机状态(未执行 或 暂停状态)
	if self.OnhookLogicState == 0 or self.OnhookLogicState == 2 then
		return;
	end
	--显示挂机ui
	self:event_show(  );
	--去除挂机暂停
	control_Combat:setPauseInfo( -1 , -1 ,-1 );
end

--添加关卡
function control_OnhookSystem:event_addlevel( event )
	local levelkey = event._usedata[1];
	print(levelkey);
	local view = self.UI_Bottom:addLevelItem( WarConfig[levelkey] );
	self.ShowLevelList[levelkey] = view ;
	self.UI_Bottom:resetLevelListShowInfo(self.OnhookLevelItem);
	self.ShowLevelList[levelkey - 1]:refresh();
end

function control_OnhookSystem:refreshOnhookUI(  )
	for k,v in pairs(self.ShowLevelList) do
		v:refresh();
	end
end

--领取奖励
function control_OnhookSystem:event_getaward( event )
	local levelkey = event._usedata[1];
	printInfo("网络日志 发送领取关卡过关奖励 MSG_C2MS_WAR_GET_REWARD", levelkey)
	gameTcp:SendMessage(MSG_C2MS_WAR_GET_REWARD,{
		levelkey
		})
end

--领取奖励结果
function control_OnhookSystem:event_getaward_result( event )
	local levelkey = event._usedata[1];
	self.ShowLevelList[levelkey]:refresh();
end

--关闭挂机
function control_OnhookSystem:event_closeonhook( event )
	--隐藏战场
	dispatchGlobaleEvent( "battleshowlayer" ,"event_hide" );
	--隐藏挂机UI
	self:event_hide();
	--隐藏关卡列表
	self:hideLevelList();
end

--挂机切换
function control_OnhookSystem:event_data_cut( event )
	local key = event._usedata[1];
	-- Data_Battle_Onhook.LevelData = object.showData;
	--刷新界面
	self.OnhookLevelItem:refresh();
	self.ShowLevelList[key]:refresh();
	self.OnhookLevelItem = self.ShowLevelList[key];
	--清空保留的挂机战斗数据
	
	--提示下一场 挂机的关卡
	self.cutInfo:setString("下一场战斗:"..Data_Battle_Onhook.LevelData.name);
	self.UI_CutView:setVisible(true);
	
end

--暂停挂机执行
function control_OnhookSystem:PauseOnhookExecute( ispause )
	-- 得到暂停数据
	self.OnhookLogicState = ispause;
	-- self.awaitExecuteInfo.Pause
end

--恢复挂机
function control_OnhookSystem:event_recover( event )
	--结束当前挂机战斗
	self:PauseOnhookExecute( 1 );
	--显示挂机UI
	self:event_show();
	--执行结果
	-- control_Combat:doEvent("event_exit_battle");
	-- control_Combat:doEvent("event_exit_battle");
	--请求挂机数据
	-- Data_Battle_Msg:setTestData(Data_Battle.CONST_BATTLE_TYPE_ONHOOK,Data_Battle_Onhook.LevelData.name);
	Data_Battle_Onhook:requestOnhook_Msg(  );
	
	self.UI_CutView:setVisible(false);
end

--战场恢复
function control_OnhookSystem:event_battlefield_recover( event )
	--挂机系统执行中
	if self.OnhookLogicState == 1 then
		--请求挂机数据
		Data_Battle_Onhook:requestOnhook_Msg(  );
	end
end

--[[停止挂机系统

]]
function control_OnhookSystem:event_stop( event )
	--切换的提示
	local prompt = event._usedata[1];
	--结束当前挂机战斗
	self:PauseOnhookExecute( 2 );
	--暂停执行
	control_Combat:setPause(true);
	--重置数据的倒计时
	local currentResult = Data_Battle_Onhook.currentOnhookFightData.ResultData;
	currentResult.nextprompt = prompt;--提示
	currentResult.countdown = nil;--等待时间
	--执行结果
	control_Combat:doEvent("event_fight_over");
	--隐藏挂机UI
	self:event_hide();
	--隐藏关卡列表
	self:hideLevelList();
end

--战场切换
function control_OnhookSystem:event_battlefield_cut( event )
	--切换的提示
	local prompt = event._usedata[1];
	--结束当前挂机战斗
	self:PauseOnhookExecute( 2 );
	--暂停执行
	control_Combat:setPause(true);
	if not control_Combat:checkBattleOver(  ) then
		--重置数据的倒计时
		local currentResult = Data_Battle_Onhook.currentOnhookFightData.ResultData;
		currentResult.nextprompt = prompt;--提示
		currentResult.countdown = nil;--等待时间
		--执行结果
		control_Combat:doEvent("event_fight_over");
	end
	
	--隐藏挂机UI
	self:event_hide();
	--隐藏关卡列表
	self:hideLevelList();
end

--挂机执行完成一个
function control_OnhookSystem:event_executeover( event )
	if self.OnhookLogicState == 0 or self.OnhookLogicState == 2 then
		return;
	end
	--请求数据
	-- Data_Battle_Msg:setTestData(Data_Battle.CONST_BATTLE_TYPE_ONHOOK,Data_Battle_Onhook.LevelData.name);
	Data_Battle_Onhook:requestOnhook_Msg(  );
	
	self.UI_CutView:setVisible(false);
end

--执行关卡显示切换
function control_OnhookSystem:event_ui_operation_level( event )
	self.OnhookLevelState = self.OnhookLevelState * -1;
	if self.OnhookLevelState > 0 then
		self.UI_Bottom:Effect_ShowLevelList(  );
	else
		self.UI_Bottom:Effect_HideLevelList(  );
	end
end

--隐藏关卡列表
function control_OnhookSystem:hideLevelList(  )
	if self.OnhookLevelState > 0 then
		self:event_ui_operation_level(  );
	end
end

--隐藏
function control_OnhookSystem:event_hide( event )
	self.UI_Bottom:setVisible(false);
	self.UI_CutView:setVisible(false);
end

--显示
function control_OnhookSystem:event_show( event )
	self.UI_Bottom:setVisible(true);
end

function control_OnhookSystem:event_create_info( event )
	local ui_onhookinfo = class_onhookinfo.new();
	ui_onhookinfo:UpdateShowData();
	ui_onhookinfo:setPosition(cc.p(-640,-360));
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{ui_onhookinfo, 4 ,2});
end

function control_OnhookSystem:event_create_quickcombat( event )
	local result = Data_Battle_Onhook:getquickcombatType(  );
	if result == 2 then
		UIManager:CreatePrompt_Bar( {
			content = "今日战斗次数用尽",
		} )
	else
		local ui_quickcombat = class_quickcombat.new();
		ui_quickcombat:UpdateShowData(result);
		ui_quickcombat:setPosition(cc.p(-640,-360));
		--添加到显示界面
		dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{ui_quickcombat, 4 ,2});
	end
	
end

--发送快速战斗消息
function control_OnhookSystem:event_msg_quickcombat( event )
	printInfo("网络日志 发送快速战斗消息 MSG_C2MS_WAR_QUICK_COMBAT")
	local sendType = event._usedata[1];--消耗的类型
	gameTcp:SendMessage(MSG_C2MS_WAR_QUICK_COMBAT,{
		sendType;
		})
end

--快速战斗结果
function control_OnhookSystem:event_msg_quickcombat_result( event )
	local data = event._usedata[1];
	ManagerBattle:CreateQuickFightResult( data );
end

function control_OnhookSystem:event_create_sell( event )
	local ui_sell = class_sell.new();
	ui_sell:UpdateShowData();
	ui_sell:setPosition(cc.p(-640,-360));
	--添加到显示界面
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addshowobject" ,{ui_sell, 4 ,2});
end


--请求数据逻辑
function control_OnhookSystem:requestdataLogic(  )
	--请求挂机数据
	self:onhookDataLogicHandle();
end


--挂机逻辑处理
function control_OnhookSystem:onhookDataLogicHandle(  )
	--判断战场是否显示
	if battleShowManager:isShow() then
		return;
	end

	--得到当前挂机数据
	local onhookData = Data_Battle_Msg:getCurrentFightData();
	--解析局数量
	local inningsCount = onhookData.fightData.InningsCount;
	local randominning = math.random(inningsCount);
	if randominning < 1 then
		randominning = 1;
	end
	--随机回合数
	local boutCount = onhookData.fightData.InningsData[inningsCount].boutCount;
	local randombout = math.random(boutCount);

	--随机一个行动数
	local boutData = onhookData.fightData.InningsData[inningsCount].boutData[randombout];
	local actCount = boutData.actionCount
	local randomact = math.random(actCount);
	--暂停回合数 和局数
	self.PauseInfo_Inning = randominning;
	self.PauseInfo_Bout = randombout;
	self.PauseInfo_Act = randomact;
	print( "onhookStartLogicHandle:" , randominning , randombout , randomact);
	control_Combat:setPauseInfo( randominning , randombout ,randomact );
end

--注册关闭事件
function control_OnhookSystem:remove_event(  )
	--清除事件监听
	for k,v in pairs(self.eventlisen) do
		GLOBAL_EVENT_DISPTACHER:removeEventListener(v);
	end
end

Control_Onhook= control_OnhookSystem.getInstance( );

return control_OnhookSystem;
