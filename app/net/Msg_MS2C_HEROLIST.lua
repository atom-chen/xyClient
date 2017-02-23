--
-- Author: Wu Hengmin
-- Date: 2014-03-31 09:54:20
--


Msg_Logic[MSG_MS2C_BACKPACK] = function ( tcp , msg  )
	MAIN_PLAYER.heroManager.heros = {}
	local count = msg:ReadIntData()
	printLog("网络日志", "收到英雄列表消息,数量:"..count)
	for i = 1, count do
		local params = {}
		params.GUID = msg:ReadString()
		params.id = msg:ReadIntData()
		params.time = msg:ReadIntData()
		params.isLocked = msg:ReadIntData()
		-- params.EXP = msg:ReadIntData()
		-- params.LV = msg:ReadIntData()
		params.skillLv = msg:ReadIntData()
		-- 职业强度****这个是新加的
		params.occupatpower = msg:ReadIntData()
		
		-- 添加英雄
		MAIN_PLAYER.heroManager:add( params )
		printLog("网络日志:".."--------英雄数据，HeroGUID:"..params.GUID..",HeroID="..params.id
			..",params.skillLv="..params.skillLv..",params.occupatpower="..params.occupatpower)
	end

end

Msg_Logic[MSG_MS2C_DEL_HERO] = function ( tcp , msg  )
	local result = msg:ReadIntData()
	printLog("网络日志","删除英雄消息,数量:"..result)
	for i=1,result do
		local guid = msg:ReadString()
		printLog("网络日志","删除英雄消息,GUID:"..guid)
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_DEL_HERO), {guid=guid})
	end
	
	-- 如果在碎化界面,发送广播更新列表
end

Msg_Logic[MSG_MS2C_ADD_HERO] = function ( tcp , msg  )
	printLog("网络日志","收到添加英雄消息")
	local count = msg:ReadIntData()
	printLog("网络日志","添加英雄数量:"..count)
	for i=1,count do
		local params = {}
		params.GUID = msg:ReadString()
		params.id = msg:ReadIntData()
		params.time = msg:ReadIntData()
		params.isLocked = msg:ReadIntData()
		-- params.EXP = msg:ReadIntData()
		-- params.LV = msg:ReadIntData()
		params.skillLv = msg:ReadIntData()
		-- 职业强度****这个是新加的,没有技能几率了*****
		params.occupatpower = msg:ReadIntData()
		
		-- 添加英雄
		MAIN_PLAYER.heroManager:add( params )
		printLog("网络日志:".."--------英雄数据，HeroGUID:"..params.GUID..",HeroID="..params.id
			..",params.skillLv="..params.skillLv..",params.occupatpower="..params.occupatpower)
	end
end

Msg_Logic[MSG_MS2C_HERO_LOCK] = function ( tcp , msg  )
	print("MSG_MS2C_HERO_LOCK")
end

Msg_Logic[MSG_MS2C_SEND_HERO_LEVELUP] = function ( tcp , msg  )
	printLog("网络日志","英雄升级")
	local result = msg:ReadIntData()
	printLog("网络日志","英雄升级 结果:"..result)
	local errorDec = ""
	print(eHUE_Success)
	--升级成功
	if eHUE_Success == result then
		local guid = msg:ReadString()
		local curLv = msg:ReadIntData()
		local exp = msg:ReadIntData()
		print("网络日志","英雄升级 GUID:"..guid.."   等级:"..curLv.."   经验:"..exp)
		-- local lvUpHero = MAIN_PLAYER.heroManager:getHero(guid)
		-- lvUpHero.curLv = curLv
		-- lvUpHero.Exp = exp
		-- UIManager.gameMain.center.actorCulture.lvUp:lvUpSuccess()

		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_SEND_HERO_LEVELUP), {guid=guid, curLv=curLv, exp=exp})
		
		print("升级成功")
		-- AudioManager.playSound("s_cardlevelup")
	else
		-- UIManager:CreatePrompt_1( display.getRunningScene() , getErrorDescribe( result ))
		print(getErrorDescribe( result ))
		printLog("网络日志","[英雄升级] 消息(MSG_MS2C_SEND_HERO_LEVELUP)数据： "..result)
	end
end

Msg_Logic[MSG_MS2C_SEND_HERO_EVOLUTION] = function ( tcp , msg  )
	print("MSG_MS2C_SEND_HERO_EVOLUTION")
	printLog("网络日志","英雄进化")
	local result = msg:ReadIntData()
	printLog("网络日志","英雄进化 结果:"..result)

	--进化成功
	print(eHUE_Success)
	if eHUE_Success == result then
		local guid = msg:ReadString()
		local templeateID = msg:ReadIntData()

		printLog("网络日志","英雄进化 GUID:"..guid.."   模板ID:"..templeateID)
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_SEND_HERO_EVOLUTION), {guid=guid, templeateID=templeateID})
		print("觉醒成功")
	else
		-- UIManager:CreatePrompt_1( display.getRunningScene() , getErrorDescribe( result ))
		print(getErrorDescribe( result ))
		printLog("网络日志","[英雄进化] 消息(MSG_MS2C_SEND_HERO_EVOLUTION)数据： "..result)
	end
end


Msg_Logic[MSG_MS2C_HERO_OCCU_UPGRADE] = function ( tcp , msg  )
	printLog("网络日志","职业强化")
	local result = msg:ReadIntData()
	if result == eHUE_Success then
		local guid = msg:ReadString()
		local power = msg:ReadIntData()
		printLog("网络日志","职业强化guid:"..guid.." 强度:"..power)
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_HERO_OCCU_UPGRADE), {guid=guid, power=power})
	else
		print(getErrorDescribe( result ))
	end
end

Msg_Logic[MSG_MS2C_HERO_UPGRADE_SKILL_RE] = function ( tcp , msg  )
	printLog("网络日志","英雄技能升级")
	local result = msg:ReadIntData()
	printLog("网络日志","英雄技能升级 结果:"..result)

	--技能升级成功
	if eHUE_Success == result then
		local guid = msg:ReadString()
		local isSuccessForLvUp = msg:ReadIntData() --技能升级是否成功
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_HERO_UPGRADE_SKILL_RE), {guid=guid})
	else
		print(getErrorDescribe( result ))
		printLog("网络日志","[英雄技能升级] 消息(MSG_MS2C_HERO_UPGRADE_SKILL_RE)数据： "..result)
	end
end

Msg_Logic[MSG_MS2C_HERO_REDUCED] = function ( tcp , msg  )
	printLog("网络日志","英雄降阶")
	local msgData = {}
	msgData.result = msg:ReadIntData()
	printLog("网络日志","结果:"..msgData.result)

	if eHUE_Success == msgData.result then
		local guid = msg:ReadString()
		local id = msg:ReadIntData() 
		local lv = msg:ReadIntData() 

		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_HERO_REDUCED), {guid=guid, id=id,lv=lv})
	else
		-- UIManager:CreatePrompt_1( display.getRunningScene(), getErrorDescribe( msgData.result ))
		print(getErrorDescribe( msgData.result ))
	end
end

-- 获取橙将排行榜
-- Msg_Logic[MSG_MS2C_HERO_STAR_5_LIST] = function ( tcp , msg  )
-- 	print("MSG_MS2C_HERO_STAR_5_LIST")
-- end

