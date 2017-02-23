--
-- Author: Wu Hengmin
-- Date: 2014-04-14 16:04:06
--
	-- /** 打开抽奖
	-- *	int  发送免费抽剩余次数
	-- *	int  发送元宝抽奖免费次数
	-- *	int  倒计时
	-- */
-- 打开抽卡界面
-- Msg_Logic[MSG_MS2C_DRAW_OPEN] = function ( tcp , msg )
-- 	printLog("网络日志","打开抽卡界面")
-- 	local free = msg:ReadIntData()
-- 	MAIN_PLAYER.drawcradManager.free = free
-- 	printLog("网络日志","免费元宝抽奖次数:"..free)
-- 	local freetime = msg:ReadIntData()
-- 	print(freetime - os.time())
-- 	print("g_time:"..g_time)
-- 	MAIN_PLAYER.drawcradManager.freetime = freetime - os.time() - g_time
-- 	if MAIN_PLAYER.drawcradManager.freetime < 0 then MAIN_PLAYER.drawcradManager.freetime = 0 end
-- 	printLog("网络日志","元宝抽奖倒计时:"..MAIN_PLAYER.drawcradManager.freetime)
-- 	local purpletime = msg:ReadIntData()
-- 	MAIN_PLAYER.drawcradManager.purpletime = purpletime
-- 	if MAIN_PLAYER.drawcradManager.purpletime < 1 then MAIN_PLAYER.drawcradManager.purpletime = 1 end
-- 	printLog("网络日志","元宝抽奖出紫卡倒数:"..purpletime)

-- 	local isnochoose = msg:ReadIntData()
-- 	printLog("网络日志","是否有未选择的抽卡数据:"..isnochoose)
-- 	if isnochoose == 1 then
-- 		local count = msg:ReadIntData()
-- 		printLog("网络日志","抽取卡片 数量:"..count)

-- 		MAIN_PLAYER.drawcradManager.data = {}
-- 		for i=1,count do
-- 			local index = msg:ReadIntData()
-- 			printLog("网络日志","抽取卡片 索引:"..index)
-- 			local type_ = msg:ReadIntData()
-- 			printLog("网络日志","抽取卡片 类型:"..type_)
-- 			local id = msg:ReadIntData()
-- 			printLog("网络日志","抽取卡片 ID:"..id)
			
-- 			table.insert(MAIN_PLAYER.drawcradManager.data, {index = index, id = id, type_ = type_})
-- 		end
-- 	end
-- end

-- 打开商城界面
Msg_Logic[MSG_MS2C_SHOP_OPEN] = function ( tcp , msg )
	print("MSG_MS2C_SHOP_OPEN")
end

-- 打开充值界面
Msg_Logic[MSG_MS2C_RECHARGE_OPEN] = function ( tcp , msg )
	print("MSG_MS2C_RECHARGE_OPEN")

end

-- 打开礼包界面
Msg_Logic[MSG_MS2C_GIFT_OPEN] = function ( tcp , msg )
	print("MSG_MS2C_GIFT_OPEN")

end

-- 抽卡
Msg_Logic[MSG_MS2C_DRAW_UPDATE] = function ( tcp , msg )
	MAIN_PLAYER.drawcardManager.data = {}
	printLog("网络日志","抽取卡片")
	MAIN_PLAYER.drawcardManager.drwaedCardTime = msg:ReadIntData()
	printLog("网络日志","已免费抽取次数:"..MAIN_PLAYER.drawcardManager.drwaedCardTime)
	MAIN_PLAYER.drawcardManager.drwaedCardNum = msg:ReadIntData()
	printLog("网络日志","抽卡数量:"..MAIN_PLAYER.drawcardManager.drwaedCardNum)
	for i=1,MAIN_PLAYER.drawcardManager.drwaedCardNum do
		local type_ = msg:ReadIntData()
		local id = msg:ReadIntData()
		local level = msg:ReadIntData()
		local num = msg:ReadIntData()
		table.insert(MAIN_PLAYER.drawcardManager.data, {
				type_ = type_,
				id = id,
				level = level,
				num = num
			})
	end
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_DRAW_UPDATE))
end

