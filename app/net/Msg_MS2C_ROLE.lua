--
-- Author: Li Yang
-- Date: 2014-01-15 15:37:55
-- 角色数据 消息片

-- 服务器回应角色登陆数据
Msg_Logic[MSG_MS2C_ROLE_DATA] = function ( tcp , msg )
	
end


-- 服务器回应角色登陆数据
Msg_Logic[MSG_MS2C_ROLE_DATA_LOGIN] = function ( tcp , msg )
	--关闭登陆超时验证
	tcp:CloseMsgTimeOutCheck( );
	-- guid
	local playerGUID = msg:ReadString()
	MAIN_PLAYER:getBaseAttr():setGUID(playerGUID)

	local playerName = msg:ReadString()
	MAIN_PLAYER:getBaseAttr():setName(playerName)

	local Check_Name = playerName;--初始化监测
	local Check_Role = msg:ReadIntData();
	-- 数字id
	MAIN_PLAYER._numID = msg:ReadIntData();
	-- 银两
	MAIN_PLAYER.baseAttr._gold = msg:ReadIntData();
	-- 元宝
	MAIN_PLAYER.baseAttr._yuanBao = msg:ReadIntData();
	printLog("网络日志", "当前元宝数量:"..MAIN_PLAYER.baseAttr._yuanBao)
	-- 等级
	MAIN_PLAYER.baseAttr._lv = msg:ReadIntData();
	-- 经验
	local exp = msg:ReadIntData()
	MAIN_PLAYER:getBaseAttr():setExp(exp)

	--公会GUID
	local guildGUID = msg:ReadString()
	MAIN_PLAYER:getGuild():setGUID(guildGUID)
	
	--在公会中的官职
	local guildPost = msg:ReadIntData()
	MAIN_PLAYER:getGuild():setPost(guildPost)

	--string	个性签名
	MAIN_PLAYER._signature = msg:ReadString(); -- 签名
	--将魂
	MAIN_PLAYER.baseAttr._jianghun = msg:ReadIntData()

	local quickFightTime = msg:ReadIntData()--快速战斗次数
	local quickFightBuyTime = msg:ReadIntData()--快速战斗购买次数

	local BossFightTime = msg:ReadIntData()--boss战斗次数
	local BossFightBuyTime = msg:ReadIntData()--boss战斗购买次数

	local JJCFightTime = msg:ReadIntData()--jjc战斗次数
	local JJCFightBuyTime = msg:ReadIntData()--jjc战斗购买次数

	MAIN_PLAYER.baseAttr._AtkTime = msg:ReadIntData()--攻城次数
	MAIN_PLAYER.baseAttr._AtkTimeBuy = msg:ReadIntData()--购买攻城次数
	printLog("网络日志", "攻城次数"..MAIN_PLAYER.baseAttr._AtkTime.." 购买攻城次数"..MAIN_PLAYER.baseAttr._AtkTimeBuy)

	Data_Battle_Onhook.BossChallengeTime = BossFightTime;
	Data_Battle_Onhook.QuickFightTime = quickFightTime;
	-- Data_Battle_Onhook._lastChangeTime = MAIN_PLAYER._lastChangeEnergyTime;

	print(quickFightTime,quickFightBuyTime,BossFightTime,BossFightBuyTime,JJCFightTime,JJCFightBuyTime)

	MAIN_PLAYER.baseAttr._ronglianzhi = msg:ReadIntData() -- 改成熔炼值

	MAIN_PLAYER.baseAttr._TitleExp = msg:ReadIntData()
	
	MAIN_PLAYER.baseAttr._Title = msg:ReadIntData()

	MAIN_PLAYER.baseAttr._TitleExp_today = msg:ReadIntData()

	printLog("消息日志", "爵位等级:"..MAIN_PLAYER.baseAttr._Title.." 爵位经验:"..MAIN_PLAYER.baseAttr._TitleExp.." 今日获取爵位经验:"..MAIN_PLAYER.baseAttr._TitleExp_today)
	
	--int		好友上限
	MAIN_PLAYER.FriendsCaps = msg:ReadIntData() ; -- 好友上限
	print("好友上限:"..MAIN_PLAYER.FriendsCaps)

	MAIN_PLAYER.equCaps = msg:ReadIntData()
	print("装备上限:"..MAIN_PLAYER.equCaps)

	MAIN_PLAYER._shiqi = msg:ReadIntData()
	-- printLog("网络日志","更新士气,当前士气:"..user.player.shiqi)

	local curDKP = msg:ReadIntData()
	-- user.player.guild:setCurDKP(curDKP)
	-- printLog("网络日志","更新当前DKP, 当前DKP:"..curDKP)

	--local payResIdx = msg:ReadIntData()
	-- user.player.guild:setPayResIdx(payResIdx)
	-- printLog("网络日志","更新当前公会提交资源索引, 索引值:"..payResIdx)

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
	
	--新手引导值
	local newstteppos = msg:ReadIntData();
	-- NewbieGuideManager.EexecuteStepPos = msg:ReadIntData();
	-- NewbieGuideManager:CheckEexecuteStepPos(  );--检查新手引导
	-- print("新手引导值:"..NewbieGuideManager.EexecuteStepPos);

	-- printLog("网络日志","基础体力1:"..player.basePower.." 体力改变时间:"..player.lastChangePowerTime..",新手引导值："..NewbieGuideManager.EexecuteStepPos)
	-- printLog("网络日志","基础精力1:"..player.baseEnergy.." 精力改变时间:"..player.lastChangeEnergyTime)


	-- printLog("网络日志","收到角色基本数据，RoleGUID："..player.guid..",RoleName="..
	-- 	player.name..",RoleID="..player.numID..",RoleGold="..player.glod..",RoleShoe="..player.yuanBao
	-- 	..",RoleGrade="..player.lv..",RoleExp="..player.exp..",  guildGUID"..guildGUID..",  guildPost"..guildPost
	-- 	..", jiangHun="..player.jiangHun)

	-- 保存账号数据
	Data_Login:saveToLocal();
	-- 进入初始英雄选择界面（前期数据接收完后）
	print("监测.......................",Check_Role,Check_Name )
	-- print("监测.......................", InitializeCheck_Name)

	if Check_Role == 0 or  Check_Name == nil or string.len(Check_Name) < 1 then
		--进入初始化英雄数据界面
		-- SceneManager:ToScene(SceneManager.IDs.initHeroScene)
		--开启点击事件
		-- GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(-1,GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER);

		-- if NewbieGuideManager.IsFinish then
		-- 	SceneManager:ToScene(SceneManager.IDs.initHeroScene)
		-- else
		-- 	--执行开场剧情
		-- 	NewbieGuideManager:CreateNewbieGuide( "openStory" ,1);
		-- end
		
		APP:toScene(SCENE_ID_SELECT_HERO) 
		--前期直接创建角色
		--随机名字
    	-- gameTcp:SendMessage(MSG_C2MS_ROLE_GET_RANDOM_NAME, {10})
		
	else
		-- 判定是否是重连开启状态
		-- if UIManager.ResetGameData.ConnectRun then
		-- 	UIManager.ResetGameData:CloseNetworkListen(  );
		-- 	tcp:SendMessage(MSG_C2MS_GET_BACKPACK);
		-- elseif UIManager.ResumeConnect.ConnectRun then
		-- 	--关闭重新链接界面
		-- 	UIManager.ResumeConnect:ResultShow( UIManager.ResumeConnect.CONNECT_SUCCEED );
		-- else
		-- 	--进入加载界面
		-- 	-- NewbieGuideManager.EexecuteStepPos = 999;
		-- 	NewbieGuideManager:CheckEexecuteStepPos(  );--检查新手引导
		-- 	SceneManager:ToScene(SceneManager.IDs.loadScene);
		-- 	tcp:SendMessage(MSG_C2MS_GET_BACKPACK)
		-- end
		if Data_Login.ResumeConnect then
			--关闭重连界面
			dispatchGlobaleEvent( "resumeconnect", "succes" )
		else
			--进入加载界面
			APP:toScene(SCENE_ID_GAMEWORLD_RES_LOADING);
			
		end
		
		
	end
	-- UC数据收集
	-- if user.login_type == 7 then
	-- 	ucSdkSubmitExtendData()
	-- end
