--
-- Author: LiYang
-- Date: 2015-08-12 14:23:59
-- 战场控制

local control_battlefield = class("control_battlefield");

function control_battlefield:ctor()
	self.registerConfig = {
        {"battlefield","initialize",1},--观看挂机
        {"battlefield","pause",1},--暂停战场
        {"battlefield","recover",1},--恢复战场
    };

    self:register_event(  );

    --数据请求队列
	self.requestQueue = {};
	self.requestLen = 2;--队列请求数据长度
	self.addIndex = 1;

	self.executeIndex = 0;
	--战场执行状态 0 停止 1 执行
	self.executeState = 1;
end

function control_battlefield:getInstance(  )
    if control_battlefield.instance == nil then
        control_battlefield.instance = control_battlefield.new()
    end
    return control_battlefield.instance
end

--注册事件
function control_battlefield:register_event(  )

    local defaultCallbacks = {
        battlefield_initialize = handler(self, self.InitializeBattlefield),
        battlefield_pause = handler(self, self.register_event_pause),
        battlefield_recover = handler(self, self.register_event_recover),
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

function control_battlefield:register_event_pause( event )
	self.executeState = 0;
end

function control_battlefield:register_event_recover( event )
	self.executeState = 1;
	
end

--初始化战场
function control_battlefield:InitializeBattlefield( event )
	--初始化数据
	Data_Battle_Onhook:InviOnhookData();
	--创建显示关卡
	dispatchGlobaleEvent( "battlefield" ,"event_create",{false});
	--创建伤害提示管理逻辑
	self.HurtPromptManager = require("app.effect.hurtprompt.HurtPromptManager").new();
	dispatchGlobaleEvent( "battleshowlayer" ,"event_addlogicbject" ,self.HurtPromptManager);

	ManagerBattle:CreateOffLineBattleResult(  );
	--初始化挂机系统
	dispatchGlobaleEvent( "onhook" ,"initialize");
	
    --添加首个挂机执行数据
    -- self:execute_requestLogic();
   --  self:addRequestData( {
   --  		battletype = Data_Battle.CONST_BATTLE_TYPE_test,
			-- levlekey = "",
			-- isexecute = true,--是否马上执行
   --  	} )
	
	--添加首个挂机执行数据
	self:addRequestData( {
    	battletype = Data_Battle.CONST_BATTLE_TYPE_ONHOOK,
		isexecute = true,--是否马上执行
    } )
end

--检查是否能添加
function control_battlefield:checkIsCanAdd(  )
	local CurrentBattleType = Data_Battle.BattleType;
	if CurrentBattleType == Data_Battle.CONST_BATTLE_TYPE_ONHOOK or CurrentBattleType == 0 then
		return true;
	end
	return false;
end

--[[战斗数据请求格式
	1.挂机挑战
	data = {
		eventlog = "",--事件逻辑
		battletype = Data_Battle.CONST_BATTLE_TYPE_ONHOOK,战场类型
		isexecute = true,--是否马上执行
	}
	2.boss 挑战
	data = {
		battletype = CData_Battle.ONST_BATTLE_TYPE_BOSS,战场类型
		levelkey = "",
		isexecute = true,--是否马上执行
	}
	3.奇遇挑战
	data = {
		battletype = Data_Battle.CONST_BATTLE_TYPE_QIYU,战场类型
		buykey = "",--购买序号
		operkey = "",--操作序号
		isexecute = true,--是否马上执行
	}
]]
function control_battlefield:addRequestData( data )
	local iscanadd = self:checkIsCanAdd(  );
	if not iscanadd then
		UIManager:CreatePrompt_Bar( {
			content = "当前正在其他战斗",
		} )
		return;
	end
	local index = 0;
	for i=1,self.requestLen do
		if not self.requestQueue[i] then
			self.requestQueue[i] = data;
			index = i;
			break;
		end
	end
	if index == 0 then
		print("执行队列已满");
	else
		if data.isexecute then
			self:execute_requestLogic(  );
		end
	end

end

--执行数据请求
function control_battlefield:execute_requestLogic(  )
	self.requestQueue[self.executeIndex] = nil;
	self.executeIndex = self.executeIndex + 1;
	if self.executeIndex > self.requestLen then
		self.executeIndex = 1; 
	end
	local executeData = self.requestQueue[self.executeIndex];
	print(executeData.battletype,self.executeIndex)
	if executeData then
		if executeData.battletype == Data_Battle.CONST_BATTLE_TYPE_BOSS then
			dispatchGlobaleEvent( "challengeboss" ,"execute_request_msg" ,{executeData.levelkey});
		elseif executeData.battletype == Data_Battle.CONST_BATTLE_TYPE_test then
			dispatchGlobaleEvent( "testbattlefield" ,"initialize");
		elseif executeData.battletype == Data_Battle.CONST_BATTLE_TYPE_ONHOOK then
			--挂机战斗类型()
			dispatchGlobaleEvent( "onhook" ,"execute_request_msg");
		elseif executeData.battletype == Data_Battle.CONST_BATTLE_TYPE_QIYU then
			dispatchGlobaleEvent( "qiyu" ,"execute_request_msg",{executeData.mode, executeData.buykey,executeData.operkey,executeData.teamdex});
		end
	end
end




control_Battlefield = control_battlefield.getInstance( );

return control_battlefield;