Msg_Logic[MSG_MS2C_BUY_YUANBAO] = function ( tcp, msg )
	print("MSG_MS2C_BUY_YUANBAO")
end

Msg_Logic[MSG_MS2C_BUY_GOODS] = function ( tcp, msg )
	print("MSG_MS2C_BUY_GOODS")
end

-- -- 更新体力
-- Msg_Logic[MSG_MS2C_ROLE_UPDATA_STRENGTH] = function ( tcp, msg )
-- 	print("MSG_MS2C_ROLE_UPDATA_STRENGTH")
-- end

-- 更新背包
Msg_Logic[MSG_MS2C_ROLE_UPDATA_PACKLIMIT] = function ( tcp, msg )
	print("MSG_MS2C_ROLE_UPDATA_PACKLIMIT")
end

-- 更新装备
Msg_Logic[MSG_MS2C_ROLE_UPDATA_EQUIP_LIMIT] = function ( tcp, msg )
	print("MSG_MS2C_ROLE_UPDATA_EQUIP_LIMIT")
end

-- 更新好友
Msg_Logic[MSG_MS2C_ROLE_UPDATA_FRIENDLIMIT] = function ( tcp, msg )
	print("MSG_MS2C_ROLE_UPDATA_FRIENDLIMIT")
end

-- VIP信息
Msg_Logic[MSG_MS2C_VIP_INFO] = function ( tcp, msg )
	printLog("网络日志","VIP信息")

	MAIN_PLAYER.VIPManager.VipGrade = msg:ReadIntData()
	MAIN_PLAYER.baseAttr._vipLv = MAIN_PLAYER.VIPManager.VipGrade
	printLog("网络日志","当前VIP等级:"..MAIN_PLAYER.VIPManager.VipGrade)

	MAIN_PLAYER.VIPManager.chongzhijine = msg:ReadIntData()
	printLog("网络日志","当前VIP经验:"..MAIN_PLAYER.VIPManager.chongzhijine)

	local chongzhijine = msg:ReadIntData()
	printLog("网络日志","历史充值金额:"..chongzhijine)

	local count = msg:ReadIntData()
	printLog("网络日志","已购礼包数量:"..count)

	MAIN_PLAYER.VIPManager.giftpackage = {}
	for i=1,#VipConfig do
		MAIN_PLAYER.VIPManager.giftpackage[i] = 0
	end
	for i=1,count do
		local ID = msg:ReadIntData()
		printLog("网络日志","已购礼包ID:"..ID)
		MAIN_PLAYER.VIPManager.giftpackage[ID] = 1
	end

	MAIN_PLAYER.VIPManager.purchased_friends = msg:ReadIntData()
	printLog("网络日志","已购好友次数:"..MAIN_PLAYER.VIPManager.purchased_friends)

	MAIN_PLAYER.VIPManager.purchased_herolist = msg:ReadIntData()
	printLog("网络日志","已购背包次数:"..MAIN_PLAYER.VIPManager.purchased_herolist)

	MAIN_PLAYER.VIPManager.purchased_wearhouselist = msg:ReadIntData()
	printLog("网络日志","已购仓库次数:"..MAIN_PLAYER.VIPManager.purchased_wearhouselist)

	MAIN_PLAYER.VIPManager.purchased_equipment = msg:ReadIntData()
	printLog("网络日志","已购装备背包次数:"..MAIN_PLAYER.VIPManager.purchased_equipment)

	MAIN_PLAYER.VIPManager.purchased_jjc = msg:ReadIntData()
	printLog("网络日志","已购竞技场次数:"..MAIN_PLAYER.VIPManager.purchased_jjc)

	MAIN_PLAYER.VIPManager.purchased_tili = msg:ReadIntData()
	printLog("网络日志","购买体力次数:"..MAIN_PLAYER.VIPManager.purchased_tili)

	MAIN_PLAYER.VIPManager.purchased_jingli = msg:ReadIntData()
	printLog("网络日志","购买精力次数:"..MAIN_PLAYER.VIPManager.purchased_jingli)

	MAIN_PLAYER.VIPManager.rushed = msg:ReadIntData()
	printLog("网络日志","已扫荡次数:"..MAIN_PLAYER.VIPManager.rushed)

	MAIN_PLAYER.VIPManager.jianged = msg:ReadIntData()
	printLog("网络日志","已刷新将魂购买项次数:"..MAIN_PLAYER.VIPManager.jianged)

	MAIN_PLAYER.VIPManager.gongzi = msg:ReadIntData()
	printLog("网络日志","vip工资领取:"..MAIN_PLAYER.VIPManager.gongzi)

	if UIManager.gameMain and UIManager.gameMain.center and UIManager.gameMain.center.lastUIName == "商店" then
		UIManager.gameMain.center.Market:updateVIPInfo()
	end

	--更新副本体力信息
	
	count = msg:ReadIntData()
	printLog("网络日志","充值双倍数量:"..count)

	for i=1,count do
		local result = msg:ReadIntData()
		printLog("网络日志","已购礼包ID:"..result)
		MAIN_PLAYER.marketManager.shuangbei[result] = 1
	end