end



Msg_Logic[MSG_MS2C_ROLE_UPDATA_GOLD] = function ( tcp , msg )
	printLog("网络消息", "更新玩家银两(MSG_MS2C_ROLE_UPDATA_GOLD)")
	local msgData = {}
	msgData.gold = msg:ReadIntData()
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_GOLD), {msgData=msgData})
end

Msg_Logic[MSG_MS2C_ROLE_UPDATA_YUANBAO] = function ( tcp , msg )
	printLog("网络日志","--------MSG_MS2C_ROLE_UPDATA_YUANBAO(更新元宝)消息")
	local yuanBao = msg:ReadIntData()
	printLog("网络日志", "当前元宝数量:"..yuanBao)
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_YUANBAO), {msgData=yuanBao})
end

-- 修改签名消息
Msg_Logic[MSG_MS2C_EDIT_SIGNATURE_RESULT] = function ( tcp , msg )
	
end

-- 更新玩家公会ID
Msg_Logic[MSG_MS2C_ROLE_UPDATA_GUILDID] = function ( tcp , msg )
	printNetLog("更新玩家公会ID (MSG_MS2C_ROLE_UPDATA_GUILDID)")
	local msgData = {}
	msgData.guid = msg:ReadString()
	MAIN_PLAYER:getGuild():setGUID(msgData.guid)
	printNetLog(serialize(msgData))
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_ROLE_UPDATA_GUILDID), {msgData=msgData})
end

