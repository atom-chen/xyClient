--
-- Author: liYang
-- Date: 2015-06-15 11:40:29
-- 战场数据

local model_battle = class("model_battle")

local model_mapClass = import(".model_map_1")
local model_msgClass = import(".model_msg")
local model_onhookClass = import(".model_onhook")

------------------------------------战场常量----------------------------------------------

model_battle.CONST_SUM_BOUT = 30;

-- 己方阵营
model_battle.CONST_CAMP_PLAYER   = 1;
model_battle.CONST_CAMP_ENEMY    = -1;

model_battle.CONST_BATTLE_TYPE_COMMON = 1;--普通副本
model_battle.CONST_BATTLE_TYPE_ACTIVITY = 2;--活动副本
model_battle.CONST_BATTLE_TYPE_JJC = 3;--竞技场
model_battle.CONST_BATTLE_TYPE_MC_1 = 4; -- 迷宫遇怪
model_battle.CONST_BATTLE_TYPE_MC_2 = 5; -- 迷宫遇人
model_battle.CONST_BATTLE_TYPE_MC_3 = 6; -- 迷宫挑战事件
model_battle.CONST_BATTLE_TYPE_GUILD_MAZE_1 = 20; -- 公会迷宫遇怪
model_battle.CONST_BATTLE_TYPE_GUILD_MAZE_2 = 21; -- 公会迷宫遇人
model_battle.CONST_BATTLE_TYPE_GUILD_MAZE_3 = 22; -- 公会迷宫挑战事件
model_battle.CONST_BATTLE_TYPE_SHOW = 101;--展示战斗类型
model_battle.CONST_BATTLE_TYPE_ONHOOK = 30;--挂机战斗类型
model_battle.CONST_BATTLE_TYPE_BOSS = 31;--boss挑战类型
model_battle.CONST_BATTLE_TYPE_test = 32;--测试战场类型
model_battle.CONST_BATTLE_TYPE_QIYU = 33;--奇遇战场类型

--[[发送全局事件名预览
eventModleName: model_battle
eventName: 
	zhanyi_result --战役挑战结果
]]

--[[监听全局事件名预览
eventModleName: netMsg
eventName:
	tostring(MSG_MS2C_INSTANCING_DATA)
]]



function model_battle:ctor()
	self.mapData = model_mapClass.new();
	self.msgData = model_msgClass.new();
	self.onhookData = model_onhookClass.new();

	self.BattleType = 0;

	self.offLineData = {};

	--[[战斗记录数据
		比如 选择的关卡 战斗前的玩家的一些数值
	]]
	self.recordData = {
		
	};
	
	self:_registGlobalEventListeners();

end

function model_battle.getInstance()
	if model_battle.instance == nil then
		model_battle.instance = model_battle.new()
	end
	return model_battle.instance
end

function model_battle:setBattlefieldType( valuse )
	print("model_battle:setBattlefieldType",valuse)
	self.BattleType = valuse;
end

function model_battle:getBattlefieldType(  )
	return self.BattleType;
end

--[[设置战前的一些记录值
	index 值标示
	data 数据
]]
function model_battle:SetRecordValuse( index , data )
	self.recordData[index] = data;
end

function model_battle:getRecordValuse( index )
	return self.recordData[index];
end

--[[处理战役挑战结果逻辑
	战役要记录的数据key值
		zhanyilevelkey
		zhanyikey
]]
function model_battle:handleZhanyiResultLogic( event )
	local score = event._usedata;
	--得到操作的关卡
	local zhanyilevelData = get_instancing_level(self:getRecordValuse("zhanyilevelkey"));
	printInfo("战斗的战役关卡: %s %s",zhanyilevelData.Key,score)
	--攻打次数控制
	if score > 0 then
		zhanyilevelData.CurrentLimitNum = zhanyilevelData.CurrentLimitNum - 1;
	end
	--更新关卡星级数据
	if zhanyilevelData then
		if (not zhanyilevelData.LevelStar) or score > zhanyilevelData.LevelStar  then
			zhanyilevelData.LevelStar = score;
		end
	end
	--判断是否过关
	local operationCarbon = get_instancing_group( self:getRecordValuse( "zhanyikey" ) );
	if operationCarbon.CarbonState ~= 2 then
		operationCarbon.CarbonState = 2;
		for k,v in pairs(operationCarbon.CarbonLevelList) do
			local level = get_instancing_level( v );
			if level then
				if (not level.LevelStar) or level.LevelStar < 1 then
					operationCarbon.CarbonState = 1;
				end
			else
				print("副本组 关卡数据 nil")
			end
		end
		--过关奖励显示
		if operationCarbon.CarbonState == 2 and (not operationCarbon.IsPassPrize) then
			operationCarbon.IsCanGetPassAward = true;
			--开启下一个关卡组
			-- Uniquify_Carbon.carbonLevelList:UpDataPassAwardShow();
			-- Uniquify_CarbonCenter.CarbonChooseMap:UpDataChallenge_Mark( 1 );
		end
		if operationCarbon.CarbonState ~= 2 then
			operationCarbon.BattleStar = 0;
		end

	end
	--三星判断内容
	if operationCarbon.CarbonState == 2 and score > operationCarbon.BattleStar then
		operationCarbon.BattleStar = 3;--关卡组星级
		for k,v in pairs(operationCarbon.CarbonLevelList) do
			if v then
				local level = get_instancing_level( v );
				if level.LevelStar < operationCarbon.BattleStar then
					operationCarbon.BattleStar = level.LevelStar;
				end
			end
		end
		--完美过关奖励显示
		if (not operationCarbon.IsPerfectPrize) and operationCarbon.BattleStar == 3 then
			--更新领奖标示
			operationCarbon.IsCanGetPerfectAward = true;
			-- print("判断三星 -->1")
			-- Uniquify_Carbon.carbonLevelList:UpDataAwardShow();
		end
		--更新副本组星级
		-- Uniquify_CarbonCenter.CarbonChooseMap:UpDataOperationStar_Mark( );--更新选择关卡的星级
	end
	--发送战役挑战结果
	dispatchGlobaleEvent( "zhanyi_ctrl" ,"challenge_result")
end



--注册全局事件监听器
function model_battle:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_INSTANCING_RESULT), callBack=handler(self, self.handleZhanyiResultLogic)},
		-- {modelName = "netMsg", eventName = tostring(MSG_MS2C_WAR_OFFLINE_RESULT), callBack=handler(self, self._onMSG_MS2C_ROLE_UPDATA_YUANBAO)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

Data_Battle = model_battle.getInstance();

Data_Battle_Msg = Data_Battle.msgData;

Data_Battle_Onhook = Data_Battle.onhookData;

return model_battle