end

-- 增加首充标记
Msg_Logic[MSG_MS2C_VIP_ADD_FIRST_RECHARGED] = function ( tcp, msg )
	local sign = msg:ReadIntData()
	printLog("网络日志","增加首充标记:"..sign)
	MAIN_PLAYER.marketManager.shuangbei[sign] = 1

	-- 发送广播更新首充标记
end

-- VIP基本信息改变
Msg_Logic[MSG_MS2C_VIP_BASE_INFO_CHANGE] = function ( tcp, msg )
	printLog("网络日志","VIP基本信息改变")

	MAIN_PLAYER.VIPManager.VipGrade = msg:ReadIntData()
	MAIN_PLAYER.baseAttr._vipLv = MAIN_PLAYER.VIPManager.VipGrade
	printLog("网络日志","当前VIP等级:"..MAIN_PLAYER.VIPManager.VipGrade)

	MAIN_PLAYER.VIPManager.chongzhijine = msg:ReadIntData()
	printLog("网络日志","历史充值金额:"..MAIN_PLAYER.VIPManager.chongzhijine)

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_VIP_BASE_INFO_CHANGE))
end

-- 更新本日购买体力次数
Msg_Logic[MSG_MS2C_ROLE_UPDATA_BUY_STAMINA] = function ( tcp, msg )
	print("MSG_MS2C_ROLE_UPDATA_BUY_STAMINA")
end

-- 更新本日购买精力次数
Msg_Logic[MSG_MS2C_ROLE_UPDATA_BUY_VIGOUR] = function ( tcp, msg )
	print("MSG_MS2C_ROLE_UPDATA_BUY_VIGOUR")
end

-- 购买VIP礼包通知
Msg_Logic[MSG_MS2C_BUY_VIP_PACK] = function ( tcp, msg )
	printLog("网络日志","购买VIP礼包通知")
	local vip = msg:ReadIntData()
	printLog("网络日志","对应VIP等级:"..vip)
	MAIN_PLAYER.VIPManager.giftpackage[vip] = 1

	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_BUY_VIP_PACK))
end

-- 将魂购买项
Msg_Logic[MSG_MS2C_GETEXCHANGE_SHOP_LIST] = function ( tcp, msg )
	print("MSG_MS2C_GETEXCHANGE_SHOP_LIST")
end


-- 将魂购买结果
Msg_Logic[MSG_MS2C_EXCHANGE_GOODS] = function ( tcp, msg )
	print("MSG_MS2C_EXCHANGE_GOODS")
end

