--
-- Author: li Yang
-- Date: 2014-06-25 13:49:38
-- 副本消息

-- 收到服务器副本数据
-- Msg_Logic[MSG_MS2C_INSTANCING_DATA] = function ( tcp , msg )
-- 	printInfo("网络日志 %s","--------收到副本数据")
-- 	local jsondata = msg:ReadString()
-- 	-- require "cocos.cocos2d.json"
-- 	-- printInfo("MSG_MS2C_INSTANCING_DATA %s",jsondata)
-- 	-- local tb = json.decode(jsondata);
-- 	local zhanyiData = unserialize(jsondata);
-- 	--初始化副本数据
-- 	for i,v in pairs(zhanyiData) do
-- 		local Carbonsort = v;
-- 		printInfo("副本种类：%s",i);
-- 		if Carbonsort then
-- 			if type(Carbonsort) == "table" then
-- 				for k,groupdata in pairs(Carbonsort) do
-- 					-- 判断副本组状态 1 开启 2 通关
-- 					-- print("" ,k);
-- 					local carbonData = get_instancing_group( k );
-- 					local levelSum = #carbonData.CarbonLevelList;
-- 					printInfo("   副本组 %d ,%d",k , levelSum);
-- 					carbonData.CarbonState = 1; -- 开启
					
-- 					carbonData.IsPerfectPrize = false;--是否领奖标示
-- 					carbonData.IsPassPrize = false;--是否领取过关奖励
-- 					carbonData.IsCanGetPerfectAward = true;--是否能领取完美过关奖励
-- 					carbonData.IsCanGetPassAward = true;--是否能领取过关奖励
-- 					carbonData.BattleStar = 3;--关卡组星级
-- 					carbonData.IsFristOpen = true;
-- 					-- 得到关卡数据
-- 					if groupdata then
-- 						for j,leveldata in pairs(groupdata) do
-- 							if type(leveldata) == "table" then
-- 								-- 得到关卡分数
-- 								printInfo("        关卡：%d",j)
-- 								local level = get_instancing_level( j );
-- 								if level then
-- 									level.LevelStar = leveldata.score;
-- 									if leveldata.count then
-- 										level.CurrentLimitNum = level.LimitNum - leveldata.count;
-- 									end
-- 									printInfo("           level: %d ,%d ,%d",j,leveldata.score,level.CurrentLimitNum);
-- 									if level.LevelStar > 0 or i == "page_3" then
-- 										levelSum = levelSum - 1;
-- 									end
-- 									--判断是否是首次
-- 									if level.LevelStar > 0 then
-- 										level.IsFristOpen = false;
-- 										carbonData.IsFristOpen = false;
-- 									end
-- 									--判断是否能完美领取奖励
-- 									if carbonData.IsCanGetPerfectAward and level.LevelStar < 3 then
-- 										carbonData.IsCanGetPerfectAward = false;
-- 									end
-- 									--判断关卡星级逻辑(显示个关卡最小星级)
-- 									if level.LevelStar < carbonData.BattleStar then
-- 										carbonData.BattleStar = level.LevelStar;
-- 									end
-- 								end
								
-- 							else
-- 								--是否领取奖励标示
-- 								if j == "get_perfect" then
-- 									carbonData.IsPerfectPrize = leveldata;
-- 									printInfo("      完美领奖标示：%s",leveldata)
-- 								end
-- 								--过关奖励标示
-- 								if j == "pass_prize" then
-- 									carbonData.IsPassPrize = leveldata;
-- 									printInfo("      过关领奖领取标示：%s",leveldata)
-- 								end
-- 							end

-- 						end
-- 						if levelSum <= 0  then
-- 							carbonData.CarbonState = 2;--通关状态
-- 							if i == "page_3" then
-- 								carbonData.IsCanGetPassAward = false;
-- 								carbonData.IsCanGetPerfectAward = false;
-- 								carbonData.IsPerfectPrize = true;
-- 								carbonData.IsPassPrize = true;
-- 							end
-- 						else
-- 							--没有通关 就是1星
-- 							-- if levelSum == #carbonData.CarbonLevelList  then
-- 							-- 	carbonData.BattleStar = 0;
-- 							-- else
-- 							-- 	carbonData.BattleStar = 1;
-- 							-- end
-- 							carbonData.BattleStar = 0;
-- 							carbonData.IsCanGetPassAward = false;
-- 						end
-- 						printInfo("        状态 %d = > %d",k , carbonData.CarbonState);
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end


-- 收到副本战斗结果通知
-- Msg_Logic[MSG_MS2C_INSTANCING_RESULT] = function ( tcp , msg )
-- 	printInfo("网络日志 %s","--------收到副本战斗结果MSG_MS2C_INSTANCING_RESULT")
	
-- 	local code = msg:ReadIntData()
-- 	printInfo("战斗随机解码code1: %s %s",code,Data_Battle.BattleType);
-- 	if Data_Battle_Msg.BattleCode ~= code then
-- 		return;
-- 	end

-- 	-- 分数
-- 	local score = msg:ReadIntData();
-- 	local ResultData = {};
-- 	ResultData.star = score;
-- 	ResultData.result = 0;
-- 	ResultData.gold = 0;
-- 	ResultData.exp = 0;
-- 	ResultData.soul = 0;
-- 	Data_Battle_Msg.ResultData = ResultData;

-- 	--副本关卡处理
-- 	if Data_Battle.BattleType == 1 then
-- 		print("===")
-- 		 dispatchGlobaleEvent( "netMsg" ,tostring(MSG_MS2C_INSTANCING_RESULT),score)
-- 	end