-- 更新玩家公会官职
Msg_Logic[MSG_MS2C_ROLE_UPDATA_GUILDPOSITION] = function ( tcp , msg )
	printNetLog("更新公会官职(MSG_MS2C_ROLE_UPDATA_GUILDPOSITION)")
	local post = msg:ReadIntData()
	MAIN_PLAYER:getGuild():setPost(post)
end

-- 更新角色等级
Msg_Logic[MSG_MS2C_ROLE_UPDATA_LEVEL] = function ( tcp , msg )
	printLog("网络日志","更新角色等级")
	local level = msg:ReadIntData()
	printLog("网络日志","当前等级:"..level)
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_LEVEL), {msgData=level})
end

-- 更新角色经验
Msg_Logic[MSG_MS2C_ROLE_UPDATA_EXP] = function ( tcp , msg )
	printLog("网络日志","更新角色经验")
	local exp = msg:ReadIntData()
	printLog("网络日志","角色经验:"..exp)
	MAIN_PLAYER:getBaseAttr():setExp(exp)
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_EXP), {msgData=exp})
end


-- 角色将魂更新消息
Msg_Logic[MSG_MS2C_ROLE_UPDATA_HERO_SOUL] = function ( tcp , msg )
	printLog("网络日志","更新角色将魂消息")
	local jianghun = msg:ReadIntData()
	printLog("网络日志","当前将魂:"..jianghun)
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_HERO_SOUL), {msgData=jianghun})
end

-- 角色经验池更新消息
-- Msg_Logic[MSG_MS2C_ROLE_UPDATA_HERO_EXP] = function ( tcp , msg )
-- 	printLog("网络日志","更新角色经验池消息")
-- 	local jingyanchi = msg:ReadIntData()
-- 	printLog("网络日志","当前经验池:"..jingyanchi)
-- 	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_HERO_EXP), {msgData=jingyanchi})
-- end