-- 将魂购买项刷新
Msg_Logic[MSG_MS2C_FREE_REFRESH_GOODSLIST] = function ( tcp, msg )
	print("MSG_MS2C_FREE_REFRESH_GOODSLIST")
end

-- 礼包兑换结果
Msg_Logic[MSG_MS2C_LIBAO_DUIHUAN] = function ( tcp, msg )
	print("MSG_MS2C_LIBAO_DUIHUAN")
end

-- 限购商品
--[[ 打开限购商品列表
*
*	int 	商品数量
*		int 	id
*		int 	最大数量
*		int 	当前剩余数量
*		int 	正常价格
*		int 	折后价格
*		int 	折扣
*
]]
Msg_Logic[MSG_MS2C_OPEN_XIANGOU_SHOPLIST] = function ( tcp, msg )
	MAIN_PLAYER.marketManager.shijiData = {}
	printLog("网络日志","打开限购商品列表")
	local count = msg:ReadIntData()
	printLog("网络日志","商品数量:"..count)
	for i=1,count do
		local limit = {}
		limit.index = msg:ReadIntData()
		limit.buycount = msg:ReadIntData()
		limit.id = msg:ReadIntData()
		limit.count1 = msg:ReadIntData()
		limit.count2 = msg:ReadIntData()
		limit.price1 = msg:ReadIntData()
		limit.price2 = msg:ReadIntData()
		limit.dc = msg:ReadIntData()

		printLog("网络日志","序号:"..limit.index.." 购买次数:"..limit.buycount.."商品信息 ID:"..limit.id.." 数量:"..limit.count1.." 当前数量:"..limit.count2..
			" 原价:"..limit.price1.." 现价:"..limit.price2.." 折扣:"..limit.dc)

		limit.name = XianGouConfig[limit.id].name
		limit.subscription = XianGouConfig[limit.id].subscription
		limit.package = XianGouConfig[limit.id].package
		limit.itemTypeForIcon = XianGouConfig[limit.id].itemTypeForIcon
		limit.itemIDForIcon = XianGouConfig[limit.id].itemIDForIcon

		table.insert(MAIN_PLAYER.marketManager.shijiData, limit)
		
	end
	
	-- 打开或者更新市集
	dispatchGlobaleEvent("model_marketManager", "openXiangou", {})
end


Msg_Logic[MSG_MS2C_BUY_XIANGOU_ITEM] = function ( tcp, msg )
	printLog("网络日志","购买限购商品结果")
	local result = msg:ReadIntData()
	if result == eXGS_BuySecced then
		-- UIManager:CreatePrompt_Bar( display.getRunningScene() , "购买成功")
		print("购买成功")
	else
		-- UIManager:CreatePrompt_1( display.getRunningScene() , getErrorDescribe( result ))
		print(getErrorDescribe( result ))
	end
	gameTcp:SendMessage(MSG_C2MS_OPEN_XIANGOU_SHOPLIST)
end

-- 阵营选择结果
Msg_Logic[MSG_MS2C_NEICE_ZHENYINGLIBAO] = function ( tcp, msg )
	print("MSG_MS2C_NEICE_ZHENYINGLIBAO")
end


-- 每日领取体力精力结果
Msg_Logic[MSG_MS2C_GETBUJI_EVERYDAY] = function (tcp, msg)
	local result = msg:ReadIntData()
	printLog("网络日志","每日领取体力精力结果:"..result)
	if result == eRI_Meiri_Buji_Succed then
		print("领取成功")
	else
		print(getErrorDescribe( result ))
	end
end

-- 选择抽取武将
-- Msg_Logic[MSG_MS2C_CHOOSE_DRAW_HERO] = function (tcp, msg)
-- 	local result = msg:ReadIntData()
-- 	printLog("网络日志","选择抽取武将结果:"..result)
-- 	if result == eRI_Meiri_Buji_Succed then
-- 		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_CHOOSE_DRAW_HERO))
-- 	else
-- 		print(getErrorDescribe( result ))
-- 	end
-- end