-- 	--掉落数据处理
-- 	ResultData.dropGoods = {};
-- 	print("score:"..score)
-- 	if score > 0 then
-- 		ResultData.result = 1;
-- 		-- 银两
-- 		local gold = msg:ReadIntData()

-- 		ResultData.gold = gold;
-- 		-- 经验
-- 		local exp = msg:ReadIntData()
-- 		ResultData.exp = exp;
-- 		local goodsNum = msg:ReadIntData();
-- 		printInfo("网络日志 %s","收到副本战斗奖励银两："..gold..",Exp:"..exp..",掉落数量："..goodsNum)
-- 		--所在的副本是否通关
-- 		-- BattleManager.ResultData.dropCard = {}--掉落卡片
-- 		-- BattleManager.ResultData.dropCard = {}--掉落卡片
-- 		-- BattleManager.ResultData.dropGoods = {}--掉落装备
-- 		-- BattleManager.ResultData.dropdebris = {}--掉落碎片

-- 		--银两
-- 		if gold > 0 then
-- 			ResultData.dropGoods[eDT_Gold] = {};
-- 			ResultData.dropGoods[eDT_Gold].count = 1;
-- 			ResultData.dropGoods[eDT_Gold].dropData = {};

-- 			local goods = {};
-- 			goods.TempleID =  0;
-- 			goods.Grade = 0;
-- 			goods.GoodsCount = gold;
-- 			ResultData.dropGoods[eDT_Gold].dropData[1] = goods;
-- 		end
-- 		--经验
-- 		if exp > 0 then
-- 			ResultData.dropGoods[eDT_PlayerExp] = {};
-- 			ResultData.dropGoods[eDT_PlayerExp].count = 1;
-- 			ResultData.dropGoods[eDT_PlayerExp].dropData = {};

-- 			local goods = {};
-- 			goods.TempleID =  0;
-- 			goods.Grade = 0;
-- 			goods.GoodsCount = exp;
-- 			ResultData.dropGoods[eDT_PlayerExp].dropData[1] = goods;
-- 		end

-- 		--卡片数量
-- 		local cardCount = 0;
-- 		--装备数量
-- 		local equipCount = 0;
-- 		--碎片数量
-- 		local chipCount = 0;
-- 		-- 掉落物品
-- 		for i=1,goodsNum do
-- 			local goodsType = msg:ReadIntData();--物品类型
-- 			local goodsID = msg:ReadIntData();--物品模板id
-- 			local goodsgrade = msg:ReadIntData();--物品等级
-- 			local goodscount = msg:ReadIntData();--物品数量
-- 			printInfo("网络日志 掉落 ==> %s","Goods："..goodsType..",物品ID："..goodsID..",物品等级："..goodsgrade..",物品数量："..goodscount)

-- 			if not ResultData.dropGoods[goodsType] then
-- 				ResultData.dropGoods[goodsType] = {};
-- 				ResultData.dropGoods[goodsType].count = 0;
-- 				ResultData.dropGoods[goodsType].dropData = {};
-- 			end
-- 			ResultData.dropGoods[goodsType].count = ResultData.dropGoods[goodsType].count + 1;
-- 			local goods = {};
-- 			goods.TempleID =  goodsID;
-- 			goods.Grade = goodsgrade;
-- 			goods.GoodsCount = goodscount;
-- 			ResultData.dropGoods[goodsType].dropData[ResultData.dropGoods[goodsType].count] = goods;
-- 		end
-- 	end
	
-- end

--解析战斗打斗数据
-- Msg_Logic[MSG_MS2C_BATTLE_DATA] = function ( tcp , msg )
-- 	if Data_Battle_Msg.BattleCode ~= 0 then
-- 		return;
-- 	end
-- 	local code = msg:ReadIntData()
-- 	Data_Battle_Msg.BattleCode = code;
-- 	-- print("战斗随机解码code2:"..code);
-- 	-- Data_Battle_Msg:analysisBattleData(msg);
-- 	-- 测试版本 创建战斗结果通知
-- 	--进入战斗界面
-- 	-- SceneManager.curOnSceneID = SceneManager.IDs.battleView
-- 	--进行资源加载
-- 	-- dispatchGlobaleEvent( "loadbattleres" ,"loadbattleres_start")
-- end

-- 收到副本开启通知
-- Msg_Logic[MSG_MS2C_INSTANCING_UPDATE] = function ( tcp , msg )
	
-- end

--完美通关奖励
-- Msg_Logic[MSG_MS2C_INSTANCING_PERFECT_REWARD] = function ( tcp , msg )
	
-- end

--过关奖励
-- Msg_Logic[MSG_MS2C_INSTANCING_PASS_REWARD] = function ( tcp , msg )
	
-- end


-- 	副本扫荡战斗结果通知
-- Msg_Logic[MSG_MS2C_INSTANCING_RUSH_RESULT] = function ( tcp , msg )
	
-- end

-- --错误消息
-- Msg_Logic[MSG_MS2C_INSTANCING_ERROR] = function ( tcp , msg )
	
-- end

---副本排行榜信息
-- Msg_Logic[MSG_MS2C_WAR_RANKING_INDEX] = function ( tcp , msg )
	
-- end

---副本关卡排行榜信息
-- Msg_Logic[MSG_MS2C_WAR_RANKING_LEVEL] = function ( tcp , msg )
	
-- end
