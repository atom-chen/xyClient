--
-- Author: Wu Hengmin
-- Date: 2014-05-15 14:56:47
--

-- 装备列表
Msg_Logic[MSG_MS2C_EQUIPS_LIST] = function ( tcp , msg  )
	local count = msg:ReadIntData()
	MAIN_PLAYER.equipManager.data = {}
	
	printLog("网络日志","收到装备列表消息,数量:"..count)
	for i=1,count do
		local guid = msg:ReadString()
		local id = msg:ReadIntData()
		local mainlevel = msg:ReadIntData()
		local count_stone_upgrade = msg:ReadIntData()
		local count_stone_improve = msg:ReadIntData()

		local off_attr_1 = msg:ReadIntData()
		local off_attr_2 = msg:ReadIntData()
		local off_attr_3 = msg:ReadIntData()
		local off_attr_4 = msg:ReadIntData()
		local off_attr_5 = msg:ReadIntData()

		local count_other_attr = msg:ReadIntData()
		-- printLog("网络日志", "额外属性条数:"..count_other_attr)
		local other_attr = {}
		for i=1,count_other_attr do
			local type_ = msg:ReadIntData()
			local attr = msg:ReadFloat()
			table.insert(other_attr, {type_ = type_, attr = string.format("%6.2f", attr)})
			-- printLog("网络日志", "其他属性type:"..type_.." attr:"..attr.." 格式化后:"..string.format("%6.2f", attr))
		end



		printLog("网络日志","装备信息:guid="..guid..
			" ID="..id..
			" 主属性等级="..mainlevel..
			" 返还强化石:"..count_stone_upgrade..
			" 返还进阶石:"..count_stone_improve..
			" off_attr_1"..off_attr_1..
			" off_attr_2"..off_attr_2..
			" off_attr_3"..off_attr_3..
			" off_attr_4"..off_attr_4..
			" off_attr_5"..off_attr_5
			)
		MAIN_PLAYER.equipManager:addEqu({
				mainlevel = mainlevel,
				id = id,
				guid = guid,
				count_stone_upgrade = count_stone_upgrade,
				count_stone_improve = count_stone_improve,
				off_attr_1 = off_attr_1,
				off_attr_2 = off_attr_2,
				off_attr_3 = off_attr_3,
				off_attr_4 = off_attr_4,
				off_attr_5 = off_attr_5,
				other_attr = other_attr,

			});
	end

	count = msg:ReadIntData()
	printLog("网络日志","收到装备碎片列表消息,数量:"..count)
	MAIN_PLAYER.equipManager.equipmentfragments = {}
	for i=1,count do
		local ID = msg:ReadIntData()
		local COUNT = msg:ReadIntData()
		printLog("网络日志","碎片信息:ID="..ID.." 数量="..COUNT)
		MAIN_PLAYER.equipManager:addFragment({
			id = ID,
			count = COUNT,
			})
	end

	if MainPageSystemInstance then
		dispatchGlobaleEvent("model_equipManager", "openequip", {})
	else
		print("不跳转装备")
	end
end

--[[ 装备洗炼结果
*	int 结果
*	string 装备GUID
*	int 副属性1
*	int 副属性2
*	int 副属性3
*	int 副属性4
*	int 副属性5
*
]]
Msg_Logic[MSG_MS2C_EQUIPS_WASH] = function ( tcp , msg  )
	local result = msg:ReadIntData()
	printLog("网络日志","收到装备洗炼消息,结果:"..result)

	if result == eEquip_Succed then
		dispatchGlobaleEvent("backpack_ctrl", "updatePanel", {})
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end
	
end

-- 删除装备
Msg_Logic[MSG_MS2C_EQUIPS_REMOVE] = function ( tcp , msg  )
	printLog("网络日志","服务器推送删除装备消息")
	local count = msg:ReadIntData()
	printLog("网络日志","收到删除装备消息,数量:"..count)
	for i=1,count do
		local guid = msg:ReadString()
		printLog("网络日志","收到删除装备guid:"..guid)
		MAIN_PLAYER.equipManager:removeEqu(guid)
	end
	dispatchGlobaleEvent("model_equipManager", "removeEquip", {})
end