--[[ 打开熔炼商店
*
*	int 当前熔炼值
*	int 免费刷新次数
*	int 下次回复刷新次数的时间
* 	int 商品数量
*		int 商品类型
*		int 商品ID
*		int 等级
*		int 数量
*		int 货币类型
*		int 货币数量
*		int 折扣数
*
]]
Msg_Logic[MSG_MS2C_OPEN_RONGLIAN_SHOP] = function (tcp, msg)
	MAIN_PLAYER.marketManager.ronglianShop = {}
	printLog("网络日志","打开熔炼商店")
	MAIN_PLAYER.marketManager.freetimes = msg:ReadIntData()
	printLog("网络日志","免费刷新次数:"..MAIN_PLAYER.marketManager.freetimes)
	MAIN_PLAYER.marketManager.freetime = msg:ReadIntData()
	printLog("网络日志","下次回复刷新次数的时间:"..MAIN_PLAYER.marketManager.freetime)
	local count = msg:ReadIntData()
	printLog("网络日志","商品数量:"..count)
	for i=1,count do
		local type_ = msg:ReadIntData()
		local id = msg:ReadIntData()
		local lv = msg:ReadIntData()
		local num = msg:ReadIntData()
		local pricetype = msg:ReadIntData()
		local price = msg:ReadIntData()
		local discount = msg:ReadIntData()
		printLog("网络日志", "类型:"..type_.." ID:"..id.." 等级:"..lv
			.." 数量:"..num.." 价格类型:"..pricetype.." 价格:"..price.." 折扣:"..discount)

		table.insert(MAIN_PLAYER.marketManager.ronglianShop, {
				type_ = type_,
				id = id,
				lv = lv,
				num = num,
				pricetype = pricetype,
				price = price,
				discount = discount
			})

	end
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_OPEN_RONGLIAN_SHOP))
end

-- 更新熔炼商店
Msg_Logic[MSG_MS2C_RUSH_RONGLIAN_SHOP] = function (tcp, msg)
	printLog("网络日志","更新熔炼商店")
	local result = msg:ReadIntData()

	if eXGS_RushRl_Succed == result then
		MAIN_PLAYER.marketManager.ronglianShop = {}
		MAIN_PLAYER.marketManager.freetimes = msg:ReadIntData()
		printLog("网络日志","免费刷新次数:"..MAIN_PLAYER.marketManager.freetimes)
		MAIN_PLAYER.marketManager.freetime = msg:ReadIntData()
		printLog("网络日志","下次回复刷新次数的时间:"..MAIN_PLAYER.marketManager.freetime)
	


		local count = msg:ReadIntData()
		printLog("网络日志","商品数量:"..count)
		for i=1,count do
			local type_ = msg:ReadIntData()
			local id = msg:ReadIntData()
			local lv = msg:ReadIntData()
			local num = msg:ReadIntData()
			local pricetype = msg:ReadIntData()
			local price = msg:ReadIntData()
			local discount = msg:ReadIntData()
			printLog("网络日志", "类型:"..type_.." ID:"..id.." 等级:"..lv
				.." 数量:"..num.." 价格类型:"..pricetype.." 价格:"..price.." 折扣:"..discount)

			table.insert(MAIN_PLAYER.marketManager.ronglianShop, {
					type_ = type_,
					id = id,
					lv = lv,
					num = num,
					pricetype = pricetype,
					price = price,
					discount = discount
				})

		end
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar({content = errorDec})
	end
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_RUSH_RONGLIAN_SHOP))
end

