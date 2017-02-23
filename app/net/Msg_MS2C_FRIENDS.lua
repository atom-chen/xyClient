--
-- Author: li yang
-- Date: 2014-04-11 09:07:31
-- 好友消息片

--------------------------好友数据------------------------------

--[[ 发送申请数据
*
*	int				好友数量
*	{
*		int			1=全部信息 0=只有ID和名字
*		string		好友GUID
*		string		好友名字
*		(
*			存在由标识确定
*			string	好友签名
*			int		好友等级
*			int 	上次登录时间
*			int		好友队长模版
*			int		好友队长等级
*			int		好友队长生命
*			int		好友队长攻击
*		)
*	}
*
]]
Msg_Logic[MSG_MS2C_FRIENDS_DATA] = function ( tcp, msg )
	--好友数量
	local amount = msg:ReadIntData()
	printLog("网络日志", "接收到好友数据-->数量："..amount)
	MAIN_PLAYER.friendsManager.FriendsNum = amount
	MAIN_PLAYER.friendsManager:ClearFriendsPool()
	--在线好友数量
	MAIN_PLAYER.friendsManager.OnlineNum = 0;
	for i=1,amount do
		local friendsData = require("app.models.player.friends").new()
		--在线和离线标示
		friendsData.mark_online = msg:ReadIntData()
		printLog("网络日志","在线标记:"..friendsData.mark_online)
		friendsData.GUID = msg:ReadString() -- 好友GUID
		friendsData.Name = msg:ReadString() -- 好友名称
		if friendsData.mark_online == 1 then
			MAIN_PLAYER.friendsManager.OnlineNum = MAIN_PLAYER.friendsManager.OnlineNum + 1
			-- friendsData.signature = msg:ReadString()-- 签名
			friendsData.grade = msg:ReadIntData()-- 等级
			friendsData.vipgrade = msg:ReadIntData()-- vip等级
			-- friendsData.loginTime = msg:ReadIntData()--上次登录时间
			friendsData.strength = msg:ReadIntData()-- 战力值
			local params = {}
			params.ID = msg:ReadIntData()-- 队长模板
			-- params.LV = msg:ReadIntData()-- 队长等级
			-- params.baseHP = msg:ReadIntData()-- 队长附加HP
			-- params.baseAtt = msg:ReadIntData()-- 队长附加攻击
			-- local gift = msg:ReadIntData()-- 是否有礼物
			printLog("队长信息：","模板ID:"..params.ID)
			friendsData.mark_Stamina_get = 1;
			-- if gift == 1 then
			-- 	friendsData.mark_Stamina_get = 1;
			-- end
			friendsData.captainhero = MAIN_PLAYER.heroManager:CreateHero( params );
		end
		printLog("网络日志", "         好友："..i..",在线标示："..friendsData.mark_online..",GUID:"..friendsData.GUID..",Name:"..friendsData.Name
			..",signature:"..friendsData.signature..",grade"..friendsData.grade.."，上次登录时间："..friendsData.loginTime)
		--添加进入好友列表
		MAIN_PLAYER.friendsManager:addFriends( friendsData );
	end

	--已接收礼物数量
	local count = msg:ReadIntData();
	MAIN_PLAYER.friendsManager.ReceiveNum = count;
	

	-- MAIN_PLAYER.friendsManager.getVigorTime = VipConfig[1].get_friend_gift - count;
	printLog("网络日志", "接收到已经接受赠送体力-->数量："..count)
	for i=1,count do
		local guid = msg:ReadString();
		printLog("网络日志", "       接受-->GUID："..guid)
		-- 0没有 2 已接收

		MAIN_PLAYER.friendsManager:UpDataMark_Stamina_Receive( guid , 2)
	end
end