-- 更新boss挑战次数
Msg_Logic[MSG_MS2C_ROLE_UPDATA_BOSS] = function ( tcp , msg )
	Data_Battle_Onhook.BossChallengeTime = msg:ReadIntData();
	local buyTime =  msg:ReadIntData();
	printLog("网络日志 收到更新boss挑战次数消息 MSG_MS2C_ROLE_UPDATA_BOSS","挑战boss次数:"..Data_Battle_Onhook.BossChallengeTime..",购买次数:"..buyTime);
	-- dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_VIGOUR))
end

-- 更新快速战斗次数
Msg_Logic[MSG_MS2C_ROLE_UPDATA_QUICK] = function ( tcp , msg )
	Data_Battle_Onhook.QuickFightTime = msg:ReadIntData();
	local buyTime =  msg:ReadIntData();
	printLog("网络日志 收到更新快速次数消息 MSG_MS2C_ROLE_UPDATA_QUICK","快速战斗次数:"..Data_Battle_Onhook.QuickFightTime..",购买次数:"..buyTime);
	-- dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_VIGOUR))
end

-- 更新竞技场挑战次数
Msg_Logic[MSG_MS2C_ROLE_UPDATA_ARENA] = function ( tcp , msg )
	local jjcTime = msg:ReadIntData();
	local buyTime =  msg:ReadIntData();
	printLog("网络日志 收到更新快速次数消息 MSG_MS2C_ROLE_UPDATA_ARENA","JJC挑战次数:"..jjcTime..",购买次数:"..buyTime);
	-- dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_VIGOUR))
end

-- 更新士气
Msg_Logic[MSG_MS2C_ROLE_UPDATA_SHIQI] = function ( tcp , msg )
	
end

-- 更新当前DKP
Msg_Logic[MSG_MS2C_ROLE_UPDATA_GONGXUN] = function ( tcp , msg )
	
end

-- 更新玩家当前战力
Msg_Logic[MSG_MS2C_UPDATE_TEAM_CP] = function ( tcp , msg )
	printLog("网络日志","更新玩家当前战力(MSG_MS2C_UPDATE_TEAM_CP):")
	local msgData = {}
	msgData.teamList = {}

	local powerValueList = msgData.teamList.powerValueList
	local memberList = msgData.teamList.memberList
	local teamManager = MAIN_PLAYER:getTeamManager()

	for i=1, MaxPlayerTeamNum do
		msgData.teamList = {}
		msgData.teamList[i] = {}
		local team = msgData.teamList[i]
		team.powerValue = msg:ReadIntData()
		printLog("网络日志", 
			"队伍%d战斗力:%d", 
			i,
			team.powerValue
		)

		local localData_team = teamManager:getTeam(i)
		localData_team:setPowerValue(
			team.powerValue
		)

		team.memberNum = msg:ReadIntData()
		printLog("网络日志", "成员数量: "..team.memberNum)

		team.memberList = {}
		local memberList = team.memberList

		local localData_battleHeroManager = localData_team:getBattleHeroManager()
		
		for i=1, team.memberNum do
			memberList[i] = {}
			local member = memberList[i]
			member.posInTeam = msg:ReadIntData() + 1
			member.hp = msg:ReadFloat()
			member.atk = msg:ReadFloat()
			member.pdef = msg:ReadFloat()
			member.mdef = msg:ReadFloat()
			member.miss = msg:ReadFloat()
			member.hit = msg:ReadFloat()
			member.crit = msg:ReadFloat()
			member.crit_damage = msg:ReadFloat()
			member.tenacity = msg:ReadFloat()
			member.skillLv = msg:ReadFloat()

			member.delta_hp = msg:ReadFloat()
			member.delta_atk = msg:ReadFloat()
			member.delta_pdef = msg:ReadFloat()
			member.delta_mdef = msg:ReadFloat()
			member.delta_miss = msg:ReadFloat()
			member.delta_hit = msg:ReadFloat()
			member.delta_crit = msg:ReadFloat()
			member.delta_crit_damage = msg:ReadFloat()
			member.delta_tenacity = msg:ReadFloat()
			member.delta_skill_lv = msg:ReadFloat()

			member.power = msg:ReadIntData()

			printLog("网络日志", 
				"位置: "..member.posInTeam..
				" HP: "..member.hp..
				" 攻击: "..member.atk..
				" 物防: "..member.pdef..
				" 法防: "..member.mdef..
				" 闪避: "..member.miss..
				" 命中: "..member.hit..
				" 暴击: "..member.crit..
				" 爆伤: "..member.crit_damage..
				" 韧性: "..member.tenacity..
				" 技能强度: "..member.skillLv..
				" 附加HP: "..member.delta_hp..
				" 附加攻击: "..member.delta_atk..
				" 附加物防: "..member.delta_pdef..
				" 附加法防: "..member.delta_mdef..
				" 附加命中: "..member.delta_hit..
				" 附加暴击: "..member.delta_crit..
				" 附加爆伤: "..member.delta_crit_damage..
				" 附加韧性: "..member.delta_tenacity..
				" 附加技能强度: "..member.delta_skill_lv..
				" 武将战斗力: "..member.power
			)

			local localData_pos = localData_battleHeroManager:getPos(member.posInTeam)
			local heroAttr = clone(member)
			localData_pos:setHeroAttrWithoutGUID(heroAttr)
		end
	end