-- 购买结果
Msg_Logic[MSG_MS2C_BUY_RONGLIANSHOP_ITEM] = function (tcp, msg)
	MAIN_PLAYER.marketManager.ronglianShop = {}
	local result = msg:ReadIntData()
	printLog("网络日志","购买结果:"..result)
	MAIN_PLAYER.marketManager.freetimes = msg:ReadIntData()
	printLog("网络日志","免费刷新次数:"..MAIN_PLAYER.marketManager.freetimes)
	MAIN_PLAYER.marketManager.freetime = msg:ReadIntData()
	printLog("网络日志","上次回复刷新次数的时间:"..MAIN_PLAYER.marketManager.freetime)


	local errorDec = getErrorDescribe( result ) or "未知错误"
	UIManager:CreatePrompt_Bar( {content = errorDec})
	gameTcp:SendMessage(MSG_C2MS_OPEN_RONGLIAN_SHOP)
end


--[[ 打开奇遇列表
*
* 	int 奇遇数量
*		int 奇遇ID
*		int 货币类型 0 则是不需要货币
*		int 货币数量 0 则是不需要货币
*
]]
Msg_Logic[MSG_MS2C_OPEN_QIYU_LIST] = function (tcp, msg)
	printLog("网络日志","打开奇遇列表")
	MAIN_PLAYER.marketManager.qiyu = {}
	local count = msg:ReadIntData()
	for i=1,count do
		local id = msg:ReadIntData()
		local type_ = msg:ReadIntData()
		local count = msg:ReadIntData()
		local level = msg:ReadIntData()
		local zhanli = msg:ReadIntData()
		local name = msg:ReadString()
		table.insert(MAIN_PLAYER.marketManager.qiyu, {id = id, type_ = type_, count = count, name = name, level = level, zhanli = zhanli})
	end

	if qiyurefresh then
		qiyurefresh = nil
		dispatchGlobaleEvent("qiyu_ctrl", "refreshlist")
	else
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_OPEN_QIYU_LIST))
	end
end


--[[ 购买确认奇遇操作
*
* 	int 操作结果
*	int 是否有战斗0.无战斗1.有战斗
*   (战斗数据)误战斗则没有数据,直接读取后面的
*	int 是否获得奖励0.无奖励1.有奖励
*	int 物品类型
*	int 物品ID
*	int 物品等级
*	int 物品数量
*
]]
Msg_Logic[MSG_MS2C_OPERATION_QIYU] = function (tcp, msg)
	printLog("网络日志","购买确认奇遇操作")
	local result = msg:ReadIntData()

	if eQY_DeleteQy == result then
		print("删除奇遇")
	elseif eQY_GetSecced == result then
		print("领取成功")
		local fight = msg:ReadIntData()
		if fight == 1 then
			local battledata = Data_Battle_Msg:analysisBattleData( msg ,Data_Battle.CONST_BATTLE_TYPE_QIYU , "奇遇战斗");
			local ResultData = {
				result = battledata.battleResult,
				score = 0,
				AttackSumHurt = battledata.AttackSumHurt,
				sumBout = 30,--总回合数
				boutCount = battledata.MaxBoutCount,--回合数
				nextprompt = "下场开始倒计时", --下一场战斗提示
		        countdown = 10,--倒计时
		        dropout = {},--掉落
			};
			battledata.ResultData = ResultData;
			--发送挂机战斗结果消息
			dispatchGlobaleEvent("netMsg", "qiyu_result",{battledata})
		end

		local reward = msg:ReadIntData()
		if reward == 1 then

			local type_ = msg:ReadIntData()
			local id = msg:ReadIntData()
			local lv = msg:ReadIntData()
			local num = msg:ReadIntData()
			printLog("网络日志","获得物品type:"..type_.." ID:"..id.." num:"..num)
			
			if fight ~= 1 then
				dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_GET_NOTICE), {data = {{ID = id, type_ = type_, num = num}}})
			else
				UIManager:QiyuSave({{ID = id, type_ = type_, num = num}})
			end
		end
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

	qiyurefresh = true
	gameTcp:SendMessage(MSG_C2MS_OPEN_QIYU_LIST)
	
end