--好友验证数据
Msg_Logic[MSG_MS2C_APPLICANT_DATA] = function ( tcp, msg )
	--好友数量
	local amount = msg:ReadIntData()
	printLog("网络日志", "接收到好友验证数据-->数量："..amount)
	--清空好友验证池
	MAIN_PLAYER.friendsManager:ClearFriendsVerifyPool( );
	MAIN_PLAYER.friendsManager.FriendsVerifyNum = amount;
	--更新验证好友数量
	if Uniquify_Friends then
		Uniquify_Friends.friendsTop:UpDataButtonLabelShow();
	end
	for i=1,amount do
		local friendsData = require("app.models.player.friends").new()
		--在线和离线标示
		friendsData.mark_online = msg:ReadIntData()
		friendsData.GUID = msg:ReadString();-- 好友GUID
		friendsData.Name = msg:ReadString(); -- 好友名称
		if friendsData.mark_online == 1 then
			-- friendsData.signature = msg:ReadString();-- 签名
			friendsData.grade = msg:ReadIntData();-- 等级
			friendsData.vipgrade = msg:ReadIntData()-- vip等级

			local params = {};
			-- friendsData.lastLoginTime = msg:ReadIntData();-- 上次登录时间
			friendsData.strength = msg:ReadIntData();--战力值
			params.ID = msg:ReadIntData();-- 队长模板
			-- params.LV = msg:ReadIntData();-- 队长等级
			-- params.baseHP = msg:ReadIntData();-- 队长附加HP
			-- params.baseAtt = msg:ReadIntData();-- 队长附加攻击
			
			friendsData.captainhero = MAIN_PLAYER.heroManager:CreateHero( params );
		end
		printLog("网络日志", "         好友："..i..",在线标示："..friendsData.mark_online..",GUID:"..friendsData.GUID..",Name:"..friendsData.Name
			..",signature:"..friendsData.signature..",grade"..friendsData.grade.."，队长：")
		--添加进入等待验证好友列表
		MAIN_PLAYER.friendsManager:addVerifyFriends( friendsData );
	end
	dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_APPLICANT_DATA))
end

-- 申请好友结果
Msg_Logic[MSG_MS2C_FRIEND_APPLY_RESULT] = function ( tcp, msg )
	local result = msg:ReadIntData();
	printLog("网络日志", "申请好友结果："..result)
	--推荐好友特殊处理
	if RecommendSend_Mark == 1 then
		
		return;
	end
	if result == eFI_Success then
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = "已飞鸽传书，等待对方回复"})
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end
end

-- 同意添加结果
Msg_Logic[MSG_MS2C_FRIEND_AGREE_RESULT] = function ( tcp, msg )
	local result = msg:ReadIntData();
	local handleType = msg:ReadIntData();
	printLog("网络日志", "同意添加好友结果："..result..",处理方式:"..handleType)
	if result == eFI_Success and handleType == 1 then
		local friendsData = require("app.models.player.friends").new()
		friendsData.GUID = msg:ReadString();-- 好友GUID
		friendsData.Name = msg:ReadString(); -- 好友名称
		-- friendsData.signature = msg:ReadString();-- 签名
		friendsData.grade = msg:ReadIntData();-- 等级
		friendsData.vipgrade = msg:ReadIntData()-- vip等级
		friendsData.mark_online = 1;
		-- friendsData.lastLoginTime = msg:ReadIntData();-- 上次登录时间
		friendsData.strength = msg:ReadIntData();--战力值

		printLog("网络日志", ",在线标示："..friendsData.mark_online..",GUID:"..friendsData.GUID..",Name:"..friendsData.Name
			..",signature:"..friendsData.signature..",grade"..friendsData.grade.."，队长：")

		local params = {};
		params.ID = msg:ReadIntData();-- 队长模板
		-- params.LV = msg:ReadIntData();-- 队长等级
		-- params.baseHP = msg:ReadIntData();-- 队长附加HP
		-- params.baseAtt = msg:ReadIntData();-- 队长附加攻击

		printLog("队长数据:",params.ID,friendsData.lastLoginTime,params.LV,params.baseHP,params.baseAtt)
			
		friendsData.captainhero = MAIN_PLAYER.heroManager:CreateHero( params );

		MAIN_PLAYER.friendsManager.FriendsNum = MAIN_PLAYER.friendsManager.FriendsNum + 1;
		--添加进好友
		MAIN_PLAYER.friendsManager:addFriends( friendsData );
		--重置好友接收体力赠送标示
		MAIN_PLAYER.friendsManager:resetStamina_Receive_Mark( friendsData.GUID );
		--resetStaminaSendMark( friendsData.GUID );
		-- 更新
		MAIN_PLAYER.friendsManager.IsFriendsUpData = true;
		-- if Uniquify_Friends then
		-- 	Uniquify_Friends.IsFriendsUpData = true;
		-- end

		printLog("删除验证好友GUID：",friendsData.GUID)
		MAIN_PLAYER.friendsManager:RemoveVerifyFriends( friendsData.GUID )
		MAIN_PLAYER.friendsManager.FriendsVerifyNum = MAIN_PLAYER.friendsManager.FriendsVerifyNum - 1;
		-- if Uniquify_Friends then
		-- 	--重置更新标示
		-- 	Uniquify_Friends.IsFriendsVerifyUpData = true;
		-- 	Uniquify_Friends.friendsTop:UpDataButtonLabelShow();
		-- 	--更新界面
		-- 	Uniquify_Friends:ClickFriendsSort( {
		-- 		selected = 2,
		-- 		unselected = 0
		-- 		} )
		-- 	--更新验证好友数量
		-- 	Uniquify_Friends.friendsTop:UpDataButtonLabelShow();
		-- end
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_FRIEND_AGREE_RESULT))
		return;
	end
	if result == eFI_Success and handleType == 0 then
		local guid = msg:ReadString();-- 删除好友的GUID
		printLog("删除好友GUID：",guid)
		MAIN_PLAYER.friendsManager:RemoveVerifyFriends( guid )
		MAIN_PLAYER.friendsManager.FriendsVerifyNum = MAIN_PLAYER.friendsManager.FriendsVerifyNum - 1;
		-- if Uniquify_Friends then
		-- 	--重置更新标示
		-- 	Uniquify_Friends.IsFriendsVerifyUpData = true;
		-- 	Uniquify_Friends.friendsTop:UpDataButtonLabelShow();
		-- 	--更新界面
		-- 	Uniquify_Friends:ClickFriendsSort( {
		-- 		selected = 2,
		-- 		unselected = 0
		-- 		} )
		-- end
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_FRIEND_AGREE_RESULT))
		return;
	end
	print(getErrorDescribe( result ))
	-- UIManager:CreatePrompt_1( display.getRunningScene() , getErrorDescribe( result ))
