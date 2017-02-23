--
-- Author: liYang
-- Date: 2015-06-15 11:40:29
-- 挂机数据

local model_onhook = class("model_onhook")


function model_onhook:ctor()
	--挂机的关卡数据
	self.LevelData = nil;
	--战斗效率
	self.combatefficiency = 60;
	--战斗用时
	self.combatetime = 55;
	--获得经验
	self.exp = 3000;
	--升级时间预计
	self.upgradetime = 20;
	--金币
	self.gold = 20000;
	--装备掉率
	self.dropout = 0.456;
	--胜率(-1 为初始状态 即数据更新状态)
	self.winfficiency = 10;

	self.CurrentLimitBossNum = 0;
	self.CurrentLimitQucikNum = 0;

	--快速战斗次数
	self.QuickFightTime = 3;
	--boss挑战次数
	self.BossChallengeTime = 3;
	--boss挑战的关卡
	self.Open_Level = 0;

	self._lastChangeTime = os.time();

	--自动出售选择列表
	self.sellType = {false,false,false,false};

	self.SaveFightData = {};

	--初始化挂机关卡
	self.LevelData = WarConfig[1];
	-- print("model_onhook:ctor",self.LevelData.Key);

	--当前挂机战斗数据
	self.currentOnhookFightData = nil;
	--挂机队伍id
	self.onhookteam = 1;

	--奖励关卡数据
	self.awardLevel = {};
	
end

--注册全局事件监听器
function model_onhook:_registGlobalEventListeners()
	self._globalEventListeners = {}
	local configs = {
		{modelName = "netMsg", eventName = tostring(MSG_MS2C_VIP_BASE_INFO_CHANGE), callBack=handler(self, self.InviOnhookData)},
	}
	self._globalEventListeners = createGlobalEventListenerWithConfig(configs)
end

function model_onhook:InviOnhookData()
	local vipinfo = GetVipCfg(MAIN_PLAYER.VIPManager.VipGrade);
	self.CurrentLimitBossNum = vipinfo.every_day.boss_num;
	self.CurrentLimitQucikNum = vipinfo.every_day.quick_item_num;
	print("InviOnhookData",self.CurrentLimitBossNum,self.CurrentLimitQucikNum)
end

--得到boss 挑战次数
function model_onhook:getBossChallengeNum(  )
	local num = self.CurrentLimitBossNum - self.BossChallengeTime;
	if num < 0 then
		num = 0;
	end
	return num;
end

--得到boss道具挑战次数
function model_onhook:getBossChallengeGoodsNum(  )
	local goodsnum = MAIN_PLAYER.goodsManager:getCount(eSTID_BossPlay);
	if goodsnum < 0 then
		goodsnum = 0;
	end
	return goodsnum;
end

--是否能boss挑战
function model_onhook:checkIsCanBossChallenge(  )
	-- 0不能挑战 1 挑战次数 2 道具挑战 3购买挑战次数
	local count = self:getBossChallengeNum(  );
	if count > 0 then
		return 1;
	end
	count = self:getBossChallengeGoodsNum(  );
	if count > 0 then
		return 2;
	end
	return 0;
end

--得到快速战斗次数
function model_onhook:getQuickFightNum(  )
	local num = self.CurrentLimitQucikNum - self.QuickFightTime;
	if num < 0 then
		num = 0;
	end
	return num;
end

--得到快速战斗道具数量
function model_onhook:getQuickFightGoodsNum(  )
	local goodsnum = MAIN_PLAYER.goodsManager:getCount(eSTID_QuickPlay);
	if goodsnum < 0 then
		goodsnum = 0;
	end
	return goodsnum;
end

--[[快速战斗类型 
	0 消耗次数
	1 消耗道具
	2 用尽

]]
function model_onhook:getquickcombatType(  )
	-- local quickType = 0;
	local daojuCount = self:getQuickFightGoodsNum(  )--快速战斗令
	if self:getQuickFightNum(  ) > 0 then
		return 0;
	elseif daojuCount > 0 then
		return 1;
	end
	return 2;
end

function model_onhook:isShowAwardBox( key )
	return self.awardLevel[key];
end

--获取玩家耐力上限
function model_onhook:getChallengeMax()
	return  60
end