--[[ 刷新奇遇
*
* 	int 结果(探索成功才有后面的,失败则没有后面的数据)
* 	int 奇遇数量
*		int 奇遇ID
*		int 货币类型 0 则是不需要货币
*		int 货币数量 0 则是不需要货币
*
]]
Msg_Logic[MSG_MS2C_ADD_QIYU] = function (tcp, msg)
	printLog("网络日志","刷新奇遇结果")
	local result = msg:ReadIntData()
	if eQY_TanSuo_Succed == result then
		-- local count = msg:ReadIntData()
		-- printLog("网络日志","刷新奇遇数量:"..count)
		local id = msg:ReadIntData()
		local type_ = msg:ReadIntData()
		local count = msg:ReadIntData()
		local level = msg:ReadIntData()
		local zhanli = msg:ReadIntData()
		local name = msg:ReadString()
		table.insert(MAIN_PLAYER.marketManager.qiyu, {id = id, type_ = type_, count = count, name = name, level = level, zhanli = zhanli})
		
		dispatchGlobaleEvent("qiyu_ctrl", "refreshlist")

	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

end

--[[ 打开复仇列表
* 	int 复仇数量
*		int 货币类型 0 则是不需要货币
*		int 货币数量 0 则是不需要货币
*		int 玩家等级
*		int 玩家战力
*		string 挑战玩家的名字(如果不是玩家则为"")
*
]]
Msg_Logic[MSG_MS2C_OPEN_FUCHOU_LIST] = function (tcp, msg)
	MAIN_PLAYER.marketManager.fuchou = {}
	printLog("网络日志","打开复仇列表")
	local count = msg:ReadIntData()
	printLog("网络日志","复仇数量:"..count)
	for i=1,count do
		local type_ = msg:ReadIntData()
		local price = msg:ReadIntData()
		local level = msg:ReadIntData()
		local zhanli = msg:ReadIntData()
		local name = msg:ReadString()
		printLog("网络日志","货币类型:"..type_.."货币数量:"..price
			.."玩家等级:"..level.."玩家战力:"..zhanli
			.."名字:"..name)
		table.insert(MAIN_PLAYER.marketManager.fuchou, {type_ = type_, price = price, name = name, level = level, zhanli = zhanli})
	end
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_OPEN_FUCHOU_LIST))

end

--[[ 确认复仇操作
*
* 	int 操作结果
*   (战斗数据)误战斗则没有数据,直接读取后面的
*	int 是否获得奖励0.无奖励1.有奖励
*	int 物品类型
*	int 物品ID
*	int 物品等级
*	int 物品数量
*
]]
Msg_Logic[MSG_MS2C_OPERATION_FUCHOU] = function (tcp, msg)
	MAIN_PLAYER.marketManager.fuchou = {}
	printLog("网络日志","确认复仇操作")
	local result = msg:ReadIntData()
	if result == eQY_FuChou_Succed then

		local battledata = Data_Battle_Msg:analysisBattleData( msg ,Data_Battle.CONST_BATTLE_TYPE_QIYU , "奇遇战斗");
		local ResultData = {
			result = battledata.battleResult,
			score = 0,
			AttackSumHurt = battledata.AttackSumHurt,
			sumBout = 30,--总回合数
			boutCount = battledata.MaxBoutCount,--回合数
			nextprompt = "下场开始倒计时", --下一场战斗提示
	        countdown = 10,--倒计时
	        dropout = {},--掉落
		};
		battledata.ResultData = ResultData;
		--发送挂机战斗结果消息
		dispatchGlobaleEvent("netMsg", "qiyu_result",{battledata})

		local reward = msg:ReadIntData()
		if reward == 1 then

			local type_ = msg:ReadIntData()
			local id = msg:ReadIntData()
			local lv = msg:ReadIntData()
			local num = msg:ReadIntData()
			printLog("网络日志","获得物品type:"..type_.." ID:"..id.." num:"..num)
			
			if fight ~= 1 then
				dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_GET_NOTICE), {data = {{ID = id, type_ = type_, num = num}}})
			else
				UIManager:QiyuSave({{ID = id, type_ = type_, num = num}})
			end
		end

		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_OPERATION_FUCHOU))
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

end