end


-- 更新仓库上限
Msg_Logic[MSG_MS2C_ROLE_UPDATA_DEPOTLIMIT] = function ( tcp , msg )

end

--[[ 更新爵位经验、爵位等级
*
*	int		爵位经验
*	int		爵位等级
*
]]
Msg_Logic[MSG_MS2C_ROLE_UPDATA_PEERAGE_INFO] = function ( tcp , msg )
	printLog("消息日志", "更新爵位经验")
	MAIN_PLAYER.baseAttr._TitleExp = msg:ReadIntData()
	MAIN_PLAYER.baseAttr._Title = msg:ReadIntData()
	MAIN_PLAYER.baseAttr._TitleExp_today = msg:ReadIntData()
	printLog("消息日志", "爵位等级:"..MAIN_PLAYER.baseAttr._Title.." 爵位经验:"..MAIN_PLAYER.baseAttr._TitleExp.." 今日获取爵位经验:"..MAIN_PLAYER.baseAttr._TitleExp_today)
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_PEERAGE_INFO))
end

--[[ 发送熔炼值更新消息
*
*	int		熔炼值
*
]]
Msg_Logic[MSG_MS2C_ROLE_UPDATA_SMELT_VALUE] = function ( tcp , msg )
	printLog("消息日志", "更新熔炼值")
	MAIN_PLAYER.baseAttr._ronglianzhi = msg:ReadIntData()
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_ROLE_UPDATA_SMELT_VALUE))
end

--[[ 进攻次数更新
*
*	int			进攻次数
*	int			已购买次数
*
]]
Msg_Logic[MSG_MS2C_ROLE_UPDATE_MAPWAR_NUM] = function ( tcp , msg )
	printLog("消息日志", "进攻次数更新(MSG_MS2C_ROLE_UPDATE_MAPWAR_NUM)")
	MAIN_PLAYER.baseAttr._AtkTime = msg:ReadIntData()--攻城次数
	MAIN_PLAYER.baseAttr._AtkTimeBuy = msg:ReadIntData()--购买攻城次数
	printLog("网络日志", "攻城次数"..MAIN_PLAYER.baseAttr._AtkTime.." 购买攻城次数"..MAIN_PLAYER.baseAttr._AtkTimeBuy)
	dispatchGlobaleEvent("net", tostring(MSG_MS2C_ROLE_UPDATE_MAPWAR_NUM))
end


