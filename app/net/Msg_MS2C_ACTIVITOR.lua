--
-- Author: Wu Hengmin
-- Date: 2014-06-12 09:28:53
--

Msg_Logic[MSG_MS2C_CAMPAIGN_INFO] = function ( tcp , msg  )
	print("MSG_MS2C_CAMPAIGN_INFO")
end

-- 活动子关卡次数更新
Msg_Logic[MSG_MS2C_CAMPAIGN_SUB_INFO] = function ( tcp , msg  )
	print("MSG_MS2C_CAMPAIGN_SUB_INFO")
end

-- 错误信息
Msg_Logic[MSG_MS2C_CAMPAIGN_ERROR] = function ( tcp , msg  )
	local code = msg:ReadIntData()
	printLog("网络日志","错误码:"..code)
	print(getErrorDescribe( code ))
end

-- 世界boss信息
Msg_Logic[MSG_MS2C_CAMPAIGN_BOSS_INFO] = function ( tcp , msg  )
	printLog("网络日志","世界boss信息")
	local ID = msg:ReadIntData()
	printLog("网络日志","世界boss活动ID"..ID)
	if ID > 100 then
		tmp = MAIN_PLAYER.bossManager.data[ID%100]
	else
		printLog("网络日志","世界boss活动ID有误")
		return
	end

	local level = msg:ReadIntData()
	tmp.level = level
	printLog("网络日志","世界boss等级"..level)

	local hp = msg:ReadIntData()
	tmp.hp = hp
	printLog("网络日志","世界boss血量"..hp)

	local max = msg:ReadIntData()
	tmp.max = max
	printLog("网络日志","世界boss最大血量"..max)

	local atk = msg:ReadIntData()
	tmp.atk = atk
	printLog("网络日志","攻击力加成"..atk)

	local drum = msg:ReadIntData()
	tmp.isdrum = drum
	printLog("网络日志","是否已鼓舞"..drum)

	local damage = msg:ReadIntData()
	tmp.damage = damage
	printLog("网络日志","造成的伤害"..damage)

	local rank = msg:ReadIntData()
	tmp.rank = rank
	printLog("网络日志","当前排名"..rank)

	local colddown = msg:ReadIntData()

	tmp.colddown = math.ceil(colddown - os.time() - g_time)

	printLog("网络日志","进攻冷却时间"..tmp.colddown)
	if tmp.colddown <= 0 then
		tmp.colddown = -1
	else
		tmp.colddown = tmp.colddown + 1
	end
	printLog("网络日志","服务器冷却时间"..colddown)

	-- 0 攻打中   1 等待复活   2 等待开始
	tmp.state = msg:ReadIntData()
	printLog("网络日志","可进攻状态"..tmp.state)

	tmp.closetime = msg:ReadIntData()
	printLog("网络日志","可进攻状态时间"..tmp.closetime)

	tmp.atksign = msg:ReadIntData()
	printLog("网络日志","可进攻标志"..tmp.atksign)

	tmp.fuhuo1 = msg:ReadIntData()
	tmp.fuhuo2 = msg:ReadIntData()
	printLog("网络日志","复活批次"..tmp.fuhuo1.."/"..tmp.fuhuo2)


	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_CAMPAIGN_BOSS_INFO), {k = ID})
end


-- 世界boss排名
Msg_Logic[MSG_MS2C_CAMPAIGN_BOSS_RANK] = function ( tcp , msg  )
	print("MSG_MS2C_CAMPAIGN_BOSS_RANK")
end

-- 战斗返回结果
Msg_Logic[MSG_MS2C_CAMPAIGN_BOSS_BATTLE_RE] = function ( tcp , msg  )
	-- 1.战斗随机ID
	-- 2.胜负
	-- 3.伤害
	-- BattleManager.ResultData = {}
	local rd = msg:ReadIntData() -- 战斗随机ID

	local resault = msg:ReadIntData()
	printLog("网络日志","战斗结果:"..resault)
	local damage = msg:ReadIntData()
	printLog("网络日志","造成伤害:"..damage)
	-- BattleManager.ResultData.gold = 0;

	-- BattleManager.ResultData.exp = 0;

end
g_time = 0
times = {}
Msg_Logic[MSG_MS2C_LOGIN_TIME] = function ( tcp , msg  )
	local localtime = msg:ReadIntData()
	printLog("网络日志","本地时间戳:"..localtime)

	local servertime = msg:ReadIntData()
	printLog("网络日志","服务器时间戳:"..servertime)

	local tmptime = os.time()-localtime
	printLog("网络日志","来回耗时:"..tmptime)
	
	if tmptime>3 then
		if #times == 0 then
			table.insert(times, tmptime)
			TIME = os.time()
			printLog("网络日志","发送请求本地时间:"..TIME)
			gameTcp:SendMessage(MSG_C2MS_LOGIN_GET_TIME, {TIME})
			printLog("网络日志","1加入时间池,继续请求")
		elseif #times < 3 then
			for i=1,#times do
				if math.abs(times[i]-tmptime) > 1 then
					printLog("网络日志","误差过大,重新请求")
					times = {}
					table.insert(times, tmptime)
					TIME = os.time()
					printLog("网络日志","发送请求本地时间:"..TIME)
					gameTcp:SendMessage(MSG_C2MS_LOGIN_GET_TIME, {TIME})
					return
				end
			end
			table.insert(times, tmptime)
			printLog("网络日志","2加入时间池,继续请求")
			TIME = os.time()
			printLog("网络日志","发送请求本地时间:"..TIME)
			gameTcp:SendMessage(MSG_C2MS_LOGIN_GET_TIME, {TIME})
		else
			TIME = servertime + (times[1]+times[2]+times[3])/6
			printLog("网络日志","1确认时间戳"..TIME)
			UIManager.gameMain.center:showUI("活动")
			times = {}
			g_time = math.floor(TIME-os.time())
		end
	else
		TIME = servertime + (os.time()-localtime)/2
		printLog("网络日志","2确认时间戳"..TIME)
		-- UIManager.gameMain.center:showUI("活动")
		times = {}
		g_time = math.floor(TIME-os.time())
		-- if g_openactivitor then
		-- 	UIManager.gameMain.center:showUI("活动")
		-- 	g_openactivitor = false
		-- end
	end
	printLog("网络日志","服务器和本地时间差"..g_time)
end

--可操作提示
Msg_Logic[MSG_MS2C_GAME_HINT] = function ( tcp , msg  )
	print("MSG_MS2C_GAME_HINT")
end


-- 购买进攻冷却时间返回消息
Msg_Logic[MSG_MS2C_CAMPAIGN_BOSS_BUY_RE] = function ( tcp , msg  )
	print("MSG_MS2C_CAMPAIGN_BOSS_BUY_RE")
end