end

-- 赠送体力结果
-- Msg_Logic[MSG_MS2C_FRIEND_SEND_GIFT_RESULT] = function ( tcp, msg )

-- end

-- 领取体力结果
Msg_Logic[MSG_MS2C_FRIEND_TAKE_GIFT_RESULT] = function ( tcp, msg )
	
end

-- 一键领取结果
Msg_Logic[MSG_MS2C_FRIEND_TAKE_ALL_RESULT] = function ( tcp, msg )
	
end


-- 删除好友
Msg_Logic[MSG_MS2C_FRIEND_DEL_RESULT] = function ( tcp, msg )
	local result = msg:ReadIntData();
	printLog("网络日志", "删除好友结果："..result)
	if result == eFI_Success then
		local guid = msg:ReadString();-- 删除好友的GUID
		MAIN_PLAYER.friendsManager:RemoveFriends( guid )
		MAIN_PLAYER.friendsManager.FriendsNum = MAIN_PLAYER.friendsManager.FriendsNum - 1;
		
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_FRIEND_DEL_RESULT))

		UIManager:CreatePrompt_Bar( {content = "删除好友成功~"})
	else
		--删除好友失败
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end
end

--助阵列表 
Msg_Logic[MSG_MS2C_ASSIST_LIST] = function ( tcp, msg )
	local count = msg:ReadIntData();
	printInfo("网络日志 %s", "收到助阵列表："..count)
	MAIN_PLAYER.helperManager:ClearHelperPool( );
	for i=1,count do
		local helperData = require("app.models.player.model_helper").new();
		-- helperData.helperType = msg:ReadIntData();--类型
		helperData.GUID = msg:ReadString();
		helperData.Name = msg:ReadString();
		helperData.Grade = msg:ReadIntData();
		helperData.strength = msg:ReadIntData();

		--判断是否是好友
		if MAIN_PLAYER.friendsManager:checkFriendsByGUID( helperData.GUID ) then
			helperData.helperType = 1;
		else
			helperData.helperType = 0;
		end
		-- print("推荐玩家类型：",helperData.helperType,helperData.GUID,user.player.friendsManager:checkFriendsByGUID( helperData.GUID ))

		--创建英雄
		local heroTemple = msg:ReadIntData();--英雄模板
		local heroGrade = msg:ReadIntData();--英雄等级
		local base_HP = msg:ReadIntData();--英雄增加HP
		local base_Att = msg:ReadIntData();--英雄增加attack
		local hero = MAIN_PLAYER.heroManager:CreateHero( {
				ID = heroTemple,--英雄模板ID
				LV = heroGrade,--等级
				baseHP =  base_HP,
				baseAtt =  base_Att,
			} );
		-- print("援助者数据:",i,helperData.GUID,helperData.Name,helperData.Grade,heroTemple,heroGrade,base_HP,base_Att);
		helperData.captainhero = hero;
		MAIN_PLAYER.helperManager:addHelper( helperData );
		MAIN_PLAYER.helperManager:addHelperRecord( helperData );
	end
	--进入助阵界面