-- 添加装备
Msg_Logic[MSG_MS2C_EQUIPS_ADD] = function ( tcp , msg  )
	printLog("网络日志","服务器推送添加装备消息")
	local count = msg:ReadIntData()
	
	printLog("网络日志","收到装备添加消息,数量:"..count)
	for i=1,count do
		local guid = msg:ReadString()
		local id = msg:ReadIntData()
		local mainlevel = msg:ReadIntData()
		local count_stone_upgrade = msg:ReadIntData()
		local count_stone_improve = msg:ReadIntData()

		local off_attr_1 = msg:ReadIntData()
		local off_attr_2 = msg:ReadIntData()
		local off_attr_3 = msg:ReadIntData()
		local off_attr_4 = msg:ReadIntData()
		local off_attr_5 = msg:ReadIntData()

		local count_other_attr = msg:ReadIntData()
		local other_attr = {}
		for i=1,count_other_attr do
			local type_ = msg:ReadIntData()
			local attr = msg:ReadFloat()
			table.insert(other_attr, {type_ = type_, attr = string.format("%6.2f", attr)})
		end



		printLog("网络日志","装备信息:guid="..guid..
			" ID="..id..
			" 主属性等级="..mainlevel..
			" 返还强化石:"..count_stone_upgrade..
			" 返还进阶石:"..count_stone_improve..
			" off_attr_1"..off_attr_1..
			" off_attr_2"..off_attr_2..
			" off_attr_3"..off_attr_3..
			" off_attr_4"..off_attr_4..
			" off_attr_5"..off_attr_5
			)
		MAIN_PLAYER.equipManager:addEqu({
				mainlevel = mainlevel,
				id = id,
				guid = guid,
				count_stone_upgrade = count_stone_upgrade,
				count_stone_improve = count_stone_improve,
				off_attr_1 = off_attr_1,
				off_attr_2 = off_attr_2,
				off_attr_3 = off_attr_3,
				off_attr_4 = off_attr_4,
				off_attr_5 = off_attr_5,
				other_attr = other_attr,

			});
	end
	dispatchGlobaleEvent("model_equipManager", "addEquip", {})
end

-- 更新装备消息
Msg_Logic[MSG_MS2C_EQUIPS_UPDATE] = function ( tcp , msg  )
	printLog("网络日志","服务器推送更新装备消息")
	local guid = msg:ReadString()
	local id = msg:ReadIntData()
	local mainlevel = msg:ReadIntData()
	local count_stone_upgrade = msg:ReadIntData()
	local count_stone_improve = msg:ReadIntData()

	local off_attr_1 = msg:ReadIntData()
	local off_attr_2 = msg:ReadIntData()
	local off_attr_3 = msg:ReadIntData()
	local off_attr_4 = msg:ReadIntData()
	local off_attr_5 = msg:ReadIntData()

	local count_other_attr = msg:ReadIntData()
	local other_attr = {}
	for i=1,count_other_attr do
		local type_ = msg:ReadIntData()
		local attr = msg:ReadFloat()
		table.insert(other_attr, {type_ = type_, attr = string.format("%6.2f", attr)})
	end



	printLog("网络日志","装备信息:guid="..guid..
		" ID="..id..
		" 主属性等级="..mainlevel..
		" 返还强化石:"..count_stone_upgrade..
		" 返还进阶石:"..count_stone_improve..
		" off_attr_1="..off_attr_1..
		" off_attr_2="..off_attr_2..
		" off_attr_3="..off_attr_3..
		" off_attr_4="..off_attr_4..
		" off_attr_5="..off_attr_5
		)
	MAIN_PLAYER.equipManager:updateEqu({
			mainlevel = mainlevel,
			id = id,
			guid = guid,
			count_stone_upgrade = count_stone_upgrade,
			count_stone_improve = count_stone_improve,
			off_attr_1 = off_attr_1,
			off_attr_2 = off_attr_2,
			off_attr_3 = off_attr_3,
			off_attr_4 = off_attr_4,
			off_attr_5 = off_attr_5,
			other_attr = other_attr,

		});

end

--[[ 熔炼装备结果
*
*	int 产物数量
*	{
*		int		产物类型
*		int		产物模版ID
*		int		产物等级
*		int		产物数量
*	}
*
* ]]
Msg_Logic[MSG_MS2C_EQUIPS_SMELT] = function ( tcp , msg  )
	printLog("网络日志","收到 熔炼装备结果")
	local result = msg:ReadIntData()
	if result == eEquip_Succed then
		local count = msg:ReadIntData()
		printLog("网络日志","产物数量:"..count)
		local data = {}
		for i=1,count do
			local type_ = msg:ReadIntData()
			local id = msg:ReadIntData()
			local lv = msg:ReadIntData()
			local num = msg:ReadIntData()

			-- printLog("网络日志","产物:"..UIManager:createDropName(type_, id))

			table.insert(data, {
					type_ = type_,
					id = id,
					lv = lv,
					num = num,
				})

		end
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_EQUIPS_SMELT), {data = data})
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

end

-- 穿戴装备
Msg_Logic[MSG_MS2C_EQUIPS_SETPOSITION] = function ( tcp , msg  )
	printLog("网络日志","收到 穿戴装备 消息(MSG_MS2C_EQUIPS_SETPOSITION)")
	local msgData = {}
	msgData.result = msg:ReadIntData()

	if msgData.result == eEquip_Succed then
		msgData.teamIdx = msg:ReadIntData()
		msgData.memberPos = msg:ReadIntData()  + 1
		msgData.equipType = msg:ReadIntData()
		msgData.equipGUID = msg:ReadString()

		local battleHeroManager = MAIN_PLAYER:getTeamManager():getTeam(msgData.teamIdx):getBattleHeroManager()
		local pos = battleHeroManager:getPos(msgData.memberPos)
		pos:setEquip(msgData.equipType, msgData.equipGUID)
	else
		local errorDec = getErrorDescribe( msgData.result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_EQUIPS_SETPOSITION), msgData)
	printLog("网络日志", serialize(msgData))