--获取玩家当前耐力
function model_onhook:getCurEnergy()
	--向下取整
	if self.Boss_challenge >= self:getChallengeMax() then
		return self.Boss_challenge
	end
	return math.floor(self:curEnergyTimeValue() / serverConfig.energyBackRoundTime)+self.Boss_challenge
end

function model_onhook:isMaxChallenge(  )
	if self.Boss_challenge >= self:getChallengeMax() then
		return true;
	end
	return false;
end

--得到回复时间描述
function model_onhook:getRevertTimeDes(  )
	if self:curEnergyTimeValue() <= 0 then
		return "MAX";
	end
	
	local time = TIME_HELPER:secondToTime( self:getBackEnergyRemainTime() )
    timestr = string.format("%02d:%02d:%02d", 
                    time.hour,
                    time.min,
                    time.sec
                )
	return timestr;
end

--获取玩家恢复耐力剩余时间(单位: 秒)
function model_onhook:getBackEnergyRemainTime()
	local energyBackRoundTime = serverConfig.energyBackRoundTime
	return energyBackRoundTime - self:curEnergyTimeValue() % energyBackRoundTime
end

--玩家当前耐力转为时间后的值
function model_onhook:curEnergyTimeValue()
	local energyTimeValue = TIME_HELPER:clientTimeToServerTime(os.time()) - self._lastChangeTime
	--耐力剩余最大恢复值
	local energyRemainBackMaxValue = (self:getChallengeMax() - self.Boss_challenge) * serverConfig.energyBackRoundTime
	if energyTimeValue >= energyRemainBackMaxValue then
		energyTimeValue = energyRemainBackMaxValue
	end

	return energyTimeValue
end

function model_onhook:requestOnhook_Msg(  )
	printInfo("网络日志 请求挂机战斗数据 MSG_C2MS_WAR_GET_COMBAT_DATA key = %s", self.LevelData.Key);
	gameTcp:SendMessage(MSG_C2MS_WAR_GET_COMBAT_DATA,{
		self.LevelData.Key
		})
end

--设置boss挑战关卡
function model_onhook:setOpenLevel( levelkey )
	if self.Open_Level == 0 then
		self.Open_Level = levelkey + 1;
	else
		if levelkey == self.Open_Level then
			--挑战成功 发送解锁关卡
			if WarConfig[levelkey + 1] then
				--更新关卡
				self.Open_Level = levelkey + 1;
				dispatchGlobaleEvent( "onhook" ,"addlevel",{self.Open_Level});
			end
		end
	end
	
end

--设置挂机关卡
function model_onhook:setOnhookLevel( levelkey )
	print("model_onhook:setOnhookLevel",levelkey)
	if self.LevelData.Key ~= levelkey then
		self.LevelData = WarConfig[levelkey];
		self.IsOhookCut = true;
		dispatchGlobaleEvent( "onhook" ,"data_cut" ,{levelkey});
	end
	
end

--[[更新挂机信息
	sumcount 总次数
	sumtime 总时间
	wincount 胜利次数
]]
function model_onhook:updateOnhookInfo( sumcount ,sumtime ,wincount )
	if sumcount == 0 then
		return;
	end
	--每场 战斗用时
	self.combatetime = sumtime / sumcount;
	--战斗效率
	self.combatefficiency = math.ceil(3600 / self.combatetime);

	--战斗胜率
	self.winfficiency = math.floor( wincount / sumcount * 100);
	--获得经验
	self.exp = self.LevelData.exp * self.combatefficiency;
	--获得金币
	self.gold = self.LevelData.gold * self.combatefficiency;
	--掉落
	--更新挂机信息
	dispatchGlobaleEvent( "onhook" ,"infoupdata");
end


--保存的挂机战斗数据
function model_onhook:SaveOnhookFightData( data )
	--更新执行时间
	data.executeDate = os.time();
	self.SaveFightData[data] = data;
end


function model_onhook:clearFightData(  )
	self.SaveFightData = {};
end

--是否是挑战关卡
function model_onhook:isOnhookLevel( levelkey )
	if self.LevelData and self.LevelData.Key == levelkey then
		return true;
	end
	return false;
end

function model_onhook:setOnhookFightData( data )
	self.currentOnhookFightData = data;
end


return model_onhook;