end

--更新助战列表
Msg_Logic[MSG_MS2C_ASSIST_UPDATE] = function ( tcp, msg )
	printInfo("网络日志 %s", "更新助阵列表：MSG_MS2C_ASSIST_UPDATE"..MAIN_PLAYER.helperManager:getHelperCount(  ))
	if MAIN_PLAYER.helperManager:getHelperCount(  ) < 4 then
		--重新请求助阵列表
		printInfo("数据更新日志 %s","	助阵列表数据更新:MSG_C2MS_ASSIST_LIST ")
		gameTcp:SendMessage(MSG_C2MS_ASSIST_LIST );
		return;
	end
	local helperData = require("app.models.player.model_helper").new();
	helperData.GUID = msg:ReadString();
	helperData.Name = msg:ReadString();
	helperData.Grade = msg:ReadIntData();
	helperData.strength = msg:ReadIntData();
	--判断是否是好友
	if MAIN_PLAYER.friendsManager:checkFriendsByGUID( helperData.GUID ) then
		helperData.helperType = 1;
	else
		helperData.helperType = 0;
	end
	--创建英雄
	local heroTemple = msg:ReadIntData();--英雄模板
	local heroGrade = msg:ReadIntData();--英雄等级
	local heroHP = msg:ReadIntData();--英雄增加HP
	local heroAttack = msg:ReadIntData();--英雄增加attack
	local hero = MAIN_PLAYER.heroManager:CreateHero( {
			ID = heroTemple,--英雄模板ID
			LV = heroGrade,--等级
			baseHP =  heroHP,
			baseAtt =  heroAttack,
	} );
	-- print("援助者数据:",helperData.GUID,helperData.Name,helperData.helperType,heroTemple,heroGrade,heroHP,heroAttack);
	helperData.captainhero = hero;
	MAIN_PLAYER.helperManager:addHelper( helperData );
	MAIN_PLAYER.helperManager:addHelperRecord( helperData );
end



--好友阵型信息 
Msg_Logic[MSG_MS2C_FRIEND_TEAM_INFO_RESULT] = function ( tcp, msg )
	printLog("网络日志", "好友阵型信息：MSG_MS2C_FRIEND_TEAM_INFO_RESULT")
	
	local result = msg:ReadIntData();--结果枚举值
	local guid = msg:ReadString();--目标GUID
	local formationID = msg:ReadIntData();--阵型
	local count = msg:ReadIntData();--人数
	printLog("网络日志", "结果:"..result.." guid:"..guid.." 阵型"..formationID.." 人数"..count)
	--构建团队数据
	local textTeamData = {}
	textTeamData.members = {}
	textTeamData.membersBattlePos = {}
	textTeamData.FormationID = formationID;
	for i=1,count do
		local TeamPos = msg:ReadIntData();--队伍位置
		local formationPos = msg:ReadIntData();--阵型位置
		local templeID = msg:ReadIntData();--模板ID
		textTeamData.members[TeamPos] = templeID;
		textTeamData.membersBattlePos[formationPos] = TeamPos;
	end
	--得到好友数据
	local friendsData = MAIN_PLAYER.friendsManager:getFriendsPoolByGuid( guid );
	textTeamData.powerValue = friendsData.strength;
	friendsData.teamData = textTeamData;
	--friendsData.Name.."【"..friendsData.AborNnionName.."】"
	local showName = friendsData.Name;
	--显示团队信息
	--显示团队信息
	-- UIManager:CreateFormationInfoView(textTeamData ,showName ,function ( ... )
	-- 	--返回好友界面
	-- 	UIManager.gameMain.center:Back_showUI("好友");
	-- end);
	-- Uniquify_Friends:ShowFriendsEmbattle( textTeamData ,showName);
	-- TounchContrlScheduler(0);
	-- UIManager:CreateFormationInfoView(display.getRunningScene() ,textTeamData,showName);

end