end

-- 卸下装备
Msg_Logic[MSG_MS2C_EQUIPS_UNLOADPOSITION] = function ( tcp , msg  )
	printLog("网络日志","收到 卸下装备 消息(MSG_MS2C_EQUIPS_UNLOADPOSITION)")
	local msgData = {}
	msgData.result = msg:ReadIntData()

	if msgData.result == eEquip_Succed then
		msgData.teamIdx = msg:ReadIntData()
		msgData.memberPos = msg:ReadIntData() + 1
		msgData.equipType = msg:ReadIntData()

		local battleHeroManager = MAIN_PLAYER:getTeamManager():getTeam(msgData.teamIdx):getBattleHeroManager()
		local pos = battleHeroManager:getPos(msgData.memberPos)
		pos:setEquip(msgData.equipType, NULL_GUID)
	else
		local errorDec = getErrorDescribe( msgData.result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

	dispatchGlobaleEvent("net", tostring(MSG_MS2C_EQUIPS_UNLOADPOSITION), msgData)
	printLog("网络日志", serialize(msgData))
end

-- 更新装备碎片消息
Msg_Logic[MSG_MS2C_EQUIPS_PIECE_UPDATE] = function ( tcp , msg  )
	printLog("网络日志","装备分解结果")
	local id = msg:ReadIntData()
	local count = msg:ReadIntData()
	printLog("网络日志","ID:"..id.." count:"..count)
	MAIN_PLAYER.equipManager:updateFragment({id = id, count = count})
end

--[[ 强化装备结果
*
*	int 结果
*	string 装备GUID
*
*	统一装备属性更新消息
*
]]
Msg_Logic[MSG_MS2C_EQUIPS_STRENGTHEN] = function ( tcp , msg  )
	local result = msg:ReadIntData()
	printLog("网络日志","收到强化装备结果消息,结果:"..result)
	if result == eEquip_Succed then

		local result_ = msg:ReadIntData()
		if result_ == 1 then
			-- 成功
			UIManager:CreatePrompt_Bar({content = "强化成功"})
		else
			-- 失败
			UIManager:CreatePrompt_Bar({content = "强化失败"})
		end
		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_EQUIPS_STRENGTHEN))

	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end
end

--[[ 进阶装备结果
*
*	int 结果
*	string 装备GUID
*	
]]
Msg_Logic[MSG_MS2C_EQUIPS_UPGRADE] = function ( tcp , msg  )
	printLog("网络日志","进阶装备结果")
	local result = msg:ReadIntData()
	if result == eEquip_Succed then
		UIManager:CreatePrompt_Bar( {content = "升阶成功"})

		dispatchGlobaleEvent("backpack_ctrl", "updatePanel", {})
	else
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

end

-- 装备合成消息
Msg_Logic[MSG_MS2C_EQUIPS_PIECT_UNITE_RE] = function ( tcp , msg  )
	printLog("网络日志","合成装备结果")
	local result = msg:ReadIntData()
	if result == eEquip_Succed then
		local id = msg:ReadIntData()
		printLog("网络日志","合成装备模版ID"..id)
		local count = msg:ReadIntData()
		printLog("网络日志","消耗碎片数量"..count)

		dispatchGlobaleEvent("netMsg", tostring(MSG_MS2C_EQUIPS_PIECT_UNITE_RE), {id = id, count = count})

	elseif result == eEquip_Full then
		-- 装备满了
		print("装备满了")
		-- UIManager:CreatePrompt(
		-- 	UIManager.gameMain:getParent(),
		-- 	{
		-- 		showtype = 1,
		-- 		showname = "提  示",
		-- 		text = "达到装备上限,是否花费"..stoneConfig[4].price.."元宝额外增加5个装备上限 ?",
		-- 		listenOk = function ()
		-- 			-- body
		-- 			-- 购买消息
		-- 			if gameTcp.isConnected then
		-- 				gameTcp:SendMessage(MSG_C2MS_BUY_GOODS, {5})
		-- 			end
		-- 		end,
		-- 		listenNO = function ()
		-- 			-- body
		-- 		end
		-- 	}
		-- )
	else
		print(getErrorDescribe( result ))
	end


end

--[[ 武智互换结果
*	int 结果
*
]]
Msg_Logic[MSG_MS2C_EQUIPS_SWAP] = function ( tcp , msg  )
	printLog("网络日志","武智互换结果")
	local result = msg:ReadIntData()
	if result == eEquip_Succed then
		print("成功")
		dispatchGlobaleEvent("backpack_ctrl", "updatePanel", {})
	else
		print("失败")
		local errorDec = getErrorDescribe( result ) or "未知错误"
		UIManager:CreatePrompt_Bar( {content = errorDec})
	end

end

